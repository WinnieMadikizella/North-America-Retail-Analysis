USE North_America_Retail;

SELECT * FROM Sales_Retail;

--Entity Relationship Diagrams - split into fact and dimension tables
-- create a DimCustomer table from the Sales_Retail table
SELECT DISTINCT Customer_ID, Customer_Name, Segment 
INTO DimCustomer
FROM Sales_Retail;

SELECT * FROM DimCustomer;

WITH CTE_DimC AS (
    SELECT Customer_ID, Customer_Name, Segment,
           ROW_NUMBER() OVER (PARTITION BY Customer_ID, Customer_Name, Segment ORDER BY Customer_ID) AS ROW_NUM
    FROM DimCustomer)
DELETE FROM DimCustomer
WHERE Customer_ID IN (SELECT Customer_ID FROM CTE_DimC WHERE ROW_NUM > 1);

-- create a DimLocation table from the Sales_Retail table
SELECT DISTINCT Postal_Code, Country, City, State, Region 
INTO DimLocation
FROM Sales_Retail;

SELECT * FROM DimLocation;

WITH CTE_DimL AS (
    SELECT Postal_Code, Country, City, State, Region, 
           ROW_NUMBER() OVER (PARTITION BY Postal_Code, Country, City, State, Region ORDER BY Postal_Code) AS ROW_NUM
    FROM DimLocation)
DELETE FROM DimLocation
WHERE Postal_Code IN (SELECT Postal_Code FROM CTE_DimL WHERE ROW_NUM > 1);

-- create a DimProduct table from the Sales_Retail table
SELECT DISTINCT Product_ID, Category, Sub_Category, Product_Name 
INTO DimProduct
FROM Sales_Retail;

SELECT * FROM DimProduct;

WITH CTE_DimP AS (
    SELECT Product_ID, Category, Sub_Category, Product_Name, 
           ROW_NUMBER() OVER (PARTITION BY Product_ID, Category, Sub_Category, Product_Name ORDER BY Product_ID) AS ROW_NUM
    FROM DimProduct)
DELETE FROM DimProduct
WHERE Product_ID IN (SELECT Product_ID FROM CTE_DimP WHERE ROW_NUM > 1);


--to create our fact table-OrdersFactTable
SELECT DISTINCT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Postal_Code, Retail_Sales_People, 
                Product_ID, Returned, Sales, Quantity, Discount, Profit 
INTO OrdersFactTable
FROM Sales_Retail;

SELECT * FROM OrdersFacttable;

WITH CTE_OrderFact AS (
    SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Postal_Code, Retail_Sales_People, 
           Product_ID, Returned, Sales, Quantity, Discount, Profit, 
           ROW_NUMBER() OVER (PARTITION BY Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Postal_Code, 
                              Retail_Sales_People, Product_ID, Returned, Sales, Quantity, Discount, Profit 
                              ORDER BY Order_ID) AS ROW_NUM
    FROM OrdersFactTable)
DELETE FROM OrdersFactTable
WHERE Order_ID IN (SELECT Order_ID FROM CTE_OrderFact WHERE ROW_NUM > 1);

SELECT * FROM DimProduct
WHERE Product_ID = 'FUR-FU-10004091';

--same product_ID assigned to two different products
--add a new column called ProductKey to serve as a unique identifier for the DimProduct table
ALTER TABLE DimProduct
ADD ProductKey INT IDENTITY(1,1);

SELECT * FROM DimProduct;

--add the ProductKey to the OrdersFact table because we are going to link the two
ALTER TABLE OrdersFactTable
ADD ProductKey INT;

SELECT * FROM OrdersFacttable;

--added but are NULL hence link it with the DimProduct
UPDATE OrdersFactTable
SET ProductKey = DimProduct.ProductKey
FROM OrdersFactTable
JOIN DimProduct 
ON OrdersFactTable.Product_ID = DimProduct.Product_ID;

--to drop the product-ID from the OrdersFact and DimProduct tables
ALTER TABLE DimProduct
DROP COLUMN Product_ID;
ALTER TABLE OrdersFacttable
DROP COLUMN Product_ID;

SELECT * FROM DimProduct;
SELECT * FROM OrdersFacttable;

--ensure ProductKey in DimProduct is the Primary Key
ALTER TABLE DimProduct
ADD CONSTRAINT PK_DimProduct PRIMARY KEY (ProductKey);

--enforce referential integrity by linking ProductKey in OrdersFactTable to DimProduct
ALTER TABLE OrdersFactTable
ADD CONSTRAINT FK_OrdersFactTable_DimProduct 
FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey);

--link Customer_ID in OrdersFactTable to DimCustomer
ALTER TABLE DimCustomer
ADD CONSTRAINT PK_DimCustomer PRIMARY KEY (Customer_ID);

