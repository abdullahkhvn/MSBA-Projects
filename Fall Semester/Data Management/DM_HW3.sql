-- 1a.)
SELECT cardholder_first_name,cardholder_last_name,card_type,expiration_date
FROM customer_payment;

-- 1b.)
SELECT cardholder_first_name,cardholder_last_name,card_type,expiration_date
FROM customer_payment
ORDER BY expiration_date;

-- 2.)
SELECT cardholder_first_name || ' ' || cardholder_last_name AS customer_full_name
FROM customer_payment
WHERE cardholder_first_name IN (SELECT cardholder_first_name FROM customer_payment WHERE cardholder_first_name LIKE 'A%'
OR cardholder_first_name LIKE 'B%'
OR cardholder_first_name LIKE 'C%')
ORDER BY cardholder_last_name DESC;

-- 3.)
SELECT customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
FROM reservation
WHERE (status = 'U' AND
check_in_date >= SYSDATE AND
check_in_date <= '31-DEC-21');

-- 4a.)
SELECT customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
FROM reservation
WHERE (status = 'U' AND
check_in_date BETWEEN SYSDATE AND'31-DEC-21');

-- 4b.)
SELECT customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
FROM reservation
WHERE (status = 'U' AND
check_in_date >= SYSDATE AND
check_in_date <= '31-DEC-21')
MINUS
SELECT customer_id, confirmation_nbr, date_created, check_in_date, number_of_guests
FROM reservation
WHERE (status = 'U' AND
check_in_date BETWEEN SYSDATE AND'31-DEC-21');

-- 5.)
SELECT customer_id, location_id, (check_out_date - check_in_date) AS length_of_stay
FROM reservation
WHERE status = 'C'AND 
ROWNUM <= 10
ORDER BY length_of_stay DESC, customer_id;

-- 6.)
SELECT first_name, last_name, email, (stay_credits_earned - stay_credits_used) AS credits_available
FROM customer
WHERE (stay_credits_earned - stay_credits_used) >= 10
ORDER BY credits_available;

-- 7.)
SELECT cardholder_first_name,cardholder_mid_name,cardholder_last_name
FROM customer_payment
WHERE cardholder_mid_name IS NOT NULL
ORDER BY 2,3;

-- 8.)
SELECT SYSDATE AS today_unformatted, TO_CHAR(SYSDATE, 'MM/DD/YYYY') AS today_formatted, 25 AS credits_earned,25/10 AS stays_earned,
    FLOOR(25/10) AS redeemable_stays, ROUND(25/10) AS next_stay_to_earn
FROM DUAL;

-- 9.)
SELECT customer_id, location_id, (check_out_date - check_in_date) AS length_of_stay FROM reservation
WHERE status = 'C' AND location_id = 2
ORDER BY length_of_stay DESC, customer_id
FETCH FIRST 20 ROWS ONLY;

-- 10.)
SELECT c.first_name, c.last_name,r.confirmation_nbr, r.date_created, r.check_in_date, r.check_out_date
FROM reservation r JOIN customer c
ON r.customer_id = c.customer_id
WHERE r.status = 'C'
ORDER BY r.customer_id, r.check_out_date DESC;

-- 11.)
SELECT c.first_name || ' ' || c.last_name as customer_full_name, r.location_id, r.confirmation_nbr, r.check_in_date, ro.room_number
FROM customer c 
    FULL JOIN reservation r
        ON c.customer_id = r.customer_id
    FULL JOIN reservation_details rd
        ON r.reservation_id = rd.reservation_id
    FULL JOIN room ro
        ON rd.room_id = ro.room_id
WHERE r.status = 'U' AND c.stay_credits_earned > 40;

-- 12.) 
SELECT c.first_name, c.last_name, r.confirmation_nbr, r.check_in_date, r.check_out_date
FROM customer c LEFT JOIN reservation r
ON c.customer_id = r.customer_id
WHERE r.customer_id IS NULL;

-- 13.)
--    SELECT  '1-Gold-Member' AS status_level,c1.first_name,c1.last_name,c1.email,c1.stay_credits_earned
--    FROM customer c1 JOIN customer c2
--        ON c1.customer_id = c2.customer_id
--    WHERE c1.stay_credits_earned < 10
--UNION
--    SELECT  '2-Platinum-Member' AS status_level,c1.first_name,c1.last_name,c1.email,c1.stay_credits_earned
--    FROM customer c1 JOIN customer c2
--        ON c1.customer_id = c2.customer_id
--    WHERE c1.stay_credits_earned BETWEEN 10 AND 40
--UNION
--    SELECT  '3-Diamond-Club' AS status_level,c1.first_name,c1.last_name,c1.email,c1.stay_credits_earned
--    FROM customer c1 JOIN customer c2
--        ON c1.customer_id = c2.customer_id
--    WHERE c1.stay_credits_earned > 40
--ORDER BY 1,3;

    SELECT  '1-Gold-Member' AS status_level,first_name,last_name,email,stay_credits_earned
    FROM customer 
    WHERE stay_credits_earned < 10
UNION
    SELECT  '2-Platinum-Member' AS status_level,first_name,last_name,email,stay_credits_earned
    FROM customer 
    WHERE stay_credits_earned BETWEEN 10 AND 40
UNION
    SELECT  '3-Diamond-Club' AS status_level,first_name,last_name,email,stay_credits_earned
    FROM customer 
    WHERE stay_credits_earned > 40
ORDER BY 1,3;