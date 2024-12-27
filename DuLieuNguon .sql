Create database QL_QUANAO
ON
PRIMARY
(
    NAME = QL_QUANAO_Primary,
    FILENAME = 'D:\QL_QUANAO_Primary.mdf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 20MB
),
(
    NAME = QL_QUANAO_Secondary,
    FILENAME = 'D:\QL_QUANAO_Secondary.ndf',
    SIZE = 50MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = QL_QUANAO_Log,
    FILENAME = 'D:\QL_QUANAO_Log.ldf',
    SIZE = 50MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB
)
GO
use QL_QUANAO
GO
CREATE TABLE Users
(

	users_id int IDENTITY(1,1),
	first_name nvarchar(50),
	last_name nvarchar(50),
	adr nvarchar(200),
	phone varchar(50),
	email varchar(50),

	Constraint PK_Users PRIMARY KEY (users_id)
)

CREATE TABLE Account
(
	account_name varchar(50) not null,
	account_password varchar(255),
	role varchar(20),
	users_id int,
	isdeleted bit DEFAULT 0,

	Constraint PK_Account PRIMARY KEY (account_name),
	Constraint FK_Account_Users FOREIGN KEY (users_id) REFERENCES Users(users_id)
)
CREATE TABLE Coupon
(
    coupon_code varchar(20) not null,
    discount_percent int ,
	limit int
    Constraint PK_Coupon PRIMARY KEY (coupon_code),
    Constraint CHK_DiscountAmount CHECK(discount_percent > 0)
)
CREATE TABLE Invoices
(

	invoice_id varchar(20) not null,
	account_name varchar(50),
	invoice_date date,
	total_amount money DEFAULT 0,
	status nvarchar(30),
	coupon_code varchar(20) default(''),
	discount_Amount money default(0),
	FinalTotal money default(0),
	Constraint PK_Invoices PRIMARY KEY (invoice_id),
	Constraint FK_Invoices_Users FOREIGN KEY (account_name) REFERENCES Account(account_name),
	CONSTRAINT CHK_TotalAmount CHECK (total_amount >= 0),
	constraint FK_Invoices_Coupon foreign key(coupon_code) references Coupon(coupon_code)
)


CREATE TABLE Categories
(
	category_id int IDENTITY(1,1),
	category_name nvarchar(50),

	Constraint PK_Categories PRIMARY KEY (category_id)
)


CREATE TABLE Product
(

	product_id int IDENTITY(1,1) not null,
	product_name nvarchar(50),
	description nvarchar(255),
	price money,
	image_url varchar(100),
	isdeleted bit DEFAULT 0,
	Constraint PK_Product PRIMARY KEY (product_id),
	Constraint CHK_price CHECK(price >=0)
)

CREATE TABLE Categories_Products
(
	product_id int,
	category_id int,

	Constraint PK_Categories_Products PRIMARY KEY (product_id,category_id),
	Constraint FK_Categories_Products_Product FOREIGN KEY (product_id) REFERENCES Product(product_id),
	Constraint FK_Categories_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id)

)
	

CREATE TABLE Cart
(
	cart_id int Identity(1,1),
	product_id int,
	account_name varchar(50),
	quantity int,
	color nvarchar(20),
	size char(10),
	total_price money,
	isbuying bit DEFAULT 0,
	

	PRIMARY KEY (cart_id),
	FOREIGN KEY (account_name) REFERENCES Account(account_name),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
	Constraint CHK_quantity CHECK (quantity >=0),
	Constraint Unique_Cart unique (product_id,account_name,color,size)
)

CREATE TABLE Warehouse
(

	product_id int,
	color nvarchar(20),
	size char(10),
	quantity int

	Constraint PK_Warehose PRIMARY KEY (product_id,color,size),
	Constraint FK_Warehose_Product FOREIGN KEY (product_id) REFERENCES Product(product_id)
)

CREATE TABLE InvoiceDetails
(
	invoicesdetails_id int identity(1,1),
	invoice_id varchar(20),
	product_id int,
	quantity int,
	color nvarchar(20),
	size char(10),
	total_price money DEFAULT 0,

	Constraint PK_InvoicesDetails PRIMARY KEY (invoicesdetails_id),
	Constraint FK_InvoiceDetails_Invoices FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id),
	Constraint FK_InvoiceDetails_Product FOREIGN KEY (product_id) REFERENCES Product(product_id),
	Constraint Unique_InvoiceDetails unique (product_id,invoice_id,color,size)
)


CREATE TABLE Review
(
    review_id int IDENTITY(1,1),
    product_id int,
    account_name varchar(50),
    rating int CHECK (rating >= 1 AND rating <= 5),
    comment nvarchar(max),
    review_date datetime,
    
    Constraint PK_Review PRIMARY KEY (review_id),
    Constraint FK_Review_Product FOREIGN KEY (product_id) REFERENCES Product(product_id),
    Constraint FK_Review_Account FOREIGN KEY (account_name) REFERENCES Account(account_name)
)
GO
-----------------------------------TRIGGER-----------------------------
---Ngọc Lâm---------
-- kiểm tra số lượng trong kho trước khi mua và trừ đi số lượng sẵn có trong kho
create trigger addInsertInvoice
on InvoiceDetails
for insert,update
as
	if UPDATE(quantity)
	begin
		declare @color nvarchar(20),@size char(10),@product_id int ,@quantity int
		select @product_id=product_id,@color= color, @size=size,@quantity=quantity from inserted
		if(select quantity from Warehouse 
			where product_id = @product_id and
			color=@color and
			size=@size) < @quantity
			begin
				Print N'số lượng muốn mua nhiều hơn số lượng có trong kho'
				rollback tran
			end
		else 
			begin
				update Warehouse
				set quantity=quantity-@quantity
				where product_id = @product_id and
					color=@color and
					size=@size
			end
	end

