Create Database My_School;

USE My_School;

CREATE TABLE Schools
(
school_name varchar (100) ,
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
verified BIT not null default false,
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
username varchar (208) primary key,
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
student_ssn int ,
level_name varchar (20) ,
primary key(student_ssn , level_name),
grade int,
foreign key (student_ssn) references Students(ssn),
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

create table Parents_reviews_Schools
#Reviews #Create the table when finish parents and modify the procedures
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


create table Courses_Teaches_Students_Teachers 
#Course_Student_Teacher
(
 teacher_username varchar (20) ,
 student_ssn int,
 course_code int,
 course_name varchar (20),
 PRIMARY KEY (teacher_username,student_ssn,course_name,course_code),
 foreign key (teacher_username) references Teachers(username) on delete CASCADE ,
 foreign key (student_ssn) references Students(ssn) on delete Cascade,
 foreign key (course_code,course_name) references Courses(course_code,course_name) ON DELETE CASCADE 
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
foreign key (course_code,course_name) references Courses (course_code,course_name) on delete cascade,
foreign key (ass_id) references Assignments (id) on delete cascade
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

/*
delimiter //
create procedure add_school (school_name varchar (20), 
school_level varchar (20),email varchar (20),
information varchar(100),
vision varchar (100),mission varchar (100),fees int ,
school_type varchar (20),main_language varchar (20),
address varchar (20))
begin
if school_name is null or school_level is null or email is null
or information is null or vision is null or mission is null
or fees is null or school_type is null or main_language is null
or address is null
then SELECT "We dont accept null values";
else insert into Schools (school_name,school_level,email,
information,vision,mission,fees,school_type,main_language,
address)
values (school_name,school_level,email,
information,vision,mission,fees,school_type,main_language,
address);
end if;
end //
delimiter ;


delimiter //
create procedure add_course (course_code int,course_name varchar(20),
teacher_username varchar(20),course_description varchar (100),
level_name varchar (20),prerequisite varchar(20),course_grade int)
begin
if course_code is null or course_name is null or teacher_username is null 
or course_description is null or level_name is null or prerequisite is null
or course_grade is null 
then select "We don't accept null values";
else insert into Courses(course_code ,course_name ,teacher_username ,
course_description,level_name ,prerequisite ,course_grade)
values (course_code ,course_name ,teacher_username ,
course_description,level_name ,prerequisite ,course_grade);
end if ;
end//
delimiter ;


delimiter //
create procedure update_employee ()
 begin
select e.salary
from Employees e
inner join Administrator admin
inner join Schools s
on e.school_name = s.school_name and e.username = admin.username ;
if admin.school_type = "International"
then update Employee
set e.salary = 5000 ;
else update Employee
set e.salary = 3000 ;
end if ;

end //
delimiter ;



delimiter //
create procedure Search_School (in school_name varchar (20))
 begin
 select *
 from Schools
 where (Schools.school_name = @school_name)
 or (Schools.school_level = @school_name)
 or (Schools.address = @school_name);
 end //
 delimiter;
 
 delimiter //
 create procedure Available_School ()
 begin
 select * 
 from Schools 
 group by Schools.school_level;
end //
delimiter ;

delimiter //
create procedure School_info (in school_name varchar (20))
begin
select s.information , r.review_text , e.first_name
from Schools s 
inner join Reviews r 
on s.school_name = r.school_name 
inner join Employees e
on e.school_name = s.school_name
inner join Teachers t
on t.username = e.username 
where s.school_name = @school_name;
end //
delimiter ;


delimiter //
create procedure Assign_Teacher_Username (in first_name varchar (20),in last_name varchar (20) )
begin
select e.first_name,e.last_name
from Employees e inner join Teachers t
where e.first_name = @first_name and e.last_name = @last_name ;
set t.username =  concat(e.first_name,e.last_name); 
end //
delimiter ;

delimiter //
create procedure Assign_Student_Username (in first_name varchar (20), in ssn int )
begin
select st.student_name , st.ssn , st.student_password
from Students st 
where st.student_name = @first_name and st.ssn = @ssn ;
set st.student_username =  concat(st.student_name,st.ssn) ;
set st.student_password = concat(st.birthdate,st.student_username);
end //
delimiter ;

delimiter //
create procedure Employee_Salary ()
begin
update Teachers
set salary = 500*years_of_experience ;
end //
delimiter ;

delimiter //
create procedure Add_Admin (username varchar (20),first_name varchar(20),
last_name varchar (20),employee_password varchar (20) ,address varchar (20),
email varchar (20) ,gender varchar (20),birth_date datetime ,phone_number int ,
salary int , school_level varchar (20) ,school_name varchar (20))
begin
if school_name is null or school_level is null or email is null
or gender is null or salary is null or birth_date is null
or first_name is null or school_type is null or phone_number is null
or address is null or last_name is null or username is null
then SELECT "We dont accept null values";
else insert into Employees (username,first_name,last_name,
employee_password,address,email,gender,birth_date,phone_number,
salary,school_level,school_name)
values (username,first_name,last_name,
employee_password,address,email,gender,birth_date,
phone_number,salary,school_level,school_name)
insert into Administrators (username)
values (username);
end if;
end //
delimiter ;

delimiter //
create procedure Delete_Teachers_Student ()
begin
Drop table Teachers,Students;
end//
delimiter ;

delimiter //
create procedure Add_Announcement (id int,date datetime,description varchar(200),
ann_type varchar (20),title varchar (20),administrator_username varchar (20))
begin
if id is null or description is null or ann_type is null or title is null
or administrator_username is null
then select "We don't accept null values";
else insert into Announcements(id,description,ann_type,title,administrator_username)
values (id,description,ann_type,title,administrator_username);
end if ;
end//
delimiter ;

delimiter //
create procedure Add_Activities (activity_name varchar(20),activity_date datetime,
activity_type varchar (20),activity_location varchar(20),activity_equipment varchar(20),
activity_description varchar(100))
begin
if activity_name is null or activity_date is null or activity_type is null or activity_location
is null  or activity_description is null
then select "We don't accept null values";
else insert into Activities (activity_name,activity_date ,
activity_type,activity_location,activity_equipment,activity_description)
values (activity_name,activity_date ,
activity_type,activity_location,activity_equipment,activity_description);
insert into Activity_Teacher_Admin (teacher_username,administrator_username,activity_name)
values ((SELECT username FROM Teachers ORDER BY RAND() LIMIT 1) ,
(SELECT username FROM Administrators ORDER BY RAND() LIMIT 1),activity_name);
end if ;
end//
delimiter ;

delimiter //
create procedure Change_Teacher_Activity (username1 varchar(20),activity_name varchar(20))
begin
update Activity_Teacher_Admin ac
set teacher_username = username
where ac.activity_name =activity_name;
end //
delimiter ;

delimiter //
*/


#As teacher
#1
delimiter //
create procedure teacher_sign_up(t_first_name varchar(20), t_last_name varchar(20), t_email varchar(20) , t_birthdate datetime , t_address varchar(20) , t_gender varchar(20))
begin
insert into Employees(first_name , last_name , address , email , gender , birth_date)
values (t_first_name ,t_last_name ,t_address , t_email , t_gender , t_birthdate);
end //
delimiter ;

#2
delimiter //
create procedure view_my_courses(t_username varchar(20))
begin
select c.course_code,c.course_name
from Courses_Teaches_Students_Teachers ctst inner join Courses c on ctst.course_code = c.course_code and ctst.course_name = c.course_name
where t_username = ctst.teacher_username
order by c.level_name , c.course_grade;
end//
delimiter 
#drop procedure view_my_courses;
#call view_my_courses ('alaa11');




#3
delimiter //
create procedure post_assignment( p_date datetime , d_date datetime , content varchar(100 ))
begin
insert into Assignemts(posting_date ,content, due_date)
Values (p_date , content,d_date);
end
//
delimiter ;


#4
delimiter //
create procedure view_solutions (t_username varchar(20))
begin
select ass.solution
from Assignments_post_Courses_Teachers apct inner join Assignments_Solves_Students ass on apct.ass_id = ass.ass_id  inner join Students s on ass.student_ssn =  s.ssn
where t_username = f.teacher_username 
order by s.student_id;
end
//
delimiter ;

#5
delimiter //
create procedure grade_assignments(t_username varchar(20) , st_grade varchar(20), st_id int )
begin
update Assignments_Solves_Students ass
inner join Assignments_post_Courses_Teachers apct on apct.ass_id = ass.ass_id inner join Students s on ass.student_ssn =  s.ssn
set ass.grade = st_grade
where tca.teacher_username = t_username;
end
//
delimiter ;

#6
delimiter //
create procedure delete_assignments(ass_id int)
begin
delete from Assignments
where ass_id = id;
end
//
delimiter ;

#7
delimiter //
create procedure write_report (t_username varchar(20) ,r_date datetime , st_username varchar(20) , content varchar(200) , t_comment varchar(100))
begin

declare pa_username varchar(20);

select parent_username into pa_username
from Parents_Has_Students 
where student_username = st_username;

insert into reports(report_date,teacher_username , student_username,parent_username,report_content ,teacher_comment)
Values (r_date , t_username , st_username , phs.parent_username ,content, t_comment);
end
//
delimiter ;


#8
delimiter //
create procedure view_questions (t_username varchar(20))
begin
declare c_name varchar(20);

select cts.course_name into c_name
from Courses_Teaches_Students_Teachers cts
where t_username = cts.teacher_username ;

#declare c_code int;
select q.question_number , q.question
from Courses_Teaches_Students_Teachers  ctst inner join Courses_Ask_Students_Questions casq on ctst.teacher_username = t_username and ctst.course_name = casq.course_name and ctst.course_code = casq.course_code and ctst.student_ssn = casq.student_ssn inner join Questions q
on q.question_number = casq.question_number
where ctst.course_name = c_name
;
end
//
delimiter //




#9
delimiter //
create procedure answer_questions (t_username varchar(20) , t_answer varchar(100))
begin

update Questions q
inner join Courses_Ask_Students_Questions casq on q.question_number = casq.question_number inner join  Courses_Teaches_Students_Teachers ctst on ctst.teacher_username = t_username and ctst.course_name = casq.course_name and ctst.course_code = casq.course_code and ctst.student_ssn = casq.student_ssn
set q.answer = t_answer
;
end

//
delimiter ;

#10
delimiter //
create procedure my_students(t_username varchar(20))
begin

select s.first_name , s.last_name , sel.grade
from Courses_Teaches_Students_Teachers ctst inner join Students s on s.ssn = ctst.student_SSN  inner join Levels_Enrolled_Students les on s.ssn = les.student_SSN  
where t_username = cst.teacher_username
order by s.first_name , s.last_name 
;
end
//
delimiter ;

#11
delimiter //
create procedure student_not_in_club(t_username varchar(20))
begin

select distinct s.student_name
from students s left join Activities_Participates_in_Students apis on s.ssn = apis.students_ssn
where apis.students_ssn IS null

;
end
//
delimiter ;

#12
delimiter //
create procedure most_popular_student(t_username varchar(20))
begin
declare m_ssn int;
declare m_name varchar(20);

select cjs.student_ssn into m_ssn
from Clubs_Join_Students cjs #inner join students s on s.ssn = cjs.ssn
group by student_ssn
order by count(cjs.student_ssn) desc
limit 1;

select s.student_name into m_name
from students s
where s.ssn = m_ssn;
# inner join student s on s.ssn = m.student_ssn inner join Course_Student_Teacher cst on s.ssn = cst.student_ssn and cst.teacher_username =t_username 
#where s.ssn = m.student_ssn and cst.teacher_username = t_username;
end
//
delimiter ;





