# 📊 Dự án Phân tích Khách hàng RFM
 **📋 Giới thiệu Project:  Phân tích khách hàng ngân hàng sử dụng mô hình RFM (Recency, Frequency, Monetary) bằng SQL**
---
## Thông tin các bảng
---
### 1. Bảng users
- **Mô tả:** Thông tin cá nhân của khách hàng.
- **Khóa chính:** `user_id`

| Cột                 | Kiểu dữ liệu   | Mô tả                                                |
| ------------------- | -------------- | ---------------------------------------------------- |
| `user_id`           | `INTEGER (PK)` | Mã định danh người dùng                              |
| `retirement_age`    | `INTEGER`      | Tuổi nghỉ hưu dự kiến                                |
| `birth_year`        | `INTEGER`      | Năm sinh                                             |
| `birth_month`       | `INTEGER`      | Tháng sinh                                           |
| `gender`            | `VARCHAR(10)`  | Giới tính                                            |
| `address`           | `VARCHAR(255)` | Địa chỉ nơi ở                                        |
| `per_capita_income` | `INTEGER`      | Thu nhập bình quân đầu người (USD)                   |
| `yearly_income`     | `INTEGER`      | Tổng thu nhập hàng năm (USD)                         |
| `total_debt`        | `INTEGER`      | Tổng khoản nợ hiện có (USD)                          |
| `credit_score`      | `INTEGER`      | Điểm tín dụng                                        |
| `num_credit_cards`  | `INTEGER`      | Số lượng thẻ tín dụng mà người dùng sở hữu           |
---
### 2. Bảng cards
- **Mô tả:** Thông tin thẻ ngân hàng của khách hàng.
- **Khóa chính:** `card_id`

| Cột                    | Kiểu dữ liệu   | Mô tả                                                   |
| ---------------------- | -------------- | ------------------------------------------------------- |
| `card_id`              | `INTEGER (PK)` | Mã định danh giao dịch/thẻ                              |
| `client_id`            | `INTEGER (FK)` | Mã người dùng                                           |
| `card_brand`           | `VARCHAR(50)`  | Thương hiệu thẻ (Visa, Mastercard, v.v.)                |
| `card_type`            | `VARCHAR(50)`  | Loại thẻ (Credit, Debit, Prepaid, v.v.)                 |
| `card_number`          | `VARCHAR(20)`  | Số thẻ                                                  |
| `expires`              | `VARCHAR(7)`   | Thời hạn hiệu lực thẻ                                   |
| `cvv`                  | `VARCHAR(4)`   | Mã bảo mật CVV                                          |
| `has_chip`             | `VARCHAR(3)`   | Thẻ có chip hay không (`YES` hoặc `NO')                 |
| `num_cards_issue       | `INTEGER`      | Số lượng thẻ được phát hành cho khách hàng này          |
| `credit_limit`         | `INTEGER`      | Hạn mức tín dụng                                        |
| `acct_open_date`       | `VARCHAR(7)`   | Ngày mở tài khoản thẻ  			                            |
|`year_pin_last_changed` | `INTEGER`      | Năm thay đổi mã PIN gần nhất                            |
---

### 3. Bảng Transactions
- **Mô tả:** Các giao dịch đươc thực hiện.
- **Khóa chính:** `transaction_id`

| Cột              | Kiểu dữ liệu    | Mô tả                                                         |
| ---------------- | --------------- | ------------------------------------------------------------- |
| `transaction_id` | `INTEGER (PK)`  | Mã định danh giao dịch                                        |
| `date`           | `TIMESTAMP`     | Thời gian giao dịch xảy ra                                    |
| `client_id`      | `INTEGER (FK)`  | Mã khách hàng                                                 |
| `card_id`        | `INTEGER (FK)`  | Mã thẻ                                                        |
| `amount`         | `DECIMAL(10,2)` | Số tiền giao dịch                                             |
| `use_chip`       | `VARCHAR(20)`   | Hình thức giao dịch                                           |
| `errors`         | `VARCHAR(255)`  | tính trạng giao dịch nếu lỗi                                  |
---
## 🔗 Sơ Đồ Mối Quan Hệ

1.	users (1:N) cards - Một khách hàng có thể có nhiều thẻ
2.	cards (1:N) transactions - Một thẻ có thể thực hiện nhiều giao dịch
3.	users (1:N) transactions - Một khách hàng có thể có nhiều giao dịch
## 📂 Tổng quan dữ liệu mẫu
- Tổng số khách hàng: 2000
- Tổng số giao dịch: 1 048 575
- Link dữ liệu: https://drive.google.com/drive/folders/1_Nbqy-9zc19sbkVljXV2eExnj47_dmVR?usp=drive_link
---
📊 Mô hình RFM

**Định nghĩa các thành phần:**
- Recency (R): Số ngày từ giao dịch gần nhất đến ngày phân tích (lấy ngày 2010-06-11)
- Frequency (F): Tổng số giao dịch của khách hàng
- Monetary (M): Tổng volume giao dịch

**Thang điểm RFM:**
- Score 1: Thấp nhất
- Score 4: Cao nhất

## Customer Segments:
| **RFM Score**                                               | **Segment Name**        | **Đặc điểm mô tả**                                  | **Chiến lược gợi ý**                                            |
|-------------------------------------------------------------|-------------------------|-----------------------------------------------------|-----------------------------------------------------------------|
| 444, 443, 434, 344, 433, 424                                | **VIP**                 | Giao dịch nhiều, gần đây, giá trị cao               | Dịch vụ VIP, sản phẩm đầu tư cao cấp                            |
| 432, 423, 442, 441                                          | **Loyal Customers**     | Giao dịch thường xuyên, ổn định                     | Ưu đãi khách hàng thân thiết, giới thiệu                        |
| 414, 324, 334, 234, 414, 244                                | **High Spender**        | Khách hàng giao dịch lớn                            | Gợi ý dịch vụ mới hay nâng cấp                                  |
| 212, 213, 221, 211, 231                                     | **At Risk**             | Giảm hoạt động, từng có giá trị                     | Chiến dịch giữ chân, nhắc nhở                                   |
| 1__                                                         | **Lost Customers**      | Không còn hoạt động                                 | Chiến dịch cơ bản để giành lại khách hàng                       |
| Các score còn lại                                           | **Regular Customers**   | Khách hàng bình thường, hoạt động vừa phải          | Duy trì mối quan hệ, khuyến mãi định kỳ                         |

