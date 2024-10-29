-- OLAP
-- 1.Thống kê top 5 sản phẩm mang lại doanh số lớn nhất
USE classicmodels_olap;

SELECT
	productCode,
    SUM(quantityOrder * priceEach) AS `Doanh thu`
FROM 
	fact_order
GROUP BY
	productCode
ORDER BY
	`Doanh thu` DESC
LIMIT 5;



-- 2.Thống kê doanh số của các nhân viên/quản lý theo phòng ban

SELECT
	de.employeeNumber AS `Mã nhân viên`,
    de.officeCode AS `Mã phòng ban`, 
    SUM(quantityOrder * priceEach) AS `Doanh thu`
FROM 
	fact_order fo 
    INNER JOIN dim_employees de
    ON fo.employeeNumber = de.employeeNumber
GROUP BY
	de.employeeNumber,
    de.officeCode
ORDER BY
	`Doanh thu` DESC;
    
    
-- 3. Thống kê doanh số theo các office 

SELECT
	de.officeCode AS `Mã phòng ban`, 
    SUM(quantityOrder * priceEach) AS `Doanh số phòng ban`
FROM 
	fact_order fo 
    INNER JOIN dim_employees de
    ON fo.employeeNumber = de.employeeNumber
GROUP BY
	de.officeCode;


-- 4. Thống kê doanh số theo dòng sản phẩm
SELECT
	dp.productLine AS `Dòng sản phẩm`,
    SUM(quantityOrder * priceEach) AS `Doanh số sản phẩm`
FROM 
	fact_order fo 
    INNER JOIN dim_products dp
    ON fo.productCode = dp.productCode
GROUP BY
	dp.productLine
ORDER BY
	`Doanh số sản phẩm` DESC;
    


-- 5. Thống kê doanh số theo thời gian

SELECT
	dd.quarter ,
    dd.year,
    SUM(fo.quantityOrder * fo.priceEach) AS `Doanh thu`
FROM
	dim_date dd
    INNER JOIN
    fact_order fo
    ON dd.dateID = fo.dateID
GROUP BY
	dd.quarter,
    dd.year;
    

-- 6. Thống kê tổng số lượng hàng trong kho theo từng sản phẩm

SELECT
	fs.productCode AS `Mã sản phẩm`,
    dp.productName AS `Tên sản phẩm`,
	SUM(fs.quantityInStock) AS `Tổng sản phẩm tồn`
FROM
	dim_products dp
    INNER JOIN
    fact_stock fs
    ON dp.productCode = fs.productCode
GROUP BY
	fs.productCode,
    dp.productName;


-- 7. Thống kê top những khách hàng đã thanh toán nhiều nhất 

SELECT
	fp.customerNumber AS `Mã khách hàng`,
    dc.customerName AS `Tên khách hàng`,
    SUM(fp.amount) AS `Tổng thanh toán`
FROM
	fact_payment fp
    INNER JOIN
    dim_customers dc
    ON fp.customerNumber = dc.customerNumber
GROUP BY
	fp.customerNumber,
    dc.customerName
ORDER BY
	`Tổng thanh toán` DESC;
    
    
-- 8. Thống kê top 5 những sản phẩm được khách hàng mua nhiều nhất theo khu vực (cụ thể là USA)

SELECT
	dc.country AS `Quốc gia`,
    dp.productName AS `Tên sản phẩm`,
	SUM(quantityOrder) AS `Tổng số sản phẩm đã bán`
FROM
	dim_customers dc
    INNER JOIN
    fact_order fo 
    ON dc.customerNumber = fo.customerNumber
    INNER JOIN 
    dim_products dp
    ON dp.productCode = fo.productCode
WHERE
	dc.country = 'USA' 
GROUP BY
	dp.productName
ORDER BY
	`Tổng số sản phẩm đã bán` DESC
LIMIT 5;

