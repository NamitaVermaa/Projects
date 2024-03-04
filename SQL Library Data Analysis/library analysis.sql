/* 1.1.Find the number of available copies of Dracula  */
SELECT *, COUNT(*) AS number_of_copies FROM Books 
WHERE title LIKE '%DRACULA%';

/* 1.2. Current total loans of the book */
SELECT count(l.loanid) as total_loan, b.title
from Books b inner join Loans l 
on  b.BookID=l.BookID
WHERE b.title LIKE '%DRACULA%'
and ReturnedDate IS NULL;

/* 1.3. Total available book */
SELECT
	(SELECT COUNT(BookID) AS TotalCopies
	FROM Books
	WHERE Title LIKE '%Dracula%')
	-
	(SELECT COUNT(LoanID) AS TotalLoans
	FROM Loans
	WHERE BookID IN (
		SELECT BookID FROM Books WHERE Title LIKE '%Dracula%'
	)
	AND ReturnedDate IS NULL)
AS AvailableBooks;

/* 2. Check books for Due back. generate a report of books due back on July 13, 2020 with patron contact information  */
SELECT * FROM Patrons
WHERE patronid IN 
(SELECT patronid FROM Loans WHERE duedate like '%2020-07-13%');

/* 3. Find books to feature for an event. create a list of books from 1890s that are currently available */
SELECT b.bookid, b.title,b.author, b.published 
FROM Books b INNER JOIN Loans l 
ON  b.BookID=l.BookID
WHERE b.published BETWEEN 1890 and 1899
AND l.ReturnedDate IS NULL;

# Book Statistics 
/*1. create a report to show how many books were published each year. */
SELECT PUBLISHED,
		COUNT(DISTINCT(bookid)) AS BOOK_COUNT
FROM Books GROUP BY published
ORDER BY BOOK_COUNT;

/* 2. create a report to show 5 most popular Books to check out */
SELECT B.BookID,B.TITLE, B.AUTHOR, B.PUBLISHED, COUNT(L.LoanID) AS countofpurchase
FROM Books B INNER JOIN Loans L
ON B.BookID=L.BookID
GROUP BY b.Title
ORDER BY countofpurchase DESC
LIMIT 5;

/* 3. generate a report of showing 10 patrons who have checked out the fewest books.*/
SELECT p.FirstName, p.LastName, p.Email, COUNT(l.LoanID) AS Total_Loans
FROM Patrons p
LEFT JOIN Loans l
ON p.PatronID = l.PatronID
GROUP BY p.PatronID
ORDER BY Total_Loans ASC
LIMIT 10;




    
