/*
Looking at tables
*/
SELECT * FROM survey limit 10;
/*
Incompletes
*/
SELECT question,COUNT(response) from survey GROUP BY question;

/*
Joining Tables
*/

with FUNNELS as (SELECT quiz.user_id,
CASE
	WHEN home_try_on.user_id IS NOT NULL
  THEN 'True'
  ELSE "False"
 END AS 'is_home_try_on',
home_try_on.number_of_pairs,
CASE
	WHEN purchase.user_id IS NOT NULL
  THEN 'True'
  ELSE 'False'
 END AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
ON home_try_on.user_id = quiz.user_id
LEFT JOIN purchase
ON purchase.user_id = quiz.user_id
)
SELECT user_ID,is_home_try_on,number_of_pairs,is_purchase FROM funnels LIMIT 10;

/*
Useful Data
*/

with FUNNELS as (SELECT quiz.user_id,
CASE
	WHEN home_try_on.user_id IS NOT NULL
  THEN 'True'
 ELSE "False"
 END AS 'is_home_try_on',
home_try_on.number_of_pairs,
CASE
	WHEN purchase.user_id IS NOT NULL
  THEN 'True'
 ELSE "False"
 END AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
ON home_try_on.user_id = quiz.user_id
LEFT JOIN purchase
ON purchase.user_id = quiz.user_id
),
conv_tally as (
SELECT
user_id,
CASE WHEN
 is_home_try_on = 'True'
THEN 1
ELSE 0
END as 'home_try_count',
CASE WHEN
	is_purchase = 'True'
THEN 1
ELSE 0
end as 'purhcase_count'
FROM FUNNELS
),

conv_agg as (
SELECT user_id,
sum(home_try_count) as 'home_try_total',
sum(purhcase_count) as 'purhcase_total'
  FROM conv_tally
)

SELECT 
0.001 * home_try_total / count(user_id) as 'Home_try_percentage',
0.001 * purhcase_total / count(user_id) as 'purchase_percentage'
from conv_agg;

/*
AB TEST
*/

WITH FUNNELS as (SELECT quiz.user_id,
CASE
	WHEN home_try_on.user_id IS NOT NULL
  THEN 'True'
 ELSE "False"
 END AS 'is_home_try_on',
home_try_on.number_of_pairs,
CASE
	WHEN purchase.user_id IS NOT NULL
  THEN 'True'
 ELSE "False"
 END AS 'is_purchase'
FROM quiz
LEFT JOIN home_try_on
ON home_try_on.user_id = quiz.user_id
LEFT JOIN purchase
ON purchase.user_id = quiz.user_id
),
pair_count as (SELECT 
CASE
WHEN
	number_of_pairs = '3 pairs' and is_purchase = 'True'
  THEN 1
  Else 0
 END as 'q3_pairs',
CASE
 WHEN
	number_of_pairs = '5 pairs' and is_purchase = 'True'
  THEN 1
  Else 0
 END as 'q5_pairs'
FROM FUNNELS
)           

SELECT sum(q3_pairs) as 'purches_with_3_pairs',sum(q5_pairs) as 'purches_with_5_pairs' FROM pair_count;

/*
Summing Preferences
*/
SELECT style,COUNT(style) FROM quiz GROUP BY style;

SELECT fit,COUNT(fit) FROM quiz GROUP BY fit;

SELECT shape,COUNT(shape) FROM quiz GROUP BY shape;

SELECT color,COUNT(color) FROM quiz GROUP BY color;


