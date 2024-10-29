-- OLTP
-- 1.Thống kê doanh số của các nhân viên/quản lý theo phòng ban (cụ thể là phòng ban có officeCode = 4)

USE classicmodels;

SELECT
	e.officeCode AS 'Mã số phòng ban',
    e.employeeNumber AS 'Mã số nhân viên',
    SUM(quantityOrdered * priceEach) AS 'Doanh thu'
FROM 
	employees e
    INNER JOIN customers c
    ON c.salesRepEmployeeNumber = e.employeeNumber
    INNER JOIN orders o
    ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
WHERE 
	e.officeCode = 4
GROUP BY
	e.officeCode,
    e.employeeNumber
ORDER BY
	SUM(quantityOrdered * priceEach) DESC;
    
    
-- 2. Thống kê doanh số theo các office 
SELECT
	e.officeCode AS 'Mã số phòng ban',
    SUM(quantityOrdered * priceEach) AS 'Doanh thu'
FROM 
	employees e
    INNER JOIN customers c
    ON c.salesRepEmployeeNumber = e.employeeNumber
    INNER JOIN orders o
    ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
GROUP BY
	e.officeCode
ORDER BY
	SUM(quantityOrdered * priceEach) DESC;
    
    
-- 3. Thống kê doanh số theo nội địa tại các office
SELECT
	ofc.officeCode AS 'Mã số phòng ban',
    ofc.country AS 'Nước',
    SUM(quantityOrdered * priceEach) AS 'Doanh thu'
FROM 
	employees e
    INNER JOIN customers c
    ON c.salesRepEmployeeNumber = e.employeeNumber
    INNER JOIN orders o
    ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
    INNER JOIN offices ofc
    ON e.officeCode = ofc.officeCode
WHERE
	c.country = ofc.country
GROUP BY
	ofc.officeCode,
    ofc.country;


-- 4.Thống kê mức độ chênh lệch giá bán và giá niêm yết trung bình theo từng sản phẩm

SELECT
    p.productCode AS `Mã sản phẩm`,
    p.productName AS `Tên sản phẩm`,
    AVG(ABS(p.MSRP - od.priceEach) * od.quantityOrdered) AS `Giá chênh lệch trung bình`
FROM
    products p
    INNER JOIN orderdetails od
    ON p.productCode = od.productCode
GROUP BY
    p.productCode,
    p.productName
ORDER BY
    `Giá chênh lệch trung bình` DESC;


    
-- 5. Thống kê khách hàng tại quốc gia nào nhận được nhiều ưu đãi mua hàng nhất (giá bán rẻ hơn giá niêm yết)

SELECT
	c.country AS `Quốc gia`,
    SUM((p.MSRP - od.priceEach) * od.quantityOrdered) AS `Tổng tiền khuyến mãi`
FROM 
	customers c
    INNER JOIN orders o
    ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
    INNER JOIN products p
    ON p.productCode = od.productCode
GROUP BY
	c.country
ORDER BY
	`Tổng tiền khuyến mãi` DESC
LIMIT 1;


-- 6. Thống kế số lượng hàng tồn và mức chênh lệch giá bán trung bình theo từng sản phẩm
SELECT
	p.productCode AS `Mã sản phẩm`,
    p.productName AS `Tên sản phẩm`,
    p.quantityInStock AS `Số lượng hàng tồn`,
    AVG(p.MSRP - od.priceEach) AS `Mức chênh lệch giá bán trung bình`
FROM
	products p 
    INNER JOIN orderdetails od
    ON p.productCode = od.productCode
WHERE
	p.quantityInStock > 0
GROUP BY
	p.productCode ,
    p.productName ,
    p.quantityInStock;

	
	
-- 7. Thống kê top 5 những sản phẩm được khách hàng mua nhiều nhất theo khu vực (cụ thể là ở USA)


SELECT
	c.country AS `Quốc gia`,
    p.productName AS `Tên sản phẩm`,
    od.productCode AS `Mã sản phẩm`,
    SUM(od.quantityOrdered) AS `Tổng sản phẩm`
FROM 
	customers c
    INNER JOIN orders o
    ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
    INNER JOIN products p
    ON p.productCode = od.productCode
WHERE
	c.country = 'USA'
GROUP BY
	c.country,
    p.productCode,
    od.productCode	
ORDER BY
	`Tổng sản phẩm` DESC
LIMIT 5;
	

	