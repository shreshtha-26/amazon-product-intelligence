 -- Creating the amazon_product_intelligence database

CREATE DATABASE amazon_product_intelligence;
USE amazon_product_intelligence;

select * from amazon_products;

/*designing target schema*/

CREATE TABLE products_dim (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name TEXT,
    category VARCHAR(255)
);

-------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE pricing_fact (
    pricing_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50),
    actual_price DECIMAL(10,2),
    discounted_price DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
    price_gap DECIMAL(10,2),
    discount_bucket VARCHAR(50),
    
    FOREIGN KEY (product_id)
        REFERENCES products_dim(product_id)

-------------------------------------------------------------------------------------------------------------------------------------------------
 
CREATE TABLE reviews_fact (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50),
    rating DECIMAL(3,2),
    rating_count INT,
    rating_segment VARCHAR(50),
    revenue_score DOUBLE,

    FOREIGN KEY (product_id)
        REFERENCES products_dim(product_id)
);

