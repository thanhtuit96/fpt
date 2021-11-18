
CREATE TABLE product (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	name varchar(250) NULL,
	description varchar(250) NULL,
	barcode varchar(250) NULL,
	price DECIMAL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO product(name, description, barcode, price) values ('Chuối', '123refdsaasd', 'B0001',20000);
INSERT INTO product(name, description, barcode, price) values('Xoài', '123refdsaasd', 'B0002', 21000);
INSERT INTO product(name, description, barcode, price) values('Táo', '123refdsaasd', 'B0003', 22000);
INSERT INTO product(name, description, barcode, price) values('Bưởi', '123refdqưeqesaasd', 'B0004', 23000);
INSERT INTO product(name, description, barcode, price) values('Quý', '123refdsaasewrwerd', 'B0005', 24000);
INSERT INTO product(name, description, barcode, price) values('Nho Mỹ', '123refdsaasdử', 'B0006', 25000);
INSERT INTO product(name, description, barcode, price) values('Xoài keo', '123refdsaaưersd', 'B0007', 26000);
INSERT INTO product(name, description, barcode, price) values('Xoài thái', '123refdsaasưerd', 'B0008', 27000);
INSERT INTO product(name, description, barcode, price) values('Nho Xanh', '123refdsaasưerd', 'B0009', 30000);
INSERT INTO product(name, description, barcode, price) values('Tía Tô', '123refdsaasdưer', 'B0010', 50000);
INSERT INTO product(name, description, barcode, price) values('Dừa', '123refdsaasưerd', 'B0011', 60000);
INSERT INTO product(name, description, barcode, price) values('Dứa', '123refdsaasewrd', 'B0012', 70000);
INSERT INTO product(name, description, barcode, price) values('Dưa', '123refdsaasewrd', 'B0013', 23000);
INSERT INTO product(name, description, barcode, price) values('Cam', '123refdsaasewrd', 'B0014', 26000);
INSERT INTO product(name, description, barcode, price) values('Chôm Chôm', '123refdưerwesaasd', 'B0015', 25000);

CREATE TABLE customer (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	name varchar(250) NULL,
	phone varchar(250) NULL,
	address varchar(250) NULL,
	country varchar(250) NULL,
	state varchar(250) NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO customer(name, phone, address, country, state)  values
('Nguyễn Văn A', '099992222', '56 VVT','VN','Hồ Chí Minh'),
('Nguyễn Văn B', '049992222', '57 VVT','VN','Hà Nội'),
('Nguyễn Văn C', '059992222', '58 VVT','VN','Hải Phòng'),
('Nguyễn Văn D', '099662222', '59 VVT','VN','Long An'),
('Nguyễn Văn E', '0994492222', '60 VVT','VN','Hồ Chí Minh'),
('Nguyễn Văn F', '0932422222', '61 VVT','VN','Trà Vinh'),
('Nguyễn Văn G', '099652222', '62 VVT','VN','Tiền Giang'),
('Nguyễn Văn H', '099772222', '63 VVT','VN','Sóc Trăng'),
('Nguyễn Văn I', '09996662222', '64 VVT','VN','Bạc Liêu'),
('Nguyễn Văn T', '0999926622', '65 VVT','VN','Hồ Chí Minh');

CREATE TABLE sale_order (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	status varchar(10) NOT NULL,
	shipped_date TIMESTAMP NULL,
	comments varchar(255) NOT NULL,
	payment_status varchar(10) NOT NULL,
	customer_id int UNSIGNED null,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from sale_order so ;
CREATE TABLE sale_order_line (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	product_id INT UNSIGNED not null,
	order_id INT UNSIGNED not null,
	qty int UNSIGNED not null,
	price DECIMAL,
	money DECIMAL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO sale_order(order_date, status, shipped_date, comments, payment_status)  values
('2021-01-01 07:00:00', 'pending', null, 'Giao trong 10 ngay', 'pending'),
('2021-01-06 07:23:00', 'confirm', null, 'Giao trong 3 ngay', 'done'),
('2021-02-01 07:25:00', 'pending', null, 'Giao trong ngay', 'pending'),
('2021-02-15 07:00:00', 'confirm', null, 'Giao trong 1 ngay', 'pending'),
('2021-02-20 07:55:00', 'pending', null, 'Giao trong 2 ngay', 'pending'),
('2021-03-01 07:44:00', 'confirm', null, 'Giao trong 4 ngay', 'done'),
('2021-03-02 07:30:00', 'confirm', null, 'Giao trong 5 ngay', 'pending'),
('2021-03-03 07:20:00', 'pending', null, 'Giao trong 6 ngay', 'pending'),
('2021-03-04 07:10:00', 'done', '2021-03-10 07:00:00', 'Giao trong 7 ngay', 'done'),
('2021-05-01 07:00:00', 'done', '2021-05-10 07:00:00', 'Giao trong 8 ngay', 'pending'),
('2021-06-01 07:11:00', 'pending', null, 'Giao trong 2 ngay', 'pending'),
('2021-07-01 07:00:00', 'done', '2021-07-07 07:00:00', 'Giao trong 55 ngay', 'pending'),
('2021-08-01 07:22:00', 'pending', null, 'Giao trong 4 ngay', 'pending'),
('2021-09-01 07:22:00', 'done', '2021-09-02 07:00:00', '', 'done'),
('2021-09-02 07:22:00', 'pending', null, '', 'pending');
select * from sale_order so ;
update sale_order
set status = 'pending'
where id = 1;
INSERT INTO sale_order_line(product_id, order_id, qty, price, money)  values
(1,1,20,20000,20*20000),
(2,1,2,21000,2*21000),
(12,1,1,70000,1*70000),
(3,2,10,22000,22000*10),
(4,2,5,23000,5*23000),
(5,3,6,24000,6*24000),
(6,3,9,25000,9*25000),
(7,4,1,26000,1*26000),
(7,5,2,26000,2*26000),
(8,6,3,27000,3*27000),
(7,7,4,26000,4*26000),
(8,7,5,27000,5*27000),
(9,7,6,30000,6*30000),
(10,8,7,50000,7*50000),
(11,9,8,60000,8*60000),
(11,10,9,60000,9*60000),
(10,11,10,50000,10*50000),
(4,12,11,23000,11*23000),
(12,13,12,70000,12*70000),
(12,14,13,70000,13*70000),
(13,15,14,23000,14*23000);


