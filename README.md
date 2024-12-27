![image](https://github.com/user-attachments/assets/468984e5-d8cf-498e-93df-1f62feafa572)
# Xây Dựng Kho Dữ Liệu Phân Tích Kinh Doanh Cửa Hàng Bán Quần Áo

## Giới thiệu

Mục tiêu chính:
Đề tài hướng đến việc thiết kế và triển khai một hệ thống kho dữ liệu (Data Warehouse) nhằm lưu trữ và phân tích toàn diện dữ liệu kinh doanh của cửa hàng bán quần áo. Hệ thống sẽ hỗ trợ ban quản lý ra quyết định chiến lược, tối ưu hóa vận hành và nâng cao hiệu quả kinh doanh.
Yêu cầu cụ thể:
Thu thập dữ liệu:
Tích hợp dữ liệu từ nhiều nguồn khác nhau, bao gồm:
-	Bán hàng: Dữ liệu về doanh thu, sản phẩm, thời gian, khu vực bán hàng.
-	Khách hàng: Thông tin cá nhân, lịch sử mua hàng, hành vi tiêu dùng.
-	Kho hàng: Số lượng hàng tồn, sản phẩm bán chạy, sản phẩm sắp hết hàng.
-	Khuyến mãi: Thông tin các chương trình ưu đãi, giảm giá, hiệu quả chiến dịch quảng cáo.
-	Địa lý: Thông tin về các địa điểm mua hàng, địa điểm tiêu dùng
Xử lý dữ liệu:
Làm sạch dữ liệu để đảm bảo tính chính xác và đồng nhất.
Chuyển đổi dữ liệu từ các định dạng khác nhau sang một cấu trúc thống nhất.
Áp dụng các kỹ thuật chuẩn hóa nhằm giảm thiểu trùng lặp và tối ưu hóa lưu trữ.
 
Lưu trữ dữ liệu:
Xây dựng kho dữ liệu tập trung, được thiết kế với cấu trúc hỗ trợ phân tích và báo cáo.
Đảm bảo kho dữ liệu có khả năng mở rộng khi khối lượng dữ liệu tăng lên.
Phân tích và báo cáo:
Xây dựng hệ thống báo cáo linh hoạt, tập trung vào các chỉ số kinh doanh cốt lõi như:
-	Doanh thu theo ngày, tháng, năm.
-	Sản phẩm bán chạy nhất và kém nhất.
-	Phân tích hành vi mua sắm của khách hàng.
Triển khai các công cụ trực quan hóa dữ liệu (dashboards, biểu đồ) để hỗ trợ ra quyết định.

---

## Các thành phần chính

### 1. Thiết kế kho dữ liệu
-** nguồn dữ liệu của phần mềm:  **
**database diagram quản lý cửa hàng quần áo **
![image](https://github.com/user-attachments/assets/2c936a4a-fd4b-4c2c-a3a1-af471bbc8872)
**file excel tổng hợp doanh thu bán hàng của cửa hàng**
![image](https://github.com/user-attachments/assets/527caa1f-ad8d-4b96-be3f-80b8ebc9ff06)

- **Phân tích yêu cầu**: Thu thập và xử lý dữ liệu từ nhiều nguồn
- **Cấu trúc dữ liệu**:
  - **Cơ sở dữ liệu quan hệ**:
  - **Kho dữ liệu OLAP**: Phân tích được kho dữ liệu DDS mô hình chòm sao với các bảng Sales_Fact, Warehouse_Dimension, Coupon_Dimension, Geography_Dimension, Product_Dimension, Customer_Dimension, Time_Dimension.

**Hình ảnh minh họa**:
- Hình ảnh: **Kho dữ liệu mô hình chòm sao** 
![image](https://github.com/user-attachments/assets/41283139-de06-48a8-84cf-e935ba1c10bb)

---

### 2. Quy trình ETL (Extract, Transform, Load)
- Sử dụng **SSIS**:
  - Trích xuất dữ liệu từ SQL Server và file Excel.
  - Làm sạch, chuyển đổi dữ liệu và nạp vào kho dữ liệu.

**Hình ảnh minh họa**:
- Hình ảnh: **Quy trình SSIS**
![image](https://github.com/user-attachments/assets/ffa342b4-21d8-46c6-93c8-a2d71fab0f8b)

Phân tích được các Dimension như sau:
Dim_Time: Dùng để phân tích dữ liệu theo thời gian.
 
![image](https://github.com/user-attachments/assets/8c2b4a69-a566-4632-911f-b54807eec6e8)

 
Dim_Coupon: Dùng để phân tích dữ liệu theo coupon
 
![image](https://github.com/user-attachments/assets/993cb4f5-ca4e-4502-9411-033f6d78d047)

Dim_Customer: Dùng để phân tích dữ liệu theo khách hàng.
 
![image](https://github.com/user-attachments/assets/9e197b1d-6956-4025-9014-93c4b84b6633)

 
Dim_Product: Dùng để phân tích dữ liệu theo sản phẩm
 
![image](https://github.com/user-attachments/assets/7552bec5-41d5-41e5-9fb5-c78fc55af732)

Dim_Geography: Dùng để phân tích dữ liệu theo địa lý
 
![image](https://github.com/user-attachments/assets/4a232ff6-a727-46a8-a378-291135cd2913)

Dim_Warehouse: Dùng để phân tích dữ liệu theo kho.
 
![image](https://github.com/user-attachments/assets/ea6f3d58-3d72-4523-8e6d-cdd07136d14e)

 
Fact: Để phân tích dữ liệu bán hàng, tổng hợp và đo lường hiệu suất
 
![image](https://github.com/user-attachments/assets/b1605050-c761-4a95-81fe-95cfd0f40c67)

---

### 3. Phân tích và trực quan hóa dữ liệu
#### SSAS (SQL Server Analysis Services)
- Tạo cubes để hỗ trợ phân tích dữ liệu đa chiều.
- Các dimension như Time, Product, Customer, Coupon được cấu hình để phân tích chi tiết.

**Hình ảnh minh họa**:
- Hình ảnh: **SSAS Cube**
- ![image](https://github.com/user-attachments/assets/d08e668a-58bb-4bdd-a3a6-1b8affdf437a)


#### Giao diện ứng dụng
- Chức năng chính:
  - **Truy vấn MDX**: Hỗ trợ truy vấn và xuất báo cáo.
  - **Thống kê**: Phân tích doanh thu, sản phẩm, khách hàng.
  - **Tableau**: Trực quan hóa dữ liệu chuyên sâu.

**Hình ảnh minh họa giao diện**:
- Hình ảnh: **Giao diện chính**
  ![image](https://github.com/user-attachments/assets/22fbe6cb-af4f-437a-96b3-d54b18784e67)

- Hình ảnh: **Truy vấn MDX**
- ![image](https://github.com/user-attachments/assets/1f6a182a-d210-408a-8d95-5571289df678)
![image](https://github.com/user-attachments/assets/9a95daa0-d88d-4bd9-8367-01e9c9cb1912)

- Hình ảnh: **Thống kê**
![image](https://github.com/user-attachments/assets/8b492ba8-2e55-4b59-a99c-ca1a5b169e87)
![image](https://github.com/user-attachments/assets/04d19d88-9778-4db3-8084-841d747a7075)
![image](https://github.com/user-attachments/assets/c97681be-c8b0-456e-baea-00608b00545e)
![image](https://github.com/user-attachments/assets/6d13b2c2-158e-4817-9c03-1375269f31bc)
![image](https://github.com/user-attachments/assets/1f58c0d0-7c34-403e-bca4-90db2987aac3)

- Hình ảnh: **Tableau** 
![image](https://github.com/user-attachments/assets/6cb9d4d1-bcdb-4eca-8014-04ef616d6fcc)

---

## Hướng dẫn sử dụng

1. **Yêu cầu hệ thống**
   - SQL Server, SSIS, SSAS.
   - Tableau hoặc các công cụ trực quan hóa tương tự.

2. **Cài đặt**
   - Import dữ liệu từ file Excel hoặc SQL Server.
   - Cấu hình cubes trong SSAS và kết nối giao diện ứng dụng.

3. **Chức năng chính**
   - Truy vấn dữ liệu bằng MDX.
   - Xem và xuất báo cáo thống kê theo nhiều tiêu chí (doanh thu, sản phẩm bán chạy, v.v.).
   - Phân tích nâng cao với Tableau.

---

## Kết quả
- Hệ thống giúp cải thiện quy trình quản lý và phân tích dữ liệu.
- Hỗ trợ báo cáo trực quan, từ đó tối ưu hóa chiến lược kinh doanh và dịch vụ khách hàng.

---

## Hạn chế và định hướng phát triển
- Hệ thống chưa tích hợp phân tích dự đoán hoặc dự báo doanh thu.
- Bổ sung các tính năng bảo mật dữ liệu nâng cao.
- Mở rộng quy mô để hỗ trợ nhiều cửa hàng hoặc chuỗi kinh doanh.

---

## Đóng góp
Mọi ý kiến đóng góp và cải tiến đều được hoan nghênh. Hãy tạo một **pull request** hoặc **issue** nếu bạn muốn đóng góp vào dự án.
