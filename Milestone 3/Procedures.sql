USE My_School;

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
create procedure Add_Courses (course_code int,course_name varchar(20),
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
phone_number,salary,school_level,school_name);
insert into Administrators (username)
values (username);
END IF ;
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
delimiter ;

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
create procedure Employee_Salary ()
begin
update Teachers
set salary = 500*years_of_experience ;
end //
delimiter ;


delimiter //
create procedure Delete_Teachers_Student (admin_username varchar(50))
  begin
    delete t from
      Teachers t inner join Employees e
        on e.username = t.username
   where e.username = @admin_username ;
end//
delimiter ;

delimiter //
create procedure Update_Salary (school_name varchar(50))
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
create procedure Assign_Teacher_Username (in first_name varchar (20),in last_name varchar (20) )
begin
select e.first_name,e.last_name
from Employees e inner join Teachers t
where e.first_name = @first_name and e.last_name = @last_name ;
update Teachers 
set t.username =  concat(e.first_name,e.last_name) and t.verified = true
and e.employee_password = concat(e.years_of_experience,e.last_name)
and e.salary = e.years_of_experience*500 ;
end //
delimiter ;

delimiter //
create procedure Assign_Student_Username (in first_name varchar (20), in s_ssn int )
begin
select student_name , ssn , student_password
from Students
where student_name = @first_name and ssn =@s_ssn ;
update Students 
set student_username =  concat(student_name,ssn) ;
update Students 
set student_password = concat(birthdate,student_username) ;
update Students 
set accepted = true ;

end //
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
create procedure Assign_Teachers_Course (course_code int , teacher_username varchar (20)
, course_level varchar (20))
begin
update Courses
set teacher_username = @teacher_username
where course_code = @course_code and level_name = @course_level ;
end //
delimiter ;

delimiter //
create procedure Assign_Teacher_As_Supervisor (username varchar (20))
begin
update Teachers
set supervisor = true
where username = @username and years_of_experience > 15 ;
end //
delimiter ;

delimiter //
create procedure Accept_or_Reject (parent_username varchar(20),acceptance bit )
begin
update School_Parent_Student
set accepted = @acceptance
where parent_username = @parent_username ;
end //
delimiter ;

delimiter //
create procedure Signup_Parent (parent_username varchar (20),parent_firstname varchar (20),
parent_lastname varchar (20),parent_address varchar (20),parent_email varchar (20),
parent_password varchar (20),
parent_home_phone_number int )
begin
if parent_username is null or parent_firstname is null or parent_lastname is null or
parent_address is null or parent_email is null or parent_password is null or
parent_home_phone_number is null
then select "We don't accept null" ;
else insert into Parents (parent_username,parent_firstname,parent_lastname ,
parent_address,parent_email,parent_password,parent_home_phone_number)
values (parent_username,parent_firstname,parent_lastname ,
parent_address,parent_email,parent_password,parent_home_phone_number) ;
end if ;
end //
delimiter ;

delimiter //
create procedure Parent_Apply_Children (school_name varchar (20),
school_Level varchar (20),parent_username varchar (20),student_ssn int,accepted bit )
begin
if school_name is null or school_level is null or parent_username is null or student_ssn
is null
then select "We don't accept null";
else
insert into School_Parent_Student (school_name,school_level,parent_username,student_ssn,accepted)
values (school_name,school_level,parent_username,student_ssn,null);
end if ;
end //
delimiter ;

delimiter //
create procedure Schools_Accepted_Child (parent_username varchar (20))
begin
select school_name , student_ssn
from School_Parent_Student s
where s.parent_username = @parent_username and bit = true
group by student_ssn ;
end //
delimiter ;
#NOT-COMPLETE till we meet again
delimiter //
create procedure Choose_School (school_name varchar(20),parent_username varchar (20))
begin
update Students
set school_name = @school_name;
end //
delimiter ;

delimiter //
create procedure View_Reports (parent_username varchar (20))
begin
select report_content
from Reports r inner join School_Parent_Student s
on r.parent_username = s.parent_username
where s.parent_username = @parent_username ;
end //
delimiter ;

delimiter //
create procedure Reply_Reports (parent_username varchar (20), reply varchar (20),
student_username varchar (20))
begin
update Reports
set report_reply = @reply
where parent_username = @parent_username and student_username = @student_username ;
end //
delimiter ;

delimiter //
create procedure View_Schools_Of_Children (parent_username varchar (20))
begin
select school_name
from School_Parent_Student s
where s.parent_username = @parent_username and accepted = true ;
end //
delimiter ;

delimiter //






#
# create procedure View_Announcement (parent_username varchar (20))
# begin
# select school_name , ann.description
# from Announcements an inner join Administrators ad on
# an.administrator_username = ad.username
# inner join
# where an.date >= curdate()
#   AND an.date < curdate() + interval 10 day and
#
# END//
# delimiter ;
#




