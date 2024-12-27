# Building a Data Warehouse for Business Analysis of a Clothing Store

## Introduction

### Main Objective:
This project focuses on designing and implementing a data warehouse system to store and comprehensively analyze business data for a clothing store. The system aims to assist management in strategic decision-making, optimize operations, and enhance business efficiency.

### Specific Requirements:

#### Data Collection:
Integrate data from various sources, including:
- **Sales:** Revenue, product details, time, and sales regions.
- **Customers:** Personal information, purchase history, and consumer behavior.
- **Inventory:** Stock levels, best-selling products, and low-stock items.
- **Promotions:** Details of discount programs, effectiveness of marketing campaigns.
- **Geography:** Information on purchase and consumption locations.

#### Data Processing:
- Clean the data to ensure accuracy and consistency.
- Transform data from different formats into a unified structure.
- Apply normalization techniques to minimize duplication and optimize storage.

#### Data Storage:
- Build a centralized data warehouse designed for analysis and reporting.
- Ensure scalability to handle increasing data volumes.

#### Analysis and Reporting:
Develop a flexible reporting system focusing on key business metrics, such as:
- Revenue by day, month, and year.
- Best and worst-selling products.
- Customer shopping behavior analysis.
- Deploy data visualization tools (dashboards, charts) to support decision-making.

---

## Key Components

### 1. Data Warehouse Design

#### **Data Sources:**
- **Database Diagram:** A database management system for the clothing store.
  ![Database Diagram](https://github.com/user-attachments/assets/2c936a4a-fd4b-4c2c-a3a1-af471bbc8872)
- **Sales Revenue Excel File:** Consolidated data on store sales.
  ![Sales Revenue Excel File](https://github.com/user-attachments/assets/527caa1f-ad8d-4b96-be3f-80b8ebc9ff06)

#### **Requirement Analysis:**
- Collect and process data from multiple sources.

#### **Data Structure:**
- **Relational Database:** 
- **OLAP Data Warehouse:** Analyzable star schema model including:
  - Sales_Fact
  - Warehouse_Dimension
  - Coupon_Dimension
  - Geography_Dimension
  - Product_Dimension
  - Customer_Dimension
  - Time_Dimension

#### **Illustrations:**
- Image: **Star Schema Data Warehouse Model**
  ![Star Schema Model](https://github.com/user-attachments/assets/41283139-de06-48a8-84cf-e935ba1c10bb)

---

### 2. ETL Process (Extract, Transform, Load)

#### Using **SSIS**:
- Extract data from SQL Server and Excel files.
- Cleanse, transform, and load the data into the data warehouse.

#### **Illustrations:**
- Image: **SSIS Process Workflow**
  ![SSIS Workflow](https://github.com/user-attachments/assets/ffa342b4-21d8-46c6-93c8-a2d71fab0f8b)

#### Dimensions Analyzed:
- **Dim_Time:** For analyzing data by time.
  ![Dim_Time](https://github.com/user-attachments/assets/8c2b4a69-a566-4632-911f-b54807eec6e8)

- **Dim_Coupon:** For analyzing data by coupon.
  ![Dim_Coupon](https://github.com/user-attachments/assets/993cb4f5-ca4e-4502-9411-033f6d78d047)

- **Dim_Customer:** For analyzing customer-related data.
  ![Dim_Customer](https://github.com/user-attachments/assets/9e197b1d-6956-4025-9014-93c4b84b6633)

- **Dim_Product:** For analyzing data by product.
  ![Dim_Product](https://github.com/user-attachments/assets/7552bec5-41d5-41e5-9fb5-c78fc55af732)

- **Dim_Geography:** For geographic data analysis.
  ![Dim_Geography](https://github.com/user-attachments/assets/4a232ff6-a727-46a8-a378-291135cd2913)

- **Dim_Warehouse:** For warehouse-related data.
  ![Dim_Warehouse](https://github.com/user-attachments/assets/ea6f3d58-3d72-4523-8e6d-cdd07136d14e)

#### **Fact Table:**
- Analyzing sales data, summarizing, and measuring performance.
  ![Fact Table](https://github.com/user-attachments/assets/b1605050-c761-4a95-81fe-95cfd0f40c67)

---

### 3. Data Analysis and Visualization

#### **SSAS (SQL Server Analysis Services):**
- Create cubes for multidimensional data analysis.
- Configure dimensions such as Time, Product, Customer, and Coupon for detailed analysis.

#### **Application Interface:**
- **Key Features:**
  - **MDX Querying:** Supports querying and report generation.
  - **Statistics:** Analyze sales, products, and customers.
  - **Tableau:** Advanced data visualization.

#### **Illustrations:**
- Images: **SSAS Cube Interface**, **MDX Queries**, **Statistics Overview**, and **Tableau Visualizations**.
  ![SSAS Cube](https://github.com/user-attachments/assets/d08e668a-58bb-4bdd-a3a6-1b8affdf437a)
  ![MDX Query](https://github.com/user-attachments/assets/1f6a182a-d210-408a-8d95-5571289df678)
  ![Statistics 1](https://github.com/user-attachments/assets/8b492ba8-2e55-4b59-a99c-ca1a5b169e87)
  ![Statistics 2](https://github.com/user-attachments/assets/04d19d88-9778-4db3-8084-841d747a7075)
  ![Statistics 3](https://github.com/user-attachments/assets/c97681be-c8b0-456e-baea-00608b00545e)
  ![Tableau](https://github.com/user-attachments/assets/6cb9d4d1-bcdb-4eca-8014-04ef616d6fcc)

---

## User Guide

### 1. **System Requirements:**
   - SQL Server, SSIS, SSAS.
   - Tableau or similar visualization tools.

### 2. **Installation:**
   - Import data from Excel files or SQL Server.
   - Configure cubes in SSAS and connect to the application interface.

### 3. **Key Features:**
   - Query data using MDX.
   - View and export statistical reports based on multiple criteria (revenue, best-selling products, etc.).
   - Perform advanced analyses using Tableau.

---

## Outcomes

- Improved data management and analysis processes.
- Enhanced reporting capabilities, enabling better strategic business and customer service decisions.

---

## Limitations and Future Directions

- The system does not yet include predictive analytics or revenue forecasting.
- Enhance data security features.
- Expand scalability to support multiple stores or chains.

---

## Contributions

Feedback and contributions are welcome! Feel free to create a **pull request** or **issue** if you would like to contribute to this project.
