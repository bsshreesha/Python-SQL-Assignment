-- The outputs for each of the queries can be viewed in the SQL Screenshots Folder

-- 1. List the top 5 customers by total purchase amount.

SELECT FirstName || ' ' || LastName AS CustomerName, 
       SUM(Total) AS TotalSpent
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId
ORDER BY TotalSpent DESC
LIMIT 5;


-- 2. Find the most popular genre in terms of total tracks sold.

SELECT Genre.Name, 
       SUM(InvoiceLine.Quantity) AS TotalSold
FROM Genre
JOIN Track ON Genre.GenreId = Track.GenreId
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Genre.GenreId
ORDER BY TotalSold DESC
LIMIT 1;


-- 3. Retrieve all employees who are managers along with their subordinates.

SELECT m.FirstName || ' ' || m.LastName AS Manager,
       e.FirstName || ' ' || e.LastName AS Subordinate
FROM Employee e
JOIN Employee m ON e.ReportsTo = m.EmployeeId;


-- 4. For each artist, find their most sold album.

WITH AlbumSales AS (
    SELECT 
        ar.ArtistId,
        ar.Name AS Artist,
        al.Title AS Album,
        SUM(il.Quantity) AS TotalSold,
        ROW_NUMBER() OVER (
            PARTITION BY ar.ArtistId 
            ORDER BY SUM(il.Quantity) DESC
        ) AS rn
    FROM Artist ar
    JOIN Album al ON ar.ArtistId = al.ArtistId
    JOIN Track t ON al.AlbumId = t.AlbumId
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    GROUP BY ar.ArtistId, ar.Name, al.AlbumId, al.Title
)

SELECT Artist, Album, TotalSold
FROM AlbumSales
WHERE rn = 1
ORDER BY TotalSold DESC;



-- 5. Write a query to get monthly sales trends in the year 2013.

SELECT strftime('%Y-%m', InvoiceDate) AS Month,
       SUM(Total) AS Sales
FROM Invoice
WHERE strftime('%Y', InvoiceDate) = '2013'
GROUP BY Month
ORDER BY Month;
