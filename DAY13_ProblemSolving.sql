***KEY CONCEPT
HIỂU VẤN ĐỀ -> CHIA NHỎ VẤN ĐỀ -> KẾ HOẠCH HÀNH ĐỘNG -> TRIỂN KHAI -> REVIEW
https://datalemur.com/questions/click-through-rate
--Number of clicks
With nClicks AS(SELECT app_id, 
    count(*) as no_of_clicks FROM events
    where EXTRACT(year from timestamp) ='2022'
    and event_type ='click'
    group by app_id),
--Number of impressions
nImpressions AS(SELECT app_id, 
    count(*) as no_of_impressions FROM events
    where EXTRACT(year from timestamp) ='2022'
    and event_type ='impression'
    group by app_id)
SELECT A.app_id, ROUND(100.0 * B.no_of_clicks / A.no_of_impressions, 2) ctr
from nImpressions A
LEFT JOIN nClicks B
on A.app_id=B.app_id

---ex1: https://datalemur.com/questions/duplicate-job-listings 
WITH job_count_cte AS(SELECT 
  company_id, 
  title, 
  description, 
  COUNT(job_id) AS job_count
FROM job_listings
group by company_id, title, description)
SELECT COUNT(DISTINCT company_id) as duplicate_companies
from job_count_cte 
where job_count >=2;

--ex2: https://datalemur.com/questions/sql-highest-grossing
WITH CategorySpend AS (
  SELECT category, product,
  SUM(spend) AS total_spend
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product)
SELECT t1.category, t1.product, t1.total_spend
FROM CategorySpend t1
WHERE t1.total_spend = (SELECT MAX(t2.total_spend)
    FROM CategorySpend t2
    WHERE t2.category = t1.category
  ) OR
  t1.total_spend = (SELECT MAX(t2.total_spend)
    FROM CategorySpend t2
    WHERE t2.category = t1.category 
    AND t2.total_spend < (SELECT MAX(t3.total_spend)
      FROM CategorySpend t3
      WHERE t3.category = t1.category)
  )
ORDER BY 
  t1.category,
  t1.total_spend DESC;

--ex3: https://datalemur.com/questions/frequent-callers
WITH records AS (
  SELECT policy_holder_id, COUNT(case_id) AS call_count
  FROM callers
  GROUP BY policy_holder_id
  HAVING COUNT(case_id) >= 3)

SELECT COUNT(policy_holder_id) AS member_count
FROM records;

--ex4: https://datalemur.com/questions/sql-page-with-no-likes
WITH PageLikesCount AS (
  SELECT t1.page_id, COUNT(t2.user_id) AS likes_count
  FROM pages t1
  LEFT JOIN page_likes t2 ON t1.page_id = t2.page_id
  GROUP BY t1.page_id)
SELECT t3.page_id
FROM PageLikesCount t3
WHERE t3.likes_count IS NULL OR t3.likes_count = 0
ORDER BY t3.page_id;

--ex5: datalemur-user-retention.
WITH MonthlyActivity AS (
  SELECT user_id, COUNT(DISTINCT event_type) AS activity_count
  FROM user_actions
  WHERE
    EXTRACT(MONTH FROM event_date) IN (6, 7)
    AND EXTRACT(YEAR FROM event_date) = 2022
  GROUP BY user_id
  HAVING COUNT(DISTINCT EXTRACT(MONTH FROM event_date)) = 2)
SELECT  7 AS month, COUNT(*) AS monthly_active_users
FROM MonthlyActivity;

--ex6: leetcode-monthly-transactions.
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

--ex7: https://leetcode.com/problems/product-sales-analysis-iii/description/?envType=study-plan-v2&envId=top-sql-50
SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) IN (
    SELECT product_id, MIN(year) 
    FROM Sales
    GROUP BY product_id);

--ex8: https://leetcode.com/problems/customers-who-bought-all-products/description/?envType=study-plan-v2&envId=top-sql-50
SELECT customer_id 
FROM Customer 
GROUP BY customer_id 
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)

--ex9: leetcode-employees-whose-manager-left-the-company.
SELECT employee_id
FROM Employees
WHERE salary < 30000
  AND manager_id IS NOT NULL
  AND manager_id NOT IN (SELECT employee_id FROM Employees);

--ex10: https://leetcode.com/problems/primary-department-for-each-employee/description/
SELECT employee_id,department_id 
from Employee
group by employee_id
having count(employee_id)=1 
UNION 
SELECT employee_id,department_id 
from Employee
where primary_flag='Y'

--ex11: https://leetcode.com/problems/movie-rating/description/?envType=study-plan-v2&envId=top-sql-50
(SELECT t2.name AS results
    FROM MovieRating t1, Users t2
    WHERE t1.user_id = t2.user_id
    GROUP BY t1.user_id
    ORDER BY COUNT(1) DESC, t2.name
    LIMIT 1)
UNION ALL 
(SELECT t3.title AS results
    FROM MovieRating t1, Movies t3
    WHERE t1.movie_id = t3.movie_id AND t1.created_at LIKE '2020-02%'
    GROUP BY t1.movie_id
    ORDER BY AVG(t1.rating) DESC, t3.title
    LIMIT 1)
  
ex12: https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/?envType=study-plan-v2&envId=top-sql-50
WITH friend_list AS (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted)
SELECT id, COUNT(*) AS num
FROM friend_list
GROUP BY id
ORDER BY num DESC
LIMIT 1;








