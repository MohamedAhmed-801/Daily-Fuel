CREATE DATABASE DailyFuel;
USE DailyFuel;

CREATE TABLE FuelStation (
	station_id INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	location TEXT NOT NULL
);

CREATE TABLE Tank (
	tank_id INT IDENTITY(1,1) PRIMARY KEY,
	station_id  INT NOT NULL FOREIGN KEY REFERENCES FuelStation(station_id),
	fuel_type VARCHAR (175) NOT NULL,
	capacity DECIMAL(10,2) NOT NULL,
	current_level DECIMAL(10,2) NOT NULL
);

CREATE TABLE Sales (
	sale_id INT IDENTITY(1,1) PRIMARY KEY,
	station_id INT NOT NULL FOREIGN KEY REFERENCES FuelStation(station_id),
	tank_id INT NOT NULL FOREIGN KEY REFERENCES Tank (tank_id),
	sale_datetime  DATETIME NOT NULL,
	liters_sold DECIMAL(10,2) NOT NULL,
	price_per_liter DECIMAL(10,2) NOT NULL
);

CREATE TABLE Suppliers (
	supplier_id INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	contact_info VARCHAR(150) NOT NULL
);

CREATE TABLE Restocking (
	restock_id INT IDENTITY(1,1) PRIMARY KEY,
	tank_id INT NOT NULL FOREIGN KEY REFERENCES Tank (tank_id),
	supplier_id INT NOT NULL FOREIGN KEY REFERENCES Suppliers(supplier_id),
	restock_datetime DATETIME NOT NULL,
	liters_added DECIMAL(10,2) NOT NULL
);

CREATE TABLE "User" (
	user_id INT IDENTITY(1,1) PRIMARY KEY,
	username VARCHAR(100) NOT NULL UNIQUE,
	role VARCHAR(50) NOT NULL
);

--######################################################### insert Data()

-- 1. FuelStation
INSERT INTO FuelStation (name, location) VALUES 
('Station A', 'Cairo'),
('Station B', 'Giza'),
('Station C', 'Alexandria'),
('Station D', 'Mansoura'),
('Station E', 'Tanta'),
('Station F', 'Aswan'),
('Station G', 'Luxor'),
('Station H', 'Hurghada'),
('Station I', 'Port Said'),
('Station J', 'Suez');

-- 2. Tank
INSERT INTO Tank (station_id, fuel_type, capacity, current_level) VALUES 
(1, 'Diesel', 10000.00, 8000.00),
(1, 'Petrol 92', 8000.00, 5000.00),
(2, 'Petrol 95', 7000.00, 3000.00),
(3, 'Diesel', 12000.00, 10000.00),
(4, 'Petrol 92', 9000.00, 6000.00),
(5, 'Petrol 95', 8500.00, 4000.00),
(6, 'Diesel', 11000.00, 9000.00),
(7, 'Petrol 92', 7500.00, 5000.00),
(8, 'Petrol 95', 8000.00, 6000.00),
(9, 'Diesel', 10000.00, 300.00);

-- 3. Suppliers
INSERT INTO Suppliers (name, contact_info) VALUES 
('Supplier X', 'x@example.com'),
('Supplier Y', 'y@example.com'),
('Supplier Z', 'z@example.com'),
('Supplier Alpha', 'alpha@example.com'),
('Supplier Beta', 'beta@example.com'),
('Supplier Gamma', 'gamma@example.com'),
('Supplier Delta', 'delta@example.com'),
('Supplier Epsilon', 'epsilon@example.com'),
('Supplier Eta', 'eta@example.com'),
('Supplier Theta', 'theta@example.com');

-- 4. Users
INSERT INTO "User" (username, role) VALUES 
('admin', 'Admin'),
('manager1', 'Manager'),
('manager2', 'Manager'),
('cashier1', 'Cashier'),
('cashier2', 'Cashier'),
('supervisor1', 'Supervisor'),
('auditor1', 'Auditor'),
('operator1', 'Operator'),
('operator2', 'Operator'),
('guest', 'Guest');

-- 5. Sales
INSERT INTO Sales (station_id, tank_id, sale_datetime, liters_sold, price_per_liter) VALUES 
(1, 1, GETDATE(), 100.00, 8.50),
(1, 2, GETDATE(), 150.00, 9.25),
(2, 3, GETDATE(), 200.00, 10.00),
(3, 4, GETDATE(), 120.00, 8.75),
(4, 5, GETDATE(), 180.00, 9.50),
(5, 6, GETDATE(), 220.00, 10.20),
(6, 7, GETDATE(), 160.00, 8.60),
(7, 8, GETDATE(), 190.00, 9.30),
(8, 9, GETDATE(), 210.00, 10.10),
(9, 10, GETDATE(), 170.00, 8.80);

