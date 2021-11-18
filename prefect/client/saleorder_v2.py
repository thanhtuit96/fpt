import json

import prefect
from prefect import Flow, task, Client
from prefect.storage.local import Local
from prefect.tasks.mysql.mysql import MySQLFetch
from prefect.tasks.postgres.postgres import PostgresFetch, PostgresExecuteMany
from datetime import datetime
from decimal import Decimal

logger = prefect.context.get("logger")
DATE_FORMAT = '%Y-%m-%d %H:%M:%S'

MAPPING_PRODUCT = [('id', 'id'),('name', 'name'),('description', 'description'),('barcode', 'barcode'),('price','price'),('created_at', 'created_at'),('updated_at', 'updated_at')]
MAPPING_CUSTOMER = [('id', 'id'),('name', 'name'),('phone', 'phone'),('address', 'address'),('country', 'country'),('state', 'state'),('created_at', 'created_at'),('updated_at', 'updated_at')]
MAPPING_ORDER = [('id', 'id'),('order_date', 'order_date'),('status', 'status'),('shipped_date', 'shipped_date'),('payment_status', 'payment_status'),('customer_id', 'customer_id'),('created_at', 'created_at'),('updated_at', 'updated_at')]
MAPPING_ORDER_LINE = [('id', 'id'),('product_id', 'product_id'),('order_id', 'order_id'),('qty', 'qty'),('price', 'price'),('money', 'money'),('created_at', 'created_at'),('updated_at', 'updated_at')]

mysql_fetch =  MySQLFetch("demo", "example","example", "192.168.1.27", cursor_type="dictcursor")

MAPPING = [
    ('product', 'dim_product', MAPPING_PRODUCT),
    ('customer', 'dim_customer', MAPPING_CUSTOMER),
    ('sale_order', 'fact_sale_order', MAPPING_ORDER),
    ('sale_order_line', 'fact_order_line', MAPPING_ORDER_LINE)
]

@task
def extract_max_updated_at_from_dwh():
    pf = PostgresFetch("dwh", "dwh_user", "192.168.1.27",port=5435)
    product = pf.run(password="dwh_password", query="SELECT max(updated_at) as max_updated_at FROM dim_product")[0]
    customer = pf.run(password="dwh_password", query="SELECT max(updated_at) as max_updated_at FROM dim_customer")[0]
    sale_order = pf.run(password="dwh_password", query="SELECT max(updated_at) as max_updated_at FROM fact_sale_order")[0]
    order_line = pf.run(password="dwh_password", query="SELECT max(updated_at) as max_updated_at FROM fact_order_line")[0]
    default = datetime(1900, 1, 1)
    return {
        'product': product or default,
        'customer': customer or default,
        'sale_order': sale_order or default,
        'sale_order_line': order_line or default,
    }

@task
def extract_data(table, max_timesync):
    result = mysql_fetch.run(query="SELECT * FROM %s WHERE updated_at >= '%s'" % (table,max_timesync.strftime(DATE_FORMAT)), fetch="all")
    return result

@task
def tranform_data(records, mapping):
    records = [{ dest: item.get(src, False) for (src, dest) in mapping } for item in records]
    return records

@task
def load_data(records, table, mapping):
    pe = PostgresExecuteMany("dwh", "dwh_user", "192.168.1.27",port=5435)
    keys = [ dest for (_, dest) in mapping ]
    recors_tuples = [ tuple([item.get(i) for i in keys] +  [datetime.now()]) for item in records]
    keys += ['dwh_changed_at']
    statement = "INSERT INTO {table} ({fields}) VALUES ({field2})".format(table=table, fields=",".join(keys) , field2=','.join(['%s'] * len(keys)))
    result = pe.run(query=statement,data=recors_tuples,password="dwh_password",commit=True)
    return result

@task
def run_flow(max_sync):
    for (table, dest_table, mapping) in MAPPING:
        with Flow("subflow") as sub_flow:
            records = extract_data(table, max_sync[table])
            records = tranform_data(records, mapping)
            load_data(records, dest_table, mapping)
        sub_flow.run()        

with Flow("ETL Sales Order", storage=Local(add_default_labels=False)) as flow:
    max_sync = extract_max_updated_at_from_dwh()
    run_flow(max_sync)

try:
    client = Client()
    client.create_project(project_name="fpt")
except prefect.utilities.exceptions.ClientError as e:
    logger.info("Project already exists")

flow.register(project_name="fpt", labels=["development"], add_default_labels=False)

# # Optionally run the code now
flow.run()