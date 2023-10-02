CREATE TABLE person (
    login_name varchar(9) not null primary key,
    display_name text
);

INSERT INTO person VALUES (NULL, 'Felonious Erroneous');

INSERT INTO person VALUES ('atoolongusername', 'Felonious Erroneous');

ALTER TABLE person 
    ADD CONSTRAINT PERSON_LOGIN_NAME_NON_NULL 
    CHECK (LENGTH(login_name) > 0);

ALTER TABLE person 
    ADD CONSTRAINT person_login_name_no_space 
    CHECK (POSITION(' ' IN login_name) = 0);

INSERT INTO person VALUES ('', 'Felonious Erroneous');
INSERT INTO person VALUES ('space man', 'Major Tom');


ALTER TABLE PERSON DROP CONSTRAINT person_login_name_no_space;
ALTER TABLE PERSON DROP CONSTRAINT person_login_name_non_null;



CREATE OR REPLACE FUNCTION person_bit() 
    RETURNS TRIGGER
    SET SCHEMA 'public'
    LANGUAGE plpgsql
    SET search_path = public
    AS '
    BEGIN
    END;
    ';

CREATE TRIGGER person_bit 
    BEFORE INSERT ON person
    FOR EACH ROW EXECUTE PROCEDURE person_bit();

CREATE OR REPLACE FUNCTION person_bit()
    RETURNS TRIGGER
    SET SCHEMA 'public'
    LANGUAGE plpgsql
    AS $$
    BEGIN
    IF LENGTH(NEW.login_name) = 0 THEN
        RAISE EXCEPTION 'Login name must not be empty.';
    END IF;

    IF POSITION(' ' IN NEW.login_name) > 0 THEN
        RAISE EXCEPTION 'Login name must not include white space.';
    END IF;
    RETURN NEW;
    END;
    $$;

INSERT INTO person VALUES ('', 'Felonious Erroneous');

INSERT INTO person VALUES ('space man', 'Major Tom');


CREATE TABLE person_audit (
    login_name varchar(9) not null,
    display_name text,
    operation varchar,
    effective_at timestamp not null default now(),
    userid name not null default session_user
);

SELECT login_name, ts_abstract  FROM person;

CREATE VIEW abridged_person AS SELECT login_name, display_name, abstract FROM person;

INSERT INTO abridged_person VALUES ('skeeter', 'Mosquito Valentine', 'Skeeter is Doug''s best friend. He is famous in both series for the honking sounds he frequently makes.');


SELECT login_name, ts_abstract FROM person WHERE login_name = 'skeeter';


SELECT login_name, display_name, operation, userid FROM person_audit ORDER BY effective_at;

CREATE TABLE transaction (
    login_name character varying(9) NOT NULL,
    post_date date,
    description character varying,
    debit money,
    credit money,
    FOREIGN KEY (login_name) REFERENCES person (login_name)
);

ALTER TABLE person ADD COLUMN balance MONEY DEFAULT 0;

CREATE FUNCTION transaction_bit() RETURNS trigger
    LANGUAGE plpgsql
    SET SCHEMA 'public'
    AS $$
    DECLARE
    newbalance money;
    BEGIN

    -- Update person account balance

    UPDATE person 
        SET balance = 
            balance + 
            COALESCE(NEW.debit, 0::money) - 
            COALESCE(NEW.credit, 0::money) 
        WHERE login_name = NEW.login_name
                RETURNING balance INTO newbalance;

    -- Data validation

    IF COALESCE(NEW.debit, 0::money) < 0::money THEN
        RAISE EXCEPTION 'Debit value must be non-negative';
    END IF;

    IF COALESCE(NEW.credit, 0::money) < 0::money THEN
        RAISE EXCEPTION 'Credit value must be non-negative';
    END IF;

    IF newbalance < 0::money THEN
        RAISE EXCEPTION 'Insufficient funds: %', NEW;
    END IF;

    RETURN NEW;
    END;
    $$;



CREATE TRIGGER transaction_bit 
      BEFORE INSERT ON transaction 
      FOR EACH ROW EXECUTE PROCEDURE transaction_bit();

SELECT login_name, balance FROM person WHERE login_name = 'dfunny';

INSERT INTO transaction (login_name, post_date, description, credit, debit) VALUES ('dfunny', '2018-01-11', 'ACH CREDIT FROM: FINANCE AND ACCO ALLOTMENT : Direct Deposit', NULL, '$2,000.00');

SELECT login_name, balance FROM person WHERE login_name = 'dfunny';

SELECT login_name, balance FROM person WHERE login_name = 'dfunny';


INSERT INTO transaction (login_name, post_date, description, credit, debit) VALUES ('dfunny', '2018-01-17', 'FOR:BGE PAYMENT ACH Withdrawal', '$278.52', NULL);

SELECT login_name, balance FROM person WHERE login_name = 'dfunny';

INSERT INTO transaction (login_name, post_date, description, credit, debit) VALUES ('dfunny', '2018-01-23', 'FOR: ANNE ARUNDEL ONLINE PMT ACH Withdrawal', '$35.29', NULL);

SELECT login_name, balance FROM person WHERE login_name = 'dfunny';

BEGIN;
UPDATE person SET balance = '1000000000.00';

SELECT login_name, balance FROM person WHERE login_name = 'dfunny';

ROLLBACK;

CREATE OR REPLACE VIEW abridged_person AS
  SELECT login_name, display_name, abstract, balance FROM person;

BEGIN;
UPDATE abridged_person SET balance = '1000000000.00';
SELECT login_name, balance FROM abridged_person WHERE login_name = 'dfunny';

