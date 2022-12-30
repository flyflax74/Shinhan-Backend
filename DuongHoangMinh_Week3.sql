-- Bai 1: Procedure 
-- 1.1 
create or replace procedure depth_info(de_id in number, de_store out DEPARTMENTS%ROWTYPE)
as 
begin
select * into de_store from departments where department_id = de_id;
end;
declare de_store DEPARTMENTS%ROWTYPE;

-- 1.2
create or replace procedure add_job(j_id in varchar2, j_title varchar2)
as
begin
insert into JOBS(job_id, job_title) values (j_id, j_title);
end;

--1.3
create or replace procedure update_comm(emp_id in number)
as
begin 
update employees 
set commission_pct = commission_pct*1.05 where employee_id = emp_id;
end;

--1.4
create or replace procedure add_emp(emp_id in number, f_name in varchar2, l_name in varchar2, email in varchar2, p_num in number, h_date in date, j_id in varchar2, sal in number, commisson in number, mange_id in number, depart_id in number)
as
begin
insert into employees values (emp_id, f_name , l_name , email , p_num, h_date , j_id , sal , commisson , mange_id , depart_id);
end;

--1.5
create or replace procedure detele_emp(emp_id in number)
as
begin
delete from employees where employee_id = emp_id;
end;

--1.6
create or replace procedure find_emp(fn out varchar2)
as
begin
    select EMPLOYEES.LAST_NAME into fn
    from EMPLOYEES join JOBS 
    on EMPLOYEES.SALARY between JOBS.MIN_SALARY and JOBS.MAX_SALARY;
end;

--1.7

--1.8
create or replace procedure job_his(emp_id in number)
is
    cursor get_his
    is SELECT employee_id, start_date, end_date
    from job_history 
    where employee_id = emp_id;
BEGIN
    for h_var in get_his
    loop
        dbms_output.put_line('Employee ID:' || h_var.employee_id || ' - START DATE: ' || h_var.start_date || ' - END DATE: ' || h_var.end_date);
    end loop;
END;


-- Bai 2: FUNCTION
--2.1 
create or replace function Sum_salary(de_id in number)
return NUMBER
is 
Tol number := 0;
begin
    select sum(salary) into Tol from EMPLOYEES where department_id = de_id;
    return Tol;
end;

--2.2
create or replace function name_con(coun_id varchar2)
return varchar2
is
    name_var varchar2(30);
begin
    select country_name into name_var from countries where country_id = coun_id;
    return name_var;
end;

--2.3
create or replace function annual_comp(emp_id in number)
return number
is sal_store number; com_store number; Tol number;
begin
    select salary into sal_store from employees where employee_id = emp_id;
    select commission_pct into com_store from employees where employee_id = emp_id;
    Tol := sal_store*(1+com_store);
    return Tol;
end;

--2.4
create or replace function avg_salary(dep_id in number)
return number
is 
avg_num number;
Tol number := 0;
begin
    select sum(salary) into Tol from EMPLOYEES where department_id = dep_id;
    select count(salary) into avg_num from EMPLOYEES where department_id = dep_id;
    return Tol/avg_num;
end;

--2.5
create or replace function  time_work(id in employees.employee_id%type )
return number
is 
time_work_out number;
begin
    select months_between(sysdate,hire_date) into time_work_out  from employees where employees.employee_id=id ;
    return time_work_out;
end;


-- Bai 3: TRIGGER
--3.1
create or replace trigger hire_date_trigger
after update or insert
on employees
for each row
declare hire_date_var date;
begin
    if(hire_date_var > sysdate)
    then raise_application_error('Hire date is wrong');
    end if;
end;

--3.2
create or replace trigger salary_trigger
before update or insert on jobs 
for each row
begin
    if(:new.min_salary > :new.max_salary)
    then raise_application_error('Max Salary is less than Min Salary');
    end if;
end;

--3.3
create or replace trigger job_date_trigger
before update or insert on job_history
for each row
begin
    if(:new.start_date > :new.end_date)
    then raise_application_error('Start date must be less');
    end if;
end;

--3.4 
create or replace trigger sal_comm_trigger
before update on employees
for each row
begin
    if(:new.salary < :old.salary) 
    then raise_application_error('New salary must be more than current salary');
    end if; 
    if(:new.commission_pct < :old.commission_pct)
    then raise_application_error('New commission must be more than the current commission');
    end if;
end;

