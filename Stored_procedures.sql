--  Add New User

DELIMITER //

CREATE PROCEDURE AddNewUser (
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_category ENUM('customer', 'admin')
)
BEGIN
    INSERT INTO User (firstName, lastName, email, password, category)
    VALUES (p_firstName, p_lastName, p_email, p_password, p_category);
END //

DELIMITER ;
-- Update Product Stock
DELIMITER //

CREATE PROCEDURE UpdateProductStock (
    IN p_productID INT,
    IN p_stockQuantity INT
)
BEGIN
    UPDATE Product
    SET stockQuantity = p_stockQuantity
    WHERE productID = p_productID;
END //

DELIMITER ;
-- Calculate Order Total

DELIMITER //

CREATE PROCEDURE CalculateOrderTotal (
    IN p_orderID INT,
    OUT p_total DECIMAL(10, 2)
)
BEGIN
    SELECT SUM(op.quantity * p.price)
    INTO p_total
    FROM OrderProduct op
    JOIN Product p ON op.productID = p.productID
    WHERE op.orderID = p_orderID;
END //

DELIMITER ;
-- Add New Order

DELIMITER //

CREATE PROCEDURE AddNewOrder (
    IN p_orderDate DATE,
    IN p_status ENUM('pending', 'shipped', 'delivered', 'cancelled'),
    IN p_userID INT
)
BEGIN
    INSERT INTO `Order` (orderDate, status, userID)
    VALUES (p_orderDate, p_status, p_userID);
END //

DELIMITER ;


-- Add Product to Order

DELIMITER //

CREATE PROCEDURE AddProductToOrder (
    IN p_orderID INT,
    IN p_productID INT,
    IN p_quantity INT
)
BEGIN
    INSERT INTO OrderProduct (orderID, productID, quantity)
    VALUES (p_orderID, p_productID, p_quantity);
    
    -- Update stock quantity of the product
    UPDATE Product
    SET stockQuantity = stockQuantity - p_quantity
    WHERE productID = p_productID;
END //

DELIMITER ;
