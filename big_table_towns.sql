\echo create large table TOWNS with FK on Departments
\echo this table will DROP public.towns public.department
\prompt 'Press Enter to continue  ' user_prompt
truncate table departments cascade;
drop table departments cascade;
drop table towns;

CREATE TABLE Towns (
  id SERIAL UNIQUE NOT NULL,
  code VARCHAR(10) NOT NULL, -- not unique
  article TEXT,
  name TEXT NOT NULL, 
  department VARCHAR(4) NOT NULL, 
  UNIQUE (code, department)
);

insert into towns (
    code, article, name, department
)
select
    left(md5(i::text), 10),
    md5(random()::text),
    md5(random()::text),
    left(md5(random()::text), 4)
from generate_series(1, 1000000) s(i);

CREATE TABLE Departments (code VARCHAR(4), UNIQUE (code));

insert into departments(code) select distinct(department) from towns;

ALTER TABLE public.towns ADD CONSTRAINT towns_departments_fk FOREIGN KEY (department) REFERENCES public.departments(code);

