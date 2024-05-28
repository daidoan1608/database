-- LOCAL VARIABLE: Biến cục bộ
-- Phạm vi sử dụng: Trong khối lệnh BEGIN - END
-- Khởi tạo: DECLARE tên_biến kiểu_dữ_liệu;
-- VD: DECLARE id INT;

-- SESSION VARIABLE: Biến session
-- Phạm vi sử dụng: Trong một phiên (session) làm việc
-- Khởi tạo: SET @tên_biến = giá trị khởi tạo
-- VD SET @age = 18;

-- GLOBAL VARIABLE: Biến toàn cục
-- Phạm vi sử dụng: Toàn hệ thống
-- Khởi tạo: SET
SHOW VARIABLES; -- Hiển thị danh sách các biến hệ thống

-- TRIGGER
-- Thời điểm: BEFORE, ARTER
-- Sự kiện: INSERT, UPDATE, DELETE
-- Tham chiếu: OLD(Dữ liệu cũ), NEW(dữ liệu mới được thêm vào)
DROP TRIGGER  IF EXISTS trigger_01;
DELIMITER $$
CREATE TRIGGER trigger_01
BEFORE INSERT ON group_account
FOR EACH ROW
BEGIN
	IF NEW.joined_date > CURRENT_DATE
    THEN SET NEW.joined_date = CURRENT_DATE;
    
    END IF;
END $$
DELIMITER ;
