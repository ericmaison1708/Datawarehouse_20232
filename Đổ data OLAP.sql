-- OLTP -> OLAP
-- dim_customers 
INSERT INTO classicmodels_olap.dim_customers(
	customerNumber, customerName, city, state, country
)

SELECT 
    customerNumber, customerName, city, state, country
FROM
    classicmodels.customers;
    
-- dim employees
INSERT INTO classicmodels_olap.dim_employees(
	employeeNumber, employeeName, jobTitle, officeCode, country, territory
)
SELECT 
    employeeNumber, CONCAT(firstName, ' ', lastName) as employeeName, jobTitle, officeCode, country, territory
FROM
    classicmodels.employees INNER JOIN 	classicmodels.offices using(officeCode);
    
-- dim_products

INSERT INTO classicmodels_olap.dim_products(
	productCode, productName, productLine, productVendor
)
SELECT 
    productCode, productName, productLine, productVendor
FROM
    classicmodels.products;

-- -- dim_orders
INSERT INTO classicmodels_olap.dim_orders(
	orderNumber, `status`
)
SELECT 
    orderNumber, `status`
FROM
    classicmodels.orders;
    
-- dim_date
DROP PROCEDURE IF EXISTS fillDates;
DELIMITER |

CREATE PROCEDURE fillDates (dateStart DATE, dateEnd DATE)
BEGIN
    WHILE dateStart <= dateEnd DO 
        INSERT INTO classicmodels_olap.dim_date (dateID, day, month, quarter, year)
        VALUES (dateStart, DAY(dateStart), MONTH(dateStart), QUARTER(dateStart), YEAR(dateStart));
        SET dateStart = DATE_ADD(dateStart, INTERVAL 1 DAY);
    END WHILE;
END;
| DELIMITER ;
CALL fillDates('2003-01-01', '2005-12-31');

-- fact_customers
INSERT INTO classicmodels_olap.fact_customers(
	customerNumber, employeeNumber, creditLimit
)

SELECT 
    dim_customers.customerNumber, dim_employees.employeeNumber, classicmodels.customers.creditLimit
FROM
    dim_customers left join classicmodels.customers using (customerNumber)
	inner join dim_employees on
	dim_employees.employeeNumber = classicmodels.customers.salesRepEmployeeNumber;


-- fact_payment

INSERT INTO classicmodels_olap.fact_payment(
	customerNumber, dateID, amount
)
SELECT customerNumber, dateID, amount
FROM
	dim_customers LEFT JOIN classicmodels.payments USING (customerNumber)
	INNER JOIN dim_date ON
	classicmodels.payments.paymentDate = dim_date.dateID;
    
-- fact_stock

INSERT INTO classicmodels_olap.fact_stock(
	productCode, buyPrice, quantityInStock, MSRP
)
SELECT classicmodels_olap.dim_products.productCode, classicmodels.products.buyPrice, classicmodels.products.quantityInStock,
	   classicmodels.products.MSRP
       
FROM 
	classicmodels_olap.dim_products LEFT JOIN classicmodels.products USING (productCode);
    
-- fact_order
INSERT INTO classicmodels_olap.fact_order (
)
SELECT 
    dim_date.dateID, dim_customers.customerNumber,
    dim_employees.employeeNumber, dim_products.productCode,
    dim_orders.orderNumber, quantityOrdered,
    priceEach, dim_orders.`status`
FROM dim_customers
    INNER JOIN classicmodels.customers USING (customerNumber)
    INNER JOIN dim_employees ON dim_employees.employeeNumber = classicmodels.customers.salesRepEmployeeNumber
    INNER JOIN classicmodels.orders USING (customerNumber)
    INNER JOIN dim_date ON classicmodels.orders.orderDate = dim_date.dateID
    INNER JOIN classicmodels.orderdetails using (orderNumber)
    INNER JOIN dim_products USING (productCode)
    INNER JOIN dim_orders USING (orderNumber)
    ;