GO
-- khi hoá đơn bị cancel thì update lại số lượng sản phẩm trong warehouse-------
create trigger UpdateWarehouseOnCancelStatusInvoice
on Invoices
for insert,update
as
	if UPDATE(status)
	begin
		DECLARE @invoice_id varchar(20), @newStatus nvarchar(30)
        SELECT @invoice_id = invoice_id, @newStatus = status FROM inserted
		if @newStatus='cancel'
		begin
			DECLARE @product_id int, @quantity int, @color nvarchar(20), @size char(10)
			DECLARE cur CURSOR FOR SELECT ID.product_id, ID.quantity, ID.color, ID.size 
									FROM deleted D
									INNER JOIN InvoiceDetails ID ON D.invoice_id = ID.invoice_id
			OPEN cur
            FETCH NEXT FROM cur INTO @product_id, @quantity, @color, @size
			WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE Warehouse
                SET quantity = quantity + @quantity
                WHERE product_id = @product_id
                AND color = @color
                AND size = @size

                FETCH NEXT FROM cur INTO @product_id, @quantity, @color, @size
            END
            CLOSE cur
            DEALLOCATE cur
		end
	end
--------



-----Thanh Duy-------
-----Chuyển tất cả hoá đơn đang có trạng thái "Pending" sang "Cancel" khi account bị xoá--------
GO
CREATE TRIGGER Update_Invoices_Status
ON Account
FOR UPDATE
AS
BEGIN
    IF UPDATE(isdeleted)
    BEGIN
        UPDATE Invoices
        SET status = 'Cancel'
        FROM inserted
        INNER JOIN deleted ON inserted.account_name = deleted.account_name
        INNER JOIN Invoices ON inserted.account_name = Invoices.account_name
        WHERE inserted.isdeleted = 1 AND deleted.isdeleted = 0 AND Invoices.status = 'Pending'
    END
END


--------Tự động tính tiền chi tiết hoá đơn------------
GO
CREATE TRIGGER Calculate_Total_Price
ON InvoiceDetails
FOR INSERT, UPDATE
AS
BEGIN
    UPDATE InvoiceDetails
    SET total_price = Product.price * InvoiceDetails.quantity
    FROM InvoiceDetails
    INNER JOIN inserted ON InvoiceDetails.invoice_id = inserted.invoice_id AND InvoiceDetails.product_id = inserted.product_id
    INNER JOIN Product  ON InvoiceDetails.product_id = Product.product_id
END



-------Ngọc Văn----------

-- Update tổng tiền trong invoices khi thêm hoặc xóa invoices details
GO
CREATE TRIGGER UpdateTotalAmountAfterInsertOrDeleteInvoiceDetails
ON InvoiceDetails
FOR INSERT, DELETE
AS
BEGIN
	DECLARE @invoice_id varchar(20)

	SELECT @invoice_id = ISNULL(i.Invoice_id, d.[Invoice_id])
	FROM inserted i
	FULL JOIN deleted d ON 1 = 1

	UPDATE Invoices
	SET total_amount = ISNULL(
		(SELECT SUM(total_price) FROM InvoiceDetails WHERE invoice_id = @invoice_id),0)
	WHERE Invoice_id = @invoice_id
END

-- Trừ LIMIT của coupon đi 1 nếu Invoice có coupon_code
GO
CREATE TRIGGER InsertCouponToInvoice
ON Invoices
FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT coupon_code FROM Invoices WHERE invoice_id = (SELECT invoice_id FROM inserted))
	BEGIN
		UPDATE Coupon
		SET limit = limit - 1
		WHERE coupon_code = (SELECT coupon_code FROM Invoices WHERE invoice_id = (SELECT invoice_id FROM inserted))
	END
END

-- Cập nhật FinalTotal và discount_amount của Invoices khi Invoice có coupon
GO
CREATE TRIGGER UpdateFinalPriceOnInvoiceWhenApplyCoupon
ON InvoiceDetails
FOR INSERT
AS
BEGIN
	DECLARE @total float
	DECLARE @percentDiscount float
	DECLARE @discountAmount float
	

	SET @percentDiscount = (SELECT discount_percent
							FROM Invoices 
							JOIN Coupon on Coupon.coupon_code = Invoices.coupon_code
							WHERE invoice_id = (SELECT invoice_id FROM inserted)
							)

	SET @total = (SELECT total_amount
							FROM Invoices 
							WHERE invoice_id = (SELECT invoice_id FROM inserted)
				 )

	SET @discountAmount = @total * @percentDiscount / 100

	IF EXISTS (SELECT coupon_code FROM Invoices WHERE invoice_id = (SELECT invoice_id FROM inserted))
	BEGIN
		UPDATE Invoices
		SET FinalTotal = total_amount - @discountAmount
		WHERE coupon_code = (SELECT coupon_code FROM Invoices WHERE invoice_id = (SELECT invoice_id FROM inserted))

		UPDATE Invoices
		SET discount_Amount = @discountAmount
		WHERE coupon_code = (SELECT coupon_code FROM Invoices WHERE invoice_id = (SELECT invoice_id FROM inserted))
	END
END

-- Cho phép thêm review nếu status là success trong table invoices
GO
CREATE TRIGGER AllowReviewOnSuccessInvoices
ON Review
FOR INSERT
AS
BEGIN
	IF NOT EXISTS (
		SELECT *
		FROM Invoices
		JOIN InvoiceDetails ON Invoices.invoice_id = InvoiceDetails.invoice_id
		WHERE Invoices.status = 'success'
		AND account_name = (SELECT account_name FROM inserted)
		AND InvoiceDetails.product_id = (SELECT product_id from inserted)
	)
		BEGIN
			print N'Bạn chưa mua sản phẩm này'
			ROLLBACK tran
		END
END



------------------------------------------------------------------------

-- User
GO
INSERT INTO Users (first_name, last_name, adr, phone, email)
VALUES (N'Hoàng', N'Thị Dung', N'123 Đường Lê Lợi, Quận 1, Thành phố Hồ Chí Minh', '0987654321', 'hoangdung@gmail.com')

INSERT INTO Users (first_name, last_name, adr, phone, email)
VALUES (N'Đinh', N'Văn Bình', N'456 Đường Nguyễn Huệ, Quận 3, Thành phố Hồ Chí Minh', '0901234567', 'dinhbinh@gmail.com')

INSERT INTO Users (first_name, last_name, adr, phone, email)
VALUES (N'Vũ', N'Tuấn Anh', N'789 Đường Võ Văn Tần, Quận 10, Thành phố Hồ Chí Minh', '0912345678', 'vutuananh@gmail.com')

