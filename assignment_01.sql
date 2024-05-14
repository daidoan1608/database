CREATE DATABASE assignment_01;
USE assignment_01;
CREATE TABLE department(
	department_id INT PRIMARY KEY AUTO_INCREMENT,
	department_name VARCHAR(30)
);
CREATE TABLE `position`(
	position_id INT PRIMARY KEY AUTO_INCREMENT,
	position_name ENUM("Dev","Test","Scrum Master","PM")
);
CREATE TABLE account(
	account_id INT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR(50),
	username VARCHAR(30),
	fullname VARCHAR(30),
	department_id INT,
	position_id INT,
	create_date DATE
);
CREATE TABLE `group`(
	group_id INT PRIMARY KEY AUTO_INCREMENT,
	group_name VARCHAR(30),
	create_id INT,
	create_date DATE
);
CREATE TABLE group_account(
	group_id INT,
	account_id INT,
	join_date DATE,
    PRIMARY KEY(group_id,account_id)
);
DROP TABLE type_question;
CREATE TABLE type_question(
	type_id INT PRIMARY KEY AUTO_INCREMENT,
	type_name ENUM("Essay","Multiple-Choice")
);
CREATE TABLE category_question(
	category_id INT PRIMARY KEY AUTO_INCREMENT,
	category_name CHAR(30)
);
CREATE TABLE question(
	question_id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(255),
	category_id INT,
	type_id INT,
	creator_id INT,
	create_date DATE
);
CREATE TABLE answer(
	answer_id INT PRIMARY KEY AUTO_INCREMENT,
	content VARCHAR(255),
	question_id INT,
	is_correct BOOLEAN
);
CREATE TABLE exam(
	exam_id INT PRIMARY KEY AUTO_INCREMENT,
	code INT,
	title VARCHAR(50),
	category_id INT,
	duration TIME,
	creator_id INT,
	create_date DATE
);
CREATE TABLE exam_question(
	exam_id INT,
	question_id INT,
    PRIMARY KEY(exam_id,question_id)
);