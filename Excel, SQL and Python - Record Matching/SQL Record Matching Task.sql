USE demo;
CREATE TABLE data1 ( Order_ID VARCHAR(20), Product_ID VARCHAR(20), Qty INT(10), ordandprod VARCHAR(250));
CREATE TABLE data2 ( Order_ID VARCHAR(20), Product_ID VARCHAR(20), Qty INT(10),ordandprod VARCHAR(250));
INSERT INTO data1 VALUES('CA-2014-100090-','FUR-TA-10003715',3,'CA-2014-100090-FUR-TA-10003715'),('CA-2014-100090','OFF-BI-10001597',6,'CA-2014-100090-OFF-BI-10001597'),
('CA-2014-100293','OFF-PA-10000176',6,'CA-2014-100293-OFF-PA-10000176'),('CA-2014-100328','OFF-BI-10000343',1,'CA-2014-100328-OFF-BI-10000343'),
('CA-2014-100363','OFF-FA-10000611',2,'CA-2014-100363-OFF-FA-10000611'),('CA-2014-100363','OFF-PA-10004733',3,'CA-2014-100363-OFF-PA-10004733'),
('CA-2014-100391','OFF-PA-10001471',2,'CA-2014-100391-OFF-PA-10001471'),('CA-2014-100678','FUR-CH-10002602',3,'CA-2014-100678-FUR-CH-10002602'),
('CA-2014-100678','OFF-AR-10001868',2,'CA-2014-100678-OFF-AR-10001868'),('CA-2014-100678','OFF-EN-10000056',3,'CA-2014-100678-OFF-EN-10000056');
SELECT * FROM data1;

INSERT INTO data2 VALUES('CA-2014-100363','OFF-PA-10004733',3,'CA-2014-100363-OFF-PA-10004733'),('CA-2014-100391','OFF-PA-10001471',2,'CA-2014-100391-OFF-PA-10001471'),
('CA-2014-100678','FUR-CH-10002602',3,'CA-2014-100678-FUR-CH-10002602'),('CA-2014-100678','OFF-AR-10001868',2,'CA-2014-100678-OFF-AR-10001868'),
('CA-2014-100678','OFF-EN-10000056',3,'CA-2014-100678-OFF-EN-10000056'),('CA-2014-100706','FUR-FU-10002268',6,'CA-2014-100706-FUR-FU-10002268'),
('CA-2014-100706','TEC-AC-10001314',2,'CA-2014-100706-TEC-AC-10001314'),('CA-2014-100762','OFF-AR-10000380',4,'CA-2014-100762-OFF-AR-10000380'),
('CA-2014-100762','OFF-LA-10003930',2,'CA-2014-100762-OFF-LA-10003930'),('CA-2014-100762','OFF-PA-10001815',3,'CA-2014-100762-OFF-PA-10001815');
SELECT * FROM data2;

/* 1. How to identify the Records (Order ID + Product ID combination) present in data1 but missing in data2 (Specify the number of records missing in your answer) */
SELECT 
(SELECT COUNT(d.ordandprod)
FROM data1 d LEFT JOIN data2 e
ON d.ordandprod = e.ordandprod)
-
(SELECT COUNT(d.ordandprod)
FROM data1 d INNER JOIN data2 e
ON d.ordandprod = e.ordandprod)
AS 'data present in data1 but missing in data2';

/* 2.	How to identify the Records (Order ID + Product ID combination) missing in data1 but present in data2 (Specify the number of records missing in your answer) */
SELECT 
(SELECT COUNT(d.ordandprod)
FROM data2 d LEFT JOIN data1 e
ON d.ordandprod = e.ordandprod)
-
(SELECT COUNT(d.ordandprod)
FROM data1 d INNER JOIN data2 e
ON d.ordandprod = e.ordandprod)
AS 'data missing in data1 but present in data2';

/* 3.	Find the Sum of the total Qty of Records missing in data1 but present in data2 */
SELECT
(SELECT sum(Qty)
FROM data2 
WHERE ordandprod IN 
(SELECT d.ordandprod
FROM data2 d LEFT JOIN data1 e
ON d.ordandprod = e.ordandprod))
-
(SELECT sum(Qty)
FROM data2 
WHERE ordandprod IN 
(SELECT d.ordandprod
FROM data2 d INNER JOIN data1 e
ON d.ordandprod = e.ordandprod)
) AS 'sum of recs missing from data1 and present in data2';

/* 4. Find the total number of unique records (Order ID + Product ID combination) present in the combined dataset of data1 and data2 */
SELECT
(SELECT COUNT(DISTINCT(ordandprod)) from data1)
+
(SELECT COUNT(DISTINCT(ordandprod)) from data2)
-
(SELECT COUNT(ordandprod)
FROM data2 
WHERE ordandprod IN 
(SELECT d.ordandprod
FROM data2 d INNER JOIN data1 e
ON d.ordandprod = e.ordandprod)
) AS 'total unique records';
