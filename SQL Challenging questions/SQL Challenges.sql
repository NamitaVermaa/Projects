use demo;
/* TASK 1:
Perform SQL queries on the tables: Employee_details, Departments, Department Employee. */

CREATE TABLE empdep (id INT(10), name VARCHAR(20), birthdate DATE);
INSERT INTO empdep VALUES(1,'Vikas','1997-07-15'),(2,'Vivek','1989-02-21'),(3,'Arun','1980-06-10'),(4,'Sanjay','1981-03-30'),(5,'Claire','1999-07-03');
INSERT INTO empdep VALUES(6,'Angel','1997-11-18');

CREATE TABLE dep (depid INT(10), name VARCHAR(20));
INSERT INTO dep VALUES(1,'Sales'),(2,'Marketing'),(3,'Finance'),(4,'IT'),(5,'HR');

CREATE TABLE dep_emp (id INT(10), depid INT(10), salary_in_thousand INT(40));
INSERT INTO dep_emp VALUES(1,1,15),(2,1,17),(3,5,20),(4,4,60),(5,3,30);
INSERT INTO dep_emp VALUES(6,1,20);

SELECT * FROM empdep;
SELECT * FROM dep;
SELECT * FROM dep_emp;

/* a.	Find total number of employees */
SELECT COUNT(*) FROM empdep;

/* b.	Find total number of employees in every department with department name */
SELECT d.name, COUNT(e.id) AS total_emp
FROM dep_emp e INNER JOIN dep d
ON e.depid=d.depid
GROUP BY d.name;

/* c.	Employees above age 30 */
SELECT id, name, (YEAR(CURDATE()) - YEAR(birthdate)) AS emp_age
FROM empdep
WHERE (YEAR(CURDATE()) - YEAR(birthdate)) >30;

/* d.	Employees below age 25 and salary more than 30 */
SELECT e.id, e.name, (YEAR(CURDATE()) - YEAR(e.birthdate)) AS emp_age, d.salary_in_thousand
FROM empdep e INNER JOIN dep_emp d 
ON e.id=d.id
WHERE (YEAR(CURDATE()) - YEAR(birthdate)) <25 AND d.salary_in_thousand>30;

/* e.	Highest salary for every department */
SELECT d.name, MAX(de.salary_in_thousand)
FROM dep d INNER JOIN dep_emp de
ON d.depid=de.depid
GROUP BY d.name;

/* f.	3rd highest salary for every department */
WITH rank_sal AS
(
SELECT d.name, RANK() OVER(PARTITION BY d.name ORDER BY de.salary_in_thousand DESC) AS ranks
FROM dep d INNER JOIN dep_emp de
ON d.depid=de.depid
)
SELECT * FROM rank_sal 
WHERE ranks=3;

/* g.	Find the top 2 salaried people in every department */
WITH rank_sal AS
(
SELECT de.id,d.name, RANK() OVER(PARTITION BY d.name ORDER BY de.salary_in_thousand DESC) AS ranks
FROM dep d INNER JOIN dep_emp de
ON d.depid=de.depid
)
SELECT d.name,rs.ranks,rs.name
FROM empdep d INNER JOIN rank_sal rs
ON d.id=rs.id
WHERE ranks<=2
ORDER BY rs.name,rs.ranks;

/* h.	Find the top 2 unique salaries in every department */
SELECT COUNT(DISTINCT de.salary_in_thousand) AS uni_sal,d.name
FROM dep d INNER JOIN dep_emp de
ON d.depid=de.depid
GROUP BY d.name
ORDER BY uni_sal DESC
LIMIT 2;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TASK 2:
Analyse 3 tables below (Customer sales ,store and product data) and write a nested query to find out the name of the most popular item in each of the 2 cities: */

CREATE TABLE cust ( cust_name VARCHAR(10), item_code VARCHAR(10), store_id INT(10));
INSERT INTO cust VALUES('Ajay','XG105',1235),('Ajay','XG102',1235),('Ajay','XG103',1235),('Shanu','XG103',8866), ('Nitin','XG101',1235), ('Abhishek','XG101',8866),
('Abhishek','XG103',8866),('Ajay','XG103',1235), ('Luv','XG103',2113),('Akhil','XG104',2113),('Akhil','XG105',2113),('Rohit','XG103',8866), ('Rohit','XG101',8866),
('Naveen','XG102',2113),('Naveen','XG103',2113);

CREATE TABLE store (  store_id INT(10), storeloc VARCHAR(10));
INSERT INTO store VALUES(1235,'Delhi'), (2113,'Banglore'), (8866,'Delhi');

CREATE TABLE product (  item_code VARCHAR(10), Item_name VARCHAR(10));
INSERT INTO product VALUES('XG101','blueberry'),('XG102','blackfrst'), ('XG103','applepie'),('XG104','truffle'),('XG105','lemonpie');

