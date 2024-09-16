
CREATE TABLE public.product_lines (
                product_line VARCHAR(50) NOT NULL,
                product_name VARCHAR(70) NOT NULL,
                text_description VARCHAR(4000),
                html_description CHAR,
                image BYTEA,
                CONSTRAINT product_lines_id PRIMARY KEY (product_line)
);


CREATE SEQUENCE public.orderdetails_quantity_ordered_seq;

CREATE TABLE public.orderdetails (
                order_number INTEGER NOT NULL,
                product_code VARCHAR(15) NOT NULL,
                order_line_number SMALLINT NOT NULL,
                quantity_ordered INTEGER NOT NULL DEFAULT nextval('public.orderdetails_quantity_ordered_seq'),
                price_each NUMERIC NOT NULL,
                CONSTRAINT orderdetails_id PRIMARY KEY (order_number, product_code)
);


ALTER SEQUENCE public.orderdetails_quantity_ordered_seq OWNED BY public.orderdetails.quantity_ordered;

CREATE SEQUENCE public.employees_reports_to_seq;

CREATE TABLE public.employees (
                employee_number INTEGER NOT NULL,
                first_name VARCHAR(50) NOT NULL,
                extension VARCHAR(10) NOT NULL,
                job_Title VARCHAR(50) NOT NULL,
                reports_to INTEGER DEFAULT nextval('public.employees_reports_to_seq'),
                email VARCHAR(100) NOT NULL,
                office_code VARCHAR(10) NOT NULL,
                last_name VARCHAR(50) NOT NULL,
                Parent_employee_number INTEGER NOT NULL,
                CONSTRAINT employees_id PRIMARY KEY (employee_number)
);


ALTER SEQUENCE public.employees_reports_to_seq OWNED BY public.employees.reports_to;

CREATE TABLE public.offices (
                office_code VARCHAR(10) NOT NULL,
                city VARCHAR(50) NOT NULL,
                address_line1 VARCHAR(50) NOT NULL,
                address_line2 VARCHAR(50),
                state VARCHAR(50),
                phone VARCHAR(50) NOT NULL,
                country VARCHAR(50) NOT NULL,
                postal_code VARCHAR(15) NOT NULL,
                territory VARCHAR(10) NOT NULL,
                employee_number INTEGER NOT NULL,
                CONSTRAINT offices_id PRIMARY KEY (office_code)
);


CREATE TABLE public.products (
                product_code VARCHAR(15) NOT NULL,
                product_name VARCHAR(70) NOT NULL,
                product_line VARCHAR(50) NOT NULL,
                product_scale VARCHAR(10) NOT NULL,
                product_vendor VARCHAR(50) NOT NULL,
                product_description CHAR NOT NULL,
                quantity_in_stock SMALLINT NOT NULL,
                buy_price NUMERIC(15,2) NOT NULL,
                msrp NUMERIC NOT NULL,
                office_code VARCHAR(10) NOT NULL,
                order_number INTEGER NOT NULL,
                CONSTRAINT products_id PRIMARY KEY (product_code)
);


CREATE SEQUENCE public.customers_customer_number_seq;

CREATE TABLE public.customers (
                customer_number INTEGER NOT NULL DEFAULT nextval('public.customers_customer_number_seq'),
                postal_code VARCHAR(50),
                customer_name VARCHAR(50) NOT NULL,
                contact_first_name VARCHAR(50) NOT NULL,
                credit_limit NUMERIC,
                sales_rep_employee_number INTEGER,
                country VARCHAR(50) NOT NULL,
                state VARCHAR(50),
                address_line1 VARCHAR(50) NOT NULL,
                city VARCHAR(50) NOT NULL,
                address_line2 VARCHAR(50),
                contact_last_name VARCHAR(50) NOT NULL,
                phone VARCHAR(50) NOT NULL,
                CONSTRAINT customers_id PRIMARY KEY (customer_number)
);


ALTER SEQUENCE public.customers_customer_number_seq OWNED BY public.customers.customer_number;

CREATE TABLE public.payments (
                check_number VARCHAR(50) NOT NULL,
                customer_number INTEGER NOT NULL,
                payment_date DATE NOT NULL,
                amount NUMERIC NOT NULL,
                CONSTRAINT payments_id PRIMARY KEY (check_number, customer_number)
);


CREATE TABLE public.orders (
                order_number INTEGER NOT NULL,
                customer_number INTEGER NOT NULL,
                order_date DATE NOT NULL,
                required_date DATE NOT NULL,
                shipped_date DATE,
                status VARCHAR(15) NOT NULL,
                comments CHAR,
                product_code VARCHAR(15) NOT NULL,
                office_code VARCHAR(10) NOT NULL,
                employee_number INTEGER NOT NULL,
                check_number VARCHAR(50) NOT NULL,
                CONSTRAINT orders_id PRIMARY KEY (order_number)
);


ALTER TABLE public.products ADD CONSTRAINT product_lines_products_fk
FOREIGN KEY (product_line)
REFERENCES public.product_lines (product_line)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orders ADD CONSTRAINT orderdetails_orders_fk
FOREIGN KEY (order_number, product_code)
REFERENCES public.orderdetails (order_number, product_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.products ADD CONSTRAINT orderdetails_products_fk
FOREIGN KEY (order_number, product_code)
REFERENCES public.orderdetails (order_number, product_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orders ADD CONSTRAINT employees_orders_fk
FOREIGN KEY (employee_number)
REFERENCES public.employees (employee_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.employees ADD CONSTRAINT employees_employees_fk
FOREIGN KEY (Parent_employee_number)
REFERENCES public.employees (employee_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.offices ADD CONSTRAINT employees_offices_fk
FOREIGN KEY (employee_number)
REFERENCES public.employees (employee_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orders ADD CONSTRAINT offices_orders_fk
FOREIGN KEY (office_code)
REFERENCES public.offices (office_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.products ADD CONSTRAINT offices_products_fk
FOREIGN KEY (office_code)
REFERENCES public.offices (office_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orders ADD CONSTRAINT products_orders_fk
FOREIGN KEY (product_code)
REFERENCES public.products (product_code)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orders ADD CONSTRAINT customers_orders_fk
FOREIGN KEY (customer_number)
REFERENCES public.customers (customer_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.payments ADD CONSTRAINT customers_payments_fk
FOREIGN KEY (customer_number)
REFERENCES public.customers (customer_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.orders ADD CONSTRAINT payments_orders_fk
FOREIGN KEY (check_number, customer_number)
REFERENCES public.payments (check_number, customer_number)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
