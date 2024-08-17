--  Trigger to Update Stock on Order Product Insert

DELIMITER //

CREATE TRIGGER trg_update_stock_on_order_insert
AFTER INSERT ON OrderProduct
FOR EACH ROW
BEGIN
    UPDATE Product
    SET stockQuantity = stockQuantity - NEW.quantity
    WHERE productID = NEW.productID;
END //

DELIMITER ;


-- Trigger to Log Product Stock Changes

DELIMITER //

CREATE TRIGGER trg_log_stock_changes
AFTER UPDATE ON Product
FOR EACH ROW
BEGIN
    INSERT INTO StockLog (productID, oldStock, newStock, changeDate)
    VALUES (OLD.productID, OLD.stockQuantity, NEW.stockQuantity, NOW());
END //

DELIMITER ;


CREATE TABLE StockLog (
    logID INT AUTO_INCREMENT PRIMARY KEY,
    productID INT,
    oldStock INT,
    newStock INT,
    changeDate TIMESTAMP,
    FOREIGN KEY (productID) REFERENCES Product(productID)
);


-- Trigger to Prevent Deletion of Delivered Orders

DELIMITER //

CREATE TRIGGER trg_prevent_delivered_order_deletion
BEFORE DELETE ON `Order`
FOR EACH ROW
BEGIN
    IF OLD.status = 'delivered' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete a delivered order';
    END IF;
END //

DELIMITER ;


-- Trigger to Automatically Set Delivery Date

DELIMITER //

CREATE TRIGGER trg_set_delivery_date_on_status_change
BEFORE UPDATE ON Delivery
FOR EACH ROW
BEGIN
    IF NEW.deliveryStatus = 'delivered' THEN
        SET NEW.deliveryDate = CURDATE();
    END IF;
END //

DELIMITER ;
