create database Fraud_detection_bank
use Fraud_detection_bank

//table1 customer

CREATE TABLE Customers(
    cust_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);

//table2 branches

CREATE TABLE Branches(
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);

//table3 employees

CREATE TABLE Employees(
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT,
    emp_name VARCHAR(100),
    role VARCHAR(50),
    FOREIGN KEY(branch_id)
    REFERENCES Branches(branch_id)
);

//table4 accounts

CREATE TABLE Accounts(
    acc_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_id INT,
    branch_id INT,
    acc_type VARCHAR(30),
    balance DECIMAL(12,2),

    FOREIGN KEY(cust_id)
    REFERENCES Customers(cust_id),

    FOREIGN KEY(branch_id)
    REFERENCES Branches(branch_id)
);

//table5

CREATE TABLE TransactionTypes(
	txn_type_id int PRIMARY KEY AUTO_INCREMENT,
    txn_type VARCHAR(30) NOT NULL
    );

//table6

CREATE TABLE Transactions (
    txn_id INT PRIMARY KEY AUTO_INCREMENT,
    acc_id INT,
    txn_type_id INT,
    amount DECIMAL(12,2),
    txn_date DATETIME,
    FOREIGN KEY (acc_id) REFERENCES Accounts(acc_id),
    FOREIGN KEY (txn_type_id) REFERENCES TransactionTypes(txn_type_id)
);

//table7

CREATE TABLE Cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    acc_id INT,
    card_type VARCHAR(30),
    status VARCHAR(20),
    FOREIGN KEY (acc_id) REFERENCES Accounts(acc_id)
);

//table8

CREATE TABLE Devices (
    device_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_id INT,
    device_name VARCHAR(50),
    FOREIGN KEY (cust_id) REFERENCES Customers(cust_id)
);

//table9

CREATE TABLE LoginHistory (
    login_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_id INT,
    device_id INT,
    login_time DATETIME,
    FOREIGN KEY (cust_id) REFERENCES Customers(cust_id),
    FOREIGN KEY (device_id) REFERENCES Devices(device_id)
);

//table10

CREATE TABLE Beneficiaries (
    ben_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_id INT,
    ben_name VARCHAR(100),
    bank_name VARCHAR(100),
    FOREIGN KEY (cust_id) REFERENCES Customers(cust_id)
);

//table11

CREATE TABLE FraudAlerts (
    fraud_id INT PRIMARY KEY AUTO_INCREMENT,
    txn_id INT,
    fraud_type VARCHAR(50),
    status VARCHAR(20),
    FOREIGN KEY (txn_id) REFERENCES Transactions(txn_id)
);

//table12

CREATE TABLE Investigations (
    invest_id INT PRIMARY KEY AUTO_INCREMENT,
    fraud_id INT,
    emp_id INT,
    remarks VARCHAR(255),
    FOREIGN KEY (fraud_id) REFERENCES FraudAlerts(fraud_id),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

//table13

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    cust_id INT,
    loan_amt DECIMAL(12,2),
    status VARCHAR(20),
    FOREIGN KEY (cust_id) REFERENCES Customers(cust_id)
);

//table14

CREATE TABLE LoanPayments (
    pay_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    pay_date DATE,
    amount DECIMAL(12,2),
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

//table15

CREATE TABLE AuditLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    txn_id INT,
    action VARCHAR(100),
    log_time DATETIME,
    FOREIGN KEY (txn_id) REFERENCES Transactions(txn_id)
);

SHOW TABLES

select * from Customers
select * from branches
select * from employees
select * from accounts
select * from transactiontypes


INSERT INTO Transactions
(acc_id, txn_type_id, amount, txn_date)
VALUES
(553, 2, 1000.00, '2025-07-10 10:00:00');

select * from transactions 
select * from cards
select * from devices
select * from loginhistory
select * from beneficiaries
select * from fraudalerts
select * from investigations
select * from loans

select * from loanpayments
select * from auditlogs


//Queries

//query1  Write a query to find all customers whose account balance is above ₹1,00,000.
select cust_id,balance from accounts where balance>100000

//query2 Retrieve all transactions performed in 2025.
select * from transactions where year(txn_date)=2025
accountsauditlogs
//query3 Find the total number of customers available in each city.
select count(cust_name),city from customers group by city

//query4 Display all employees working in each branch.
SELECT e.emp_id,
       e.emp_name,
       b.branch_name
FROM Employees e
INNER JOIN Branches b
ON e.branch_id = b.branch_id;

//query5  find the total number of accounts maintained by each branch.
select branch_id,count(*) as total_accounts from accounts group by branch_id;

//query6  retrieve customers who do not have any loan.
select * from customers where cust_id not in(select cust_id from loans);

//query7  find all transactions where the amount exceeds ₹40,0000.
select * from transactions where amount>40000;

//query8  display the top 10 highest transaction amounts.
select * from transactions order by amount desc limit 10;

//query9  find the total number of accounts available branch-wise.
select branch_id,count(*) as total_accounts from accounts group by branch_id;

//query10 retrieve all blocked cards.
select * from cards where status='blocked';

//query11 find the average account balance grouped by account type.
select acc_type,avg(balance) as average_balance from accounts group by acc_type;

