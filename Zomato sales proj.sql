drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

create proc see
as
begin
select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;
End

-- 1. what is the Total amount each customer spent on Zomato?


select S.userid, Sum(P.price) as Total_spent
from sales S
Join product P
on S.product_id = P.product_id
Group By S.userid

-- 2. How many days has each customer visited Zomato?

Select userid, count(userid) as total_days from sales group by userid

-- 3. What was the first product purchased by each customer?

With CTE
as(
Select userid, created_date, product_name,
rank() over (partition by userid order by created_date) as [RANK]
from sales S
join product P
On P.product_id = S.product_id) 
select * from CTE where RANK = 1

select * from sales order by created_date

-- 4. what is the most purchased item on the menu and how many times it was purchased by all customers?

Select top 1 product_id, count(product_id) as Count_of_purchase 
from sales 
group by product_id
order by Count_of_purchase desc


select userid, count(product_id) as [Total]
from sales where product_id = 
(Select top 1 product_id from sales
group by product_id
order by count(product_id) desc)
group by userid

-- 5. which item was purchased first by the customer after they became a member?
see

With CTE
as(
Select G.userid, product_id, S.created_date, rank () over (Partition by G.userid order by S.created_date) as [Rank]
from goldusers_signup G
Join sales S
On S.userid = G.userid
Where S.created_date > G.gold_signup_date
Group by G.userid, product_id, S.created_date
)

Select userid, product_id, created_date from CTE where [Rank] = 1 

-- 6. which item was purchased just before the customer became a member?

With CTE
As(
select S.userid, created_date, product_id, RANK() over (partition by S.userid order by created_date desc) as [Rank]
from sales S
join goldusers_signup G
on S.userid = G.userid
where S.created_date < G.gold_signup_date
Group By s.userid, S.created_date,S.product_id)
select * from CTE where [Rank] = 1

select *, RANK() over (partition by userid order by created_date desc) as [Rank] from sales 

-- 7.  what is the total order and amount spent for each member before they became a member?

select G.userid, count(S.userid) as [Total Orders], sum(price) as Amount_spent
from sales S
join product P
on P.product_id = S.product_id
join goldusers_signup G
on G.userid = S.userid
where S.created_date < G.gold_signup_date
Group by G.userid

-- 8. if buying each product generates points for EX: 5rs = 2 zomato point and each product has differnt purchasing points 
   for Ex: for p1 5rs = 1 zomato point , for p2 10 rs = 5 zomato points and p3 5rs = 1 zomato point. 
   Calculate points collected by each customer and for which product points have been given till now.

Select 
userid,
product_id,
AMT,
AMT/Ref_points as Zomato_points
from
(Select *,
	Case
		When B.product_id = 1 then 5 
		When B.product_id = 2 then 2
		When B.product_id = 3 then 5
		else 0
		end AS Ref_points 
From 
(SELECT 
    A.userid, 
    A.product_id, 
    SUM(A.price) AS AMT 
FROM 
    (SELECT S.userid, S.product_id, P.price
     FROM sales S
     JOIN product P
     ON S.product_id = P.product_id) AS A
GROUP BY A.userid, A.product_id) as B) as C
Order By Zomato_points Desc


-- 10. In the first one year after a customer joins the gold program(including their join date ) irrespective of what the customer has 
	purchased they earn 5 Zomato points for every 10rs spent. Who earned more 1 or 3 and what was their points earnings in the first year?

Select *, price*.5 as Zomatopoints 
from
(Select S.userid, P.price, created_date 
from Product P
Join Sales S
On P.product_id = S.product_id
Join goldusers_signup G
on S.userid = G.userid
Where S.created_date >= G.gold_signup_date and S.created_date <= DATEADD(YEAR, 1, G.gold_signup_date)
Group by S.userid, P.price, S.created_date) as A 


-- 11. Rank all the transactions of the customer.

Select *, rank() over (Partition by userid order by created_date) as [Rank]
from Sales 

-- 12. Rank all transactions for each member whenever they are a Zomato gold member for any non gold member transaction mark NA.

SELECT *,
    CASE 
        WHEN gold_signup_date IS NULL THEN 'NA'
        ELSE CAST(RANK() OVER (PARTITION BY userid ORDER BY created_date desc) AS NVARCHAR(50))
    END AS Ranking
FROM (
    SELECT S.userid, S.product_id, S.created_date, G.gold_signup_date
    FROM Sales S
    LEFT JOIN goldusers_signup G 
    ON S.userid = G.userid AND S.created_date >= G.gold_signup_date
) AS A;
