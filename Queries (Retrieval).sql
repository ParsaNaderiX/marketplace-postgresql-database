-- Retrieval Queries (Selects)

-- 1. The top 3 products with the highest number of ratings or reviews
SELECT 
    p.id,
    p.title,
    COUNT(pr.id) AS review_count
FROM 
    Products p
JOIN 
    ProductReviews pr ON p.id = pr.product_id
GROUP BY 
    p.id, p.title
ORDER BY 
    review_count DESC
LIMIT 3;

-- 2. All orders registered in the last 7 days (up to now)
SELECT *
FROM Orders
WHERE 
    registration_time >= NOW() - INTERVAL '7 days';

-- 3. The most frequently used shipping methods in orders
SELECT 
    shipping_method,
    COUNT(*) AS usage_count
FROM 
    Orders
GROUP BY 
    shipping_method
ORDER BY 
    usage_count DESC;

-- 4. The shop with the highest total sales amount
SELECT 
    s.id AS shop_id,
    s.shop_identifier,
    SUM(op.quantity * p.price) AS total_sales
FROM 
    Shops s
JOIN 
    ShopProducts sp ON s.id = sp.shop_id
JOIN 
    Products p ON sp.product_id = p.id
JOIN 
    OrderProducts op ON p.id = op.product_id
GROUP BY 
    s.id, s.shop_identifier
ORDER BY 
    total_sales DESC
LIMIT 1;

-- 5. Users who have chatted with the highest number of distinct people (regardless of message direction)
SELECT 
    u.username,
    COUNT(DISTINCT other_user) AS unique_chat_partners
FROM (
    SELECT 
        sender_username AS username,
        receiver_username AS other_user
    FROM Messages
    UNION
    SELECT 
        receiver_username AS username,
        sender_username AS other_user
    FROM Messages
) AS all_chats
JOIN Users u ON u.username = all_chats.username
GROUP BY 
    u.username
ORDER BY 
    unique_chat_partners DESC;

-- 6. Number of products offered by each seller/shop owner
SELECT 
    u.username AS seller_username,
    COUNT(DISTINCT sp.product_id) AS product_count
FROM 
    Users u
JOIN 
    Shops s ON u.username = s.owner_username
JOIN 
    ShopProducts sp ON s.id = sp.shop_id
GROUP BY 
    u.username
ORDER BY 
    product_count DESC;

-- 7. Top 5 best-selling products based on total quantity sold across orders
SELECT 
    p.id,
    p.title,
    SUM(op.quantity) AS total_units_sold
FROM 
    Products p
JOIN 
    OrderProducts op ON p.id = op.product_id
GROUP BY 
    p.id, p.title
ORDER BY 
    total_units_sold DESC
LIMIT 5;

-- 8. The average amount paid per user across their orders
SELECT 
    user_username,
    AVG(total_price) AS avg_payment
FROM 
    Orders
GROUP BY 
    user_username;

-- 9. Users who have submitted reviews for more than 5 products
SELECT 
    user_username,
    COUNT(product_id) AS reviewed_products
FROM 
    ProductReviews
GROUP BY 
    user_username
HAVING 
    COUNT(product_id) > 5;

-- 10. Products with poor feedback (average rating below 3)
SELECT 
    p.id,
    p.title,
    AVG(pr.rating) AS avg_rating
FROM 
    Products p
JOIN 
    ProductReviews pr ON p.id = pr.product_id
GROUP BY 
    p.id, p.title
HAVING 
    AVG(pr.rating) < 3;

-- 11. Total inventory (stock quantity) of all products in each shop
SELECT 
    s.id AS shop_id,
    s.shop_identifier,
    SUM(p.stock_quantity) AS total_stock
FROM 
    Shops s
JOIN 
    ShopProducts sp ON s.id = sp.shop_id
JOIN 
    Products p ON sp.product_id = p.id
GROUP BY 
    s.id, s.shop_identifier;

-- 12. Complete message history between the first two users
WITH first_two_users AS (
    SELECT username
    FROM Users
    LIMIT 2
),
user_pair AS (
    SELECT 
        MIN(username) AS user1,
        MAX(username) AS user2
    FROM first_two_users
)
SELECT *
FROM Messages
WHERE 
    (sender_username, receiver_username) IN (SELECT user1, user2 FROM user_pair)
    OR
    (sender_username, receiver_username) IN (SELECT user2, user1 FROM user_pair)
ORDER BY sent_at;
	
-- 13. Categories associated with each shop
SELECT 
    s.id AS shop_id,
    s.shop_identifier,
    STRING_AGG(c.title, ', ') AS categories
FROM 
    Shops s
JOIN 
    ShopCategories sc ON s.id = sc.shop_id
JOIN 
    Categories c ON sc.category_id = c.id
GROUP BY 
    s.id, s.shop_identifier
ORDER BY 
    s.id;

-- 14. The most expensive product in each shop
SELECT 
    s.id AS shop_id,
    s.shop_identifier,
    p.id AS product_id,
    p.title,
    p.price
FROM 
    Shops s
JOIN 
    ShopProducts sp ON s.id = sp.shop_id
JOIN 
    Products p ON sp.product_id = p.id
WHERE 
    (s.id, p.price) IN (
        SELECT 
            sp.shop_id,
            MAX(p2.price)
        FROM 
            ShopProducts sp
        JOIN 
            Products p2 ON sp.product_id = p2.id
        GROUP BY 
            sp.shop_id
    );

-- 15. Rank users based on their total purchase amount
SELECT 
    u.username,
    COALESCE(SUM(o.total_price), 0) AS total_spent
FROM 
    Users u
LEFT JOIN 
    Orders o ON u.username = o.user_username
GROUP BY 
    u.username
ORDER BY 
    total_spent DESC;

-- 16. Purchase history for each user (including order details)
SELECT 
    o.user_username,
    o.id AS order_id,
    o.registration_time,
    p.title AS product_title,
    op.quantity,
    (op.quantity * p.price) AS total_price
FROM 
    Orders o
JOIN 
    OrderProducts op ON o.id = op.order_id
JOIN 
    Products p ON op.product_id = p.id
ORDER BY 
    o.user_username, o.registration_time;

-- 17. Cumulative sales report per shop over time (monthly)
SELECT 
    s.id AS shop_id,
    s.shop_identifier,
    DATE_TRUNC('month', o.registration_time) AS month,
    SUM(op.quantity * p.price) AS monthly_sales
FROM 
    Shops s
JOIN 
    ShopProducts sp ON s.id = sp.shop_id
JOIN 
    Products p ON sp.product_id = p.id
JOIN 
    OrderProducts op ON p.id = op.product_id
JOIN 
    Orders o ON op.order_id = o.id
GROUP BY 
    s.id, s.shop_identifier, DATE_TRUNC('month', o.registration_time)
ORDER BY 
    s.id, month;

-- -----------------------------------------------------