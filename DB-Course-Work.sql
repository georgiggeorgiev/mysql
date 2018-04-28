/* КУРСОВА РАБОТА БД */


/*

Базата данни е реализирана посредством 6 таблици и 2 свързващи таблица. Същността на всяка таблица е описана при съответния CREATE TABLE
код. Релациите между таблиците са както следва:

countries 	:  brands			 1 : M
brands    	:  models			 1 : M
models   	:  cars				 1 : M
cars      	:  people			 M : M  ( свързваща таблица cars_owners )
cars 		:  repair_shops		 M : M  ( свързваща таблица car_repairs )

*/


/****** CREATE TABLE ******/


DROP DATABASE IF EXISTS cars;
CREATE DATABASE cars;
USE cars;

/*
Държавите на автопроизводителите
*/
CREATE TABLE countries (
	id INT NOT NULL AUTO_INCREMENT,
    country_name VARCHAR(84) NOT NULL UNIQUE,
    PRIMARY KEY( id )
);

/*
Автопроизводители. Пази се име и външен ключ към държавата, където се намира седалището на фирмата
*/
CREATE TABLE brands (
	id INT NOT NULL AUTO_INCREMENT,
    brand_name VARCHAR(255) NOT NULL UNIQUE,
    country_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY ( country_id ) REFERENCES countries(id),
    PRIMARY KEY ( id )
);

/*
Модели автомобили. Пази се име, код на двигател, мощност в конски сили, тип гориво и външен ключ към производителя.
Комбинацията от име на модела и код на двигателя е уникален ключ, защото често се произвеждат вариации на един модел с различни двигатели.
*/
CREATE TABLE models (
	id INT NOT NULL AUTO_INCREMENT,
    brand_id INT NOT NULL,
    model_name VARCHAR(255) NOT NULL,
    engine_code VARCHAR(50) NOT NULL,
    horsepower SMALLINT UNSIGNED NOT NULL,
    fuel_type ENUM('gas','diesel','electric','hybrid') NOT NULL,
    UNIQUE KEY( model_name, engine_code ),
	CONSTRAINT FOREIGN KEY ( brand_id ) REFERENCES brands(id),
    PRIMARY KEY ( id )
);

/*Конкретните автомобили, записани в БД. Пази се номер на рамата, регистрационен номер, пробег, година на производство и външен ключ
към модела. Булевият флаг "active" показва дали автомобилът е в движение.
*/
CREATE TABLE cars (
	id INT NOT NULL AUTO_INCREMENT,
    vin CHAR(17) NOT NULL UNIQUE,
    license_plate VARCHAR(10) NOT NULL UNIQUE,
    miles MEDIUMINT UNSIGNED NOT NULL,
    made SMALLINT UNSIGNED NOT NULL,
    active BOOLEAN NOT NULL DEFAULT 1,
    model_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY ( model_id ) REFERENCES models(id),
	PRIMARY KEY ( id )
);

/*Собственици. Пази се егн, три имена и адрес.
*/
CREATE TABLE people (
	id INT NOT NULL AUTO_INCREMENT,
    egn VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    PRIMARY KEY ( id )
);

/*Свързваща таблица за осъществяване на връзката М:М между собствениците и автомобилите. Булевият флаг "active_owner" показва дали
човекът е текущ собственик на съответния автомобил( ако стойността му е 1, в противен случай е предишен собственик)
*/
CREATE TABLE cars_owners (
	car_id INT NOT NULL,
    owner_id INT NOT NULL,
    active_owner BOOLEAN NOT NULL DEFAULT 1,
    PRIMARY KEY( car_id, owner_id ),
    CONSTRAINT FOREIGN KEY ( car_id ) REFERENCES cars(id),
    CONSTRAINT FOREIGN KEY ( owner_id ) REFERENCES people(id)
);

/*Автосервизи. Пази се име на фирмата, адрес и БУЛСТАТ
*/
CREATE TABLE repair_shops (
	id INT NOT NULL AUTO_INCREMENT,
    company_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL UNIQUE,
    bulstat CHAR(9) NOT NULL UNIQUE,
    PRIMARY KEY ( id )
);

