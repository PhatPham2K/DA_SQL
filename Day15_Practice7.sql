EX8: https://datalemur.com/questions/top-fans-rank
WITH Top10Artists AS (
  SELECT artists.artist_name,
  DENSE_RANK() OVER (ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  INNER JOIN songs
  ON artists.artist_id = songs.artist_id
  INNER JOIN global_song_rank AS ranking
  ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY artists.artist_name)
SELECT artist_name, artist_rank
FROM Top10Artists
WHERE artist_rank <= 5;


EX7: https://datalemur.com/questions/sql-highest-grossing
WITH RankedProducts AS (
    SELECT category, product,
    SUM(spend) AS total_spend,
    RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS product_rank
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY category, product)
SELECT category,product, total_spend
FROM RankedProducts
WHERE product_rank <= 2;


EX5: https://datalemur.com/questions/repeated-payments
WITH RollingAvg AS (
    SELECT user_id, tweet_date, tweet_count,
    AVG(tweet_count) OVER (PARTITION BY user_id 
    ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg_3d
    FROM tweets )
SELECT user_id, tweet_date, ROUND(rolling_avg_3d, 2) AS rolling_avg_3d
FROM RollingAvg;

EX4: https://datalemur.com/questions/histogram-users-purchases
WITH LatestTransactionsCTE AS (
  SELECT transaction_date, user_id, product_id, 
    RANK() OVER ( PARTITION BY user_id 
    ORDER BY transaction_date DESC) AS transaction_rank 
    FROM user_transactions) 
SELECT  transaction_date, user_id,
  COUNT(product_id) AS purchase_count
FROM LatestTransactionsCTE
WHERE transaction_rank = 1 
GROUP BY transaction_date, user_id
ORDER BY transaction_date;

EX3: https://datalemur.com/questions/sql-third-transaction
WITH UserTransactionRank AS (
    SELECT user_id, spend, transaction_date,
    ROW_NUMBER() 
    OVER (PARTITION BY user_id ORDER BY transaction_date) AS transaction_rank
    FROM transactions)
SELECT  user_id, spend, transaction_date
FROM UserTransactionRank
WHERE transaction_rank = 3;

EX2: https://datalemur.com/questions/card-launch-success
WITH LaunchMonths AS (
  SELECT card_name,
  MIN(issue_year * 12 + issue_month) AS launch_month
  FROM  monthly_cards_issued
  GROUP BY card_name)
SELECT mci.card_name, mci.issued_amount
FROM monthly_cards_issued mci
JOIN LaunchMonths lm ON mci.card_name = lm.card_name
AND (mci.issue_year * 12 + mci.issue_month) = lm.launch_month
ORDER BY mci.issued_amount DESC;

EX1: https://datalemur.com/questions/yoy-growth-rate
WITH YearlySpend AS (
  SELECT EXTRACT(YEAR FROM transaction_date) AS transaction_year,
  product_id, SUM(spend) AS total_spend
  FROM user_transactions
  GROUP BY EXTRACT(YEAR FROM transaction_date), product_id)
SELECT y1.transaction_year AS year,
    y1.product_id, y1.total_spend AS curr_year_spend,
    LAG(y1.total_spend) 
    OVER (PARTITION BY y1.product_id ORDER BY y1.transaction_year) AS prev_year_spend,
    ROUND((y1.total_spend - LAG(y1.total_spend) 
    OVER (PARTITION BY y1.product_id ORDER BY y1.transaction_year)) / LAG(y1.total_spend) 
    OVER (PARTITION BY y1.product_id ORDER BY y1.transaction_year) * 100, 2) AS yoy_rate
FROM YearlySpend y1
ORDER BY y1.product_id, y1.transaction_year;

EX6: https://datalemur.com/questions/repeated-payments
WITH RepeatedPayments AS (
    SELECT transaction_id, merchant_id, credit_card_id, amount,
    transaction_timestamp,
    LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount 
    ORDER BY transaction_timestamp) AS prev_timestamp
    FROM transactions)
SELECT COUNT(*) AS payment_count
FROM RepeatedPayments
WHERE transaction_timestamp - prev_timestamp <= INTERVAL '10 minutes' 
AND prev_timestamp IS NOT NULL;