DELIMITER //
create procedure View_Announcement (school_name varchar (20),parent_username varchar (20))
begin
select ann_description
from Announcements an inner join Employee e on an.administrator_username = e.username
inner join School_Parent_Student ssp on ssp.schoo_name = e.school_name
where e.school_name = @school_name and ssp.parent_username = @parent_username ;
end //
delimiter ;


delimiter //
create procedure Rate_Teachers (parent_username varchar (20),student_username varchar(50),rating int)
begin
declare t_username varchar(50); # hinna b3ml variable gded ahoot feh el teacheruser name ely hytl3 mn ely h3mlo ta7t

select teacher.username tu into t_username
from Course_Student_Teacher tsc
where tsc.student_username=student_username  ;    #el mfrod fe relation been course w teacher w student shoof esmaha eh w hotaha makan (course_teacher_student)
insert into Parent_rate_teacher values(parent_username,t_username, rating);
end//
delimiter ;

delimiter //
create procedure Delete_Parent_rate(parent_username varchar(50))
begin
delete from Parent_Rate_Teacher #bos shoof el syntax bt3k bytktb ezayy .. el mfrodd 3nde kda sah
where parent_username=@parent_username ;
end //
delimiter ;

delimiter //
create procedure View_overall_rating (teacher_username varchar(50))
begin
select avg (rating)
from parent_rate_teacher ptt
where teacher_username=ptt.teacher_username;
#declare t_username varchar(50);
#select teacher.username into t_username
#from Teacher t
#where teacher_username= t.username;
end //
delimiter ;












delimiter //
create procedure Top_Schools (parent_username varchar (50))
begin
SELECT s.school_name
FROM Schools s
inner join School_Parent_Student sps
on s.school_name = sps.school_name
inner join Reviews r
on r.school_name = s.school_name
where sps.parent_username <> @parent_username
GROUP BY s.school_name
HAVING count(school_name) > 1
order by count(r.school_name) desc
limit 10;
end//
delimiter ;

#WARNING
#DROP PROCEDURE IF EXISTS Top_International_School;
delimiter //
create procedure Top_International_School ()
begin
select s.school_name
from schools s
inner join Reviews r
on r.school_name = s.school_name
where s.school_type = "International"
order by count (s.school_name) desc
limit 1 ;
end //
delimiter ;

#DROP PROCEDURE IF EXISTS Edit_School_info;

delimiter //
create procedure Edit_School_info (school_name varchar (20),
school_level varchar (20),email varchar (20),
information varchar(100),
vision varchar (100),mission varchar (100),fees int ,
school_type varchar (20),main_language varchar (20),
address varchar (20))
begin
 if @school_name is null then update Schools set school_name = school_name ;
 else update Schools set school_name = @school_name ; end if ;
 if @school_level is null then update Schools set school_level = school_level ;
 else update Schools set school_level = @school_level ; end if ;
 if @email is null then update Schools set email = email ;
 else update Schools set email = @email ; end if ;
 if @information is null then update Schools set information = information;
 else update Schools set information = @information ; end if ;
 if @vision is null then update Schools set vision = vision;
 else update Schools set vision = @vision ; end if ;
 if @mission is null then update Schools set mission = mission ;
 else update Schools set mission = @mission ; end if ;
 if @fees is null then update Schools set fees = fees ;
 else update Schools set fees = @fees ; end if ;
 if @school_type is null then update Schools set school_type = school_type ;
 else update Schools set school_type = @school_type ; end if ;
 if @main_language is null then update Schools set main_language = main_language ;
 else update Schools set main_language=@main_language ; end if ;
 if @address is null then update Schools set address = adress ;
 else update Schools set address =@address ; end if ;
end //
delimiter ;

delimiter //
create procedure Delete_Employees_Students (admin_username varchar (50),student_username varchar (50),
teacher_username varchar (50))
begin
delete s from Students s inner join Employee e on s.school_name = e.school_name
inner join Administrators a on a.admin_username = e.username
where s.username = @student_username ;

Delete t from Teachers t inner join Employee e on s.school_name = e.school_name
inner join Administrators a on a.admin_username = e.username
where t.username = @teacher_username ;
end //
delimiter ;






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
delimiter ;
#drop procedure view_my_courses;

-- call view_my_courses('salem11');


#3
delimiter //
create procedure post_assignment(t_usern varchar(20) ,course_n varchar(20) , p_date datetime , d_date datetime , content varchar(100 ))
begin
declare course_c int;
select course_code into course_c
from Courses
where course_name = course_n;

insert into Assignemts(posting_date ,content, due_date)
Values (p_date , content,d_date);

insert into Assignments_post_Courses_Teachers (course_name, course_code, teacher_username)
values (course_n ,course_c , t_usern);

end
//
delimiter ;


#4
delimiter //
create procedure view_solutions (t_username varchar(20))
begin
select ass.solution , asss.student_id , apct.course_name , a.content
from Assignments_post_Courses_Teachers apct inner join Assignments_Solves_Students ass on apct.ass_id = ass.ass_id  inner join Students s on ass.student_ssn =  s.ssn inner join Assignments a on apct.ass_id = a.id and ass.ass_id = a.id
where t_username = apct.teacher_username
order by s.student_id;
end
//
delimiter;

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