ROLLBACK;

CREATE FUNCTION abridged_person_iut() RETURNS TRIGGER
    LANGUAGE plpgsql
    SET search_path TO public
    AS $$
    BEGIN

    -- Disallow non-transactional changes to balance

      NEW.balance = OLD.balance;
    RETURN NEW;
    END;
    $$;

CREATE TRIGGER abridged_person_iut
    INSTEAD OF UPDATE ON abridged_person
    FOR EACH ROW EXECUTE PROCEDURE abridged_person_iut();

UPDATE abridged_person SET balance = '1000000000.00';

SELECT login_name, balance FROM abridged_person WHERE login_name = 'dfunny';

CREATE USER eve;

GRANT SELECT,INSERT, UPDATE ON abridged_person TO eve;
GRANT SELECT,INSERT ON transaction TO eve;

SET SESSION AUTHORIZATION eve;

SELECT * FROM person;

SELECT * from person_audit;

SELECT * FROM abridged_person;

SELECT * FROM transaction;

SET SESSION AUTHORIZATION eve;

INSERT INTO transaction (login_name, post_date, description, credit, debit) VALUES ('dfunny', '2018-01-23', 'ACH CREDIT FROM: FINANCE AND ACCO ALLOTMENT : Direct Deposit', NULL, '$2,000.00');

RESET SESSION AUTHORIZATION;
ALTER FUNCTION transaction_bit() SECURITY DEFINER;

SET SESSION AUTHORIZATION eve;

INSERT INTO transaction (login_name, post_date, description, credit, debit) VALUES ('dfunny', '2018-01-23', 'ACH CREDIT FROM: FINANCE AND ACCO ALLOTMENT : Direct Deposit', NULL, '$2,000.00');

SELECT * FROM transaction;

SELECT login_name, balance FROM abridged_person WHERE login_name = 'dfunny';


drop table if exists clickstream;
create table clickstream (
eventId varchar(40),
userId int,
sessionId int,
actionType varchar(8),
datetimeCreated timestamp
);
insert into clickstream(eventId, userId, sessionId, actionType, datetimeCreated )
values ('6e598ae5-3fb1-476d-9787-175c34dcfeff',1 ,1000,'click','2020-11-25 12:40:00'),
('0c66cf8c-0c00-495b-9386-28bc103364da',1 ,1000,'login','2020-11-25 12:00:00'),
('58c021ad-fcc8-4284-a079-8df0d51601a5',1 ,1000,'click','2020-11-25 12:10:00'),
('85eef2be-1701-4f7c-a4f0-7fa7808eaad1',1 ,1001,'buy','2020-11-22 18:00:00'),
('08dd0940-177c-450a-8b3b-58d645b8993c',3 ,1010,'buy','2020-11-20 01:00:00'),
('db839363-960d-4319-860d-2c9b34558994',10,1120,'click','2020-11-01 13:10:03'),
('2c85e01d-1ed4-4ec6-a372-8ad85170a3c1',10,1121,'login','2020-11-03 18:00:00'),
('51eec51c-7d97-47fa-8cb3-057af05d69ac',8 ,6,'click','2020-11-10 10:45:53'),
('5bbcbc71-da7a-4d75-98a9-2e9bfdb6f925',3 ,3002,'login','2020-11-14 10:00:00'),
('f3ee0c19-a8f9-4153-b34e-b631ba383fad',1 ,90, 'buy','2020-11-17 07:00:00'),
('f458653c-0dca-4a59-b423-dc2af92548b0',2 ,2000,'buy','2020-11-20 01:00:00'),
('fd03f14d-d580-4fad-a6f1-447b8f19b689',2 ,2000,'click','2020-11-20 00:00:00');
-- create fake geolocation data
drop table if exists geolocation;
create table geolocation (
userId int,
zipcode varchar(10),
datetimeCreated timestamp
);
insert into geolocation(userId, zipCode, datetimeCreated )
values
(1 ,66206,'2020-11-25 12:40:00'),
(1 ,66209,'2020-11-25 12:00:00'),
(1 ,91355,'2020-11-25 12:10:00'),
(1 ,83646,'2020-11-22 18:00:00'),
(3 ,91354,'2020-11-20 01:00:00'),
(10,91355,'2020-11-01 13:10:03'),
(10,91355,'2020-11-03 18:00:00'),
(8 ,91355,'2020-11-10 10:45:53'),
(3 ,91355,'2020-11-14 10:00:00'),
(1 ,83646,'2020-11-17 07:00:00'),
(2 ,83646,'2020-11-20 01:00:00'),
(2 ,91355,'2020-11-20 00:00:00');


with purchasingUsers as (
	select userId,
	(sum(
		case
			when actionType = 'buy' then 1
			else 0
		end
		)) as numPurchases
	from clickstream
	group by userId
	HAVING SUM(CASE WHEN actionType = 'buy' THEN 1 ELSE 0 END) >= 1
),
movingUsers as (
	select userId
	from geolocation
	group by userId
	having count(distinct zipCode) > 1
),
userSessionMetrics as (
	select userId,
		sessionId,
		sum(
			case
				when actionType = 'click' then 1
			else 0
		end
		) as numclicks,
		sum(
			case
				when actionType = 'login' then 1
				else 0
			end
		) as numlogins,
			sum(
			case
				when actionType = 'buy' then 1
				else 0
			end
		) as numPurchases
	from clickstream
	group by userId, sessionId
	)
select usm.*
from userSessionMetrics as usm
	join movingUsers as mu on usm.userId = mu.userId
	join purchasingUsers as pu on usm.userId = pu.userId;