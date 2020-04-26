Create Database My_School;

USE My_School;

CREATE TABLE Schools
(
school_name varchar (20) ,
school_level varchar (20) ,
PRIMARY KEY (school_name,school_level),
email varchar (20),
information varchar(100),
vision varchar (100),
mission varchar (100),
fees int ,
school_type varchar (20),
main_language varchar (20),
address varchar (20) 
);

CREATE TABLE SchooL_Phone_Numbers
(
school_Name varchar (20),
school_Level varchar (20),
phone_num int,
 PRIMARY KEY (school_Name,school_Level,phone_num),
 FOREIGN KEY (school_Name,school_Level) REFERENCES Schools(school_name,school_level) ON DELETE CASCADE

);

create table Levels
(
level_name varchar (20) primary key
);

create table Elementary
(
school_name varchar (20) ,
school_Level varchar (20),
PRIMARY KEY (school_name,school_Level),
supplies varchar (20),
FOREIGN KEY (school_name,school_Level) REFERENCES Schools(school_name,school_level) ON DELETE CASCADE
);

create table Middle
(
school_name varchar (20),
school_Level varchar (20),
 PRIMARY KEY (school_name,school_Level),
 FOREIGN KEY (school_name,school_Level) REFERENCES Schools(school_name,school_Level) ON DELETE CASCADE
);

create table High
(
school_name varchar (20) ,
school_Level varchar (20) ,
 PRIMARY KEY (school_name,school_Level),
 FOREIGN KEY (school_name,school_Level) REFERENCES Schools(school_name,school_level) ON DELETE CASCADE
);
create table Employees
(
username varchar (20) ,
primary key (username),
first_name varchar(20),
last_name varchar (20),
employee_password varchar (20) ,
address varchar (20),
email varchar (20) ,
gender varchar (20),
birth_date datetime NOT NULL,
phone_number int ,
salary int ,
school_name varchar (20) ,
school_Level varchar (20) ,
 foreign key (school_name,school_Level) references Schools(school_name,school_level) on delete CASCADE

);


create table Administrators
(
username varchar (20) primary key,
foreign key (username) references Employees (username) on delete CASCADE
);


create table Teachers
(
username varchar (20) primary key,
foreign key (username) references Employees (username) on delete CASCADE ,
years_of_experience int ,
supervisor varchar (20),
foreign key (supervisor) references Teachers(username) on delete CASCADE
);
create table Parents #modify procedures
(
parent_username varchar (20) primary key,
parent_firstname varchar (20),
parent_lastname varchar (20),
parent_address varchar (20),
parent_email varchar (20),
parent_password varchar (20),
parent_home_phone_number int
);

create table Parent_Phone
(
parent_username varchar (20),
parent_phone_number int ,
primary key (parent_username , parent_phone_number ),
foreign key(parent_username) references Parents(parent_username)
);


create table Students
(
ssn int,
school_name varchar (20),
school_Level varchar (20) ,
id int auto_increment,
PRIMARY KEY (ssn,id),
key(id),
student_username varchar (20),
student_name varchar (20),
gender varchar (20),
birthdate datetime NOT NULL,
age int AS (YEAR("2016-1-1") - YEAR(birthdate)),
student_password varchar(20),
FOREIGN KEY (school_name,school_Level) REFERENCES Schools(school_name,school_level) ON DELETE CASCADE
);

create table Parents_Has_Students
(

student_ssn int ,
parent_username varchar (20) ,
primary key( student_ssn ,parent_username ),
foreign key (student_ssn) references Students(ssn)ON DELETE CASCADE ,
foreign key(parent_username) references Parents(parent_username)ON DELETE CASCADE
);

create table Levels_Enrolled_Students
#Student_Enrolled_Level
(
student_ssn int primary key,
level_name varchar (20) primary key,
grade int,
foreign key (student_ssn) references Student (ssn),
foreign key (level_name) references Levels(level_name)

);


create table Courses
(
course_code int ,
course_name varchar(20),
primary key (course_code ,course_name),
course_description varchar (100),
course_grade int,
level_name varchar (20),
foreign key (level_name) references Levels(level_name) 

);

Create table Courses_prerequisite_Course #not created
(
course_code1 int ,
course_name1 varchar(20),
course_code2 int ,
course_name2 varchar(20),
primary key(course_code1 ,course_name1 ,course_code2 ,course_name2),
Foreign key (course_code1, course_name1  ) references Courses(course_code,course_name) on Delete cascade on update cascade,
Foreign key (course_code2, course_name2  ) references Courses(course_code,course_name) on Delete cascade on update cascade
);