INSERT INTO Users (first_name, last_name, adr, phone, email)
VALUES (N'Lâm', N'Thị Hà', N'101 Đường Cách Mạng Tháng Tám, Quận Bình Thạnh, Thành phố Hồ Chí Minh', '0976543210', 'lamthiha@gmail.com')

INSERT INTO Users (first_name, last_name, adr, phone, email)
VALUES (N'Nguyễn', N'Trung Kiên', N'999 Đường Nguyễn Thị Minh Khai, Quận 1, Thành phố Hồ Chí Minh', '0961234567', 'nguyentrungkien@gmail.com')


GO
-- accounts
INSERT INTO Account (account_name, account_password, role, users_id)
VALUES ('nguyenvana@gmail.com', 'userpass1', 'User', 1)

INSERT INTO Account (account_name, account_password, role, users_id)
VALUES ('tranthib@gmail.com', 'userpass2', 'User', 2)

INSERT INTO Account (account_name, account_password, role, users_id)
VALUES ('letuanc@gmail.com', 'userpass3', 'User', 3)

INSERT INTO Account (account_name, account_password, role, users_id)
VALUES ('phamthanhd@gmail.com', 'userpass4', 'User', 4)

INSERT INTO Account (account_name, account_password, role, users_id)
VALUES ('tranngoce@gmail.com', 'userpass5', 'User', 5)

INSERT INTO Account (account_name, account_password, role, users_id)
VALUES ('nguyenvana_admin@gmail.com', 'adminpass', 'Admin', 1)

INSERT INTO Account (account_name, account_password, role, users_id)
VALUES ('tranthib_staff@gmail.com', 'staffpass', 'Staff', 2)

GO
-- Product
INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Polo', N'Áo polo thời trang, phù hợp cho hoạt động ngoại ô.', 300000, 'polo.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Oxford', N'Áo Oxford lịch lãm, thích hợp cho mọi dịp.', 400000, 'oxford.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Thun', N'Áo thun thoáng khí, phù hợp cho mọi dịp.', 250000, 'tshirt.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Đồng Phục', N'Áo đồng phục chất lượng, thích hợp cho công ty, nhóm.', 350000, 'uniform.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Sơ Mi Công Sở', N'Áo sơ mi công sở thanh lịch, phù hợp cho môi trường công ty.', 500000, 'dressshirt.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Quần Jeans', N'Quần jeans nam phong cách, chất liệu thoáng khí.', 400000, 'jeans.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Quần Khaki', N'Quần khaki nam phong cách, chất liệu thoáng khí.', 350000, 'khaki.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Quần Đùi', N'Quần đùi thoải mái, phù hợp cho mùa hè.', 300000, 'shorts.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Quần Thể Thao', N'Quần thể thao co giãn, thoáng khí.', 180000, 'sportpants.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Thể Thao', N'Áo thể thao thoáng khí, phù hợp cho hoạt động thể dục.', 200000, 'sportshirt.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Phông', N'Áo phông trẻ trung, phù hợp cho mọi dịp.', 150000, 'tshirtcasual.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Quần Vải', N'Quần vải nam phong cách, thích hợp cho dạo phố.', 180000, 'trousers.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Len', N'Áo len ấm áp, phù hợp cho mùa đông.', 220000, 'sweater.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Khoác Nhẹ', N'Áo khoác nhẹ thời trang, phù hợp cho mùa thu.', 300000, 'lightjacket.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Sơ Mi Công Sở', N'Áo sơ mi công sở thanh lịch, phù hợp cho môi trường công ty.', 500000, 'dressshirt.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Quần Tây', N'Quần tây nam lịch lãm, chất liệu cao cấp.', 450000, 'dresspants.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Vest', N'Áo vest nam thanh lịch, phù hợp cho các dịp trang trọng.', 700000, 'suitvest.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Cưới', N'Áo cưới nam phong cách, lịch lãm.', 1000000, 'weddingsuit.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Váy Dự Tiệc', N'Váy dự tiệc nữ thanh lịch, phù hợp cho các dịp đặc biệt.', 800000, 'partydress.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Khoác Dạ', N'Áo khoác dạ nam sang trọng, ấm áp cho mùa đông.', 800000, 'wintercoat.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Khoác Bomber', N'Áo khoác bomber nam thời trang, phù hợp cho mùa thu và mùa xuân.', 450000, 'bomberjacket.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Dài Nam', N'Áo dài nam truyền thống, phù hợp cho các dịp lễ hội.', 600000, 'traditionalao.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Len Cổ V', N'Áo len nam kiểu cổ V, phong cách và ấm áp.', 350000, 'vneckknitsweater.jpg')

INSERT INTO Product (product_name, description, price, image_url)
VALUES (N'Áo Hoodie Nữ', N'Áo hoodie nữ ấm áp và thoải mái.', 400000, 'hoodiewomen.jpg')

GO
-- Categories
INSERT INTO Categories (category_name) VALUES (N'Áo Sơ Mi')
INSERT INTO Categories (category_name) VALUES (N'Quần dài')
INSERT INTO Categories (category_name) VALUES (N'Quần Áo Thể Thao')
INSERT INTO Categories (category_name) VALUES (N'Quần Áo Thường Ngày')
INSERT INTO Categories (category_name) VALUES (N'Quần Áo Công Sở')
INSERT INTO Categories (category_name) VALUES (N'Quần Áo Mùa Đông')
INSERT INTO Categories (category_name) VALUES (N'Áo Khoác Bomber')
INSERT INTO Categories (category_name) VALUES (N'Áo Dài Truyền Thống')
INSERT INTO Categories (category_name) VALUES (N'Áo Len Cổ V')
INSERT INTO Categories (category_name) VALUES (N'Áo Hoodie Nữ')
INSERT INTO Categories (category_name) VALUES (N'Khác')

