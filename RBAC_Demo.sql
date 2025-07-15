# Role Base Access Control Demo
# Create table with open access
create user admin;
alter user admin with password 'passme326';

create table employee ( empno int, ename text, address text, salary int, account_number text );

insert into employee values (1, 'john', '2 down str',  20000, 'HDFC-22001' );
insert into employee values (2, 'clark', '132 south avn',  80000, 'HDFC-23029' );
insert into employee values (3, 'soojie', 'Down st 17th',  60000, 'ICICI-19022' );
select * from employee;

# DBA user has access to table.  Admin has access, too.  Lets provide alternative
revoke SELECT on employee from admin ;
create view emp_info as select empno, ename, address from employee;
grant SELECT on emp_info TO admin;

# connect as admin to test
\c postgres admin
select * from employee;
# permission denied for salary info:
select * from emp_info;
select * from employee;

grant select (empno, ename, address) on employee to admin;
\c postgres admin
select empno, ename, address, salary from employee;
select empno, ename, address from employee;

## demo column encryption for "account" column
CREATE EXTENSION pgcrypto;
\dx
create user finance with password 'passme326';
grant select (empno, ename, address,account_number) on employee to finance;
TRUNCATE TABLE employee;
insert into employee values (1, 'john', '2 down str',  20000, pgp_sym_encrypt('HDFC-22001','emp_sec_key'));
insert into employee values (2, 'clark', '132 south avn',  80000, pgp_sym_encrypt('HDFC-23029', 'emp_sec_key'));
insert into employee values (3, 'soojie', 'Down st 17th',  60000, pgp_sym_encrypt('ICICI-19022','emp_sec_key'));
select * from employee;

\c postgres finance
select empno, ename, address, account_number from employee;
select empno, ename, address,pgp_sym_decrypt(account_number::bytea,'emp_sec_key') from employee;
select empno, ename, address,pgp_sym_decrypt(account_number::bytea,'random_key' ) from employee;
# if incorrect key provided, query will fail

## Row Level Security Demo
\c postgres postgres
DROP VIEW emp_info;
DROP TABLE employee;
create table employee ( empno int, ename text, address text, salary int, account_number text );
insert into employee values (1, 'john', '2 down str',  20000, 'HDFC-22001' );
insert into employee values (2, 'clark', '132 south avn',  80000, 'HDFC-23029' );
insert into employee values (3, 'soojie', 'Down st 17th',  60000, 'ICICI-19022' );
select * from employee;
# create user who can see only their data
create user john with password 'passme326';
create user clark with password 'passme326';
create user soojie with password 'passme326';
grant select on employee to john;
grant select on employee to clark;
grant select on employee to soojie;

CREATE POLICY emp_rls_policy ON employee FOR ALL TO PUBLIC USING (ename=current_user);
ALTER TABLE employee ENABLE ROW LEVEL SECURITY;
# policy implemented so users can only view data with their own connection
\c postgres john
select * from employee;

## Row Security Syntax
ALTER TABLE ... DISABLE ROW LEVEL SECURITY;
ALTER TABLE .. FORCE ROW LEVEL SECURITY;
ALTER TABLE .. NO FORCE ROW LEVEL SECURITY;
DROP POLICY emp_rls_policy ON employee;


Ref:  https://www.enterprisedb.com/postgres-tutorials/how-implement-column-and-row-level-security-postgresql