#Student Stories

DROP PROCEDURE IF EXISTS updateInfromation;
DELIMITER //
CREATE PROCEDURE updateInfromation(s_username     VARCHAR(20), s_ssn INT, s_name VARCHAR(20), s_gender VARCHAR(20),
                                   s_birthdate    DATETIME, s_password VARCHAR(20), s_school_name VARCHAR(20),
                                   s_school_level VARCHAR(20))
  BEGIN
    UPDATE Student
    SET ssn            = s_ssn, student_name = s_name, gender = s_gender, birthdate = s_birthdate,
      student_password = s_password, school_name = s_school_name, school_Level = s_school_level
    WHERE student_username = s_username;
  END//
DELIMITER ;

DELIMITER //





DROP PROCEDURE IF EXISTS viewCourses;
DELIMITER //
CREATE PROCEDURE viewCourses(s_ssn int)
  BEGIN
    DECLARE studentGrade VARCHAR(20);
    SELECT s.grade INTO studentGrade
      FROM Student_Enrolled_Level s
      WHERE s_ssn=s.student_ssn;

    SELECT c.course_name
    FROM Level l INNER JOIN Course c ON c.course_grade=studentGrade;

  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE PostQuestion(s_ssn int,s_course_name VARCHAR(20),s_course_code VARCHAR(20),question_number INT, s_question VARCHAR(255), answer VARCHAR(255))
  BEGIN
    INSERT INTO Questions (ssn,question_number,course_name,course_code,question)
    VALUES(s_ssn,question_number,s_course_name,s_course_code,s_question);
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE viewQuestions(s_ssn INT)
  BEGIN
  SELECT q.question,q.answer
    FROM Questions q
    WHERE q.ssn!=s_ssn;
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE viewAssignments(s_ssn INT)
  BEGIN
  SELECT ass.content, ass.id
    FROM  Assignments_post_Courses_Teachers apct INNER JOIN Courses_Teachers_Students_Teachers ctst ON apct.course_code=ctst.course_code AND
      apct.course_name=ctst.course_name INNER JOIN Assignments ass ON ass.id=apct.ass_id
      WHERE s_ssn=ctst.sudent_ssn;
  END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE solveAssignments(s_ssn INT,ass_id INT,ass_solution VARCHAR(100))
  BEGIN
    INSERT INTO Assignments_solves_Students(student_ssn,ass_id,solution) VALUES (s_ssn,ass_id,ass_solution);
  END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE viewGrade(s_ssn INT)
  BEGIN
  SELECT ass.grade
    FROM Assignments_post_Courses_Teachers apct INNER JOIN Courses_Teachers_Students_Teachers ctst ON apct.course_code=ctst.course_code AND apct.course_name=ctst.course_name INNER JOIN Assignments_solves_Students ass ON apct.ass_id=ass.ass_id
    WHERE s_ssn=ctst.ssn;
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE viewAnnouncements(s_ssn INT)
  BEGIN

    DECLARE Schoolname VARCHAR(20);

    SELECT s.Schoolname INTO Schoolname
      FROM School s INNER JOIN Student st ON st.school_name=s.school_name
    WHERE st.ssn=s_ssn;



    SELECT *
    FROM Announcement a INNER JOIN  Employee emp ON emp.username=a.administrator_username
    WHERE emp.school_name=Schoolname;

  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE viewActivities (s_ssn INT)
  BEGIN
    SELECT a.*,ata.teacher_username
           FROM ((Activity a INNER JOIN Activity_Teacher_Admin ata ON a.activity_name = ata.activity_name) INNER JOIN Employee emp ON ata.teacher_username=emp.username) INNER JOIN Student st ON st.school_name=emp.school_name
    WHERE s_ssn=st.ssn;
  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE applyForActivities(s_ssn INT,s_activity_name VARCHAR(20))
  BEGIN
    INSERT INTO Activities_Participates_in_Students VALUES (s_ssn,s_activity_name);
  END //


DELIMITER ;
DROP PROCEDURE IF EXISTS studentJoinsClubs;
DELIMITER //
CREATE PROCEDURE studentJoinsClubs(s_ssn INT, s_club_name VARCHAR(20))
  BEGIN
    DECLARE Schoolname VARCHAR(20);

    SELECT s.school_name INTO Schoolname
      FROM School s INNER JOIN Student st ON st.school_name=s.school_name
    WHERE st.ssn=s_ssn and st.school_Level='high';

    INSERT INTO Student_Join_Club VALUES (s_club_name,s_ssn);

  END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE searchByNameOrCode(s_ssn INT,s_course_code INT, s_course_name VARCHAR(20))
  BEGIN
      SELECT c.*
        FROM Course c INNER JOIN Course_Student_Teacher cst ON c.course_name=cst.course_name and c.course_code=cst.course_name INNER JOIN Student st ON st.student_username=cst.student_username
    WHERE s_ssn=st.ssn and (c.course_name=s_course_name OR c.course_code=s_course_code);
  END //
DELIMITER ;