DROP DATABASE IF EXISTS testing_exam_01;
CREATE DATABASE testing_exam_01;
USE testing_exam_01;

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50),
	phone CHAR(10),
	email VARCHAR(50),
    address VARCHAR(50),
    note VARCHAR(100)
);

DROP TABLE IF EXISTS car;
CREATE TABLE car (
	car_id INT PRIMARY KEY AUTO_INCREMENT,
    maker ENUM("HONDA","TOYOTA","NISSAN"),
    model VARCHAR(30),
    `year` DATE,
    color VARCHAR(20),
    note VARCHAR(100)
);

DROP TABLE IF EXISTS car_order;
CREATE TABLE car_order (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    car_id INT,
    amount INT DEFAULT(1),
    sale_price INT,
    order_date DATE,
    delivery_date DATE,
    delivery_address VARCHAR(50),
    `status` ENUM("0","1","2") DEFAULT("0"),
    note VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES car (car_id) ON UPDATE CASCADE ON DELETE CASCADE
);
-- 1. Tạo table với các ràng buộc và kiểu dữ liệu
-- Thêm ít nhất 5 bản ghi vào table.
-- 2. Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã
-- mua và sắp sếp tăng dần theo số lượng oto đã mua.
SELECT name,SUM(amount)
FROM customer
INNER JOIN car_order USING(customer_id)
WHERE `status` = "1"
GROUP BY customer_id
ORDER BY SUM(amount) ASC;
-- 3. Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều
-- oto nhất trong năm nay.
SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS fn_01;
DELIMITER $$
CREATE FUNCTION fn_01() RETURNS ENUM("HONDA","TOYOTA","NISSAN")
BEGIN
	DECLARE v_maker ENUM("HONDA","TOYOTA","NISSAN");
    WITH c1 AS(
    SELECT maker, SUM(amount) AS car_count
    FROM car
    LEFT JOIN car_order USING(car_id)
    WHERE `status` = "1" AND YEAR(delivery_date) = YEAR(CURRENT_DATE)
    GROUP BY maker
    )SELECT maker INTO v_maker
    FROM c1
    WHERE car_count = MAX(car_count);
    
    RETURN v_maker;
END $$
DELIMITER ;
-- 4. Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của
-- những năm trước. In ra số lượng bản ghi đã bị xóa.
DROP PROCEDURE IF EXISTS sp_01;
DELIMITER $$
CREATE PROCEDURE sp_01() 
BEGIN
	DECLARE v_removed_order INT;
    
	SELECT COUNT(*) INTO v_removed_order
    FROM car_order
    WHERE YEAR(order_date) < YEAR(CURRENT_DATE) AND `status` = "2";
    
    DELETE FROM car_order
    WHERE YEAR(order_date) < YEAR(CURRENT_DATE) AND `status` = "2";
    
    SELECT CONCAT("Số bản ghi đã xóa là ",v_removed_order) AS message;
END $$
DELIMITER ;

CALL sp_01();
-- 5. Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn
-- hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng oto
-- và tên hãng sản xuất.
DROP PROCEDURE IF EXISTS sp_02;
DELIMITER $$
CREATE PROCEDURE sp_02(IN v_customer_id INT) 
BEGIN
	SELECT name, order_id, amount, maker
    FROM customer
    INNER JOIN car_order USING(customer_id)
    INNER JOIN car USING(car_id)
    WHERE customer_id = v_customer_id AND `status` = "0" OR ;
END $$
DELIMITER ;
-- 6. Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
-- vào database (DeliveryDate < OrderDate + 15).
DROP TRIGGER IF EXISTS trigger_01;
DELIMITER $$
CREATE TRIGGER trigger_01
BEFORE INSERT ON car_order
FOR EACH ROW
BEGIN
    IF delivery_date < order_date + INTERVAL 15 DAY THEN
		SIGNAL SQLSTATE "12345"
        SET MESSAGE_TEXT = "Ngày giao hàng phải sau ngày đặt hàng ít nhất 15 ngày";
    END IF;
END $$
DELIMITER ;
