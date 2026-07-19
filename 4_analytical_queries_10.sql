--Q1. Who are the most valuable (VIP) customers?
select * from(
    select CustomerName, Total_Balance
    from customer_account_summary
    order by Total_Balance desc
) 
where ROWNUM <=5;

--Q2. Which customer hold more than one account?
select CustomerName, Total_Accounts
from customer_account_summary
where Total_Accounts > 1
order by Total_Accounts desc;

--Q3. Which accounts are close to falling below minimum balance?
select a.AccountID, c.FirstName || ' ' || c.LastName AS CustomerName,
a.AccountType, a.Balance, a.Status
from Accounts a 
join customers c ON a.CustomerID = c.CustomerID
where a.Balance < 1000
order by a.Balance ASC;

--Q4. Overall, is more money entering or leaving the bank?
Select TransactionType,
count(*),
Sum(Amount)
from Transactions
Group by TransactionType;

--Q5. Compliance needs a list of all restricted accounts for audit.
select AccountID, CustomerID, AccountType, Balance, Status
from Accounts
where status IN('Frozen','Closed');

--Q6. Flag unusually large transactionns for fraud review.
select * from (
    select TransactionID, FromAccountID, ToAccountID, Amount, TransactionType, TransactionDate
    from Transactions
    order by Amount desc
) 
where ROWNUM <= 5;

--Q7. Which accounts have never been used at all (Dormant accounts)?
Select a.AccountID, a.CustomerID, a.AccountType, a.Balance
from Accounts a
where a.AccountID NOT IN(
    select FromAccountID from Transactions 
    where FromAccountID is not null
    Union
    select ToAccountID from Transactions
    where ToAccountID is not null
);

--Q8. Which customer transacts with us the most (engagement)?
select c.CustomerID, c.FirstName || ' ' || c.LastName AS CustomerName,
count(*) AS Transaction_Count
from Transactions t 
join Accounts a ON t.FromAccountID = a.AccountID OR t.ToAccountID = a.AccountID
join Customers c ON a.CustomerID = c.CustomerID
Group by c.CustomerID, c.FirstName, c.LastName
order by Transaction_Count desc
fetch first 5 rows only;

--Q9. Show cumulative deposit growth over time (like a running bank statement).
select TransactionID, ToAccountID, Amount, TransactionDate,
sum(Amount) over (order by TransactionDate) AS Running_Total
from Transactions
where TransactionType = 'Deposit'
Order by TransactionDate;

--Q10. Who's the wealthiest savings account holder vs wealthiest current account holder, separately?
select AccountID, CustomerID, AccountType, Balance,
Rank() over (partition by AccountType order by Balance desc) AS Balance_Rank
from Accounts
order by AccountType, Balance_Rank;

