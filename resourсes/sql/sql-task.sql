-- Task 1
SELECT 
	a.model, s.fare_conditions, COUNT(s.seat_no)
FROM 
	aircrafts_data a
INNER JOIN
	seats s ON a.aircraft_code = s.aircraft_code
GROUP BY
	a.model, s.fare_conditions;

-- Task 2
SELECT 
	a.model, COUNT(s.seat_no) AS total_seats
FROM 
	aircrafts_data a
INNER JOIN
	seats s ON a.aircraft_code = s.aircraft_code
GROUP BY
	a.model
LIMIT 3;

-- Task 3
SELECT 
	f.flight_no, f.scheduled_departure, f.actual_departure
FROM 
	flights f
WHERE 
	f.actual_departure IS NOT NULL
	AND f.actual_departure > f.scheduled_departure + INTERVAL '2 hour';

-- Task 4
SELECT 
	t.passenger_name, t.contact_data,
	tf.fare_conditions, b.book_date
FROM 
	tickets t
INNER JOIN
	ticket_flights tf ON t.ticket_no = tf.ticket_no
INNER JOIN
	bookings b ON t.book_ref = b.book_ref
WHERE 
	tf.fare_conditions = 'Business' 
	AND t.passenger_name IS NOT NULL
	AND t.contact_data IS NOT NULL
ORDER BY 
	b.book_date DESC
LIMIT 10;

-- Task 5
SELECT
	f.flight_no,
	tf.fare_conditions
FROM
	flights f
INNER JOIN
	ticket_flights tf ON f.flight_id = tf.flight_id
WHERE
	tf.fare_conditions <> 'Business'
GROUP BY
	f.flight_no,
	tf.fare_conditions

-- Task 6
SELECT DISTINCT
	a.airport_name, a.city
FROM 
	airports a
INNER JOIN 
	flights f ON a.airport_code = f.departure_airport
WHERE
	f.actual_departure > f.scheduled_departure;

-- Task 7
SELECT DISTINCT
	a.airport_name, COUNT(f.flight_no) AS flight_count
FROM 
	airports a
INNER JOIN 
	flights f ON a.airport_code = f.departure_airport
WHERE
	f.status NOT IN ('Departed', 'Arrived', 'Cancelled')
GROUP BY 
	a.airport_name
ORDER BY
	flight_count DESC;

-- Task 8
SELECT 
    f.flight_id,
    f.flight_no,
    f.scheduled_arrival,
    f.actual_arrival
FROM 
    flights f
WHERE 
    f.scheduled_arrival <> f.actual_arrival;

-- Task 9
SELECT 
	a.aircraft_code, 
	a.model, 
	s.seat_no
FROM 
	aircrafts a
INNER JOIN
	seats s ON a.aircraft_code = s.aircraft_code
WHERE 
	s.fare_conditions <> 'Economy' 
	AND a.model = 'Аэробус A321-200'
ORDER BY 
	s.seat_no;

-- Task 10
SELECT DISTINCT
	a.airport_code,
	a.airport_name,
	a.city
FROM 
	airports a
WHERE
	a.city IN (
		SELECT city
		FROM airports
		GROUP BY city
		HAVING COUNT(airport_code) > 1
	);

-- Task 11
SELECT
	t.passenger_name,
	SUM(tf.amount) AS total_amount
FROM
	tickets t
INNER JOIN
	ticket_flights tf ON t.ticket_no = tf.ticket_no
GROUP BY
	t.passenger_name
HAVING
	SUM(tf.amount) > (SELECT AVG(amount) FROM ticket_flights);

-- Task 12
SELECT
	f.flight_no,
	a1.city AS departure_city,
	a2.city AS arrival_city,
	f.scheduled_departure
FROM
	flights f
INNER JOIN
	airports a1 ON f.departure_airport = a1.airport_code
INNER JOIN
	airports a2 ON f.arrival_airport = a2.airport_code
WHERE
	a1.city = 'Екатеринбург'
	AND a2.city = 'Москва'
	AND f.status NOT IN ('Departed', 'Arrived', 'Cancelled')
ORDER BY
	f.scheduled_departure ASC
LIMIT 1;

-- Task 13
SELECT
    t.ticket_no,
    tf.amount
FROM ticket_flights tf
INNER JOIN tickets t ON tf.ticket_no = t.ticket_no
WHERE tf.amount = (SELECT MIN(amount) FROM ticket_flights)
   OR tf.amount = (SELECT MAX(amount) FROM ticket_flights);


-- Task 14
CREATE TABLE Customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL
);

-- Task 15
CREATE TABLE Orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customerId INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT fk_customer
        FOREIGN KEY (customerId) REFERENCES Customers(id)
);

-- Task 16
INSERT INTO Customers (firstName, lastName, email, phone)
VALUES ('John', 'Doe', 'john.doe@example.com', '+1234567890');

INSERT INTO Customers (firstName, lastName, email, phone)
VALUES ('Jane', 'Smith', 'jane.smith@example.com', '+1234567891');

INSERT INTO Customers (firstName, lastName, email, phone)
VALUES ('Alice', 'Brown', 'alice.brown@example.com', '+1234567892');

INSERT INTO Customers (firstName, lastName, email, phone)
VALUES ('Bob', 'Johnson', 'bob.johnson@example.com', '+1234567893');

INSERT INTO Customers (firstName, lastName, email, phone)
VALUES ('Eve', 'Davis', 'eve.davis@example.com', '+1234567894');

INSERT INTO Orders (customerId, quantity)
VALUES (1, 2);

INSERT INTO Orders (customerId, quantity)
VALUES (2, 5);

INSERT INTO Orders (customerId, quantity)
VALUES (3, 3);

INSERT INTO Orders (customerId, quantity)
VALUES (4, 1);

INSERT INTO Orders (customerId, quantity)
VALUES (5, 4);

-- Task 17
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