ALTER TABLE OrdersFactTable
ADD CONSTRAINT FK_OrdersFactTable_DimCustomer 
FOREIGN KEY (Customer_ID) REFERENCES DimCustomer(Customer_ID);

--link Postal_Code in OrdersFactTable to DimLocation
ALTER TABLE DimLocation
ADD CONSTRAINT PK_DimLocation PRIMARY KEY (Postal_Code);

ALTER TABLE OrdersFactTable
ADD CONSTRAINT FK_OrdersFactTable_DimLocation 
FOREIGN KEY (Postal_Code) REFERENCES DimLocation(Postal_Code);

--verify constraints
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY';



--Exploratory Data Analysis (EDA)
-- 1. Average Delivery Days for Each Product Subcategory
SELECT 
    p.Sub_Category, 
    DATEDIFF(DAY, o.Order_Date, o.Ship_Date) AS Delivery_Days
FROM OrdersFactTable o
JOIN DimProduct p 
ON o.ProductKey = p.ProductKey;

SELECT 
    p.Sub_Category, 
    AVG(DATEDIFF(DAY, o.Order_Date, o.Ship_Date)) AS Avg_Delivery_Days
FROM OrdersFactTable o
JOIN DimProduct p 
ON o.ProductKey = p.ProductKey
GROUP BY p.Sub_Category;

/*the average delivery days for the chairs, bookcases, furnishings and tables is 3 days*/


-- 2. Average Delivery Days by Customer Segment
SELECT 
    c.Segment, 
    AVG(DATEDIFF(DAY, o.Order_Date, o.Ship_Date)) AS Avg_Delivery_Days
FROM OrdersFactTable o
JOIN DimCustomer c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY Avg_Delivery_Days;

/*the average delivery days for each segment-Corporate, Home Office and Consumer is 3 days*/


-- 3. Top 5 Fastest and Slowest Delivered Products
-- Top 5 Fastest delivered products
SELECT TOP 5 
    p.ProductKey, p.Product_Name, 
    AVG(DATEDIFF(DAY, o.Order_Date, o.Ship_Date)) AS Avg_Delivery_Days
FROM OrdersFactTable o
JOIN DimProduct p ON o.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.Product_Name
ORDER BY Avg_Delivery_Days ASC;

/*the top 5 fastest delivered products are deliverd within 0 days and include
1. Global Enterprise Series Seating High-Back Swivel/Tilt Chairs
2. Tenex Chairmat w/Average Lip 45"*53*
3. Hon Pagoda Stacking Chairs
4. Nu-Dell EZ-Mount Plastic Wall Frames
5. Tenex Traditional Chairmats for Hard Flors, Average Lip, 36"*48* */

-- Top 5 slowest delivered products
SELECT TOP 5 
    p.ProductKey, p.Product_Name, 
    AVG(DATEDIFF(DAY, o.Order_Date, o.Ship_Date)) AS Avg_Delivery_Days
FROM OrdersFactTable o
JOIN DimProduct p ON o.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.Product_Name
ORDER BY Avg_Delivery_Days DESC;

/*the slowest delivered products are delivered within 6 and 5 days and include:
1. Rush Hierlooms Collection Rich Wood Bookcases
2. Hon Metal Bookcases, Gray
3. Ultra Commercial Grade Dual Valve Door Closer
4. O'Sullivan Manor Hill 2-Door Library in Brianna Oak
5. Bevis Round Conference Room Tables and Bases*/


-- 4. Most Profitable Product Subcategories
SELECT 
    p.Sub_Category, 
    SUM(o.Profit) AS Total_Profit
FROM OrdersFactTable o
JOIN DimProduct p ON o.ProductKey = p.ProductKey
GROUP BY p.Sub_Category
ORDER BY Total_Profit DESC;

/*the most profitable subcategory is the Chairs $26,682 while tables the lowest*/

-- 5. Most Profitable Customer Segment
SELECT 
    c.Segment, 
    SUM(o.Profit) AS Total_Profit
FROM OrdersFactTable o
JOIN DimCustomer c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY Total_Profit DESC;
/*the most profitable segment is corporate at $10,649*/


-- 6. Top 5 Customers by Profit Contribution
SELECT TOP 5 
    c.Customer_ID, c.Customer_Name, 
    SUM(o.Profit) AS Total_Profit
FROM OrdersFactTable o
JOIN DimCustomer c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Profit DESC;

/* the top 5 customers are:
1. Laura Armstrong
2. Quincy Jones
3. Joe Elijah
4. Bill Donatelli
5. Anne McFarland */

-- 7. What is the total number of products by Subcategory

SELECT 
    Sub_Category, 
    COUNT(DISTINCT ProductKey) AS Total_Products
FROM DimProduct
GROUP BY Sub_Category
ORDER BY Total_Products DESC;

/* total number of products per category are 186 for Furnishings, 87 for Chairs, 
48 for Bookcases and 34 for Tables */
