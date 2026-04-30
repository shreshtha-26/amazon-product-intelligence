 -- adavnced analysis by solving business insight queries


  -- Q1. Which products show highest estimated revenue opportunity?
  SELECT
    pd.product_name,
    pd.category,
    rf.revenue_score
FROM reviews_fact rf
JOIN products_dim pd
    ON rf.product_id = pd.product_id
ORDER BY rf.revenue_score DESC
LIMIT 10;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q2. Which category satifies the customers the most?
SELECT
    pd.category,
    ROUND(AVG(rf.rating), 2) AS avg_rating
FROM products_dim pd
JOIN reviews_fact rf
    ON pd.product_id = rf.product_id
GROUP BY pd.category
ORDER BY avg_rating DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q3. Do discounted products have better ratings?
 SELECT
    pf.discount_bucket,
    ROUND(AVG(rf.rating), 2) AS avg_rating,
    COUNT(*) AS total_products
FROM pricing_fact pf
JOIN reviews_fact rf
    ON pf.product_id = rf.product_id
GROUP BY pf.discount_bucket
ORDER BY avg_rating DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q4. What are the highest rated products per category?
 WITH ranked_products AS (
    SELECT
        pd.category,
        pd.product_name,
        rf.rating,
        ROW_NUMBER() OVER (
            PARTITION BY pd.category
            ORDER BY rf.rating DESC, rf.rating_count DESC
        ) AS rank_in_category
    FROM products_dim pd
    JOIN reviews_fact rf
        ON pd.product_id = rf.product_id
)
SELECT *
FROM ranked_products
WHERE rank_in_category <= 3;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q5. Products with high ratings but low prices?
 SELECT
    pd.product_name,
    pf.discounted_price,
    rf.rating,
    rf.revenue_score
FROM products_dim pd
JOIN pricing_fact pf
    ON pd.product_id = pf.product_id
JOIN reviews_fact rf
    ON pd.product_id = rf.product_id
WHERE rf.rating >= 4.3
  AND pf.discounted_price < (
      SELECT AVG(discounted_price)
      FROM pricing_fact
  )
ORDER BY rf.rating DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q6. Premium products with weak reviews.
 SELECT
    pd.product_name,
    pf.discounted_price,
    rf.rating
FROM products_dim pd
JOIN pricing_fact pf
    ON pd.product_id = pf.product_id
JOIN reviews_fact rf
    ON pd.product_id = rf.product_id
WHERE pf.discounted_price > (
    SELECT AVG(discounted_price)
    FROM pricing_fact
)
AND rf.rating < 4.0
ORDER BY pf.discounted_price DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q7. Category revenue contribution
 SELECT
    pd.category,
    ROUND(SUM(rf.revenue_score), 2) AS total_revenue_score
FROM products_dim pd
JOIN reviews_fact rf
    ON pd.product_id = rf.product_id
GROUP BY pd.category
ORDER BY total_revenue_score DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q8. Which discount buckets produce strongest revenue response?
 SELECT
    pf.discount_bucket,
    ROUND(AVG(rf.revenue_score), 2) AS avg_revenue_score
FROM pricing_fact pf
JOIN reviews_fact rf
    ON pf.product_id = rf.product_id
GROUP BY pf.discount_bucket
ORDER BY avg_revenue_score DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q9. Top 20% Products by Revenue Score
 WITH revenue_ranked AS (
    SELECT
        pd.product_name,
        rf.revenue_score,
        NTILE(5) OVER (ORDER BY rf.revenue_score DESC) AS quintile
    FROM products_dim pd
    JOIN reviews_fact rf
        ON pd.product_id = rf.product_id
)
SELECT *
FROM revenue_ranked
WHERE quintile = 1;

-------------------------------------------------------------------------------------------------------------------------------------------------

 -- Q10. Category pricing benchmark
 SELECT
    pd.category,
    ROUND(AVG(pf.discounted_price), 2) AS avg_price,
    ROUND(MIN(pf.discounted_price), 2) AS min_price,
    ROUND(MAX(pf.discounted_price), 2) AS max_price
FROM products_dim pd
JOIN pricing_fact pf
    ON pd.product_id = pf.product_id
GROUP BY pd.category;
----------------------------------------------------------------------------------------------------------------------------------------------------


