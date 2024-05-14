-- Xóa cơ sở dữ liệu
DROP DATABASE IF EXISTS lesson_01;
-- Tạo cơ sở dữ liệu
CREATE DATABASE lesson_01;

-- Hiển thị danh sách cơ sở dữ liệu
SHOW DATABASES;

-- Chọn cơ sở dữ liệu muốn thao tác
USE lesson_01;-- tên_database;

-- Tạo bảng

-- logic: BOOLEAN, bit
-- ENUM("male","famele")
-- UNIQUE: Duy nhất nhưng có thể null
SELECT CURRENT_DATE;
SELECT NOW();

DROP TABLE IF EXISTS department;
CREATE TABLE department (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);
--
DROP TABLE IF EXISTS account;
CREATE TABLE account (
	id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50),
    department_id INT,
    FOREIGN KEY (department_id) 
    REFERENCES department(id)
    ON UPDATE CASCADE ON DELETE CASCADE
);
--
INSERT INTO department (id, name)
VALUES (100, "Bảo vệ");
INSERT INTO account (full_name, department_id)
VALUES ("Nguyễn Văn Khoa", 1000);