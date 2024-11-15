USE sakila; 



/*
## Challenge
**Creating a Customer Summary Report**
In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.
- Step 1: Create a View
*/

CREATE OR REPLACE VIEW rental_information AS
SELECT sakila.rental.customer_id, CONCAT(sakila.customer.last_name, ", ", sakila.customer.first_name) AS Customer, sakila.customer.email, COUNT(sakila.rental.rental_date) AS rental_count
FROM sakila.rental
JOIN sakila.customer
	ON sakila.rental.customer_id = sakila.customer.customer_id
GROUP BY sakila.rental.customer_id
;

SELECT *
FROM rental_information;


/*
step2
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
*/


CREATE TEMPORARY TABLE payments_customer 
	SELECT sakila.payment.customer_id, SUM(sakila.payment.amount) AS total_paid
    FROM sakila.payment
    GROUP BY sakila.payment.customer_id
     ;

SELECT *
FROM payments_customer;

/*

- Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid. 
Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count,
total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
*/

SELECT r.Customer, pc.total_paid, r.email, r.rental_count
FROM payments_customer AS pc
JOIN rental_information AS r
	ON pc.customer_id = r.customer_id;
    


SELECT r.Customer, pc.total_paid, r.email, r.rental_count, ROUND(AVG(sakila.payment.amount), 2) AS avg_pay_per_rental
FROM payments_customer AS pc
JOIN rental_information AS r
	ON pc.customer_id = r.customer_id
JOIN sakila.payment
	ON sakila.payment.customer_id = r.customer_id
GROUP BY r.Customer, pc.total_paid, r.email, r.rental_count
    ;
    
