# 🍽️ Zomato Data Analysis Project

## 📌 Project Overview
This project analyzes a food delivery dataset to extract valuable customer insights using SQL.  
By answering key business questions, the project helps understand customer behavior, spending patterns, and loyalty program effectiveness.

---

## 💡 Key Questions Answered

- **Total Spending Per Customer** – How much has each customer spent on Zomato?  
- **Visit Frequency** – How many days has each customer placed orders on Zomato?  
- **First Purchased Item** – What was the first product purchased by each customer?  
- **Most Popular Item** – What is the most purchased item and how many times was it ordered?  
- **First Item After Membership** – Which item was purchased first after a customer became a Zomato Gold member?  
- **Last Item Before Membership** – Which item was purchased just before the customer became a member?  
- **Spending Before Membership** – Total orders and amount spent before joining Zomato Gold.  

### 🎯 Loyalty Points Calculation  

- Different products have different Zomato point conversion rates.  
- **Example:**  
  - P1 → (5₹ = 1 Point)  
  - P2 → (10₹ = 5 Points)  
  - P3 → (5₹ = 1 Point)  
- Calculate the points each customer has collected and for which products.  

### 🏅 Gold Membership Points System  

- In the first year of Zomato Gold membership, customers earn **5 points for every 10₹ spent**.  
- **Who earned more points: Customer 1 or Customer 3?**  
- **Total points earned in the first year.**  

### 🔢 Transaction Ranking  

- Rank all transactions of each customer.  
- **Gold Membership Transaction Ranking** – Rank all transactions for Zomato Gold members and mark non-Gold transactions as `"NA"`.  

---

## 🛠️ Tech Stack

- **SQL** – Querying and data analysis.  
- **GitHub** – Version control and project sharing.  

---

## 📊 Approach  

✔️ Designed **SQL queries** to solve each business question efficiently.  
✔️ Used **window functions, ranking functions, and joins** to extract meaningful insights.  
✔️ Applied **conditional logic** for loyalty point calculations.  
✔️ Ensured **data consistency and integrity**.  

---

## 🚀 How to Run the Project  

1. **Clone the repository:**  
   ```bash
   git clone https://github.com/yashvardhan0607/Zomato-Data-Analysis-Project
