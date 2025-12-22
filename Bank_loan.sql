use bank_data;

create table loans (
    loan_id int not null,
    customer_id int not null,
    loan_amount decimal(10,2) not null,
    monthly_intrest decimal(10,2) not null,
    start_date date not null,
    status varchar(20) default 'active',
    primary key (loan_id)
);

describe loans;

select * from loans;

insert into loans
(loan_id, customer_id, loan_amount, monthly_intrest, start_date, status)
values
(103, 3, 450000, '980', '2024-03-01', 'active');

describe loans;

create table payments (
    payment_id int primary key,
    loan_id  int not null,
    due_date date not null,
    paid_date date,
    amount_paid decimal(10,2),
    status varchar(20)
    );
    
    describe payments;
    
insert into payments
(payment_id, loan_id, due_date, paid_date, amount_paid, status)
values
(1, 101, '2024-01-01', '2024-01-28', 1090, 'paid'),
(2, 101, '2024-02-01', null,null, 'unpaid'),
(3, 101, '2024-03-01', null,null, 'unpaid'),
(4, 102, '2024-01-01', '2024-01-25', 850, 'paid');

select * from payments;

# SHOW ALL UNPAID EMI'S
select * from payments
where status = 'unpaid';

# COUNT UNPAID MONTHS FOR LOAN
select loan_id, count(*) as unpaid_months
from payments
where status = 'unpaid'
group by loan_id;

# LOANS WITH MORE THAN 1 UNPAID MONTH
select loan_id, count(*)as unpaid_manths
from payments
where status = 'unpaid'
group by loan_id
having count(*) > 1 ;

# UNDERSTAND THE CONNECTION IS VERY IMPORTANT
#loan_id -> IDENTIFIES THE LOAN
# customer_id
#loan_amount
# monthly_intrest

# PAYMENTS TABLE
# LOAN_ID -> SAME LOAN_ID(THIS IS THE LINK)
# DUE_DATE
#PAID_DATE
#AMOUNT_PAID
#STATUS

# SIMPLE JOIN (SEE BOTH TABLES TOGETHER)
select
    l.loan_id,
    l.customer_id,
    l.loan_amount,
    p.due_date,
    p.paid_date,
    p.amount_paid,
    p.status
from loans l 
join payments p 
on l. loan_id = p.loan_id;

select loan_id from loans;

select distinct loan_id from payments;

# TEST WITH LEFT JOIN (VERY IMPORTANT TEST)
select
    l.loan_id,
    p.loan_id as payment_loan_id
from loans l
left join payments p
on l.loan_id = p.loan_id;



use bank_data;

create table customers (
	customer_id int primary key,
    customer_name varchar(100) not null,
    phonne varchar(15),
    city varchar(50)
    );
    
    insert into customers
    (customer_id, customer_name, phonne, city)
    values
    ('1', 'Ravi', '9866775543', 'vijaywada'),
    ('2', 'subbayya', '8376768789', 'srikakula'),
    ('3', 'Rattayya', '9098765676', 'vizag'),
    ('4', 'kumar', '9857432334', 'Rajamundry');
    
    alter table customers 
    rename column phonne to phone;
    
    select * from customers;
    
    # JOIN THREE TABLES PAYMENTS & LOANS & CUSTOMERS
    select 
         c.customer_name,
         l.loan_id,
         p.due_date,
         p.status
	from customErs c
    join loans l 
    on c.customer_id = l.customer_id 
    join payments p 
    on l.loan_id = p.loan_id 
    where p.status ='unpaid'; 
    
#  CHECK LOANS TABLE ? LET'S DEBUG STEP -BY-STEP 
select loan_id, customer_id
from loans;

# CHECK PAYMENTS UNPAID ROWS 
select loan_id, due_date, status
from payments 
where status = 'unpaid'; 


# 	VERY USEFUL TEST LEFT JOIN 

select
	c.customer_name,
    l.loan_id,
    p.status 
from customers c  
left join loans l 
on c. customer_id = l.customer_id
left join payments p 
on l.loan_id = p.loan_id; 

# INSERT MATCHING PAYMENTS FOR LOAN_ID =103 ;
insert into payments
(payment_id, loan_id, due_date, paid_date, amount_paid, status)
values
(5, 103, '2024-04-01', null, null, 'unpaid'),
(6, 103, '2024-05-01', null, null, 'unpaid');
    
# JOIN LOAN & JOIN PAYMENTS & UNPAID STATUS
select 
	c.customer_name,
    l.loan_id,
    p.due_date,
    p.status
from customers c 
join loans l on c.customer_id = l.customer_id
join payments p on l.loan_id = p.loan_id
where p.status = 'unpaid'; 

#  COUNT UNPAID MONTHS PER CUSTOMER
select 
    c.customer_name,
    count(*) as unpaid_months
from customers c 
join loans l on c.customer_id = l.customer_id
join payments p on l.loan_id = p.loan_id
where p.status = 'unpaid'
group by c.customer_name;

#  TOTAL UNPAID AMOUNT (WHEN AMOUNT IS ADDED)
select 
    c.customer_name,
    sum(p.amount_paid) as total_due
from customers c 
join loans l on c.customer_id = l.customer_id
join payments p on l. loan_id = p.loan_id = p.loan_id
where p.status = 'unpaid'
group by c.customer_name;

# important SQL RULE 
# SUM OF NULL VALUES = NULL 
# USE ******"COALESCE"************
select 
    c.customer_name,
    sum(coalesce(P.amount_paid, 0)) as total_due
from customers c
join loans l on c.customer_id = l.customer_id
join payments p on l.loan_id = p.loan_id
where p.status = 'unpaid'
group by c.customer_name;

# CALCULATE DUE USING MONTHLY INTREST (REALISTIC)
select
    c.customer_name,
    count(*) * l.monthly_intrest as total_due 
from customers c 
join loans l on c. customer_id = l.customer_id
join payments p on l.loan_id = p.loan_id 
where p.status = 'unpaid' 
group by c.customer_name, l.monthly_intrest;