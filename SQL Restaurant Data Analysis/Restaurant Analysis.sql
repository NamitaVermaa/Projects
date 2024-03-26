/* 1. Create invitations for a party  */
SELECT firstname, lastname, email, phone FROM Customers; 

/*2. Create a table to store information */
CREATE TABLE PartyInvites (firstname varchar(20), lastname varchar(20), email varchar(20), phone int(10),
                           FOREIGN KEY (customerid) REFERENCES Customers(customerid));

/* 3. Print a menu */
SELECT name, price, type FROM Dishes
ORDER BY type,price ASC;

/* 4. Update Customer Personal Information  */
UPDATE Customers
SET state='CA', phone='499-118-1613', city='San Francisco'
WHERE customerid=40;

/* 5. Remove Customer Record */
DELETE FROM Customers
WHERE customerid=8;

/* 6. Look up Reservations */
SELECT c.customerid, c.firstname, c.lastname,
c.phone, c.email, r.* 
FROM Customers c INNER JOIN Reservations r 
ON c.CustomerID=r.CustomerID
WHERE r.Date LIKE '2020%';

/* 7.  Take a Reservation */
SELECT * FROM Customers 
WHERE Email = 'smac@rouxacademy.com';

INSERT INTO Customers(FirstName, LastName, Email, Phone)
VALUES('Same', 'McAdams', 'smac@rouxacademy.com', '(555)555-1212)');

INSERT INTO Reservations(CustomerID, Date, PartySize)
VALUES('102','2020-07-14 18:00:00','5');

SELECT * FROM Reservations 
WHERE CustomerID = 102;

/* 8. Take a Delivery Order */
/* check cusotmer exist or not */
SELECT * FROM Customers
WHERE FirstName = 'Loretta' AND LastName = 'Hundey';

/* check dishes */
SELECT * FROM Dishes;

/* create order */
INSERT INTO Orders(CustomerID, OrderDate)
VALUES(
	(SELECT CustomerID FROM Customers WHERE FirstName = 'Loretta' AND LastName = 'Hundey'),
	'27-08-2020 20:00:00'
);

/* check the latest order of that customer */
SELECT OrderID FROM Orders WHERE CustomerID IN 
		(SELECT CustomerID FROM Customers WHERE FirstName = 'Loretta' AND LastName = 'Hundey')
ORDER BY OrderID DESC
LIMIT 1;

/*9. Top 5 customers */
SELECT c.firstname, c.lastname, COUNT(o.orderid) AS order_count 
FROM Customers c INNER JOIN Orders o 
ON c.CustomerID=o.CustomerID
GROUP BY c.CustomerID
ORDER BY order_count DESC
LIMIT 5;
	