/*Регистър за ремонти. Пази се външен ключ към ремонтирания автомобил, сервиза, където е ремонтиран, датата, описанието и
цената на ремонта. Комбинацията от id на автомобил и дата на ремонт е уникална, за да не се допускат записи, където един автомобил е
ремонтиран едновременно в два различни сервиза. Всеки отделен ремонт има уникално id.
*/
CREATE TABLE car_repairs (
	repair_id INT NOT NULL AUTO_INCREMENT,
	car_id INT NOT NULL,
    shop_id INT NOT NULL,
    repair_date DATE NOT NULL,
    repair_description TEXT,
    repair_cost DECIMAL(15,2) NOT NULL,
    CONSTRAINT FOREIGN KEY ( car_id ) REFERENCES cars(id),
    CONSTRAINT FOREIGN KEY ( shop_id ) REFERENCES repair_shops(id),
    UNIQUE KEY ( car_id, repair_date ),
    PRIMARY KEY ( repair_id )
);


/****** END CREATE TABLE ******/

/****** INSERT DATA ******/


INSERT INTO countries ( country_name )
VALUES ( 'Germany' ), ( 'Japan') , ( 'USA' ), ( 'Italy' ), ( 'France' ), ( 'Romania' ), ( 'Russian Federation' ), ( 'UK' );

INSERT INTO brands ( country_id, brand_name )
VALUES ( 1, 'VW' ), ( 1, 'BMW' ), ( 1, 'Mercedes-Benz' ), ( 2, 'Honda' ), ( 2, 'Toyota' ), ( 3, 'Ford' ), ( 6, 'Dacia' );

INSERT INTO models ( brand_id, model_name , engine_code , horsepower , fuel_type )
VALUES ( 1, 'GOLF TDI' , 'ARL' , 150, 'diesel' ),
		( 1, 'GOLF 1.8T' , 'AGU' , 150, 'gas' ),
        ( 2, 'M3' , 'S65' , 414, 'gas' ),
        ( 5, 'Prius' , '1NZ-FXE' , 90, 'hybrid' ),
        ( 7, 'Sandero' , 'H4Bt' , 80, 'gas' );

INSERT INTO cars ( vin , license_plate , miles, made , model_id )
VALUES ( '1FAFP58S11A177991', 'PK6666AM' , 10000, 2010, 3 ),
		( 'JH4DB1641NS802336', 'CO1010BH' , 100000, 2004, 1 ),
        ( '1G4GD5EDXBF330171', 'PB3089BA' , 60000, 2009, 4 ),
        ( 'KL5VM52L54B110914', 'C000000' , 300000, 1999, 5 ),
        ( 'WDBHM36E3VF540750', 'PK9999AH' , 50000, 2003, 1 );

INSERT INTO people ( egn, first_name, surname, last_name, address )
VALUES ( '9703194444' , 'Georgi' , 'Georgiev' , 'Georgiev', 'Bulgaria,Kostinbrod,Lomsko Shose,5' ),
		( '6312194443' , 'James' , 'Daniel' , 'May', 'UK,London,Hammersmith,10' ),
        ( '9603193333' , 'Valentin' , 'Georgiev' , 'Aleksandrov', 'Bulgaria,Sofia,Tsar Simeon,8' ),
        ( '9703190000' , 'Ivan' , 'Ivanov' , 'Ivanov', 'Germany,Berlin,Karl-Marx-Allee,45' ),
        ( '9703191111' , 'Petur' , 'Petrov' , 'Petrov', 'Bulgaria,Plovdiv,Ivan Asen II,17' );

INSERT INTO cars_owners ( car_id, owner_id )
VAlUES ( 4, 2 ),
		( 1, 1),
        ( 3, 4),
        ( 3, 5),
        ( 2, 1),
        ( 5, 2);

UPDATE cars_owners
SET active_owner = 0
WHERE (car_id = 5) OR (car_id = 3 AND owner_id = 4);

INSERT INTO repair_shops ( company_name, address, bulstat )
VALUES ( 'Ortatsi EOOD', 'Bulgaria,Peturch,Pliska,1', '130255999'),
		( 'BMW Serviz Sofia Iztok', 'Bulgaria,Sofia,Mladost,10', '150690420');

INSERT INTO car_repairs ( car_id, shop_id, repair_date, repair_description, repair_cost)
VALUES ( 2, 1, '2018-04-01', 'Blown Head Gasket repair', 500.00 ),
		( 1, 2, '2018-04-03', 'Oil Change', 50.00);

/****** END INSERT DATA ******/

/****** QUERIES ******/