GO
-- Categories_Products
INSERT INTO Categories_Products (product_id, category_id) VALUES (1, 5)
INSERT INTO Categories_Products (product_id, category_id) VALUES (2, 5)
INSERT INTO Categories_Products (product_id, category_id) VALUES (3, 4)
INSERT INTO Categories_Products (product_id, category_id) VALUES (3, 3)
INSERT INTO Categories_Products (product_id, category_id) VALUES (4, 11)
INSERT INTO Categories_Products (product_id, category_id) VALUES (5, 5)
INSERT INTO Categories_Products (product_id, category_id) VALUES (6, 6)
INSERT INTO Categories_Products (product_id, category_id) VALUES (6, 2)
INSERT INTO Categories_Products (product_id, category_id) VALUES (7, 6)
INSERT INTO Categories_Products (product_id, category_id) VALUES (7, 2)
INSERT INTO Categories_Products (product_id, category_id) VALUES (8, 11)
INSERT INTO Categories_Products (product_id, category_id) VALUES (8, 4)
INSERT INTO Categories_Products (product_id, category_id) VALUES (9, 3)
INSERT INTO Categories_Products (product_id, category_id) VALUES (10, 3)
INSERT INTO Categories_Products (product_id, category_id) VALUES (11, 4)
INSERT INTO Categories_Products (product_id, category_id) VALUES (11, 3)
INSERT INTO Categories_Products (product_id, category_id) VALUES (12, 4)
INSERT INTO Categories_Products (product_id, category_id) VALUES (12, 2)
INSERT INTO Categories_Products (product_id, category_id) VALUES (13, 6)
INSERT INTO Categories_Products (product_id, category_id) VALUES (14, 6)
INSERT INTO Categories_Products (product_id, category_id) VALUES (14, 4)
INSERT INTO Categories_Products (product_id, category_id) VALUES (15, 5)
INSERT INTO Categories_Products (product_id, category_id) VALUES (16, 5)
INSERT INTO Categories_Products (product_id, category_id) VALUES (17, 5)
INSERT INTO Categories_Products (product_id, category_id) VALUES (18, 8)
INSERT INTO Categories_Products (product_id, category_id) VALUES (19, 8)
INSERT INTO Categories_Products (product_id, category_id) VALUES (20, 6)
INSERT INTO Categories_Products (product_id, category_id) VALUES (21, 4)
INSERT INTO Categories_Products (product_id, category_id) VALUES (22, 9)
INSERT INTO Categories_Products (product_id, category_id) VALUES (22, 10)
INSERT INTO Categories_Products (product_id, category_id) VALUES (23, 6)
INSERT INTO Categories_Products (product_id, category_id) VALUES (23, 4)
INSERT INTO Categories_Products (product_id, category_id) VALUES (24, 3)
INSERT INTO Categories_Products (product_id, category_id) VALUES (24, 4)


-- Coupon
INSERT INTO Coupon (coupon_code, discount_percent, limit) VALUES ('COUPON001', 10, 50)
INSERT INTO Coupon (coupon_code, discount_percent, limit) VALUES ('COUPON002', 15, 30)
INSERT INTO Coupon (coupon_code, discount_percent, limit) VALUES ('COUPON003', 20, 20)
INSERT INTO Coupon (coupon_code, discount_percent, limit) VALUES ('COUPON004', 25, 10)
INSERT INTO Coupon (coupon_code, discount_percent, limit) VALUES ('COUPON005', 30, 15)
INSERT INTO Coupon (coupon_code, discount_percent, limit) VALUES ('COUPON006', 5, 100)



GO
-- Invoices
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status,coupon_code) VALUES ('HD001', 'nguyenvana@gmail.com', '2022-03-27', 'Success','COUPON001')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status, coupon_code) VALUES ('HD002', 'tranthib@gmail.com', '2022-03-26', 'Pending', 'COUPON001')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status,coupon_code) VALUES ('HD003', 'nguyenvana@gmail.com', '2022-03-25', 'Cancel','COUPON003')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status, coupon_code) VALUES ('HD004', 'nguyenvana@gmail.com', '2022-03-24', 'Success', 'COUPON002')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status, coupon_code) VALUES ('HD005', 'tranthib@gmail.com', '2022-03-23', 'Pending', 'COUPON003')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status, coupon_code) VALUES ('HD006', 'tranthib@gmail.com', '2022-03-22', 'Success', 'COUPON004')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status,coupon_code) VALUES ('HD007', 'letuanc@gmail.com', '2022-03-21', 'Cancel','COUPON004')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status, coupon_code) VALUES ('HD008', 'letuanc@gmail.com', '2022-03-20', 'Success', 'COUPON005')
INSERT INTO Invoices (invoice_id, account_name, invoice_date, status, coupon_code) VALUES ('HD009', 'letuanc@gmail.com', '2022-03-19', 'Pending', 'COUPON006')


GO
-- Invoices Details
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD001', 1, 2, N'Đen', 'M')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD001', 4, 1, N'Trắng', 'L')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD002', 3, 3, N'Xanh', 'S')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD002', 6, 2, N'Đỏ', 'XL')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD002', 10, 1, N'Đen', 'L')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD003', 8, 2, N'Trắng', 'M')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD003', 12, 3, N'Xám', 'S')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD004', 2, 1, N'Đen', 'XL')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD004', 5, 2, N'Đỏ', 'M')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD004', 9, 3, N'Trắng', 'L')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD005', 11, 1, N'Xanh', 'S')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD005', 15, 3, N'Đen', 'XL')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD006', 7, 2, N'Đỏ', 'M')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD006', 14, 1, N'Trắng','XL')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD007', 13, 3, N'Đen', 'S')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD007', 16, 1, N'Xám', 'XL')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD007', 20, 2, N'Trắng', 'M')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD008', 18, 1, N'Đỏ', 'XL')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD008', 19, 2, N'Đen', 'M')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD009', 17, 3, N'Xám', 'L')
INSERT INTO InvoiceDetails (invoice_id, product_id, quantity, color, size) VALUES ('HD009', 1, 1, N'Trắng', 'S')

-- Warehouse
INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (1, N'Màu Đỏ', 'M', 40),
    (1, N'Màu Đỏ', 'L', 50),
    (1, N'Màu Đỏ', 'XL', 70),
    (1, N'Màu Xanh', 'S', 30),
    (1, N'Màu Xanh', 'M', 10),
    (1, N'Màu Xanh', 'L', 30),
    (1, N'Màu Xanh', 'XL', 20),
    (1, N'Màu Đen', 'S', 20),
    (1, N'Màu Đen', 'M', 40),
    (1, N'Màu Trắng', 'M', 50),
    (1, N'Màu Trắng', 'L', 20),
    (1, N'Màu Trắng', 'XL', 70)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (2, N'Màu Xanh', 'S', 40),
    (2, N'Màu Xanh', 'M', 25),
    (2, N'Màu Xanh', 'L', 40),
    (2, N'Màu Xám', 'S', 20),
    (2, N'Màu Xám', 'M', 15),
    (2, N'Màu Xám', 'L', 60),
    (2, N'Màu Xám', 'XL', 70),
    (2, N'Màu Đen', 'L', 40),
    (2, N'Màu Đen', 'XL', 10)
INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (3, N'Màu Trắng', 'S', 30),
    (3, N'Màu Trắng', 'M', 25),
    (3, N'Màu Trắng', 'L', 20),
    (3, N'Màu Đen', 'M', 20),
    (3, N'Màu Đen', 'L', 15),
    (3, N'Màu Đen', 'XL', 10),
    (3, N'Màu Xanh', 'S', 20),
    (3, N'Màu Xanh', 'M', 15),
    (3, N'Màu Xanh', 'XL', 8)
INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (4, N'Màu Trắng', 'S', 30),
    (4, N'Màu Trắng', 'M', 25),
    (4, N'Màu Trắng', 'L', 20),
    (4, N'Màu Trắng', 'XL', 15),
    (4, N'Màu Xanh', 'S', 25),
    (4, N'Màu Xanh', 'M', 20),
    (4, N'Màu Xanh', 'L', 15),
    (4, N'Màu Xanh', 'XL', 10),
    (4, N'Màu Đen', 'S', 20),
    (4, N'Màu Đen', 'M', 15),
    (4, N'Màu Đen', 'L', 12),
    (4, N'Màu Đen', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (5, N'Màu Trắng', 'S', 30),
    (5, N'Màu Trắng', 'M', 25),
    (5, N'Màu Trắng', 'L', 20),
    (5, N'Màu Xanh', 'S', 25),
    (5, N'Màu Xanh', 'M', 20),
    (5, N'Màu Xanh', 'L', 15),
    (5, N'Màu Đen', 'S', 20),
    (5, N'Màu Đen', 'M', 15),
    (5, N'Màu Đen', 'L', 12),
    (5, N'Màu Đen', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (6, N'Màu Xanh', 'M', 25),
    (6, N'Màu Xanh', 'L', 20),
    (6, N'Màu Xanh', 'XL', 15),
    (6, N'Màu Đen', 'S', 25),
    (6, N'Màu Đen', 'L', 15),
    (6, N'Màu Đen', 'XL', 10),
    (6, N'Màu Nâu', 'S', 20),
    (6, N'Màu Nâu', 'M', 15),
    (6, N'Màu Nâu', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (7, N'Màu Be', 'S', 30),
    (7, N'Màu Be', 'M', 25),
    (7, N'Màu Be', 'L', 20),
    (7, N'Màu Xanh', 'M', 20),
    (7, N'Màu Xanh', 'L', 15),
    (7, N'Màu Xanh', 'XL', 10),
    (7, N'Màu Đen', 'S', 20),
    (7, N'Màu Đen', 'M', 15),
    (7, N'Màu Đen', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (8, N'Màu Đen', 'S', 30),
    (8, N'Màu Đen', 'M', 25),
    (8, N'Màu Đen', 'L', 20),
    (8, N'Màu Đen', 'XL', 15),
    (8, N'Màu Xanh', 'S', 25),
    (8, N'Màu Xanh', 'M', 20),
    (8, N'Màu Xanh', 'L', 15),
    (8, N'Màu Xanh', 'XL', 10),
    (8, N'Màu Trắng', 'S', 20),
    (8, N'Màu Trắng', 'M', 15),
    (8, N'Màu Trắng', 'L', 12),
    (8, N'Màu Trắng', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (9, N'Màu Đen', 'S', 30),
    (9, N'Màu Đen', 'M', 25),
    (9, N'Màu Xanh', 'L', 15),
    (9, N'Màu Xanh', 'XL', 10),
    (9, N'Màu Đỏ', 'S', 20),
    (9, N'Màu Đỏ', 'M', 15),
    (9, N'Màu Đỏ', 'L', 12),
    (9, N'Màu Đỏ', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (10, N'Màu Xanh', 'M', 25),
    (10, N'Màu Xanh', 'L', 20),
    (10, N'Màu Xanh', 'XL', 15),
    (10, N'Màu Đen', 'M', 20),
    (10, N'Màu Đen', 'L', 15),
    (10, N'Màu Đỏ', 'M', 15),
    (10, N'Màu Đỏ', 'L', 12),
    (10, N'Màu Đỏ', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (11, N'Màu Trắng', 'S', 30),
    (11, N'Màu Trắng', 'M', 25),
    (11, N'Màu Trắng', 'L', 20),
    (11, N'Màu Xanh', 'M', 20),
    (11, N'Màu Xanh', 'L', 15),
    (11, N'Màu Đen', 'S', 20),
    (11, N'Màu Đen', 'M', 15),
    (11, N'Màu Đen', 'L', 12),
    (11, N'Màu Đen', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (12, N'Màu Nâu', 'S', 30),
    (12, N'Màu Nâu', 'M', 25),
    (12, N'Màu Nâu', 'XL', 15),
    (12, N'Màu Xanh', 'S', 25),
    (12, N'Màu Xanh', 'M', 20),
    (12, N'Màu Xanh', 'L', 15),
    (12, N'Màu Đen', 'S', 20),
    (12, N'Màu Đen', 'M', 15),
    (12, N'Màu Đen', 'L', 12)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (13, N'Màu Trắng', 'S', 30),
    (13, N'Màu Trắng', 'M', 25),
    (13, N'Màu Trắng', 'L', 20),
    (13, N'Màu Trắng', 'XL', 15),
    (13, N'Màu Xanh', 'S', 25),
    (13, N'Màu Xanh', 'M', 20),
    (13, N'Màu Xanh', 'L', 15),
    (13, N'Màu Xanh', 'XL', 10),
    (13, N'Màu Đen', 'S', 20),
    (13, N'Màu Đen', 'M', 15),
    (13, N'Màu Đen', 'L', 12),
    (13, N'Màu Đen', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (14, N'Màu Đen', 'S', 30),
    (14, N'Màu Đen', 'M', 25),
    (14, N'Màu Đen', 'L', 20),
    (14, N'Màu Đen', 'XL', 15),
    (14, N'Màu Xanh', 'S', 25),
    (14, N'Màu Xanh', 'M', 20),
    (14, N'Màu Xanh', 'L', 15),
    (14, N'Màu Xanh', 'XL', 10),
    (14, N'Màu Nâu', 'S', 20),
    (14, N'Màu Nâu', 'M', 15),
    (14, N'Màu Nâu', 'L', 12),
    (14, N'Màu Nâu', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (15, N'Màu Trắng', 'S', 30),
    (15, N'Màu Trắng', 'M', 25),
    (15, N'Màu Trắng', 'L', 20),
    (15, N'Màu Trắng', 'XL', 15),
    (15, N'Màu Xanh', 'S', 25),
    (15, N'Màu Xanh', 'M', 20),
    (15, N'Màu Xanh', 'L', 15),
    (15, N'Màu Xanh', 'XL', 10),
    (15, N'Màu Đen', 'S', 20),
    (15, N'Màu Đen', 'M', 15),
    (15, N'Màu Đen', 'L', 12),
    (15, N'Màu Đen', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (16, N'Màu Đen', 'S', 30),
    (16, N'Màu Đen', 'M', 25),
    (16, N'Màu Đen', 'L', 20),
    (16, N'Màu Đen', 'XL', 15),
    (16, N'Màu Xám', 'L', 15),
    (16, N'Màu Xám', 'XL', 10),
    (16, N'Màu Nâu', 'M', 15),
    (16, N'Màu Nâu', 'L', 12),
    (16, N'Màu Nâu', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (17, N'Màu Đen', 'S', 30),
    (17, N'Màu Đen', 'M', 25),
    (17, N'Màu Đen', 'L', 20),
    (17, N'Màu Đen', 'XL', 15),
    (17, N'Màu Xanh', 'L', 15),
    (17, N'Màu Xanh', 'XL', 10),
    (17, N'Màu Ghi', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (18, N'Màu Trắng', 'M', 25),
    (18, N'Màu Trắng', 'L', 20),
    (18, N'Màu Trắng', 'XL', 15),
    (18, N'Màu Hồng', 'S', 25),
    (18, N'Màu Hồng', 'L', 15),
    (18, N'Màu Hồng', 'XL', 10),
    (18, N'Màu Đỏ', 'S', 20),
    (18, N'Màu Đỏ', 'M', 15),
    (18, N'Màu Đỏ', 'XL', 8)
	
INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (19, N'Màu Trắng', 'S', 25),
    (19, N'Màu Trắng', 'M', 18),
    (19, N'Màu Trắng', 'L', 12),
    (19, N'Màu Trắng', 'XL', 8),
    (19, N'Màu Đen', 'S', 30),
    (19, N'Màu Đen', 'M', 22),
    (19, N'Màu Đen', 'L', 18),
    (19, N'Màu Đen', 'XL', 15),
    (19, N'Màu Hồng', 'S', 15),
    (19, N'Màu Hồng', 'M', 12),
    (19, N'Màu Hồng', 'L', 10),
    (19, N'Màu Hồng', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (20, N'Màu Đen', 'S', 30),
    (20, N'Màu Đen', 'M', 20),
    (20, N'Màu Đen', 'L', 15),
    (20, N'Màu Đen', 'XL', 10),
    (20, N'Màu Xám', 'S', 20),
    (20, N'Màu Xám', 'M', 15),
    (20, N'Màu Xám', 'L', 12),
    (20, N'Màu Xám', 'XL', 8),
    (20, N'Màu Nâu', 'S', 25),
    (20, N'Màu Nâu', 'M', 18),
    (20, N'Màu Nâu', 'L', 12),
    (20, N'Màu Nâu', 'XL', 10)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (21, N'Màu Đen', 'S', 30),
    (21, N'Màu Đen', 'M', 25),
    (21, N'Màu Đen', 'L', 20),
    (21, N'Màu Đen', 'XL', 15),
    (21, N'Màu Xanh', 'S', 25),
    (21, N'Màu Xanh', 'M', 20),
    (21, N'Màu Xanh', 'L', 15),
    (21, N'Màu Xanh', 'XL', 10),
    (21, N'Màu Cam', 'S', 20),
    (21, N'Màu Cam', 'M', 15),
    (21, N'Màu Cam', 'L', 12),
    (21, N'Màu Cam', 'XL', 8)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (22, N'Màu Đen', 'M', 18),
    (22, N'Màu Đen', 'L', 12),
    (22, N'Màu Đen', 'XL', 8),
    (22, N'Màu Trắng', 'S', 30),
    (22, N'Màu Trắng', 'L', 18),
    (22, N'Màu Trắng', 'XL', 15)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (23, N'Màu Đen', 'S', 30),
    (23, N'Màu Đen', 'M', 20),
    (23, N'Màu Đen', 'L', 15),
    (23, N'Màu Xám', 'S', 25),
    (23, N'Màu Xám', 'XL', 8),
    (23, N'Màu Nâu', 'S', 20),
    (23, N'Màu Nâu', 'XL', 10)

INSERT INTO Warehouse (product_id, color, size, quantity)
VALUES 
    (24, N'Màu Trắng', 'S', 25),
    (24, N'Màu Trắng', 'M', 18),
    (24, N'Màu Trắng', 'L', 12),
    (24, N'Màu Đen', 'M', 22),
    (24, N'Màu Đen', 'L', 18),
    (24, N'Màu Đen', 'XL', 15)

-- stored proce
--thanh duy 
-------------------------------------------------
GO
CREATE PROC Staff_UpdateInvoice_Sta
	@invoice_id varchar(20),
	@new_status nvarchar(30)
AS
BEGIN
	UPDATE Invoices
    	SET status = @new_status
    	WHERE invoice_id = @invoice_id
END

-------------------------------------------------
GO
CREATE PROC Staff_loadInvoiceDetails
	@invoice_id varchar(20)
AS
BEGIN
	SELECT product_name,image_url,color,size,quantity,price
	FROM Product
	INNER JOIN InvoiceDetails ON Product.product_id = InvoiceDetails.product_id
	WHERE InvoiceDetails.invoice_id = @invoice_id 
END

-------------------------------------------------
GO
CREATE FUNCTION Staff_GetAllProducts()
RETURNS TABLE
AS
RETURN (
    SELECT product_id, product_name, image_url,price
    FROM Product
)
----------------------------------------------
GO
CREATE PROC Staff_loadAccountUser
AS
BEGIN
    SELECT account_name,Account.users_id,phone,email FROM Account
	INNER JOIN Users ON Account.users_id = Users.users_id
	WHERE Account.role = 'User' and Account.isdeleted = 0
	
END

GO
CREATE PROC Staff_GetInvoices
AS
BEGIN
    SELECT invoice_id,account_name,invoice_date,status,coupon_code,discount_Amount,FinalTotal FROM Invoices WHERE status = 'Pending'
END
-------------------------------------------------

-----------------------------------------------
-- Ngọc Văn
-- Lấy lịch sử mua hàng của một account
GO
CREATE PROCEDURE Staff_GetHistoryAccount
    @AccountName NVARCHAR(50)
AS
BEGIN
    SELECT invoice_id,account_name,invoice_date,status,coupon_code,discount_Amount,FinalTotal
    FROM Invoices
    WHERE account_name = @AccountName AND status = 'Success'
END

-- Lấy thông tin của user (chưa banned khỏi hệ thống) bằng account name
GO
CREATE PROCEDURE Staff_GetUserByAccountName
    @account_name varchar(50)
AS
BEGIN
	SELECT Account.users_id,first_name,last_name,adr,phone,email,Account.account_name,Account.account_password
    FROM Users
	inner join Account on Users.users_id = Account.users_id
    WHERE Account.users_id = ( 
		SELECT A.users_id
        FROM Account A
        WHERE A.account_name = @account_name AND A.role = 'User' AND A.isdeleted = 0)
		AND Account.role = 'User'
END

GO
-- render ra thông tin staff
create proc ViewAccountStaff
@account_name varchar(50)
as
	select A.account_name,A.role,U.*
	from Account A
	inner join Users U on A.users_id=U.users_id
	where A.role='Staff' and account_name like '%'+@account_name+'%' and A.isdeleted=0
go
-- FUNCTION
-- Lấy tổng số tiền thực tế mà một user phải trả
GO
CREATE FUNCTION dbo.GetTotalAmountSpentByUser(@account_name varchar(50))
RETURNS money
AS
BEGIN
    DECLARE @totalAmountSpent money

    SELECT @totalAmountSpent = SUM(FinalTotal)
    FROM Invoices
    WHERE account_name = @account_name

    RETURN ISNULL(@totalAmountSpent, 0)
END


GO
-- Lấy giá trị trung bình review của một product
CREATE FUNCTION dbo.GetAverageRating
(
    @ProductID INT
)
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @AverageRating DECIMAL(3, 2)

    SELECT @AverageRating = AVG(CAST(rating AS DECIMAL(3, 2)))
    FROM Review
    WHERE product_id = @ProductID

    RETURN @AverageRating
END

-- CURSOR
-- Lấy danh sách id và tên sản phẩm thuộc 1 category
GO
CREATE PROCEDURE GetProductsInCategory
    @CategoryID INT
AS
BEGIN
    DECLARE @ProductID INT, @ProductName NVARCHAR(50)

    -- Tạo cursor cho bảng Categories_Products
    DECLARE product_cursor CURSOR FOR
    SELECT p.product_id, p.product_name
    FROM Product p
    JOIN Categories_Products cp ON p.product_id = cp.product_id
    WHERE cp.category_id = @CategoryID

    OPEN product_cursor

    FETCH NEXT FROM product_cursor INTO @ProductID, @ProductName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'ProductID: ' + CAST(@ProductID AS NVARCHAR(10)) + ', ProductName: ' + @ProductName

        FETCH NEXT FROM product_cursor INTO @ProductID, @ProductName
    END

    CLOSE product_cursor
    DEALLOCATE product_cursor
END

GO
-- Lấy danh sách product id và rating cao nhất của một sản phẩm
CREATE PROCEDURE GetMaxRatingPerProduct
AS
BEGIN
    DECLARE @ProductID INT, @MaxRating INT

    DECLARE review_cursor CURSOR FOR
    SELECT product_id, MAX(rating) AS MaxRating
    FROM Review
    GROUP BY product_id

    OPEN review_cursor

    FETCH NEXT FROM review_cursor INTO @ProductID, @MaxRating

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'ProductID: ' + CAST(@ProductID AS NVARCHAR(10)) + ', MaxRating: ' + CAST(@MaxRating AS NVARCHAR(10))

        FETCH NEXT FROM review_cursor INTO @ProductID, @MaxRating
    END

    CLOSE review_cursor
    DEALLOCATE review_cursor
END
-------------------------------
--ngọc lâm
GO

create Proc ViewAccountUser 
@account_name varchar(50)
as
	WITH inforBuying AS (
	  SELECT 
		account_name,
		SUM(I.total_amount) AS total_amount,
		MAX(I.invoice_date) AS Last_Buying,
		SUM(CASE WHEN MONTH(I.invoice_date) = MONTH(GETDATE()) THEN I.total_amount ELSE 0 END) AS [Total amount purchased in the current month]
	  FROM Invoices I
	  WHERE status = 'Success'
	  GROUP BY I.account_name
	)
	select 
		A.account_name,
		U.*,
		total_amount,
		Last_Buying,
		[Total amount purchased in the current month]
	from inforBuying I
	right join Account A on A.account_name = I.account_name
	inner join Users U on A.users_id=U.users_id
	where A.account_name Like '%'+@account_name+'%' and A.isdeleted=0

go
--render ra thông tin products và số lượng đã được mua
create proc ViewProducts
@Product_name nvarchar(50),
@isdelete bit 
as
	with amount_Buying as(
		select product_id,  SUM(D.quantity) as 'Quantity purchased'
		from InvoiceDetails D
		inner join Invoices I on I.invoice_id=D.invoice_id
		where I.status='Success'
		group by product_id

	)
	select P.product_id,P.product_name,P.description,P.price,P.image_url, isnull(A.[Quantity purchased],0) as 'Quantity purchased'
	from Product P
	left join amount_Buying A on A.product_id=P.product_id
	where  P.isdeleted=@isdelete and product_name like '%'+@Product_name+'%' 
	order by 'Quantity purchased' asc
go

-- create account

create proc CreateAccount
@account_name varchar(50),
@account_password varchar(255),
@role varchar(20),
@first_name nvarchar(50),
@last_name nvarchar(50),
@adr nvarchar(200),
@phone varchar(50),
@email varchar(50)
as
	insert into Users
	values (@first_name,@last_name,@adr,@phone,@email)
	declare @user_id int
	set @user_id=(select max(users_id) from Users)
	insert into Account
	values (@account_name,@account_password,@role,@user_id,0)
go

-- render quanity
create proc ViewQuanityWareHouse
@Product_id nvarchar(50)
as
	if(@Product_id <> '')
		begin
			select P.product_name,W.color,W.size,W.quantity 
			from Product P
			inner join Warehouse W on W.product_id=P.product_id
			where p.product_id = @Product_id
		end
	else
		begin 
			select P.product_name,W.color,W.size,W.quantity 
				from Product P
				inner join Warehouse W on W.product_id=P.product_id
		end

go
--delete products and categories

create proc deleteProduct
@Product_id nvarchar(50)
as
	update Product 
	set isdeleted=1
	where product_id=@Product_id
go

CREATE FUNCTION dbo.TinhTongSoLuongTheoLoai()
RETURNS @ThongTinLoai TABLE
(
    TenLoai NVARCHAR(50),
    TongSoLuong INT
)
AS
BEGIN
    DECLARE @TenLoai NVARCHAR(50)
    DECLARE @TongSoLuong INT

    -- Khởi tạo con trỏ cho bảng Categories
    DECLARE ConTroLoai CURSOR FOR
    SELECT category_name
    FROM Categories

    OPEN ConTroLoai
    FETCH NEXT FROM ConTroLoai INTO @TenLoai

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tính tổng số lượng sản phẩm cho từng loại
        SELECT @TongSoLuong = SUM(quantity)
        FROM Warehouse w
        INNER JOIN Categories_Products cp ON w.product_id = cp.product_id
        WHERE cp.category_id = (SELECT category_id FROM Categories WHERE category_name = @TenLoai)

        -- Thêm thông tin vào bảng kết quả
        INSERT INTO @ThongTinLoai (TenLoai, TongSoLuong)
        VALUES (@TenLoai, ISNULL(@TongSoLuong, 0))

        FETCH NEXT FROM ConTroLoai INTO @TenLoai
    END

    CLOSE ConTroLoai
    DEALLOCATE ConTroLoai

    RETURN
END
go
CREATE FUNCTION dbo.TinhTongSoLuongSanPhamTrongDonDatHang()
RETURNS @ThongTinDonHang TABLE
(
    MaHoaDon NVARCHAR(20),
    TongSoLuong INT
)
AS
BEGIN
    DECLARE @MaHoaDon NVARCHAR(20)
    DECLARE @TongSoLuong INT

    -- Khởi tạo con trỏ cho bảng Invoices
    DECLARE ConTroHoaDon CURSOR FOR
    SELECT invoice_id
    FROM Invoices

    OPEN ConTroHoaDon
    FETCH NEXT FROM ConTroHoaDon INTO @MaHoaDon

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tính tổng số lượng sản phẩm trong đơn đặt hàng
        SELECT @TongSoLuong = SUM(quantity)
        FROM InvoiceDetails
        WHERE invoice_id = @MaHoaDon

        -- Thêm thông tin vào bảng kết quả
        INSERT INTO @ThongTinDonHang (MaHoaDon, TongSoLuong)
        VALUES (@MaHoaDon, ISNULL(@TongSoLuong, 0))

        FETCH NEXT FROM ConTroHoaDon INTO @MaHoaDon
    END

    CLOSE ConTroHoaDon
    DEALLOCATE ConTroHoaDon

    RETURN
END
go

-- ---------------Tạo tài khoản đăng nhập Staff-------------------------
GO
CREATE LOGIN staff WITH PASSWORD = 'staff123'
USE QL_QUANAO
CREATE USER staff FOR LOGIN staff


GRANT SELECT, UPDATE ON dbo.Invoices TO staff
GRANT SELECT  ON dbo.InvoiceDetails TO staff
GRANT SELECT  ON dbo.Account TO staff
GRANT SELECT ON dbo.Users TO staff
GRANT SELECT ON dbo.Review TO staff
GRANT SELECT,UPDATE ON dbo.Product TO staff

GO
ALTER AUTHORIZATION ON dbo.Staff_GetAllProducts TO staff
ALTER AUTHORIZATION ON dbo.Staff_GetHistoryAccount TO staff
ALTER AUTHORIZATION ON dbo.Staff_GetInvoices TO staff
ALTER AUTHORIZATION ON dbo.Staff_GetUserByAccountName TO staff
ALTER AUTHORIZATION ON dbo.Staff_loadAccountUser TO staff
ALTER AUTHORIZATION ON dbo.Staff_loadInvoiceDetails TO staff
ALTER AUTHORIZATION ON dbo.Staff_UpdateInvoice_Sta TO staff

------------------------Tạo tài khoảng customer----------------------
GO
CREATE LOGIN customer WITH PASSWORD = 'customer123'
USE QL_QUANAO
CREATE USER customer FOR LOGIN customer

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Cart TO customer
GRANT SELECT, INSERT, UPDATE ON dbo.Invoices TO customer
GRANT SELECT, INSERT ON dbo.InvoiceDetails TO customer
GRANT SELECT, INSERT, UPDATE ON dbo.Account TO customer
GRANT SELECT, INSERT, UPDATE ON dbo.Users TO customer
GRANT SELECT, INSERT, UPDATE ON dbo.Review TO customer

-- Gán quyền CHỈ XEM cho người dùng trên bảng Product
GRANT SELECT ON dbo.Product TO customer
GRANT SELECT ON dbo.Coupon TO customer
GRANT SELECT,UPDATE ON dbo.Warehouse TO customer

-----------------Tạo tài khoản BOSS--------------------
GO
CREATE LOGIN boss WITH PASSWORD = 'boss123'
USE QL_QUANAO
CREATE USER boss FOR LOGIN boss
EXEC sp_addrolemember 'db_owner', 'boss'