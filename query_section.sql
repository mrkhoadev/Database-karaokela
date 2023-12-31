INSERT INTO rooms (room_id, room_type, capacity, price)
VALUES
('P0001', 'Loai 1', 20, 60000),
('P0002', 'Loai 2', 25, 80000),
('P0003', 'Loai 3', 15, 50000),
('P0004', 'Loai 4', 20, 50000);

INSERT INTO customers (customer_id, customer_name, address, phone_number)
VALUES
('KH0001', 'Nguyen Van A', 'Hoa xuan', 1111111111),
('KH0002', 'Nguyen Van B', 'Hoa hai', 1111111112),
('KH0003', 'Pham Van A', 'Cam le', 1111111113),
('KH0004', 'Pham Van B', 'Hoa xuan', 1111111114);
-- SELECT * FROM customers

INSERT INTO services (service_id, service_name, unit, price)
VALUES
('DV0001', 'Beer', 'lon', 10000),
('DV0002', 'Nuoc ngot', 'lon', 8000),
('DV0003', 'Trai cay', 'dia', 35000),
('DV0004', 'Khan uot', 'cai', 20000);
-- SELECT * FROM services

INSERT INTO bookings (booking_id, room_id, customer_id, check_in_date, start_time, end_time, deposit, booking_status)
VALUES
('DP0001', 'P0001', 'KH0001', '2018-03-26', '11:00', '13:30', 100000, 'Da dat'),
('DP0002', 'P0002', 'KH0002', '2018-03-27', '17:15', '19:15', 50000, 'Da huy'),
('DP0003', 'P0003', 'KH0003', '2018-03-26', '20:30', '22:15', 100000, 'Da dat'),
('DP0004', 'P0004', 'KH0004', '2018-04-01', '19:30', '21:15', 200000, 'Da dat'),
('DP0005', 'P0001', 'KH0004', '2018-04-01', '13:30', '15:15', 200000, 'Da dat'),
('DP0006', 'P0001', 'KH0004', '2018-04-01', '17:30', '20:15', 200000, 'Da dat');
-- SELECT * FROM bookings

INSERT INTO service_usage_details (booking_id, service_id, quantity)
VALUES
('DP0001', 'DV0001', 20),
('DP0001', 'DV0003', 3),
('DP0001', 'DV0002', 10),
('DP0002', 'DV0002', 10),
('DP0002', 'DV0003', 1),
('DP0003', 'DV0003', 2),
('DP0003', 'DV0004', 10);
-- SELECT * FROM service_usage_details

WITH lession_1 AS (
	WITH cte AS (
		SELECT  
			b.booking_id AS booking_id, 
			r.room_id AS room_id, 
			r.room_type AS room_type, 
			r.price AS room_price, 
			c.customer_name AS customer_name,
			b.check_in_date AS check_in_date,
			MAKE_TIMESTAMP(
				DATE_PART('year', b.check_in_date)::int,
				DATE_PART('month', b.check_in_date)::int,
				DATE_PART('day', b.check_in_date)::int,
				DATE_PART('hour', b.start_time)::int,
				DATE_PART('minute', b.start_time)::int,
				DATE_PART('second', b.start_time)::int
			) AS start_timestamp,
			TO_TIMESTAMP(
				b.check_in_date || ' ' || b.end_time::text, 
				'YYYY-MM-DD HH24:MI:SS'
			) +
			CASE WHEN b.end_time < b.start_time THEN INTERVAL '1 day' ELSE INTERVAL '0' END AS end_timestamp,
			COALESCE(sud.quantity, 0) AS quantity,
			COALESCE(s.price, 0) AS service_price,
			b.deposit AS deposit
		FROM customers AS c
		LEFT JOIN bookings AS b ON b.customer_id = c.customer_id AND b.booking_status = 'Da dat'
		LEFT JOIN rooms AS r ON b.room_id = r.room_id
		LEFT JOIN service_usage_details AS sud ON b.booking_id = sud.booking_id
		LEFT JOIN services AS s ON sud.service_id = s.service_id
		WHERE LOWER(b.booking_status) = 'da dat'
	),
	total_singing_cost AS (
		SELECT 
			booking_id,
			ROUND(SUM(room_price * EXTRACT(EPOCH FROM (end_timestamp - start_timestamp)) / 3600))::int AS total_singing_cost
		FROM cte
		GROUP BY booking_id
	),
	total_service_cost AS (
		SELECT 
			booking_id,
			ROUND(SUM(quantity * service_price))::int AS total_service_cost
		FROM cte
		GROUP BY booking_id
	)
	SELECT 
		cte.booking_id AS "Mã đặt phòng",
		cte.room_id AS "Mã phòng",
		cte.room_type AS "Loại phòng",
		cte.room_price AS "Giá phòng",
		cte.customer_name AS "Tên khách hàng",
		cte.check_in_date AS"Ngày đặt",
		TO_CHAR(tsi.total_singing_cost, 'FM999,999,999') || 'đ' AS "Tổng tiền hát", 
		TO_CHAR(tse.total_service_cost, 'FM999,999,999') || 'đ' AS "Tổng tiền sử dụng dịch vụ",
		TO_CHAR((tsi.total_singing_cost + tse.total_service_cost - cte.deposit), 'FM999,999,999') || 'đ' AS "Tổng thanh toán"
	FROM cte
	LEFT JOIN total_singing_cost AS tsi ON cte.booking_id = tsi.booking_id
	LEFT JOIN total_service_cost AS tse ON cte.booking_id = tse.booking_id

	GROUP BY 
		cte.booking_id,
		cte.check_in_date,
		cte.room_id,
		cte.room_type,
		cte.customer_name,
		cte.room_price,
		cte.deposit,
		tsi.total_singing_cost,
		tse.total_service_cost
)
SELECT * FROM lession_1;

WITH lession_2 AS (
	SELECT 
		customer_id AS "Mã khách hàng",
		customer_name AS "Tên khách hàng",
		address AS "Địa chỉ",
		phone_number AS "Số điện thoại"
	FROM 
		customers AS c
	WHERE EXISTS (
		SELECT 
			'ok'
		FROM 
			bookings AS b
		WHERE 
			b.customer_id = c.customer_id 
			AND LOWER(b.booking_status) = 'da dat' 
			AND LOWER(c.address) = 'hoa xuan'
	)
)
SELECT * FROM lession_2;

WITH lession_3 AS (
	SELECT 
		b.room_id
		AS "Mã phòng",
		r.room_type
		AS "Loại phòng",
		r.capacity
		AS "Số khách tối đa",
		r.price
		AS "Giá phòng",
		COUNT(b.room_id) AS "Số lần đặt"
	FROM 
		bookings AS b
	LEFT JOIN rooms AS r ON b.room_id = r.room_id
	WHERE LOWER(b.booking_status) = 'da dat'
	GROUP BY 
		b.room_id,
		r.room_type,
		r.capacity,
		r.price
	HAVING COUNT(b.booking_id) > 2
)
SELECT * FROM lession_3;

	
