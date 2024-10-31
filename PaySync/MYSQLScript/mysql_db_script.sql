-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET time_zone = "+00:00";

-- disable foreign key
SET foreign_key_checks = 0;

DROP TABLE IF EXISTS t_user;
CREATE TABLE IF NOT EXISTS t_user (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  phase int NOT NULL,
  block int NOT NULL,
  lot int NOT NULL,
  email varchar(100) NOT NULL,
  mobile varchar(20) NOT NULL,
  username varchar(100) NOT NULL,
  password varchar(100) NOT NULL default 'password',
  active varchar(1) NOT NULL default 'Y',
  PRIMARY KEY (id),
  CONSTRAINT uc_username Unique(username)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE t_user
ADD COLUMN  role VARCHAR(10) AFTER mobile;

ALTER TABLE t_user
ADD COLUMN  login_attempted int default 0 AFTER password;

ALTER TABLE t_user
ADD COLUMN  createdon DATETIME default current_timestamp AFTER login_attempted;

ALTER TABLE t_user
ADD COLUMN  createdby int AFTER createdon;

ALTER TABLE t_user
ADD COLUMN  updatedon DATETIME default current_timestamp on update current_timestamp AFTER createdon;

ALTER TABLE t_user
ADD COLUMN  updatedby int AFTER updatedon;

-- Trigger to update login_attempted
DROP TRIGGER IF EXISTS trg_t_user_upd;
delimiter //
CREATE TRIGGER trg_t_user_upd BEFORE UPDATE ON t_user
   FOR EACH ROW
       BEGIN
           IF OLD.id = NEW.updatedby THEN
               SET NEW.login_attempted = OLD.login_attempted + 1;
           ELSEIF OLD.id != NEW.updatedby AND NEW.role = 'admin' THEN
               SET NEW.login_attempted = 0;
           END IF;
       END;//
delimiter ;
-- CREATE TRIGGER t_user_update BEFORE/AFTER INSERT/UPDATE ON t_user
-- FOR EACH ROW
-- SET NEW.login_attempted = OLD.login_attempted + 1;

DROP TABLE IF EXISTS t_offset;
CREATE TABLE IF NOT EXISTS t_offset (
  offset_status int NOT NULL,
  offset_desc varchar(100) NOT NULL,
  offset_display varchar(100) NOT NULL,
  PRIMARY KEY (offset_status)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS t_bill;
CREATE TABLE IF NOT EXISTS t_bill (
  bill_id int NOT NULL AUTO_INCREMENT,
  user_id int NOT NULL,
  bill_date date,
  amount decimal(10,4) NOT NULL,
  pay_id int,
  pay_offset_pending_id int,
  pay_offset_status int NOT NULL default 0,
  pay_offset_amount decimal(10,4),
  pay_offset_pending_amount decimal(10,4),
  createdby int NOT NULL,
  createdon DATETIME default current_timestamp,
  updatedby int NOT NULL,
  updatedon DATETIME default current_timestamp on update current_timestamp,
  PRIMARY KEY (bill_id),
  FOREIGN KEY (user_id) REFERENCES t_user(id),
  FOREIGN KEY (pay_id) REFERENCES t_payment(pay_id),
  FOREIGN KEY (pay_offset_status) REFERENCES t_offset(offset_status)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS t_payment;
CREATE TABLE IF NOT EXISTS t_payment (
  pay_id int NOT NULL AUTO_INCREMENT,
  user_id int NOT NULL,
  paid_date DATETIME default current_timestamp,
  paid_amount decimal(10,4) NOT NULL,
  offset_status int NOT NULL default 0,
  offset_amount decimal(10,4),
  offset_pending_amount decimal(10,4),
  createdby int NOT NULL,
  createdon DATETIME default current_timestamp,
  updatedby int NOT NULL,
  updatedon DATETIME default current_timestamp on update current_timestamp,
  PRIMARY KEY (pay_id),
  FOREIGN KEY (user_id) REFERENCES t_user(id),
  FOREIGN KEY (offset_status) REFERENCES t_offset(offset_status)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- Sample Insert Statements
INSERT INTO t_offset
	(offset_status, offset_desc, offset_display)
VALUES 
    (0, 'Offset Pending Amount', 'Pending'),
    (1, 'Offset Settled Amount', 'Paid'),
    (2, 'Offset Extra Amount', 'Extra Paid');
commit;
    
INSERT INTO t_user 
   (name, phase, block, lot, email, mobile, role, username, password, createdby, updatedby) 
VALUES
   ('Armida B. Contreras', 1, 3, 8, 'armidabuenavista@icloud.com', 09217111552, 'admin', 'admin', 'admin', 1, 1),
   ('Armida B. Contreras', 1, 3, 8, 'armidabuenavista@icloud.com', 09217111552, 'user', 'midz', 'midz', 1, 1),
   ('Mauro D. Lucido Jr., Ed.D.', 2, 16, 23, 'mauro.lucido@lspu.edu.ph', 09213002228, 'user', 'mauro', 'mauro', 1, 1),
   ('Joebert C. Palcon', 1, 5, 1, 'joebert.palcon27@gmail.com', 09458138030, 'user', 'joebert', 'joebert', 1, 1),
   ('Cherrylyn Cuz', 2, 15, 3, 'cher.cus.cc@gmail.com', 09777061046, 'user', 'cus', 'cus', 1, 1),
   ('June Ali A. Francisco', 2, 2, 97, 'j.a.francisco@hotmail.com', 09063968363, 'user', 'ali', 'ali', 1, 1),
   ('Angeli Joyce Buan Regla', 2, 14, 7, 'angelijoycemapebuan@gmail.com', 09684423163, 'user', 'angeli', 'angeli', 1, 1),
   ('Aivy Jhoy M. Cabuso', 2, 2, 54, 'aivyjhoycabuso@yahoo.com', 09171132373, 'user', 'jhoy', 'jhoy', 1, 1),
   ('Daniel M. Gonzales', 1, 1, 25, 'daniel_gonzales37@yahoo.co.uk', 09387870451, 'user', 'daniel', 'daniel', 1, 1),
   ('Bryan D. Villamayor', 2, 2, 131, 'bryan.villamayor001@deped.gov.ph', 09399378741, 'user', 'bryan', 'bryan', 1, 1),
   ('Christofferson P. Llarenas', 2, 2, 40, 'christoffersonllarenas0826@gmail.com', 09455032932, 'user', 'llarenas', 'llarenas', 1, 1),
   ('Leonardo Samson', 2, 2, 41, 'leonardosamson5@gmail.com', 09771068220, 'user', 'samson', 'samson', 1, 1),
   ('Mylenne', 2, 4, 5, 'test@icloud.com', 12345678900, 'user', 'mai', 'mai', 1, 1),
   ('Rhona', 2, 4, 5, 'test@icloud.com', 12345678900, 'user', 'rhona', 'rhona', 1, 1); 
commit;   

 INSERT INTO t_bill 
   (user_id, bill_date, amount, pay_id, pay_offset_pending_id, pay_offset_status, pay_offset_amount, pay_offset_pending_amount, createdby, updatedby)
 VALUES
    (2, DATE_ADD(current_date(), INTERVAL -5 MONTH), 500, 1, 0, 1, 500,	0, 1, 2),
	(2, DATE_ADD(current_date(), INTERVAL -4 MONTH), 500, 1, 0, 1, 500,	0, 1, 2),
    (2, DATE_ADD(current_date(), INTERVAL -3 MONTH), 500, 1, 0, 1, 500,	0, 1, 2);	
 commit; 

 INSERT INTO t_payment
    (user_id, paid_date, paid_amount, offset_status,	offset_amount, offset_pending_amount, createdby, createdon, updatedby, updatedon) 
 VALUES
    (2, DATE_ADD(current_date(), INTERVAL -5 MONTH), 500, 1, 500, 0, 2, current_date(), 2, current_date()),
    (2, DATE_ADD(current_date(), INTERVAL -4 MONTH), 500, 1, 500, 0, 2, current_date(), 2, current_date()),
    (2, DATE_ADD(current_date(), INTERVAL -3 MONTH), 500, 1, 500, 0, 2, current_date(), 2, current_date());
 commit;   
   
-- disable foreign key
-- SET foreign_key_checks = 1;

-- Test of CRUD 
DROP TABLE IF EXISTS tutorials;
CREATE TABLE IF NOT EXISTS tutorials (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(100),
  title varchar(300),
  description varchar(500),
  published int NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


DROP TABLE IF EXISTS test;
CREATE TABLE IF NOT EXISTS test (
  name varchar(100)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