//query12 display the total number of transactions performed by each account.
select acc_id,count(*) as total_transactions from transactions group by acc_id;

//query13 display all customers who have taken loans.
select c.cust_id,c.cust_name,l.loan_amt
from customers c
inner join loans l
on c.cust_id=l.cust_id;

//query14 display the latest 20 transactions.
select * from transactions order by txn_date desc limit 20;

//query15 find customers who have more than one beneficiary.
select cust_id,count(*) as total_beneficiaries from beneficiaries group by cust_id having count(*)>1;

//query16 find the total number of accounts in each branch.
select branch_id,count(*) as total_accounts from accounts group by branch_id;

//query17 display branches having more than 30 accounts.
select branch_id,count(*) as total_accounts from accounts group by branch_id having total_accounts>30

//query18 find the total balance maintained in each branch.
select branch_id ,sum(balance) as total_balance from accounts group by branch_id

//query20 display fraud types having more than 20 fraud alerts.
select fraud_type,count(*) as alerts from fraudalerts group by fraud_type having alerts>20

//query21 display customer details along with account details.
select c.cust_id,c.cust_name,a.acc_id,a.balance
from customers c
inner join accounts a on c.cust_id=a.cust_id

//query22 display customer transactions.
select c.cust_name,t.txn_id,t.amount,t.txn_date
from customers c
inner join accounts a on c.cust_id=a.cust_id
inner join transactions t on a.acc_id=t.acc_id

//query23 display fraud alerts with transaction details.
select f.fraud_id,f.fraud_type,t.amount,t.txn_date
from fraudalerts f
inner join transactions t on f.txn_id=t.txn_id

//query24 display investigation details with employee names.
select i.invest_id,e.emp_name,i.remarks
from investigations i
inner join employees e on i.emp_id=e.emp_id

//query25 display customer loan details.
select c.cust_name,l.loan_amt,l.status
from customers c
inner join loans l on c.cust_id=l.cust_id

//query26 display all customers even if they have not taken a loan.
select c.cust_id,c.cust_name,l.loan_amt
from customers c
left join loans l on c.cust_id=l.cust_id

//query27 display all branches along with their employees.
select b.branch_name,e.emp_name
from branches b
left join employees e on b.branch_id=e.branch_id

//query28 create a view to display high value transactions (above ₹40,000).
create view high_value_transaction as
select * from transactions where amount>40000;

//query29 create a view to display customer account details.
create view customer_accounts as
select c.cust_id,c.cust_name,a.acc_id,a.balance
from customers c
join accounts a on c.cust_id=a.cust_id;

select * from customer_accounts

//query30 display all records from the high value transactions view.
select * from high_value_transaction

//query31 display accounts having balance greater than the average balance.
select * from accounts having balance > (select avg(balance) from accounts)

//query32 display the customer having the highest account balance.
select c.cust_name,a.balance
from customers c
join accounts a on c.cust_id=a.cust_id
where balance=(select max(balance) from accounts)

//query33 display customers who have not taken any loan.
select * from customers where cust_id not in(select cust_id from loans)

//query34 display branches that have customer accounts.
select * from branches where branch_id in (select branch_id from accounts)

//query35 display customer names in uppercase.
select upper(cust_name) as Name from customers

//query36 display the square root of all account balances.
select acc_id,sqrt(balance) from accounts

//query37 display transactions performed in the current year.
select * from transactions where year(txn_date)=year(curdate())

//query38 classify account balance using if().
select acc_id,balance,
if(balance>=100000,'high balance','normal balance') as status from accounts

//query39 create a procedure to display transactions of an account.
call accounttransactions(135);

//query40 transaction control using commit.
start transaction;
update accounts set balance=balance+5000 where acc_id=1
commit;

//query41 transaction control using rollback.
start transaction;
update accounts set balance=balance-5000 where acc_id=1;
rollback;

//query42 assign rank transactions based on amount.
select txn_id,amount,rank() over(order by amount desc) as transaction_rank from transactions;

//query43 Assign dense rank to transactions based on transaction amount.
select txn_id,amount,dense_rank() over(order by amount desc) as dense_amt_rank from transactions;

//query44 Display the total transaction amount for each transaction type.
select txn_id,txn_type_id,amount,sum(amount) over(partition by txn_type_id) as total_amount from transactions;

//query45 Display the average transaction amount for each transaction type.
select txn_id,txn_type_id,amount,avg(amount) over(partition by txn_type_id) as average_amount from transactions;

//query46 Display the previous and next transaction amounts.
select txn_id,amount,
lag(amount) over(order by txn_date) as previous_amount,
lead(amount) over(order by txn_date) as next_amount
from transactions;

//query47 Automatically block a card when a fraud alert is created.
delimiter //

create trigger block_card_after_fraud
after insert on fraudalerts
for each row
begin
    update cards
    set status='blocked'
    where acc_id=
    (
        select acc_id
        from transactions
        where txn_id=new.txn_id
    );
end//

delimiter ;
insert into fraudalerts(txn_id,fraud_type,status)
values(10,'card fraud','pending');

select * from cards;


//query48 Create an index on the card_type column to improve the performance of searching cards by their type.
create index index_card_status on cards(status)

select * from cards where status='blocked';
