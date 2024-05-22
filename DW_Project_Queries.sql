-- to create the database that I work on
/*
Create database DW_Project
*/
----------------------------------------------------------------------------------------------------------

-- Q1: From Api to DB
/*
CREATE TABLE University (
    name            NVARCHAR(255),
    stateProvince   NVARCHAR(255),
    domains         NVARCHAR(MAX),
    webPages        NVARCHAR(MAX),
    alpha_two_code  NVARCHAR(2),
    country         NVARCHAR(255)
);

drop table University    -- drop!

select * from University

delete from University

*/
---------------------------------------------------------------------------------------------------------

-- Q2
/*

create table Employee_Q2_Source(
	ID           int primary key,
	Name         varchar(50),
	City         varchar(50),
	Email        varchar(150),
	Update_Date  date
);

create table Employee_Q2_Target1(
	ID     int primary key,
	Name   varchar(50),
	City   varchar(50),
	Email  varchar(150),
	inserted_Date date
);


create table Employee_Q2_History_Target2(
	ID          int not null,
	Name        varchar(50),
	City        varchar(50),
	Email       varchar(150),
	Start_Date  date,
	End_Date    date DEFAULT '9999-12-30'
);

drop table Employee_Q2_History_Target2   -- drop!
drop table Employee_Q2_Target1           -- drop!
drop table Employee_Q2_Source            -- drop!


insert into Employee_Q2_Source
values(1001,'Ahmed','Cairo','ahmed@mail.com',CONVERT(DATE, '20-4-2024', 105)),
(1002,'Nehal','Giza','nehal@mail.com',CONVERT(DATE, '20-4-2024', 105)),
(1003,'Asem','Cairo','asem@mail.com',CONVERT(DATE, '20-4-2024', 105));

UPDATE Employee_Q2_Source
SET Email = 'HELLO@mail.com',Update_date = '2024-09-10' WHERE ID = 1002;

select * from Employee_Q2_Source order by ID
select* from Employee_Q2_Target1 order by ID
select* from Employee_Q2_History_Target2 order by ID, End_Date

delete from Employee_Q2_History_Target2
delete from Employee_Q2_Target1
delete from Employee_Q2_Source

*/
--------------------------------------------------------------------------------------------------------------------

-- Q3
/*
create table Employee_Q3_Source(
	ID			  int primary key,
	Name		  varchar(50),
	City		  varchar(50),
	Email		  varchar(150),
	Schedule_Date date
);
create table Employee_Q3_Target(
	Emp_Key		 INT IDENTITY PRIMARY KEY,
	ID			 int not null,
	Name		 varchar(50),
	City		 varchar(50),
	Email		 varchar(150),
	Insert_Date  date,
	Active_Flag  int default 1,
	Version_No   int default 1
);

drop  table Employee_Q3_Target      -- drop!
drop  table Employee_Q3_Source      -- drop!


insert into Employee_Q3_Source 
values(1001,'Ahmed','Cairo','ahmed@mail.com',CONVERT(DATE, '20-4-2024', 105)),
(1002,'Nehal','Giza','nehal@mail.com',CONVERT(DATE, '20-4-2024', 105)),
(1003,'Asem','Cairo','asem@mail.com',CONVERT(DATE, '20-4-2024', 105));


UPDATE Employee_Q3_Source
SET Schedule_Date = '2024-09-1' WHERE ID = 1001;

UPDATE Employee_Q3_Source
SET Schedule_Date = '2025-12-12' WHERE ID = 1001;

insert into Employee_Q3_Source 
values(1004,'Amr','Cairo','amr@mail.com',CONVERT(DATE, '20-4-2024', 105));

select * from Employee_Q3_Source order by ID
select* from Employee_Q3_Target order by Emp_Key,ID

delete from Employee_Q3_Target
delete from Employee_Q3_Source
*/

--------------------------------------------------------------------------------------------------------------------


-- Q4
/*
CREATE TABLE Attendance_Device_Source (
    id				int  PRIMARY KEY,
    employee_id		int,
    finger_print_ts	datetime,
    in_out			varchar(3)
);

INSERT INTO Attendance_Device_Source (id, employee_id, finger_print_ts, in_out) VALUES
	('1', '101', '2024-03-12 9:00:00', 'in'),('2', '101', '2024-03-12 10:00:00', 'in'),
	('3', '102', '2024-03-12 9:00:00', 'in'),('4', '103', '2024-03-12 11:00:00', 'in'),
	('5', '104', '2024-03-12 9:15:00', 'in'),('6', '105', '2024-03-12 10:00:00', 'in'),
	('7', '105', '2024-03-12 11:00:00', 'in'),('8', '105', '2024-03-12 11:30:00', 'in'),
	('9', '106', '2024-03-12 09:00:00', 'in'),('10', '107', '2024-03-12 9:00:00', 'in'),
	('11', '108', '2024-03-12 9:00:00', 'in'),('12', '101', '2024-03-12 9:00:00', 'out'),
	('13', '101', '2024-03-12 17:00:00', 'out'),('14', '101', '2024-03-12 19:00:00', 'out'),
	('15', '102', '2024-03-12 17:00:00', 'out'),('16', '103', '2024-03-12 17:00:00', 'out'),
	('17', '105', '2024-03-12 10:00:00', 'out'),('18', '105', '2024-03-12 11:00:00', 'out'),
	('19', '105', '2024-03-12 18:00:00', 'out'),('20', '106', '2024-03-12 19:00:00', 'out'),
	('21', '107', '2024-03-12 14:00:00', 'out'),('22', '108', '2024-03-12 17:00:00', 'out');
	
	INSERT INTO Attendance_Device_Source (id, employee_id, finger_print_ts, in_out) VALUES
	('23', '109', '2024-03-12 9:00:00', 'out'),('24', '108', '2024-04-1 9:00:00', 'in'),
	('25', '108', '2024-04-1 17:00:00', 'out');

create table Employee_Attendence_Details_Target(
	Att_Key		 int IDENTITY primary key,
	Emp_ID		 int not null ,
	Date		 date,
	Time_In	     nvarchar(150),
	Time_Out     nvarchar(150) null,
	Worked_Hours int null,
	State        nvarchar(100)  -- used nvarchar to support unicode
);

drop table Attendance_Device_Source             -- drop!
drop table Employee_Attendence_Details_Target   -- drop!


select * from Employee_Attendence_Details_Target
select * from Attendance_Device_Source


delete from Employee_Attendence_Details_Target

delete from Attendance_Device_Source

*/