SELECT * FROM cust;
SELECT * FROM store;
SELECT * FROM product;

WITH pop AS(

SELECT c.item_code,
 s.storeloc 
 FROM cust c INNER JOIN store s 
 ON c.store_id = s.store_id
 )
 SELECT DISTINCT p.storeloc,count(p.item_code) AS popproduct, pr.item_name
 FROM pop p INNER JOIN product pr 
 ON p.item_code=pr.item_code
 GROUP BY pr.item_name,p.storeloc
 ORDER BY popproduct DESC
 LIMIT 4;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TASK 3:
Perform queries on 4 tables: pets, owners, procedure history and procedure details */

CREATE TABLE pets (petid VARCHAR(20), name VARCHAR(20), kind VARCHAR(20), gender VARCHAR(20), age INT(10), owner_id VARCHAR(20));
INSERT INTO pets VALUES('J6-8562','Blackie','Dog','male',11,'5168'),('Q0-2001','Roomba','Cat','male',9,'5508'),('M0-2904','Simba','Cat','male',1,'3086'),
('R3-7551','Keller','Parrot','female',2,'7908'),('P2-7342','Cuddles','Dog','male',13,'4378'),('X0-8765','Vuitton','Parrot','female',11,'7581'),
('Z4-5652','Priya','Cat','female',7,'7343'),('Z4-4045','Simba','Cat','male',0,'2700'),('M8-7852','Cookie','Cat','female',8,'7606'),
('J2-3320','Heisenberg','Dog','male',3,'1319');
INSERT INTO pets VALUES('I6-9459','Biscuit','Dog','female',4,'6049'),('R4-6131','Biscuit','Dog','female',5,'2863'),('N6-7350','Biscuit','Dog','female',8,'3518'),
('U4-6674','Biscuit','Dog','female',1,'3663'),('U8-6473','Biscuit','Dog','female',3,'1070'),('S4-0789','Biscuit','Dog','female',10,'7101'),
('P0-1725','Lily','Dog','female',0,'2419');

CREATE TABLE owners (owner_id VARCHAR(20), name VARCHAR(20), surname VARCHAR(20), streetaddress VARCHAR(40), city VARCHAR(20), state VARCHAR(20), statefull VARCHAR(40),
zipcode VARCHAR(20));
INSERT INTO owners VALUES('6049','Debbie','Metivier','315 Goff Avenue','Grand Rapids','MI','Michigan','49503'),('2863','John','Sebastian','3221 Perry Street','Davison','MI',
'Michigan','48423'),('3518','Connie','Pauley','1539 Cunningham Court','Bloomfield Township','MI','Michigan','48302'),('3663','Lena','Haliburton','4217 Twin Oaks Drive',
'Traverse City','MI','Michigan','49684'),('1070','Jessica','Velazquez','3861 Woodbridge Lane','Southfield','MI','Michigan','48034'),('7101','Bessie','Yen','30 Cunningham Court',
'Rochester Hills','MI','Michigan','48306'),('2419','Luisa','Cuellar','1308 Shingleton Road','Kalamazoo','MI','Michigan','49007'),('6194','Karen','Torres','3941 Ritter Avenue',
'Center Line','MI','Michigan','48015'),('5833','Mary','Hurtado','4865 Juniper Drive','Saint Charles','MI','Michigan','48655'),('9614','Carmen','Ingram','1056 Eagle Drive',
'Detroit','MI','Michigan','48219');

CREATE TABLE proceduredetails (type VARCHAR(20), subcode INT(10), descr VARCHAR(40), price int(10));
INSERT INTO proceduredetails VALUES('OFFICE FEES',1,'Office Call',32),('OFFICE FEES',2,'Emergency',100),('OFFICE FEES',3,'Reck',24),
('GROOMING',1,'Bath',15),('GROOMING',2,'Flea Dip',15),('GROOMING',3,'Flea Spray',10),('VACCINATIONS',1,'Galaxie (DHLPP)',15),('VACCINATIONS',2,'Leukemia',20),
('VACCINATIONS',3,'Lyme',15),('VACCINATIONS',4,'PCR',15),('VACCINATIONS',5,'Rabies',10),('VACCINATIONS',6,'Bordetella',10),('HOSPITALIZATION',1,'All Hospitalization',25),
('ORTHOPEDIC',1,'Amput. per lim thor.',400),('ORTHOPEDIC',2,'Casting',97),('ORTHOPEDIC',3,'Re-Casting',62),('ORTHOPEDIC',4,'Fem. head Ostec.',420),
('ORTHOPEDIC',5,'Lx Patella Repair',305),('ORTHOPEDIC',6,'Metamason Splint',50),('ORTHOPEDIC',7,'Pinning-I.M.',325),('ORTHOPEDIC',8,'Pin Removal',68),
('ORTHOPEDIC',9,'Cast Removal',40),('GENERAL SURGERIES',1,'Anal Gland Caut',150),('GENERAL SURGERIES',2,'Aural Hematoma',108),('GENERAL SURGERIES',3,'Declaw',125),
('GENERAL SURGERIES',4,'Dissolvable Suture',15),('GENERAL SURGERIES',5,'Ear Crop',350),('GENERAL SURGERIES',6,'Gastric Torsion',450);
INSERT INTO proceduredetails VALUES('GENERAL SURGERIES',8,'Umbilical',175);

