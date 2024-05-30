-- 2. Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua và sắp sếp tăng dần theo số lượng oto đã mua.
select c.CustomerID,c.`name`,sum(Amount) as SoLuongOToDaMua from Car_order co
join Customer c on co.CustomerID = c.CustomerID
WHERE `status` = 1
group by co.CustomerID
order by SoLuongOToDaMua ASC;

-- 3. Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều oto nhất trong năm nay.
DROP PROCEDURE IF EXISTS Question3;
DELIMITER $$
CREATE PROCEDURE Quesition3()
Begin 
        select c1.Maker from Car_order co1
        join Car c1 on co1.CarID = c1.CarID
        group by co1.CarID
        having Sum(co1.Amount)=(select max(Tong) from 
        (select c.Maker,c.CarID,Sum(co.Amount) as Tong from Car_order co
        join Car c on co.CarID = c.CarID
        where `status` = 1 AND YEAR(DeliveryDate) = YEAR(now())
        group by co.CarID) as a);
END $$
DELIMITER ;
call Quesition3;

-- 4. Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của những năm trước. In ra số lượng bản ghi đã bị xóa.
DROP PROCEDURE IF EXISTS Delete_car_status_2;
DELIMITER $$
CREATE PROCEDURE Delete_car_status_2()
Begin 
    SELECT COUNT(*) AS Sum_Don_hang FROM Car_order
    where `status` = 2 AND YEAR(DeliveryDate) < YEAR(now());
    DELETE FROM Car_order 
    where `status` = 2 AND YEAR(DeliveryDate) < YEAR(now());
END $$
DELIMITER ;

CALL Delete_car_status_2;

-- 5. Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn hàng đã đặt hàng bao gồm: 
-- tên của khách hàng, mã đơn hàng, số lượng oto và tên hãng sản xuất.
DROP PROCEDURE IF EXISTS select_car;
DELIMITER $$
CREATE PROCEDURE select_car(IN CustomerID INT)
Begin 
    SELECT c.name,co.OrderID,CO.Amount,ca.Maker FROM Customer C
    join Car_order CO ON C.CustomerID = CO.CustomerID
    join car ca on ca.CarID = CO.CarID
    WHERE `Status` = 0 OR `Status` = 1  AND c.CustomerID = CustomerID;
END $$
DELIMITER ;

set @CustomerID = 1;
call select_car(@CustomerID);

-- 6: Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
-- vào database (DeliveryDate < OrderDate + 15).
DROP TRIGGER IF EXISTS Ques6;
DELIMITER $$
CREATE TRIGGER Ques6 
BEFORE INSERT ON Car_order
FOR EACH ROW
BEGIN
	-- 
	IF DAY(NEW.DeliveryDate) < DATE_ADD(NEW.OrderDate, INTERVAL 15 DAY) THEN
    SIGNAL SQLSTATE '12345' 
    SET MESSAGE_TEXT = 'Khong nhap duoc';
	END IF;
END $$
DELIMITER ;
-- cách 2 câu 6
DROP TRIGGER IF EXISTS trig1;
DELIMITER $$
CREATE TRIGGER trig1
BEFORE INSERT ON Car_order
FOR EACH ROW
BEGIN
    DECLARE V_DeliveryDate DATE;
    DECLARE V_OrderDate DATE;
    SET V_DeliveryDate = NEW.DeliveryDate;
    SET V_OrderDate    = NEW.OrderDate;
	IF V_DeliveryDate < DATE_ADD(V_OrderDate, INTERVAL 15 DAY) THEN
		SIGNAL SQLSTATE '12345' 
        SET MESSAGE_TEXT = 'ERROR';
    END IF;
    END$$
DELIMITER ;