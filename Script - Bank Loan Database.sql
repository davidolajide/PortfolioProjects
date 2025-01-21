-- View the dataset

SELECT *
FROM BankLoanDatabase..financial_loan


-- Calculate Total Applications received

SELECT COUNT(id) AS total_applications_received
FROM BankLoanDatabase..financial_loan


-- Calculate MTD Total Loan Applications

SELECT COUNT(id) AS mtd_total_applications_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021 -- 1

-- Since there is only one loan id in December, we will consider it immaterial for the purpose of this project 
-- MTD calculations will be done using month 11


-- Calculate MTD Total Loan Applications

SELECT COUNT(id) AS pmtd_total_applications_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021 -- 20851


-- Calculate PMTD Total Loan Applications

SELECT COUNT(id) AS pmtd_total_applications_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021 -- 11197


-- Calculate MOM Total Loan Applications

WITH MTD_app AS(
SELECT COUNT(id) AS mtd_total_applications_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021),
PMTD_app AS(
SELECT COUNT(id) AS pmtd_total_applications_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021)

SELECT ROUND(((MTD.mtd_total_applications_received - PMTD.pmtd_total_applications_received) *1.0/NULLIF(PMTD.pmtd_total_applications_received, 0)) *100, 2) AS mom_total_loan_applications
FROM MTD_app MTD
CROSS JOIN PMTD_app PMTD; -- 86.22


-- Calculate the Total Funded Amount

SELECT SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan; --435757075


-- Calculate the MTD Total Funded Amount

SELECT SUM(loan_amount) AS mtd_total_funded_amount
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021; -- 253214725


-- Calculate the PMTD Total Funded Amount

SELECT SUM(loan_amount) AS pmtd_total_funded_amount
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021; -- 119568600


-- Calculate MOM Total Funded Amount

WITH MTD_funded AS(
SELECT SUM(loan_amount) AS mtd_total_funded_amount
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021),
PMTD_funded AS(
SELECT SUM(loan_amount) AS pmtd_total_funded_amount
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021)

SELECT ROUND(((MTD.mtd_total_funded_amount - PMTD.pmtd_total_funded_amount) *1.0/PMTD.pmtd_total_funded_amount) *100, 2) AS mom_total_funded_amount
FROM MTD_funded MTD, PMTD_funded PMTD; -- 111.77


-- Calculate the Total Amount Received

SELECT SUM(total_payment) AS total_amount_received
FROM BankLoanDatabase..financial_loan; --473070933


-- Calculate the MTD Total Funded Amount

SELECT SUM(total_payment) AS mtd_total_amount_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021; -- 278244337


-- Calculate the PMTD Total Funded Amount

SELECT SUM(total_payment) AS pmtd_total_amount_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021; --128148384


-- Calculate MOM Total Amount Received

WITH MTD_received AS(
SELECT SUM(total_payment) AS mtd_total_amount_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021),
PMTD_received AS(
SELECT SUM(total_payment) AS pmtd_total_amount_received
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021)

SELECT ROUND(((MTD.mtd_total_amount_received - PMTD.pmtd_total_amount_received) *1.0/PMTD.pmtd_total_amount_received) *100, 2) AS mom_total_amount_received
FROM MTD_received MTD, PMTD_received PMTD; -- 117.13


-- Calculate the Average Interest Rate

SELECT ROUND(AVG(int_rate) *100, 2) AS avg_int_rate
FROM BankLoanDatabase..financial_loan; -- 12.05


-- Calculate the MTD Average Interest Rate

SELECT ROUND(AVG(int_rate) *100, 2) AS mtd_avg_int_rate
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021; -- 12.25


-- Calculate the PMTD Average Interest Rate

SELECT ROUND(AVG(int_rate) *100, 2) AS pmtd_avg_int_rate
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021; -- 11.77


-- Calculate MOM Average Interest Rate

WITH MTD_int AS(
SELECT ROUND(AVG(int_rate) *100, 2) AS mtd_avg_int_rate
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021),
PMTD_int AS(
SELECT ROUND(AVG(int_rate) *100, 2) AS pmtd_avg_int_rate
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021)

SELECT ROUND(((MTD.mtd_avg_int_rate - PMTD.pmtd_avg_int_rate) *1.0/PMTD.pmtd_avg_int_rate) *100 , 2) AS mom_avg_int_rate
FROM MTD_int MTD, PMTD_int PMTD; -- 4.08


-- Calculate the Average Debt to Income Ratio (DTI)

SELECT ROUND(AVG(dti) *100, 2) AS avg_dti
FROM BankLoanDatabase..financial_loan; -- 13.33


-- Calculate the MTD Average Debt to Income Ratio (DTI)

