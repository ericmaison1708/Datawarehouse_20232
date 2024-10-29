USE classicmodels;
/* 1. Truy vấn thông tin khách hàng phàn nàn
SELECT 
	* 
FROM 
	customers
where 
	phone = '+49 69 66 90 2555';
    */

/* 2. Truy vấn ra thông tin đơn hàng 
SELECT
	*
FROM
	orders
where
	customerNumber = '128'
*/    


/* 3. Truy vấn nhân viên đã chăm sóc khách hàng của đơn hàng này 
SELECT
	e.employeeNumber AS "Mã số nhân viên",
	CONCAT(e.firstName, ' ', e.lastName) AS "Tên nhân viên",
    e.reportsTo AS "Mã số quản lý",
    e.officeCode AS "Mã số phòng quản lý"
FROM 
	customers c,
    employees e
WHERE
	c.salesRepEmployeeNumber = e.employeeNumber
    AND
    c.customerNumber = '128';*/
	
/* 4. Truy vấn thông tin sản phẩm bị phàn nàn. */
SELECT
	productCode,
    productName,
    productLine,
    buyPrice
FROM
	products
WHERE 
	productName LIKE '%1928 Mercedes-Benz%' ;

/* 5. Kiểm tra kho hàng còn sản phẩm đó không. */

SELECT
	productCode,
    productName,
    productLine,
    quantityInStock
FROM
	products
WHERE 
	productName LIKE '%1928 Mercedes-Benz%' ;
    
/* 6. Đưa ra những dòng sản phẩm có cùng mức giá, chênh lệch giá nhỏ để tư vấn.
(Nhỏ hơn 5 đô) */

SELECT
	productName AS 'Tên sản phẩm',
    productLine AS 'Dòng sản phẩm',
    buyPrice AS 'Giá bán'
FROM
	products
WHERE
	ABS(buyPrice - 72.56) < 5
    AND 
    productCode != 'S18_2795';
    
/* 7. Đưa ra những dòng xe có cùng một số đặc điểm với xe trước.*/

SELECT
	productName,
    productLine,
    productScale,
    productVendor,
    productDescription
FROM
	products
WHERE
	productLine = 'Vintage Cars'
    AND
    productScale = '1:18';
	
/* 8. Truy vấn sản phẩm mới mà khách hàng yêu cầu theo đặc điểm. */

SELECT
	productName,
    productLine,
    productScale,
    productVendor,
    productDescription,
    buyPrice
FROM
	products
WHERE
	productDescription REGEXP 'white|black'
    AND
    productDescription LIKE '%opening hood%'
;    

/* 9. Tìm 1 nhân viên đã có kinh nghiệm để tư vấn cho khách hàng. */

SELECT 
	c.salesRepEmployeeNumber AS 'Mã nhân viên',
	COUNT(c.salesRepEmployeeNumber) AS 'Số lượng khách hàng đã hỗ trợ'
FROM
	customers c
GROUP BY
	c.salesRepEmployeeNumber
ORDER BY
	COUNT(c.salesRepEmployeeNumber) DESC
LIMIT 1;
	
/* 10. Hiển thị những khách hàng đã mua sản phẩm này để tiến hành khảo sát chất lượng. */

SELECT 
	c.*
FROM
	customers c
    INNER JOIN orders o
    ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
WHERE
	od.productCode = 'S18_2795';

/* 11. Hiển thị top 5 khách hàng có tổng giá trị đơn hàng lớn nhất.*/

SELECT 
	c.customerNumber,
    c.customerName,
    SUM(od.quantityOrdered * od.priceEach) AS 'Tổng tiền'
FROM
	customers c
    INNER JOIN orders o
    ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
GROUP BY
	c.customerNumber,
    c.customerName
ORDER BY
	SUM(od.quantityOrdered * od.priceEach) DESC
LIMIT 5;


/* 12. Hiển thị top 5 sản phẩm có tỷ lệ doanh số cao nhất*/

SELECT
	od.productCode,
    SUM(od.quantityOrdered * od.priceEach) AS 'Tổng doanh thu'
FROM
	orderdetails od
GROUP BY
	productCode
ORDER BY
	SUM(od.quantityOrdered * od.priceEach) DESC
LIMIT 5;

/* 13. Kiểm tra giao vận đã đúng thời gian yêu cầu chưa, hiển thị đơn hàng giao trễ. */

SELECT
	orderNumber,
    orderDate,
    requiredDate,
    shippedDate,
    datediff(shippedDate, requiredDate) AS DayDelayed
FROM
	orders
WHERE
	shippedDate > requiredDate;
    
/* 14. Đưa các các sản phẩm không có mặt trong bất kỳ một đơn hàng nào. */

SELECT
	*
FROM
	products 
WHERE
	productCode NOT IN 
		(SELECT
			productCode
		FROM
			orderdetails);
            
            
/* 15. Đưa ra các sản phẩm có số lượng trong kho lớn hơn trung bình số lượng trong kho của các sản phẩm cùng loại. */

SELECT
	*
FROM
	products
WHERE
	quantityInStock > (SELECT
							AVG(quantityInStock)
						FROM
							products);
                            
/* 16. Thống kê tổng số lượng sản phẩm trong kho theo từng dòng sản phẩm của từng nhà cung ứng */

SELECT
	productName,
    quantityInStock,
	productLine,
    productVendor
FROM
	products
GROUP BY
	productLine,
    productVendor;
    
    
/* 17. Thống kê ra mỗi sản phẩm được đặt hàng lần cuối vào thời gian nào và khách hàng đã đặt hàng */
SELECT 
    p.productCode AS "Mã sản phẩm",
    p.productName AS "Tên sản phẩm",
    o.orderDate AS "Ngày đặt hàng cuối",
    c.customerName AS "Tên khách hàng"
FROM
    products p
	JOIN
	orderdetails od ON p.productCode = od.productCode
	JOIN
	orders o ON od.orderNumber = o.orderNumber
	JOIN
	customers c ON o.customerNumber = c.customerNumber
WHERE
    o.orderDate = (
        SELECT 
            MAX(o2.orderDate)
        FROM 
            orders o2
        JOIN 
            orderdetails od2 ON o2.orderNumber = od2.orderNumber
        WHERE 
            od2.productCode = p.productCode
    )
ORDER BY 
    p.productCode;

 