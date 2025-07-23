--  tạo bảng tính sô ngày từ ngày giao dịch gần nhất đến 2010-11-06 
WITH recent_trans AS (
    SELECT u.user_id, 
    MAX(t.date) as last_transaction_date, 
    DATEDIFF(DATE('2010-11-06'), 
    MAX(t.date)) AS recent_days
	FROM users u 
	LEFT JOIN transactions t
	ON u.user_id=t.client_id
	GROUP BY u.user_id
)
-- bảng tính sô tiền giao dịch
, monetary_trans AS (
    SELECT u.user_id, 
    Round(sum(abs(amount)),2) AS total_money
	FROM users u 
	LEFT JOIN transactions t
	ON u.user_id=t.client_id
	GROUP BY u.user_id)
-- bảng số lần thực hiện giao dịch
 , freq_trans as(
	SELECT u.user_id, count(t.transaction_id) as frequency 
    FROM users u 
    LEFT JOIN transactions t
    ON u.user_id = t.client_id 
    GROUP BY u.user_id)
, data_rfm as(
	SELECT rt.user_id, rt.recent_days, mt.total_money, ft.frequency
	FROM recent_trans rt
    JOIN monetary_trans mt ON rt.user_id= mt.user_id
    JOIN freq_trans ft ON rt.user_id = ft.user_id )
, monetary_ranked AS (
    SELECT 
        user_id, 
        total_money,
        NTILE(3) OVER (ORDER BY total_money) AS tertile
    FROM monetary_trans
    WHERE total_money IS NOT NULL
),
m_score_trans AS (
    SELECT mt.user_id,
           CASE 
               WHEN mt.total_money = 0 or mt.total_money is null THEN 1
               WHEN mr.tertile = 1 THEN 4 
               WHEN mr.tertile = 2 THEN 3
               WHEN mr.tertile = 3 THEN 2 
           END AS m_score
    FROM monetary_trans mt
    LEFT JOIN monetary_ranked mr ON mt.user_id = mr.user_id
)
,score_rf AS (
SELECT dt.user_id,
CASE 
	WHEN recent_days < 1 THEN 4
    WHEN recent_days < 10 THEN 3
    WHEN recent_days < 50 THEN 2
    ELSE '1'
    END AS r_score,
CASE 
	WHEN frequency = 0 THEN 1
	WHEN frequency >2000 THEN 4
	WHEN frequency > 900 THEN 3
	ELSE '2'
	END AS f_score,
    m_score
FROM data_rfm as dt
join m_score_trans as m
on dt.user_id=m.user_id)

, score AS (
	SELECT user_id,
        r_score,
        f_score,
        m_score,  
		CONCAT(r_score, f_score, m_score) AS rfm_score
	FROM score_rf  

)
SELECT  * , CASE 
    WHEN rfm_score IN ('444','443','434','344','433','424') THEN 'VIP' 
    WHEN rfm_score IN ('432', '423', '442', '441') THEN 'Loyal Customers'  
    WHEN rfm_score IN('414', '324', '334', '234', '414', '244') THEN 'High Spender'
     WHEN rfm_score IN ('212', '213','221', '211', '231') THEN 'At Risk'
    WHEN rfm_score LIKE '1%' OR rfm_score is null  THEN 'Lost Customers' 
    ELSE 'Regular Customers'
END AS segment
FROM score;