create table Clubs
(
club_name varchar (20),
school_name varchar (20) ,
school_Level varchar (20) ,
PRIMARY KEY (club_name,school_name,school_Level),
purpose varchar (100),
 FOREIGN KEY (school_name,school_Level) REFERENCES Schools(school_name,school_level) ON DELETE CASCADE
);

create table Reviews #Create the table when finish parents and modify the procedures
(
school_name varchar (20),
school_Level varchar (20),
parent_username varchar (20),
PRIMARY KEY (school_name,school_Level,parent_username),
review_text varchar (200),
FOREIGN KEY (school_name,school_Level) REFERENCES Schools(school_name,school_Level) ON DELETE CASCADE,
FOREIGN KEY (parent_username) REFERENCES Parents(parent_username) ON DELETE CASCADE

);


create table Parents_apply_Schools_Students #create when finish parent and student
(
school_name varchar (20),
school_Level varchar (20),
parent_username varchar (20),
student_ssn int,
PRIMARY KEY (school_name,school_Level,parent_username,student_ssn),
accepted bit,
FOREIGN KEY (school_name,school_Level) REFERENCES Schools(school_name,school_level) ON DELETE CASCADE,
FOREIGN KEY (parent_username) REFERENCES Parents(parent_username) ON DELETE CASCADE ,
FOREIGN KEY (student_ssn) REFERENCES Students(ssn) ON DELETE CASCADE 
);



create table Courses_Teaches_Students_Teachers #create when students & courses 
#Course_Student_Teacher
(
 teacher_username varchar (20) ,
 student_ssn int,
 course_code int,
 course_name varchar (20),
 PRIMARY KEY (teacher_username,student_ssn,course_name,course_code),
 foreign key (teacher_username) references Teachers(username) on delete CASCADE ,
 foreign key (course_code,course_name) references Courses(course_code,course_name) ON DELETE CASCADE ,
 foreign key (student_ssn) references Students(ssn) on delete Cascade
);

create table Assignments(
id int primary key auto_increment,
posting_date datetime NOT NULL,
content varchar (100),
due_date datetime NOT NULL
);

create table Assignments_post_Courses_Teachers #Teacher_Course_Assignment
(
ass_id int,
course_name varchar (20),
course_code int,
teacher_username varchar (20),
PRIMARY KEY (course_name,teacher_username,course_code,ass_id),
foreign key (teacher_username) references Teachers(username) on delete CASCADE,
foreign key (course_code,course_name) references Courses (course_code,course_name),
foreign key (ass_id) references Assignments (id)
);

create table Assignments_Solves_Students
(
student_ssn int,
 ass_id int,
 PRIMARY KEY (student_ssn,ass_id),
 grade int,
 solution varchar (100),
 foreign key (student_ssn) references Students(ssn),
 foreign key (ass_id) references Assignments(id)
);


create table Announcements
(
id int primary key auto_increment,
date datetime NOT NULL,
description varchar(200),
ann_type varchar (20),
title varchar (20),
administrator_username varchar (20),
foreign key (administrator_username) references Administrators (username) on delete set null
);

create table Activities
(
activity_name varchar(20) primary key,
activity_date datetime NOT NULL,
activity_type varchar (20),
activity_location varchar(100),
activity_equipment varchar(100),
activity_description varchar(100)
);

create table Activities_Participates_in_Students
(
student_ssn int ,
activity_name varchar(20) ,
primary key(student_ssn, activity_name ),
foreign key (student_ssn) references Students(ssn) on delete cascade,
foreign key (activity_name) references Activities(activity_name) on delete cascade
);

create table Activities_Create_Administrators_Teachers
#Activity_Teacher_Admin
(
teacher_username varchar(20),
administrator_username varchar (20),
activity_name varchar (20),
PRIMARY KEY (teacher_username,administrator_username,activity_name),
foreign key (teacher_username) references Teachers(username) on delete CASCADE ,
foreign key (administrator_username) references Administrators(username) on delete CASCADE ,
foreign key (activity_name) references Activities(activity_name) 
);


