--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    booking_id character varying(10) NOT NULL,
    room_id character varying(10) NOT NULL,
    customer_id character varying(10) NOT NULL,
    check_in_date date DEFAULT now(),
    start_time time with time zone DEFAULT now(),
    end_time time with time zone,
    deposit integer DEFAULT 0,
    note text,
    booking_status character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id character varying(10) NOT NULL,
    customer_name character varying(100) NOT NULL,
    address character varying(255),
    phone_number integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_id character varying(10) NOT NULL,
    room_type character varying(100) NOT NULL,
    capacity integer DEFAULT 1,
    price integer DEFAULT 0,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: service_usage_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_usage_details (
    booking_id character varying(10) NOT NULL,
    service_id character varying(10) NOT NULL,
    quantity integer DEFAULT 0
);


ALTER TABLE public.service_usage_details OWNER TO postgres;

--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    service_id character varying(10) NOT NULL,
    service_name character varying(255) NOT NULL,
    unit character varying(100) NOT NULL,
    price integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: TABLE services; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.services IS 'Dịch vụ
';


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (booking_id, room_id, customer_id, check_in_date, start_time, end_time, deposit, note, booking_status, created_at, updated_at) FROM stdin;
DP0001	P0001	KH0002	2018-03-26	11:00:00+07	13:30:00+07	100000	\N	Da dat	2023-12-30 17:50:55.550994+07	2023-12-30 17:50:55.550994+07
DP0002	P0001	KH0003	2018-03-27	17:15:00+07	19:15:00+07	50000	\N	Da huy	2023-12-30 17:50:55.550994+07	2023-12-30 17:50:55.550994+07
DP0003	P0002	KH0002	2018-03-26	20:30:00+07	22:15:00+07	100000	\N	Da dat	2023-12-30 17:50:55.550994+07	2023-12-30 17:50:55.550994+07
DP0004	P0003	KH0001	2018-04-01	19:30:00+07	21:15:00+07	200000	\N	Da dat	2023-12-30 17:50:55.550994+07	2023-12-30 17:50:55.550994+07
DP0005	P0001	KH0004	2018-04-01	13:30:00+07	15:15:00+07	200000	\N	Da dat	2023-12-31 05:18:28.11089+07	2023-12-31 05:18:28.11089+07
DP0006	P0001	KH0004	2018-04-01	17:30:00+07	20:15:00+07	200000	\N	Da dat	2023-12-31 05:18:28.11089+07	2023-12-31 05:18:28.11089+07
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, customer_name, address, phone_number, created_at, updated_at) FROM stdin;
KH0001	Nguyen Van A	Hoa xuan	1111111111	2023-12-30 15:34:24.615754+07	2023-12-30 15:34:24.615754+07
KH0002	Nguyen Van B	Hoa hai	1111111112	2023-12-30 15:34:24.615754+07	2023-12-30 15:34:24.615754+07
KH0003	Pham Van A	Cam le	1111111113	2023-12-30 15:34:24.615754+07	2023-12-30 15:34:24.615754+07
KH0004	Pham Van B	Hoa xuan	1111111114	2023-12-30 15:34:24.615754+07	2023-12-30 15:34:24.615754+07
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (room_id, room_type, capacity, price, description, created_at, updated_at) FROM stdin;
P0001	Loai 1	20	60000	\N	2023-12-30 15:20:45.824482+07	2023-12-30 15:20:45.824482+07
P0002	Loai 2	25	80000	\N	2023-12-30 15:20:45.824482+07	2023-12-30 15:20:45.824482+07
P0003	Loai 3	15	50000	\N	2023-12-30 15:20:45.824482+07	2023-12-30 15:20:45.824482+07
P0004	Loai 4	20	50000	\N	2023-12-30 15:20:45.824482+07	2023-12-30 15:20:45.824482+07
\.


--
-- Data for Name: service_usage_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_usage_details (booking_id, service_id, quantity) FROM stdin;
DP0001	DV0001	20
DP0001	DV0003	3
DP0001	DV0002	10
DP0002	DV0002	10
DP0002	DV0003	1
DP0003	DV0003	2
DP0003	DV0004	10
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (service_id, service_name, unit, price, created_at, updated_at) FROM stdin;
DV0001	Beer	lon	10000	2023-12-30 15:43:58.250176+07	2023-12-30 15:43:58.250176+07
DV0002	Nuoc ngot	lon	8000	2023-12-30 15:43:58.250176+07	2023-12-30 15:43:58.250176+07
DV0003	Trai cay	dia	35000	2023-12-30 15:43:58.250176+07	2023-12-30 15:43:58.250176+07
DV0004	Khan uot	cai	20000	2023-12-30 15:43:58.250176+07	2023-12-30 15:43:58.250176+07
\.


--
-- Name: rooms Rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT "Rooms_pkey" PRIMARY KEY (room_id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (booking_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- Name: bookings bookings_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) NOT VALID;


--
-- Name: bookings bookings_room_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_id_foreign FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) NOT VALID;


--
-- Name: service_usage_details service_usage_details_booking_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_usage_details
    ADD CONSTRAINT service_usage_details_booking_id_foreign FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id);


--
-- Name: service_usage_details service_usage_details_service_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_usage_details
    ADD CONSTRAINT service_usage_details_service_id_foreign FOREIGN KEY (service_id) REFERENCES public.services(service_id);


--
-- PostgreSQL database dump complete
--

