-- 1,
WITH ranked_products AS (
    SELECT 
        p.category_id,
        p.product_name,
        SUM(s.sales_amount) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY SUM(s.sales_amount) DESC) AS product_rank
    FROM 
        sales s
    JOIN 
        products p ON s.product_id = p.product_id
    GROUP BY 
        p.category_id, p.product_id
)
SELECT 
    category_id, 
    product_name, 
    total_sales
FROM 
    ranked_products
WHERE 
    product_rank = 1
ORDER BY 
    category_id;

-- 2,
SELECT department_id, 
       AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary DESC
LIMIT 1;

-- 3,
SELECT e.employee_id,
       e.name,
       e.department_id,
       e.salary,
       d.avg_salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) d
ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;

-- 4,
SELECT o.region,
       o.customer_id,
       COUNT(*) AS order_count
FROM orders o
GROUP BY o.region, o.customer_id
HAVING COUNT(*) = (
    SELECT MAX(order_count)
    FROM (
        SELECT region, customer_id, COUNT(*) AS order_count
        FROM orders
        WHERE region = o.region
        GROUP BY region, customer_id
    ) sub
);

-- 5,
SELECT p.category_id,
       AVG(p.price) AS avg_category_price,
       t.overall_avg_price
FROM products p
CROSS JOIN (
    SELECT AVG(price) AS overall_avg_price
    FROM products
) t
GROUP BY p.category_id, t.overall_avg_price
HAVING AVG(p.price) > t.overall_avg_price;

-- 6,
SELECT p.product_id,
       p.product_name,
       p.category_id,
       p.price
FROM products p
LEFT JOIN orders o
  ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
