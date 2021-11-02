CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8,2),
    customer_id INT,
   FOREIGN KEY(customer_id) 
       REFERENCES customers(id) 
       ON DELETE CASCADE #adding this, when deleting a row from customer table related row here will be gone too
);

INSERT INTO customers (first_name, last_name, email) 
VALUES ('Boy', 'George', 'george@gmail.com'),
       ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
       ('Bette', 'Davis', 'bette@aol.com');
       
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/02/10', 99.99, 1),
       ('2017/11/11', 35.50, 1),
       ('2014/12/12', 800.67, 2),
       ('2015/01/03', 12.50, 2),
       ('1999/04/11', 450.25, 5);
    

#Implicit Inner Join
SELECT * FROM customers, orders
    WHERE customers.id = orders.customer_id; #this returns everything that customer_id in table orders matches id                                                #in customers

SELECT first_name, last_name, order_date, amount
    FROM customers, orders
    WHERE custoemrs.id = orders.customer_id; #implicit is not as simple as explicit
    
#Explicit Inner Join  - MUCH MORE SIMPLE
SELECT * FROM customers
    JOIN orders
      ON custoemrs.id = orders.customer_id;
    
    
SELECT first_name,last_name,order_date,amount
    FROM customers
      JOIN orders
        ON customers.id = orders.customer_id; #the result will be the same if the two table in the code is switched
        
#Inner join with order by & group by
SELECT first_namem, last_name, order_date amount
    FROM customers
      JOIN orders
        ON customers.id = orders.customer_id
ORDER BY order_date; 


SELECT first_name, last_name, SUM(amount) AS Total_Amount
    FROM customers
      JOIN orders
        ON customers.id = orders.customer_id
GROUP BY customer_id
ORDER BY Total_Amount DESC;


#Left Join
SELECT * FROM customers
LEFT JOIN orders
    ON customers.id = orders.customer_id #simple example


SELECT first_name, last_name, order_date, amount
FROM customers
    LEFT JOIN orders
        ON customers.id = orders.customer_id; #find the matching by customer id in both table, from customers to                                                 #orders, but those with no orders history will show "NULL"

SELECT first_name, last_name, IFNULL(SUM(amount), 0) AS Total_Amount
FROM customers
    LEFT JOIN orders
        ON customers.id = orders.customer_id
GROUP BY customers.id
ORDER BY Total_amount DESC;


#Right Join
SELECT * FROM orders
    RIGHT JOIN customers
    ON customers.id = orders.customer_id; #simple right join, shows everything on table orders.


SELECT IFNULL(first_name,'Missing'), IFNULL(last_name,'Customer'), SUM(amount), order_date
FROM customers
    RIGHT JOIN orders
        ON customers.id = orders.customer_id
GROUP BY first_name, last_name; #in this right join those with no order history will not be shown 


#Exerciese
CREATE TABLE students(id INT AUTO_INCREMENT PRIMARY KEY, first_name varchar(50));

CREATE TABLE papers
    (title VARCHAR(100), 
     grade INT, 
     student_id INT, 
     FOREIGN KEY(student_id) 
     REFERENCES students(id)
    );


INSERT INTO students (first_name) VALUES 
('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade) VALUES
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);

SELECT first_name, title, grade FROM papers
     JOIN students
     ON students.id = papers.student_id
     ORDER BY grade DESC;
     
SELECT first_name, title, grade 
FROM students 
    LEFT JOIN papers 
        ON students.id = papers.student_id;

SELECT first_name, title, IFNULL(grade, 0) AS grade 
    FROM students
     LEFT JOIN papers
     ON students.id = papers.student_id;
     
SELECT first_name, IFNULL(AVG(grade),0) AS Average
    FROM students
      LEFT JOIN papers
      ON students.id = papers.student_id
      GROUP BY first_name
      ORDER BY Average DESC;
      
      
SELECT first_name, IFNULL(AVG(grade),0) AS Average,  
      CASE 
         WHEN AVG(grade) IS NULL THEN 'FAILING' 
         WHEN AVG(grade) >= 75 THEN 'PASSING' 
         ELSE 'FAILING'
      END AS passing_status
FROM students
      LEFT JOIN papers
      ON students.id = papers.student_id
GROUP BY first_name
ORDER BY Average DESC;


