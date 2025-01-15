-- Create Table for Customers

USE [E-Banking]

CREATE TABLE Customers (
    customer_id INT IDENTITY (1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    birthdate DATE,
	city VARCHAR(255),
	country VARCHAR(255)
);

-- Create Table for Loan

USE [E-Banking]

CREATE TABLE Loans (
    loan_id INT IDENTITY (1,1) PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(12, 2) NOT NULL,
    loan_date DATE NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create Dummy Table Sample

INSERT INTO Customers
VALUES
    ('John', 'Doe', 'johndoe@gmail.com', '+234-910-233-4556', '1990-05-15', 'Lagos', 'Nigeria'),
    ('Jane', 'Smith', 'janesmith@gmail.com', '+234-811-222-4567', '1985-09-20', 'Lagos', 'Nigeria'),
    ('Michael', 'Johnson', 'michaelj@gmail.com', '+234-901-666-7777', '1988-03-10', 'Lagos', 'Nigeria'),
    ('Emily', 'Davis', 'emilydavis@gmail.com', '+234-911-233-3232', '1995-12-28', 'Lagos', 'Nigeria'),
    ('Chris', 'Wilson', 'chriswilson@gmail.com', '+234-900-123-2222', '1992-07-03', 'Lagos', 'Nigeria'),
    ('Sarah', 'Brown', 'sarahbrown@gmail.com', '+234-800-4444-5674', '1980-11-15', 'Lagos', 'Nigeria'),
    ('Alex', 'Martinez', 'alexmartinez@gmail.com', '+234-811-1111-2334', '1993-04-25', 'Lagos', 'Nigeria'),
    ('Jessica', 'Lee', 'jessicalee@gmail.com', '+234-810-3456-7890', '1987-06-08', 'Lagos', 'Nigeria'),
    ('David', 'Garcia', 'davidgarcia@gmail.com', '+234-800-111-1111', '1983-02-17', 'Lagos', 'Nigeria'),
    ('Lisa', 'Nguyen', 'lisanguyen@gmail.com', '+234-814-234-4567', '1991-08-05', 'Lagos', 'Nigeria'),
	('Chris', 'Taylor', 'ctaylor@gmail.com', '+234-803-444-5555', '1990-07-12', 'Lagos', 'Nigeria'),
	('Samantha', 'White', 'swhite@gmail.com', '+234-701-222-3333', '1985-06-05', 'Lagos', 'Nigeria'),
	('Robert', 'Downey', 'rdowney@gmail.com', '+234-801-784-1234', '1999-12-24', 'Lagos', 'Nigeria'),
	('Sarah', 'Miller', 'sarahm@gmail.com', '+234-911-784-1234', '1989-09-12', 'Lagos', 'Nigeria'),
    ('Chris', 'Lee', 'chrisl@gmail.com', '+234-801-434-3211', '1973-06-18', 'Lagos', 'Nigeria'),
    ('Laura', 'Wilson', 'lauraw@gmail.com', '+234-801-000-9999', '1993-02-28', 'Lagos', 'Nigeria'),
    ('Kevin', 'Garcia', 'keving@gmail.com', '+234-811-555-6666', '1987-04-04', 'Lagos', 'Nigeria'),
    ('Amanda', 'Martinez', 'amandam@egmail.com', '+234-811-654-3245', '1980-11-09', 'Lagos', 'Nigeria');


-- Delete Data

DELETE FROM Loans
WHERE customer_id = 18;

DELETE FROM Customers
WHERE customer_id = 18;

-- Loan Table Sample

INSERT INTO Loans
VALUES
    (1, 5000.00, '2023-01-15', 5.25),
    (2, 8000.00, '2023-02-28', 4.75),
    (3, 10000.00, '2023-03-10', 6.00),
    (4, 3000.00, '2023-04-05', 3.99),
    (5, 12000.00, '2023-05-20', 5.50),
    (6, 7000.00, '2023-06-12', 4.25),
    (7, 6000.00, '2023-07-03', 4.00),
    (8, 9000.00, '2023-08-18', 5.75),
    (9, 4000.00, '2023-09-22', 3.50),
    (10, 11000.00, '2023-10-30', 6.25),
    (11, 2000.00, '2023-11-15', 4.00),
    (12, 5000.00, '2023-12-20', 5.75),
    (13, 15000.00, '2024-01-25', 6.50),
    (14, 2500.00, '2024-02-08', 4.25),
    (15, 8000.00, '2024-03-14', 5.00),
    (16, 6000.00, '2024-04-05', 4.75),
    (17, 7000.00, '2024-05-10', 4.25),
    (18, 10000.00, '2024-06-18', 5.50);

-- Retrieve Total Number of Loans

SELECT c.customer_id, c.first_name, c.last_name, 
COUNT(l.loan_id) AS num_loans
FROM Customers c
LEFT OUTER JOIN Loans l 
ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Return Average Loan Amount

SELECT
	AVG(loan_amount) as avg_loan_amount
  FROM [E-Banking].[dbo].[Loans]


-- Update Status of Loan

UPDATE Loans
SET loan_amount = 7500.00, interest_rate = 3.80
WHERE loan_id = 2


-- Retrieve list of all Customers

SELECT *
FROM Customers;