create table Clubs_Join_Students
#Student_Join_Club
(
  club_name varchar (20),
  student_ssn int,
  PRIMARY KEY (club_name,student_ssn),
  foreign key (student_ssn) references Students(ssn) on delete CASCADE ,
  foreign key (club_name) references Clubs (club_name) ON DELETE CASCADE
);

create table Questions
(
question_number int auto_increment,
course_code int,
course_name varchar (20),
PRIMARY KEY (question_number,course_name,course_code),
student_ssn int,
question varchar (200),
answer varchar (200),
foreign key (student_ssn) references Students(ssn) on delete CASCADE ,
foreign key (course_code,course_name) references Courses(course_code,course_name) ON DELETE CASCADE 
);

create table Courses_Ask_Students_Questions
#Student_Ask_Course_Question
(
question_number int,
student_SSN int,
course_code int,
course_name varchar (20),
PRIMARY KEY (question_number,student_SSN,course_code,course_name),
foreign key (student_SSN) references Students (ssn)ON DELETE CASCADE ,
foreign key (question_number) references Questions(question_number) ON DELETE CASCADE ,
foreign key (course_code,course_name) references Courses(course_code,course_name) ON DELETE CASCADE 
);

create table Reports
(
report_date datetime NOT NULL ,
teacher_username varchar(20) ,
parent_username varchar (20) ,
student_SSN int ,
primary key(report_date ,teacher_username,parent_username,student_SSN),
report_reply varchar(20),
report_content varchar(20),
teacher_comment varchar (20),
foreign key (teacher_username) references Teachers(username) on delete cascade ,
foreign key(parent_username) references Parents(parent_username)on delete cascade ,
foreign key (student_SSN) references Students(ssn) on delete cascade
);


create table Reports_Write_Teachers
#Teacher_Writes_Report
(
report_date datetime NOT NULL,
teacher_username varchar(20) ,
student_SSN int,
primary key(report_date ,teacher_username ,student_SSN ),
foreign key (report_date) references Reports (report_date) on delete cascade,
foreign key (teacher_username) references Teachers (username)on delete cascade,
foreign key (student_SSN) references Students(ssn)on delete cascade
);

create table Parents_Rate_Teachers
#Parent_Rate_Teacher
(parent_username varchar (20),
teacher_username varchar(20) ,
primary key (parent_username ,teacher_username ),
rating int,
foreign key(parent_username) references Parents(parent_username) on delete cascade,
foreign key (teacher_username) references Teachers (username) on delete cascade
);

create table Buses (
bus_no int auto_increment,
school_name varchar (20) ,
school_Level varchar (20) ,
primary key(bus_no ,school_name , school_Level ),
model varchar(20),
route varchar(100),
capacity int,
foreign key (school_name,school_Level) references Schools(school_name,school_level) 
);

create table Students_join_Buses
(
bus_no int ,
school_name varchar (20) ,
school_Level varchar (20) ,
student_ssn int,
student_id int,
students_c int auto_increment,
primary key(bus_no, school_name ,school_Level,student_ssn, student_id),
key(students_c),
foreign key (school_name,school_Level) references Schools(school_name,school_level) on delete cascade,
foreign key (student_ssn , student_id ) references Students(ssn , id)on delete cascade
);


delimiter //
create procedure Schools_add_Buses(b_model varchar(20),b_route varchar(20) , s_name varchar(20) , s_level varchar(20), b_capacity int)
begin
insert into Buses(school_name ,school_Level ,model,route,capacity)
value (s_name  , s_level , b_model ,b_route , b_capacity);
end
//
delimiter ;

delimiter //
create procedure students_register_Buses(b_no int ,s_name varchar(20), s_level varchar(20), s_ssn int , s_id int)
begin

declare b_c int;
select b.capacity as b_c from Buses b inner join Students_join_Buses sjb on b.bus_no = sjb.bus_no
where b_no = bus_no;

declare s_c int ;
select students_c  as s_c 
from Students_join_Buses 
where b_no = bus_no;

if(s_c<b_c)
then insert into Students_join_Buses (bus_no ,school_name ,school_Level ,student_ssn ,student_id )
Values (b_no  ,s_name , s_level , s_ssn  , s_id );
end if 
end
delimiter ;

/*
create table Schools_offers_Buses
(
bus_no int ,
model varchar(20),
school_name varchar (20) ,
school_level varchar (20) ,
PRIMARY KEY (bus_no , model,school_name,school_level)


);
*/