-- 6. Restocking
INSERT INTO Restocking (tank_id, supplier_id, restock_datetime, liters_added) VALUES 
(1, 1, GETDATE(), 2000.00),
(2, 2, GETDATE(), 1500.00),
(3, 3, GETDATE(), 1800.00),
(4, 4, GETDATE(), 2200.00),
(5, 5, GETDATE(), 1700.00),
(6, 6, GETDATE(), 1600.00),
(7, 7, GETDATE(), 2000.00),
(8, 8, GETDATE(), 1500.00),
(9, 9, GETDATE(), 1800.00),
(10, 10, GETDATE(), 2200.00);


--######################################################### 

SELECT * FROM FuelStation;
SELECT * FROM Tank;

SELECT 
    T.tank_id,
    F.name AS station_name,
    T.fuel_type,
    T.capacity,
    T.current_level
FROM Tank T
JOIN FuelStation F ON T.station_id = F.station_id;

SELECT 
    tank_id,
    fuel_type,
    current_level,
    capacity,
    (current_level / capacity) * 100 AS percent_full
FROM Tank
WHERE current_level < (capacity * 0.2);

SELECT 
    F.name AS station_name,
    SUM(S.liters_sold * S.price_per_liter) AS total_sales
FROM Sales S
JOIN FuelStation F ON S.station_id = F.station_id
GROUP BY F.name;

SELECT 
    CONVERT(DATE, sale_datetime) AS sale_date,
    T.fuel_type,
    SUM(liters_sold) AS total_liters_sold
FROM Sales S
JOIN Tank T ON S.tank_id = T.tank_id
GROUP BY CONVERT(DATE, sale_datetime), T.fuel_type
ORDER BY sale_date;

SELECT 
    R.tank_id,
    T.fuel_type,
    SUM(R.liters_added) AS total_restocked
FROM Restocking R
JOIN Tank T ON R.tank_id = T.tank_id
GROUP BY R.tank_id, T.fuel_type;

SELECT 
    R.tank_id,
    MAX(R.restock_datetime) AS last_restock
FROM Restocking R
GROUP BY R.tank_id;

SELECT * FROM "User"
ORDER BY role;

-- ================================
-- DDL – Data Definition Language
-- ================================

ALTER TABLE Suppliers ADD is_active BIT DEFAULT 1;
select* from Suppliers;
ALTER TABLE Tank ALTER COLUMN fuel_type VARCHAR(100);


-- ================================
-- DML – Data Manipulation Language
-- ================================

UPDATE Tank SET current_level = current_level - 100 WHERE tank_id = 1;

INSERT INTO Sales (station_id, tank_id, sale_datetime, liters_sold, price_per_liter)
VALUES (1, 1, GETDATE(), 120, 8.75);

DELETE FROM Restocking WHERE restock_id = 1;

SELECT name, location FROM FuelStation;

-- ================================
-- DCL – Data Control Language
-- ================================

GRANT SELECT ON FuelStation TO guest;

REVOKE INSERT, UPDATE, DELETE ON Sales FROM guest;

-- ================================
-- TCL – Transaction Control Language
-- ================================

BEGIN TRANSACTION;
INSERT INTO Sales (station_id, tank_id, sale_datetime, liters_sold, price_per_liter)
VALUES (2, 3, GETDATE(), 100, 9.50);
UPDATE Tank SET current_level = current_level - 100 WHERE tank_id = 3;
COMMIT;

BEGIN TRANSACTION;
UPDATE Tank SET current_level = current_level + 500 WHERE tank_id = 5;
ROLLBACK;




--Answer The Questions

--1- Retrieve a list of all records from a main table in this project.
SELECT * FROM Sales;
--2- How many entries are related to a certain condition? (Use COUNT or WHERE)
SELECT COUNT(*) AS GasolineSalesCount
FROM Sales
JOIN Tank ON Sales.tank_id = Tank.tank_id
WHERE Tank.fuel_type = 'Gasoline';
--3- Use JOIN to relate at least two tables and show combined data.
SELECT 
    T.tank_id,
    F.name AS station_name,
    T.fuel_type,
    T.capacity,
    T.current_level
FROM Tank T
JOIN FuelStation F ON T.station_id = F.station_id;
--4- Write a DCL query to grant or revoke access to a table.
 GRANT SELECT ON Sales TO [cashier1];
--OR--
REVOKE SELECT ON Sales FROM [cashier1];
--5- Show how to use BEGIN TRANSACTION and COMMIT for a key action.
BEGIN TRANSACTION;

INSERT INTO Sales (station_id, tank_id, sale_datetime, liters_sold, price_per_liter)
VALUES (1, 2, GETDATE(), 50.0, 9.5);

UPDATE Tank
SET current_level = current_level - 50.0
WHERE tank_id = 2;

COMMIT;


