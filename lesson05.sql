-- SUBQUERy: Truy vấn con
-- Thứ tự chạy: từ trong ra ngoài
-- VD: lấy ra tất cả chức vụ có ít người nhất
SELECT position.*,COUNT(account_id) AS account_count
FROM position
LEFT JOIN account USING(position_id)
GROUP BY position_id
HAVING COUNT(account_id) = (
							SELECT MIN(account_count)
							FROM(
									SELECT COUNT(account_id) AS account_count
									FROM position
									LEFT JOIN account USING(position_id)
									GROUP BY position_id) AS t);
-- ANY(bao gồm trường hợp IN + ">" + "<"), ALL tương tự ANY nhưng thỏa mãn tất cả các điều kiện
SELECT *
FROM account
WHERE department_id = ANY(	SELECT department_id
							FROM department
                            WHERE department_name IN("Bảo vệ","Sale"));
-- EXISTS
SELECT *
FROM `group`
WHERE NOT EXISTS
	(SELECT *
    FROM group_account
    WHERE group_account.group_id = `group`.group_id);
-- VIEW: Bảng ảo
DROP VIEW IF EXISTS view_01;

CREATE OR REPLACE VIEW view_01 AS
SELECT *
FROM department;

-- CTE: Common Table Expression, Bảng tạm lưu trong bộ nhớ ram
-- VD: lấy ra tất cả các phòng ban có nhiều nhân viên nhất
WITH c1 AS(
	SELECT department.*, COUNT(account_id) AS account_count
    FROM department
    LEFT JOIN account USING(department_id)
    GROUP BY department_id
)
SELECT *
FROM c1
WHERE account_count =(	SELECT MAX(account_count)
						FROM c1);