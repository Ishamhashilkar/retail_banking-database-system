--view 1: Customer account summary
--I need a report that shows each customer, how many accounts they have, their total balance, and average balance.
create or replace view customer_account_summary AS
select c.CustomerID, c.FirstName || ' ' || c.LastName AS CustomerName,
COUNT(a.AccountID) AS Total_Accounts, 
SUM(a.Balance) AS Total_Balance,
ROUND(AVG(a.Balance),2) AS Average_Balance_Per_Account
From Customers c 
join Accounts a ON c.CustomerID = a.CustomerID
Group by c.CustomerID, c.FirstName, c.LastName;

select * from customer_account_summary
order by Total_Balance desc;

--view 2: monthly transaction report showing how many deposits and withdrawals happened each month and their total amount.
create or replace view monthly_transaction_report AS
select To_Char(TransactionDate, 'YYYY-MM') AS Transaction_Month,
TransactionType,
Count(*) AS Transaction_Count,
Sum(Amount) AS Total_Amount
From Transactions
Group by To_Char(TransactionDate,'YYYY-MM'), TransactionType;

select * from monthly_transaction_report 
order by Transaction_Month desc;
