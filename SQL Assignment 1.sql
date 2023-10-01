-- Create the database
CREATE DATABASE SalesDatabase;

-- Use the database
USE SalesDatabase;

-- Create the Product table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255),
    Description TEXT,
    Price DECIMAL(10, 2),
    Category VARCHAR(50)
);

-- Create the Region table
CREATE TABLE Region (
    RegionID INT PRIMARY KEY AUTO_INCREMENT,
    RegionName VARCHAR(100)
);

-- Create the TimePeriod table
CREATE TABLE TimePeriod (
    TimePeriodID INT PRIMARY KEY AUTO_INCREMENT,
    TimePeriodName VARCHAR(50)
);

-- Create the Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Address TEXT,
    Age INT,
    LoyaltyStatus BOOLEAN
);

-- Create the Purchase table
CREATE TABLE Purchase (
    PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TimePeriodID INT,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TimePeriodID) REFERENCES TimePeriod(TimePeriodID)
);

-- Create the PurchaseProduct table (Many-to-Many Relationship)
CREATE TABLE PurchaseProduct (
    PurchaseProductID INT PRIMARY KEY AUTO_INCREMENT,
    PurchaseID INT,
    ProductID INT,
    Quantity INT,
    Subtotal DECIMAL(10, 2),
    FOREIGN KEY (PurchaseID) REFERENCES Purchase(PurchaseID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create the ProductRegion table (Many-to-Many Relationship)
CREATE TABLE ProductRegion (
    ProductRegionID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    RegionID INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

-- Create the Inventory table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    StockLevel INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Insert sample data into the Region table
INSERT INTO Region (RegionName) VALUES
    ('North India'),
    ('South India'),
    ('East India'),
    ('West India');

-- Insert sample data into the TimePeriod table
INSERT INTO TimePeriod (TimePeriodName) VALUES
    ('Q1 2023'),
    ('Q2 2023'),
    ('Q3 2023'),
    ('Q4 2023');

-- Insert sample data into the Customer table
INSERT INTO Customer (FirstName, LastName, Address, Age, LoyaltyStatus) VALUES
    ('Amit', 'Kumar', '123 Main Street, Delhi', 35, 1),
    ('Sneha', 'Sharma', '456 Park Avenue, Mumbai', 28, 0),
    ('Rajesh', 'Verma', '789 Oak Road, Kolkata', 42, 1),
    ('Priya', 'Singh', '101 Pine Lane, Chennai', 22, 0);

-- Insert sample data into the Product table
INSERT INTO Product (ProductName, Description, Price, Category) VALUES
    ('Widget A', 'High-quality widget', 19.99, 'Widgets'),
    ('Gadget B', 'Feature-rich gadget', 49.99, 'Gadgets'),
    ('Widget C', 'Economical widget', 9.99, 'Widgets'),
    ('Gadget D', 'Premium gadget', 99.99, 'Gadgets');

-- Insert sample data into the Inventory table
INSERT INTO Inventory (ProductID, StockLevel) VALUES
    (1, 100),
    (2, 75),
    (3, 150),
    (4, 50);

-- Insert sample data into the Purchase table
INSERT INTO Purchase (CustomerID, TimePeriodID, TotalAmount) VALUES
    (1, 1, 59.97),
    (2, 1, 49.99),
    (3, 2, 99.99),
    (4, 3, 29.97);

-- Insert sample data into the PurchaseProduct table
INSERT INTO PurchaseProduct (PurchaseID, ProductID, Quantity, Subtotal) VALUES
    (1, 1, 3, 59.97),
    (2, 2, 1, 49.99),
    (3, 3, 10, 99.99),
    (4, 4, 3, 29.97);
-- total sales by product
SELECT
    p.ProductName,
    SUM(pp.Quantity) AS TotalQuantitySold,
    SUM(pp.Subtotal) AS TotalRevenue
FROM
    Product p
JOIN
    PurchaseProduct pp ON p.ProductID = pp.ProductID
GROUP BY
    p.ProductName;
-- Total Sales by Region
SELECT
    r.RegionName,
    SUM(pp.Quantity) AS TotalQuantitySold,
    SUM(pp.Subtotal) AS TotalRevenue
FROM
    Region r
JOIN
    ProductRegion pr ON r.RegionID = pr.RegionID
JOIN
    PurchaseProduct pp ON pr.ProductID = pp.ProductID
GROUP BY
    r.RegionName;
-- Total Sales by Time Period
SELECT
    tp.TimePeriodName,
    SUM(pp.Quantity) AS TotalQuantitySold,
    SUM(pp.Subtotal) AS TotalRevenue
FROM
    TimePeriod tp
JOIN
    Purchase p ON tp.TimePeriodID = p.TimePeriodID
JOIN
    PurchaseProduct pp ON p.PurchaseID = pp.PurchaseID
GROUP BY
    tp.TimePeriodName;
-- Customer Data Queries:
--  Customer Purchase History:
SELECT
    c.FirstName,
    c.LastName,
    COUNT(p.PurchaseID) AS TotalPurchases,
    SUM(p.TotalAmount) AS TotalSpent
FROM
    Customer c
LEFT JOIN
    Purchase p ON c.CustomerID = p.CustomerID
GROUP BY
    c.FirstName, c.LastName;
-- Customers by Loyalty Status:
SELECT
    CASE
        WHEN c.LoyaltyStatus = 1 THEN 'Loyal'
        ELSE 'Non-Loyal'
    END AS LoyaltyCategory,
    COUNT(c.CustomerID) AS CustomerCount
FROM
    Customer c
GROUP BY
    LoyaltyCategory;
--  Inventory Data Queries:
-- Product Availability and Stock Levels:
SELECT
    p.ProductName,
    i.StockLevel
FROM
    Product p
JOIN
    Inventory i ON p.ProductID = i.ProductID;
