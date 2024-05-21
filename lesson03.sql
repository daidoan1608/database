SELECT CURRENT_DATE AS "Today",NOW() AS "Now";
SELECT department_name,department_id
FROM department;

-- *: lấy ra tất cả 
SELECT *
FROM question;
-- Toán tử : > . >= , < . <= , =  , != , <>
-- where
SELECT *
FROM department
WHERE department_id > 5;
-- mệnh đề logic: AND OR
SELECT *
FROM department
WHERE department_id > 3 AND department_id < 8;
-- BETWEEN ... AND ...
SELECT *
FROM department
WHERE department_id BETWEEN 3 AND 8;
-- IN
SELECT *
FROM department
WHERE department_id IN ( 2, 4, 6, 8);
-- LIKE
-- _ 1 kí tự
-- % 0 hoặc nhiều
SELECT *
FROM department
WHERE department_name LIKE "%g%";
-- IS NULL/IS NOT NULL
SELECT *
FROM department
WHERE department_name IS NOT NULL;
-- LIMIT
SELECT *
FROM department
LIMIT 5;
-- SUBSTRING_INDEX("Chuối ban đầu","ký tự cắt","ký tự cắt từ thứ bn/dương từ phải qua,âm từ trái qua")
-- ORDER BY ASC/DESC(Mặc định ASC)
SELECT *
FROM exam
ORDER BY duration DESC;
SELECT *
FROM exam
ORDER BY duration DESC, created_date DESC;
-- CHAR_LENGTH("Chuoi can lay do dai")
INSERT INTO exam (exam_id, code, title, category_id, duration, creator_id)
VALUES 			 ('11', 'VTIQ011', 'Đề thi MySQL', '2', null, '9');
-- COUNT(*): đếm tất cả các dòng
SELECT COUNT(*) AS exam_count
FROM exam;
-- COUNT(id): đếm tất cả các dòng IS NOT NULL
SELECT COUNT(duration)
FROM exam;
-- SUM,MIN,MAX,AVG chỉ có tác dụng với các dòng IS NOT NULL
SELECT
	SUM(duration),
	MIN(duration),
    MAX(duration),
    AVG(duration)
FROM exam;
-- Mệnh đề GROUP BY nhóm
SELECT duration,COUNT(exam_id) AS exam_count
FROM exam
GROUP BY duration;
SELECT duration, created_date, COUNT(exam_id) AS exam_count
FROM exam
GROUP BY duration, created_date
ORDER BY duration, created_date;
-- HAVING đk trên từng nhóm
SELECT duration, created_date, COUNT(exam_id) AS exam_count
FROM exam
GROUP BY duration, created_date
HAVING COUNT(exam_id) >=2
ORDER BY duration, created_date;
-- UPDATA
UPDATE department
SET department_name = "Phòng chờ"
WHERE department_id = 1;
-- DELETE
DELETE FROM exam
WHERE duration IS NULL;