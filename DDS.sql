

-- 1. Geography Dimension
CREATE TABLE Geography_Dimension (
    geography_key Int  PRIMARY KEY, 
    country NVARCHAR(50), 
    state NVARCHAR(50),
    city NVARCHAR(50),
    postal_code NVARCHAR(20),
    territory NVARCHAR(50)
);

-- 2. Customer Dimension
CREATE TABLE Customer_Dimension (
    customer_key int  PRIMARY KEY, 
    customer_name NVARCHAR(100), 
    phone NVARCHAR(50),
    address NVARCHAR(255) 
);

-- 3. Product Dimension
CREATE TABLE Product_Dimension (
    product_code NVARCHAR(50) PRIMARY KEY,
    product_name NVARCHAR(50),
    product_line NVARCHAR(255), 
    msrp MONEY, 
);



-- 5. Time Dimension
CREATE TABLE Time_Dimension (
    full_date DATE PRIMARY KEY,
    day_of_month INT, 
    month INT,
    quarter INT, 
    year INT 
);

-- 6. Coupon Dimension
CREATE TABLE Coupon_Dimension (
    coupon_key INT  PRIMARY KEY,
    coupon_code NVARCHAR(20)
);

-- 7. Warehouse Dimension
CREATE TABLE Warehouse_Dimension (
    warehouse_key INT  PRIMARY KEY,
    product_id NVARCHAR(50), 
    stock_quantity INT 
);

-- 8. Sales Fact Table
CREATE TABLE Sales_Fact (
    order_number INT  PRIMARY KEY, -- ID duy nhất
    product_code NVARCHAR(50), -- FK liên kết tới Product Dimension
    customer_key INT, -- FK liên kết tới Customer Dimension
    time_key Date, -- FK liên kết tới Time Dimension
    coupon_key INT, -- FK liên kết tới Coupon Dimension
    warehouse_key INT, -- FK liên kết tới Warehouse Dimension
    geography_key INT, -- FK liên kết tới Geography Dimension

    quantity_ordered INT, 
    total_sales MONEY , 
    order_status NVARCHAR(50), 
    deal_size NVARCHAR(20),
    CONSTRAINT FK_Sales_Product FOREIGN KEY (product_code) REFERENCES Product_Dimension(product_code),
    CONSTRAINT FK_Sales_Customer FOREIGN KEY (customer_key) REFERENCES Customer_Dimension(customer_key),
    CONSTRAINT FK_Sales_Time FOREIGN KEY (time_key) REFERENCES Time_Dimension(full_date),
    CONSTRAINT FK_Sales_Coupon FOREIGN KEY (coupon_key) REFERENCES Coupon_Dimension(coupon_key),
    CONSTRAINT FK_Sales_Warehouse FOREIGN KEY (warehouse_key) REFERENCES Warehouse_Dimension(warehouse_key),
    CONSTRAINT FK_Sales_Geography FOREIGN KEY (geography_key) REFERENCES Geography_Dimension(geography_key)
);
