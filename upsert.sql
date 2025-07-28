select * from payment;


INSERT INTO RAW.STRIPE.PAYMENT (
    id,
    orderid,
    paymentmethod,
    status,
    amount,
    created
)
VALUES
    (121, 100, 'credit_card', 'success', 120.00, '2025-07-24 12:00:00'),
    (122, 101, 'gift_card', 'success', 85.50, '2025-07-24 12:10:00'),
    (123, 102, 'bank_transfer', 'fail', 65.75, '2025-07-24 12:20:00');


INSERT INTO raw.jaffle_shop.orders (
    id,
    user_id,
    order_date,
    status
)
VALUES
    (100, 101, '2025-07-24', 'completed'),
    (101, 102, '2025-07-24', 'completed'),
    (102, 103, '2025-07-24', 'completed');



INSERT INTO raw.jaffle_shop.customers (
    id,
    first_name,
    last_name
)
VALUES
    (101, 'Salma', 'Judah'),
    (102, 'Salma', 'Judah'),
    (103, 'Salma', 'Judah');