SELECT ROUND(AVG(dti) *100, 2) AS mtd_avg_dti
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021; -- 13.86


-- Calculate the PMTD Average Interest Rate (DTI)

SELECT ROUND(AVG(dti) *100, 2) AS pmtd_avg_dti
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021; -- 12.98


-- Calculate MOM Total Amount Received (DTI)

WITH MTD_dti AS(
SELECT ROUND(AVG(dti) *100, 2) AS mtd_avg_dti
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021),
PMTD_dti AS(
SELECT ROUND(AVG(dti) *100, 2) AS pmtd_avg_dti
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 10 AND YEAR(issue_date) = 2021)

SELECT ROUND(((MTD.mtd_avg_dti - PMTD.pmtd_avg_dti) *1.0/PMTD.pmtd_avg_dti) *100 , 2) AS mom_avg_dti
FROM MTD_dti MTD, PMTD_dti PMTD; -- 6.78


-- Good Loan KPIs

-- Calculate the Good Loan Application Percentage

SELECT ROUND(COUNT
(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' 
 THEN id
 END) *100.00/COUNT(id), 2) AS good_loan_percentage
FROM BankLoanDatabase..financial_loan; -- 86.18


-- Calculate Number of Good Loan Applications

SELECT COUNT(id) AS good_loan_applications
FROM BankLoanDatabase..financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; -- 33243


-- Calculate Number of Good Loan Funded Amount

SELECT SUM(loan_amount) AS good_loan_applications
FROM BankLoanDatabase..financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; -- 370224850


-- Calculate Number of Good Loan Total Received Amount

SELECT SUM(total_payment) AS good_loan_applications
FROM BankLoanDatabase..financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'; -- 435786170


-- Bad Loan KPIs

-- Calculate the Bad Loan Application Percentage

SELECT ROUND(COUNT
(CASE WHEN loan_status = 'Charged Off' 
 THEN id
 END) *100.00/COUNT(id), 2) AS bad_loan_percentage
FROM BankLoanDatabase..financial_loan; -- 13.82


-- Calculate Number of Bad Loan Applications

SELECT COUNT(id) AS bad_loan_applications
FROM BankLoanDatabase..financial_loan
WHERE loan_status = 'Charged Off'; -- 5333


-- Calculate Number of Bad Loan Funded Amount

SELECT SUM(loan_amount) AS bad_loan_applications
FROM BankLoanDatabase..financial_loan
WHERE loan_status = 'Charged Off'; -- 65532225


-- Calculate Number of Bad Loan Total Received Amount

SELECT SUM(total_payment) AS bad_loan_applications
FROM BankLoanDatabase..financial_loan
WHERE loan_status = 'Charged Off'; -- 37284763


-- Calculating the Loan Count, Total Amount Received, Total Funded Amount, Interest Rate, DTI on the basis of Loan Status

SELECT
	loan_status,
	COUNT(id) AS loan_count,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount,
	AVG(int_rate * 100) AS int_rate,
	AVG(dti * 100) AS dti
FROM BankLoanDatabase..financial_loan
GROUP BY loan_status;


-- Calculating the MTD Total Amount Received and MTD Total Funded Amount on the basis of Loan Status

SELECT
	loan_status,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
GROUP BY loan_status;


-- BANK LOAN REPORT | OVERVIEW - MONTH

-- Calculating the Monthly Total Loan Application, Total Amount Received and Total Funded Amount

SELECT
	MONTH(issue_date) AS month_number,
	DATENAME(MONTH, issue_date) AS month_name,
	COUNT(id) AS loan_count,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);


-- BANK LOAN REPORT | OVERVIEW - STATE

SELECT
	address_state AS state,
	COUNT(id) AS loan_count,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan
GROUP BY address_state
ORDER BY address_state;


-- BANK LOAN REPORT | OVERVIEW - LOAN TERMS

SELECT
	term AS term,
	COUNT(id) AS loan_count,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan
GROUP BY term
ORDER BY term;


-- BANK LOAN REPORT | OVERVIEW - EMPLOYEE LENGTH

SELECT
	emp_length AS emp_length,
	COUNT(id) AS loan_count,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan
GROUP BY emp_length
ORDER BY emp_length;


-- BANK LOAN REPORT | OVERVIEW - LOAN PURPOSE

SELECT
	purpose AS loan_purpose,
	COUNT(id) AS loan_count,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan
GROUP BY purpose
ORDER BY purpose;


-- BANK LOAN REPORT | OVERVIEW - HOME OWNERSHIP

SELECT
	home_ownership AS home_ownership_cat,
	COUNT(id) AS loan_count,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM BankLoanDatabase..financial_loan
GROUP BY home_ownership
ORDER BY home_ownership;