CREATE TABLE procedurehist(petid VARCHAR(20), prdate DATE,  type VARCHAR(20), subcode INT(10));
INSERT INTO procedurehist VALUES('J6-8562','2016-08-21','GENERAL SURGERIES',8),('M0-2904','2016-07-22','VACCINATIONS',5),
('P2-7342','2016-10-05','VACCINATIONS',5),('X0-8765','2016-03-18','VACCINATIONS',5),('X0-8765','2016-10-03','GENERAL SURGERIES',8),
('M8-7852','2016-09-19','VACCINATIONS',5),('F6-3398','2016-01-12','HOSPITALIZATION',1);
INSERT INTO procedurehist VALUES('P0-1725','2016-07-06','GROOMING',3),('U8-6473','2016-07-10','VACCINATIONS',5),('U4-9376','2016-12-10','VACCINATIONS',5);
INSERT INTO procedurehist VALUES('U8-6473','2016-08-19','GROOMING',1),('U8-6473','2016-12-03','GROOMING',2);
SELECT * FROM procedurehist;
SELECT * FROM proceduredetails;
SELECT * FROM owners;
SELECT * FROM pets;

/* a.	Write a query to find owner names whose pet’s name contains ‘u’ or the pet is a ‘Parrot’ */
SELECT * FROM pets 
WHERE name LIKE '%u%'
OR kind='Parrot';

/* b.	Write a query to find the cumulative sum of total procedures performed for each pet at a monthly level */
WITH petprice AS
(
SELECT ph.petid,
		ph.prdate,
        pd.type,
        pd.subcode,
        pd.price,
		SUM(pd.price) OVER (PARTITION BY ph.petid ORDER BY MONTH(ph.prdate) ASC)  AS monthly_price
FROM procedurehist ph 
INNER JOIN proceduredetails pd
ON ph.type=pd.type AND ph.subcode=pd.subcode
)
SELECT p.petid, p.name, p.age, pp.prdate,pp.price,pp.monthly_price
FROM petprice pp INNER JOIN pets p
ON pp.petid=p.petid;

/* c.	Write a query to extract information for those pets who have undergone procedure type “Vaccinations” with sub code 3, 4 and 5
or undergone procedure type “General Surgeries” with sub code 8,10,13,15,16. */
SELECT ph.petid, p.name, p.kind, p.gender, p.age, ph.type, ph.subcode
FROM procedurehist ph 
INNER JOIN pets p
ON ph.petid=p.petid
WHERE (ph. type='VACCINATIONS' AND ph.subcode = 3 OR 4 OR 5) OR (ph.type='GENERAL SURGERIES' AND ph.subcode = 2 OR 4 OR 8);

/* d.	Write a query to find pet’s information who did not have any procedure performed */
SELECT p.*
FROM pets p LEFT JOIN procedurehist ph
ON p.petid=ph.petid
WHERE p.petid NOT IN 
(SELECT p.petid
FROM pets p INNER JOIN procedurehist ph
ON p.petid=ph.petid);

/*e.	Write a query to find the average price incurred by each owner for their pet’s procedure */
WITH owner_info AS
(
SELECT ph.petid, ROUND(AVG(pd.price)) AS price_per_pet
FROM procedurehist ph 
INNER JOIN proceduredetails pd
ON ph.type=pd.type AND ph.subcode=pd.subcode
GROUP BY ph.petid
)
SELECT p.petid, o.*,oi.price_per_pet
FROM pets p INNER JOIN owners o
ON p.owner_id=o.owner_id
INNER JOIN owner_info oi
ON p.petid=oi.petid
WHERE p.petid IN 
(SELECT petid from procedurehist);

/* f.	Write a query to find the first and last date of procedure performed on each of the pets.
 The output should have columns (Pet Name, First Procedure Date, Last Procedure Date) */
 SELECT p.name, MIN(ph.prdate) AS 'first procedure date' , MAX(ph.prdate) AS 'last procedure date'
 FROM pets p INNER JOIN procedurehist ph
 ON p.petid=ph.petid
 GROUP BY p.name;


