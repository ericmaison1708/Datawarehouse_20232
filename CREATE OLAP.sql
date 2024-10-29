-- CREATE DATABASE classicmodels_olap
USE classicmodels_olap;
CREATE TABLE dim_customers (
    customerNumber INT PRIMARY KEY,
    customerName VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE dim_employees (
    employeeNumber INT PRIMARY KEY,
    employeeName VARCHAR(50),
    jobTitle VARCHAR(50),
    officeCode INT,
    country VARCHAR(50),
    territory VARCHAR(20)
);
CREATE TABLE dim_products (
    productCode VARCHAR(50) PRIMARY KEY,
    productName VARCHAR(50),
    productLine VARCHAR(50),
    productVendor VARCHAR(50)
);

CREATE TABLE dim_orders (
    orderNumber VARCHAR(20) PRIMARY KEY,
    `status` VARCHAR(50)
);


CREATE TABLE dim_date (
	dateID DATE,
    day INT,
    quarter INT,
    year INT,
    primary key (dateID)
);

ALTER TABLE dim_date
ADD COLUMN month INT;

CREATE TABLE fact_customers (
	employeeNumber int,
    customerNumber int,
    creditLimit decimal (10,2),
    foreign key (employeeNumber) references dim_employees (employeeNumber),
    foreign key (customerNumber) references dim_customers (customerNumber)
);

CREATE TABLE fact_stock (
	productCode VARCHAR(50),
    buyPrice decimal (10,2),
    quantityInStock int,
    MRSP decimal (10,2),
    foreign key (productCode) references dim_products (productCode)
);

ALTER TABLE fact_stock
RENAME COLUMN MRSP TO MSRP;


CREATE TABLE fact_order (
	dateID date,
    customerNumber int,
    employeeNumber int,
    productCode VARCHAR(50),
    orderNumber VARCHAR(20),
	quantityOrder int,
    priceEach decimal(10,2),
    `status` VARCHAR(50),
    foreign key (customerNumber) references dim_customers (customerNumber),
    foreign key (employeeNumber) references dim_employees (employeeNumber),
	foreign key (dateID) references dim_date (dateID),
    foreign key (productCode) references dim_products (productCode)
);

ALTER TABLE fact_order
ADD CONSTRAINT fk_dim_orders_orderNumber
FOREIGN KEY (orderNumber) REFERENCES dim_orders (orderNumber);

CREATE TABLE fact_payment (
    customerNumber int,
    dateID date,
    amount decimal(10,2),
    foreign key (customerNumber) references dim_customers (customerNumber),
	foreign key (dateID) references dim_date (dateID)
);

