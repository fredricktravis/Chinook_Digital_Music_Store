/* I worked at getting some insights and analysis from the Chinook Digital Music Store. */

/* 1. A list of the albums, artists and album titles.
There are 204 albums listed on this digital music store.*/
SELECT albums.artistid, name AS ArtistName, title as AlbumTitle
FROM albums
JOIN artists
on albums.artistid = artists.artistid
GROUP BY albums.artistid
ORDER BY name ASC;

/* 2. Which country has the most purchases?
The highest purchase figure is in the USA, next is Canada in second position with France and Brazil in joint third position.
One can then infer that there is a huge market for music in the USA.*/
SELECT billingcountry, COUNT(billingcountry) AS Number_of_Invoices
FROM invoices
GROUP BY billingcountry
ORDER BY Number_of_Invoices desc;

/* 3. Which city has the best customers in terms of purchases?
Although the USA has a huge market as we learnt previously, Prague has the best set of customers.*/
SELECT BillingCity, SUM(Total) as TotalPurchase
FROM invoices
GROUP by BillingCity
ORDER by TotalPurchase DESC;

/* 4. Which country has the highest music sales?
The USA is in top position by a wide margin. We should consider having a musical concert at the USA*/
SELECT billingcountry, SUM(total) AS TotalSales
FROM invoices
GROUP by billingcountry
ORDER by TotalSales DESC;

/* 5. Which media type is most popular?
The most popular media type could be figured out in terms of purchases. MPEG audio file is the most popular media type.
Plans should be made to expand music platforms and devices that support this particular media type. */
SELECT media_types.name AS MediaType, SUM(total) AS Purchases
FROM media_types
JOIN tracks
ON media_types.MediaTypeId = tracks.MediaTypeId
JOIN invoice_items
ON tracks.TrackId = invoice_items.TrackId
JOIN invoices
ON invoice_items.invoiceid = invoices.invoiceid
GROUP BY media_types.name
order by SUM(total) DESC;

/* 6. We want to find out the best 3 customers for a loyalty reward program.
Again, the customer with the most spend happens to be located in Prague. */
SELECT customers.customerid, firstname, lastname, address, city, state, country, phone, email, SUM(total) AS TotalSpend
FROM customers
JOIN invoices
on customers.customerid = invoices.customerid
GROUP by customers.customerid
order by TotalSpend DESC;

/* 7. What music track made most money?
Walkabout from the album Lost, Season 1 made the most money in Chile*/
SELECT tracks.trackid, invoice_items.invoiceid, name, title AS AlbumTitle, billingcountry, SUM(total) AS TotalMoney
FROM invoice_items
JOIN tracks
ON tracks.trackid = invoice_items.trackid
JOIN invoices
on invoice_items.invoiceid = invoices.invoiceid
JOIN albums
ON tracks.albumid = albums.albumid
GROUP BY tracks.trackid
ORDER BY TotalMoney DESC;

/* 8. Now we know what music track made the most sales and in which country, we would like to know the name of the artist so as to 
invite them for a concert.
In this case, the artist's name is Lost. */
SELECT trackid, albums.artistid, tracks.name AS TrackName, title AS AlbumTitle, artists.name AS ArtistName
FROM tracks
JOIN albums
ON tracks.albumid = albums.albumid
JOIN artists
ON albums.artistid = artists.artistid
WHERE trackid like 2868;

/* 9. We can dive a little deeper to find the highest grossing album and in which country.
This way, we can determine destinations for a world tour.
The highest grossing album is Greatest Hits, in Finland.*/ 
SELECT invoice_items.invoiceid, title AS AlbumTitle, artists.name AS ArtistName, billingcountry, SUM(total) AS TotalMoney
FROM invoice_items
JOIN tracks
ON tracks.trackid = invoice_items.trackid
JOIN invoices
on invoice_items.invoiceid = invoices.invoiceid
JOIN albums
ON tracks.albumid = albums.albumid
JOIN artists
ON albums.artistid = artists.artistid
GROUP BY AlbumTitle
ORDER BY TotalMoney DESC;

/* 10. How many customers listen to Hip Hop/Rap music?
There are 9 out of 59 customers who are fans of Hip Hop/Rap music with most of them in the USA.*/
SELECT DISTINCT email, firstname, lastname, country, genres.name AS Genre
FROM customers
JOIN invoices
ON customers.customerid = invoices.customerid
JOIN invoice_items
ON invoices.invoiceid = invoice_items.InvoiceId
JOIN tracks
ON invoice_items.trackid = tracks.trackid
join genres
ON genres.genreid = tracks.genreid
WHERE Genre LIKE 'Hip Hop/Rap'
ORDER BY country;

/* 11. We would like to go further by finding out the artists of these Hip Hop/Rap songs, for possible musical concert plans.
They are House Of Pain and Planet Hemp.*/
SELECT artists.artistid, artists.name AS ArtistName, COUNT(artists.artistid) AS Number_of_songs,
albums.title AS AlbumTitle, genres.Name AS Genre
FROM tracks
JOIN albums
ON tracks.albumid = albums.albumid
JOIN artists
ON albums.artistid = artists.artistid
join genres
on tracks.GenreId = genres.genreid
where genres.Name LIKE 'Hip Hop/Rap'
GROUP BY artists.artistid
ORDER BY ArtistName;

/* 12. What is the most popular music genre by country?
Assumption: this determination can be made using the highest amount of purchases.
Rock is most popular in the USA*/
SELECT count(*) AS GenrePurchase, customers.country, genres.name AS Genre
FROM invoice_items
JOIN invoices
ON invoice_items.invoiceid = invoices.invoiceid
JOIN customers
ON invoices.customerid = customers.CustomerId
JOIN tracks
ON invoice_items.trackid = tracks.trackid
JOIN genres
on tracks.genreid = genres.genreid
GROUP BY customers.country, genres.name
ORDER BY GenrePurchase DESC;

/* 13. What tracks have unit prices higher than the average? */
SELECT tracks.trackid, tracks.name, invoice_items.unitprice
from tracks
JOIN invoice_items
on tracks.trackid = invoice_items.trackid
WHERE invoice_items.unitprice > (SELECT AVG(invoice_items.unitprice) AS avg_unitprice
                   				 FROM invoice_items)
ORDER by tracks.name;

/* 14. Who is the longest serving employee? We need to honour them for their long standing service.
The employee's name is Jane Peacock.*/
SELECT employeeid, lastname, firstname, title, hiredate, phone, email
from employees
ORDER by hiredate ASC;