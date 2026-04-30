-- Populate dimension and fact tables from staging/raw table.
-- The raw table serves as the source-of-truth import layer,

INSERT INTO products_dim (product_id, product_name, category)
SELECT DISTINCT
    product_id,
    product_name,
    category
FROM amazon_products;

-------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO pricing_fact (
    product_id,
    actual_price,
    discounted_price,
    discount_percentage,
    price_gap,
    discount_bucket
)
SELECT
    product_id,
    ROUND(actual_price, 2),
    ROUND(discounted_price, 2),
    ROUND(discount_percentage, 2),
    ROUND(price_gap, 2),
    discount_bucket
FROM amazon_products;

-------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO reviews_fact (
    product_id,
    rating,
    rating_count,
    rating_segment,
    revenue_score
)
SELECT
    product_id,
    rating,
    rating_count,
    rating_segment,
    revenue_score
FROM amazon_products;

 -- validation queries
 
 SELECT COUNT(*) FROM products_dim;
 
 SELECT COUNT(*) FROM pricing_fact;
