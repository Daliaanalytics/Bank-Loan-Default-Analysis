create database BankLoanDB
go
use BankLoanDB
go

create table customers(
       LoanID VARCHAR(20) PRIMARY KEY,
	   Age INT,
	   Income INT,
	   CreditScore INT,
	   EmploymentType NVARCHAR(50),
	   Education NVARCHAR(50),
	   MaritalStatus NVARCHAR(50),
	   MonthsEmployed INT
);

create table loans(
       LoanID VARCHAR(20) PRIMARY KEY,
       LoanAmount INT,
       InterestRate FLOAT,
       LoanTerm INT,
       DTIRatio FLOAT,
       NumCreditLines INT,
       LoanPurpose NVARCHAR(50),
       HasMortgage NVARCHAR(5),
       HasDependents NVARCHAR(5),
       HasCoSigner NVARCHAR(5),
       Default_ INT,
       FOREIGN KEY (LoanID) REFERENCES Customers(LoanID)
);

BULK INSERT customers
FROM 'C:\Users\MKcomputer\Documents\Bank_Loan_Default_Analysis\customers.csv'
WITH(
    FIRSTROW =2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '0x0a',
	TABLOCK
);

BULK INSERT loans
FROM 'C:\Users\MKcomputer\Documents\Bank_Loan_Default_Analysis\loans.csv'
WITH(
    FIRSTROW =2,
	FIELDTERMINATOR= ',',
	ROWTERMINATOR= '0x0a',
	TABLOCK
);

SELECT 'customers' as TableName, count(*) as Rows FROM customers
UNION ALL
SELECT 'loans', count(*) from loans;

SELECT
      COUNT(*) AS Total_loans,
	  SUM(Default_) AS Total_Defaults,
	  ROUND(SUM(Default_)*100/ COUNT(*),2) AS default_rate
	  from loans;

	  SELECT * FROM customers;

SELECT 
	       c.EmploymentType,
		   COUNT(*) AS Total_loans,
		   SUM(l.Default_) AS Total_defaults,
		   ROUND(SUM(l.Default_)*100/ COUNT(*),2) AS default_rate
FROM customers c
INNER JOIN loans l on c.LoanID= l.LoanID
GROUP BY EmploymentType
ORDER BY default_rate DESC;


SELECT 
    l.Default_,
    ROUND(AVG(CAST(c.CreditScore AS FLOAT)), 2) AS avg_credit_score,
    ROUND(AVG(CAST(c.Income AS FLOAT)), 2) AS avg_income
FROM Customers c
INNER JOIN Loans l ON c.LoanID = l.LoanID
GROUP BY l.Default_
ORDER BY l.Default_;

SELECT * FROM loans;

SELECT 
      LoanPurpose,
	  COUNT(*) AS Total_loans,
	  SUM(Default_) AS Total_defaults,
	  ROUND(SUM(Default_)*100/ COUNT(*),2) AS default_rate
FROM loans
GROUP BY LoanPurpose
ORDER BY default_rate DESC;

SELECT
      c.Education,
	  COUNT(*) AS Total_loans,
	  SUM(l.Default_) AS Total_defaults,
	  ROUND(SUM(l.Default_)*100/ COUNT(*),2) AS defaults_rate
FROM customers c
INNER JOIN loans l ON C.LoanID = l.LoanID
GROUP BY c.Education
ORDER BY defaults_rate DESC;