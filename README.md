# North-America-Retail-Analysis
Retail Sales Optimization Analysis for North America using SQL

# Project Overview
North America Retail is a large retail company with stores in many locations, selling various products to different customers. They aim to provide good customer service and an easy shopping experience. This analysis will examine its current operations to find areas to improve and suggest ways to increase efficiency and profits.

# Data Source
The data used includes:
  Retail Supply Chain Sales Analysis.CSV
  Calendar Date.CSV

# Data Extraction and Processing Methodology 
The analysis was conducted using SQL to extract, clean, and process data efficiently. The methodology involved:

## 1. Data Cleaning & Transformation
Created dimension tables (DimCustomer, DimLocation, DimProduct) from Sales_Retail, ensuring no duplicate records.
Established a fact table (OrdersFactTable) containing transactional data.

## 2. Data Integrity & Relationships
Added ProductKey as a unique identifier in DimProduct and linked it to OrdersFactTable to avoid duplicate Product_IDs.
Enforced referential integrity by setting primary and foreign key constraints across dimension and fact tables.

## 3. Exploratory Data Analysis (EDA)
Performed aggregations and grouping to analyze delivery efficiency, profitability, and product trends.
Used JOIN operations to integrate OrdersFactTable with dimensions for deeper insights.

## Entity-Relationship Diagram (ERD) Overview
An Entity Relationship Diagram (ERD) was created to establish table relationships.

![Image](https://github.com/user-attachments/assets/0dfa9229-68ae-4135-99dc-74b99122bfd3)

The ERD represents a star schema with OrdersFactTable as the central fact table, surrounded by four dimension tables: DimCustomer, DimProduct, DimLocation, and DimCalendar. Below is a breakdown of the relationships:
### 1. OrdersFactTable → DimCustomer (Many-to-One Relationship)
Key Relationship: Customer_ID
Description: Links orders to customer details, including customer name and segment. Each order is associated with a single customer, but a customer can place multiple orders.
### 2. OrdersFactTable → DimProduct (Many-to-One Relationship)
Key Relationship: ProductKey
Description: Connects orders to product attributes such as category, sub-category, and product name. Each order contains a product, and products can appear in multiple orders.
### 3. OrdersFactTable → DimLocation (Many-to-One Relationship)
Key Relationship: Postal_Code
Description: Maps orders to geographical locations, including city, state, and country. Each order is shipped to a specific location.
### 4. OrdersFactTable → DimCalendar (Many-to-One Relationship)
Key Relationship: Order_Date
Description: Associates orders with a calendar dimension for time-based analysis. This allows grouping of orders by year, quarter, month, and week.

# Objectives
1. Analyzing the average delivery time for different product subcategories.
2. Determine the average delivery time for each customer segment.
3. Identifying the top 5 fastest and slowest delivered products.
4. Evaluating the most profitable product subcategory.
5. Assessing which customer segment contributes the most profit.
6. Recognizing the top 5 customers driving profitability.
7. Counting the total number of products available by subcategory.

# Findings
## 1. Delivery Analysis:
  - The average delivery time for Chairs, Bookcases, Furnishings, and Tables is 3 days.
  - Across customer segments (Corporate, Home Office, Consumer), the average delivery time is also 3 days.
  - The fastest delivered products (0 days) include office chairs and chair mats.
  - The slowest delivered products (5-6 days) include bookcases and conference tables.

## 2. Profitability Insights:
  - Chairs are the most profitable subcategory ($26,682 in profit), while Tables generate the least profit.
  - Corporate customers contribute the most profit ($10,649).
  - The top 5 profitable customers are Laura Armstrong, Quincy Jones, Joe Elijah, Bill Donatelli, and Anne McFarland.

## 3. Product Distribution:
  - Furnishings is the most diverse subcategory with 186 unique products, followed by Chairs (87), Bookcases (48), and Tables (34).

# Recommendations
## 1. Optimize Delivery for Slow-Moving Products:
  - Investigate why bookcases and conference tables take longer to deliver and improve shipping logistics.
  - Consider alternative suppliers or faster shipping methods for slow-moving products.

## 2. Increase Profitability in Low-Performing Categories:
  - Introduce discounts or promotions to boost sales in the Tables subcategory.
  - Bundle low-performing products with high-demand items to increase sales.

## 3. Strengthen Corporate Customer Relations:
  - Since corporate customers are the most profitable, create loyalty programs or bulk discounts to encourage repeat business.

## 4. Inventory Optimization:
  - Since Furnishings has the highest variety of products, ensure that low-demand items are not overstocked.
  - Conduct an ABC inventory analysis to classify products based on profitability and demand.

## 5. Customer Targeting & Personalization:
  - The top 5 profitable customers should be targeted with personalized offers, VIP discounts, or premium services to enhance engagement.

## 6. Logistics Improvement:
  - Tracking apps should be implemented to enable customers to track their orders and improve communication.
  - The delivery model for fast-moving products (e.g., office chairs) should be adopted for slower-moving products to reduce delivery times.
  - Alternative delivery routes should be explored to increase efficiency.
  - Delivery vans and trucks should be serviced regularly to ensure reliability.
  - Driver training programs should be implemented to enhance efficiency.

## 7. Product and Service Enhancement:
  - The production team should develop more products catering to the Home Office segment to drive higher sales.
  - The Chair subcategory should be readily available to maintain its profitability.
  - Low-performing products should be sold on discount to improve turnover.

# Conclusion
This analysis provides a data-driven roadmap for North America Retail to optimize its operations, increase profitability, and enhance customer satisfaction. By addressing delivery inefficiencies, focusing on high-profit customer segments, and improving inventory management, the company can streamline processes and drive growth. Implementing strategic logistics improvements and tailored customer engagement initiatives will further position North America Retail as a market leader in the competitive retail landscape.
