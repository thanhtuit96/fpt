FROM python:3.7

COPY requirements.txt .
RUN apt update && apt install uuid -y && pip install --upgrade pip
RUN pip install prefect==0.15.9 && pip install -r requirements.txt

