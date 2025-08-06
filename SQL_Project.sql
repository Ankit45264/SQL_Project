-- Create Database
CREATE DATABASE OnlineBookstore;


-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books
WHERE Genre ='Fiction';

-- 2) Find books published after the year 1950:

SELECT * FROM Books
WHERE Published_Year >1950;

-- 3) List all customers from the Canada:

SELECT * FROM Customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023:

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(STOCK) AS Book_Available
FROM Books;

-- 6) Find the details of the most expensive book:

SELECT * FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:


SELECT * FROM Orders
WHERE Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM Orders
WHERE Total_Amount >20;


-- 9) List all genres available in the Books table:

SELECT DISTINCT Genre FROM Books;


-- 10) Find the book with the lowest stock:

SELECT * FROM Books
Order By Stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(Total_Amount) AS Revenue
FROM Orders;

-- Advance Questions : 


-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM ORDERS;

SELECT Books.Genre, SUM(Orders.Quantity) AS Total_Books_Sold
FROM Orders
JOIN Books ON Orders.book_id = Books.book_id
GROUP BY Books.Genre;


-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(Price) AS Average_price
FROM Books
WHERE Genre='Fantasy';
  
  
-- 3) List customers who have placed at least 2 orders:

SELECT Orders.customer_id, Customers.name, COUNT(Orders.Order_id) AS ORDER_COUNT
FROM Orders
JOIN Customers  ON Orders.customer_id=Customers.customer_id
GROUP BY Orders.customer_id, Customers.name
HAVING COUNT(Order_id) >=2;


-- 4) Find the most frequently ordered book:

SELECT Orders.Book_id, Books.title, COUNT(Orders.order_id) AS ORDER_COUNT
FROM Orders
JOIN books Books ON Orders.book_id=Books.book_id
GROUP BY Orders.book_id, Books.title
ORDER BY ORDER_COUNT DESC LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :


SELECT * FROM Books
WHERE Genre ='Fantasy'
ORDER BY Price DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT Books.Author, SUM(Orders.Quantity) AS Total_Books_Sold
FROM Orders
JOIN Books ON Orders.Book_ID=Books.Book_ID
GROUP BY Books.Author;


-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT Customers.City, Orders.Total_Amount
FROM Orders 
JOIN Customers ON Orders.Customer_ID = Customers.Customer_ID
WHERE Orders.Total_Amount > 30;



-- 8) Find the customer who spent the most on orders:

SELECT Customers.Customer_ID, Customers.Name, SUM(Orders.Total_Amount) AS Total_Spent
FROM Orders
JOIN Customers ON Orders.Customer_ID=Customers.Customer_ID
GROUP BY Customers.Customer_ID, Customers.Name
ORDER BY Total_Spent DESC LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT Books.Book_ID, Books.Title, Books.Stock, COALESCE(SUM(Orders.Quantity),0) AS Order_Quantity,  
	Books.Stock- COALESCE(SUM(Orders.Quantity),0) AS Remaining_Quantity
FROM Books
LEFT JOIN Orders ON Books.Book_ID=Orders.Book_ID
GROUP BY Books.Book_ID ORDER BY Books.Book_ID;