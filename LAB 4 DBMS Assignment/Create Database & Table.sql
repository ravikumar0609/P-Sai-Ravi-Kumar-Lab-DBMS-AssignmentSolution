DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

DROP TABLE IF EXISTS supplier,customer,category,product,supplier_pricing,orders,rating;

create table supplier (
supp_id int primary key,
supp_name varchar(50) NOT NULL,
supp_city varchar(50) NOT NULL,
supp_phone varchar(50) NOT NULL
);


create table customer (
cus_id int primary key,
cus_name varchar(20) NOT NULL,
cus_phone varchar(10) NOT NULL,
cus_city varchar(30) NOT NULL,
cus_gender CHAR(1) 
);

create table category (
cat_id int primary key,
cat_name varchar(20) NOT NULL
);

create table product (
pro_id int primary key,
pro_name varchar(20) NOT NULL Default "Dummy",
pro_desc varchar(60),
cat_id int,
foreign key(cat_id) references category(cat_id)
);

create table supplier_pricing (
pricing_id int primary key,
pro_id int,
supp_id int,
foreign key(pro_id) references product(pro_id),
foreign key(supp_id) references supplier(supp_id),
supp_price int Default 0
);

create table orders (
ord_id int primary key,
ord_amount int NOT NULL,
ord_date Date NOT NULL,
cus_id int,
pricing_id int,
foreign key(cus_id) references customer(cus_id),
foreign key(pricing_id) references supplier_pricing(pricing_id)
);

create table rating (
rat_id int primary key,
ord_id int,
foreign key(ord_id) references orders(ord_id),
rat_ratstars int NOT NULL
);

