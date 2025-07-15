\echo create hash partitioned table example
\echo hash partition with odd/even/zero partitions
\prompt "This will create table ORDERS partitioned by CUSTOMER_ID " promptenter
truncate table public.orders;
drop table public.orders cascade;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC
) PARTITION BY HASH (order_id);

CREATE TABLE orders_1 PARTITION OF orders
FOR VALUES WITH (MODULUS 3, REMAINDER 0);

CREATE TABLE orders_2 PARTITION OF orders
FOR VALUES WITH (MODULUS 3, REMAINDER 1);

CREATE TABLE orders_3 PARTITION OF orders
FOR VALUES WITH (MODULUS 3, REMAINDER 2);

INSERT INTO orders (order_date, customer_id, total_amount) VALUES
('2023-01-15', 101, 500.00),
('2023-02-20', 102, 600.00),
('2023-03-10', 103, 700.00),
('2023-04-05', 104, 450.00),
('2023-05-12', 105, 900.00);

SELECT count(*), tableoid::regclass FROM orders GROUP BY 2;