/*Селектира имената на автопроизводителите от избраната държава в WHERE клаузата( в случая - Германия) и ги подрежда по азбучен ред.
*/
SELECT brand_name AS german_brands
FROM brands
WHERE brands.country_id IN( SELECT c.id
					 FROM countries AS c
                     WHERE c.country_name = 'Germany'
)
ORDER BY brand_name;					/*** SELECT WITH WHERE CLAUSE ***/

/*Селектира id, име на фирмата и цялата печалба от ремонти на отделните сервизи за даден период от време ( между две дати), като
ги подрежда по най-голяма печалба.
*/
SELECT shop_id, company_name, SUM(repair_cost) AS total_profit
FROM car_repairs
JOIN repair_shops
ON repair_shops.id = car_repairs.shop_id
WHERE repair_date BETWEEN '2018-04-03' AND '2018-04-05'
GROUP BY shop_id
ORDER BY total_profit DESC;		/*** SELECT WITH AGGREGATE FUNCTION AND GROUP BY ***/

/*Селектира имената на моделите автомобили и техния производител
*/
SELECT b.brand_name, m.model_name
FROM brands AS b
JOIN models AS m
ON b.id = m.brand_id
ORDER BY b.brand_name; 				/*** INNER JOIN ***/

/*Селектира име и фамилия на собствениците и регистрационния номер, модела и марката на техните текущи автомобили. Информацията за
собствениците се изкарва, дори те да не притежават автомобил
*/
SELECT CONCAT(p.first_name," ", p.last_name) AS owner_name, c.license_plate, CONCAT(b.brand_name," ", m.model_name) AS car
FROM people AS p
LEFT JOIN cars AS c
ON c.id IN ( SELECT co.car_id
			 FROM cars_owners AS co
             WHERE p.id = co.owner_id
             AND co.active_owner !=0 /*** OUTER JOIN ***/
             )
LEFT JOIN models AS m
ON c.model_id = m.id
LEFT JOIN brands AS b
ON m.brand_id = b.id;

/*Селектира id, име и фамилия и брой (COUNT) общо притежавани автомобили ( текущи и предишни) на собствениците ( дори броят да е 0 )
*/
SELECT p.id, p.first_name, p.last_name, COUNT(c.id) AS total_owned_cars
FROM people AS p
LEFT JOIN cars AS c
ON c.id IN ( SELECT co.car_id
			 FROM cars_owners AS co
             WHERE p.id = co.owner_id
)
GROUP BY p.id; 						/*** JOIN WITH AGGREGATE FUNCTION ***/

DROP PROCEDURE IF EXISTS cursor_test;

/*Процедура, на която се подават минимална сума за отстъпка и процент на отстъпка. Таблицата с ремонтите се обхожда с помощта на
 курсор, като ремонтите, отговарящи на условието за получаване на отстъпка, се записват ( вече с обновена цена ) във временна таблица
 със storage engine Memory.
*/
DELIMITER $
CREATE PROCEDURE cursor_test(IN discount_min INT, IN discount_amount DECIMAL(2,2))
BEGIN
DECLARE finished tinyint(1);
DECLARE temp_repair_id INT;
DECLARE temp_repair_cost INT;
DECLARE discount_cursor CURSOR FOR
SELECT cr.repair_id, cr.repair_cost
FROM car_repairs AS cr
WHERE cr.repair_cost > discount_min;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

DROP TEMPORARY TABLE IF EXISTS discounts_temp;
CREATE TEMPORARY TABLE discounts_temp(
repair_id INT PRIMARY KEY,
discounted_repair_cost DECIMAL(15,2) NOT NULL,
CONSTRAINT FOREIGN KEY (repair_id) REFERENCES car_repairs(repair_id)
)ENGINE = Memory;

SET finished = 0;
OPEN discount_cursor;
discount_loop: WHILE(finished = 0)
DO
FETCH discount_cursor INTO temp_repair_id, temp_repair_cost;
	IF (finished = 1)
    THEN LEAVE discount_loop;
    END IF;
	INSERT INTO discounts_temp (repair_id, discounted_repair_cost )
    VALUES ( temp_repair_id, temp_repair_cost * discount_amount );
END WHILE;
CLOSE discount_cursor;
SET finished = 0;
END;
$
DELIMITER ;
/*** CURSOR ***/

CALL cursor_test(40, 0.90); /* 10% отстъпка за ремонтите с цена по-висока от 40 */
SELECT * FROM discounts_temp;

/****** END QUERIES ******/
