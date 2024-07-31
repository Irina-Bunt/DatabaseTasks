--пробные запросы
SELECT header, priority,
    (SELECT name FROM Users
	WHERE (Users.user_id = Task.user_do_id) )
FROM Task
	ORDER BY priority LIMIT 3;
	
SELECT Users.name, Task.header, Task.priority
FROM (Task
JOIN Users ON Users.user_id = Task.user_do_id)
	ORDER BY name, priority;

--Получаем юзеров с кол-вом задач не больше 3
SELECT name
  FROM Users u
 WHERE (SELECT COUNT (*)
         FROM Task
         WHERE u.user_id = user_do_id) <= 3
	ORDER BY user_id;

--Получаем 3 первых задачи с самым высоким приоритетом у юзера 7
WITH Tempor AS (
        --Получаем 3 первых строк в таблице
        SELECT task_id, header, priority, user_do_id
		   FROM Task
			 WHERE user_do_id = 7
		   ORDER BY priority DESC
		   OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
   )
   SELECT * FROM Tempor
   ORDER BY task_id; --Применяем нужную нам сортировку
	
--Получаем юзера с первым самым большим приоритетом задачи
SELECT name
	  FROM Users u
	 WHERE (SELECT user_do_id
			   FROM Task
			   ORDER BY priority DESC
			   OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) = user_id
		ORDER BY user_id;
		
-- первый (плохой вариант) без подзапросов
WITH Over AS (
		SELECT user_do_id AS id_executor, COUNT (*) AS "+"
		FROM Task
		WHERE state = 'Закрыта'
		GROUP BY user_do_id
   ), Under As (
		SELECT user_do_id AS id_executor, COUNT (*) AS "-"
		FROM Task
		WHERE (state = 'Новая' OR state = 'Переоткрыта' OR state = 'Выполняется')
		GROUP BY user_do_id
   )
   SELECT * FROM Over, Under;
-- второй вариант без подзапросов
WITH Over AS (
		SELECT user_do_id AS id_executor, 
		CASE 
			WHEN state = 'Закрыта' THEN (
				SELECT COUNT (*)
				FROM Task
				WHERE state = 'Закрыта')
		END "+",
		CASE 
			WHEN state <> 'Закрыта' THEN (
				SELECT COUNT (*)
				FROM Task
				WHERE (state = 'Новая' OR state = 'Переоткрыта' OR state = 'Выполняется'))
		END "_"
		FROM Task
		GROUP BY user_do_id
   )
   SELECT * FROM Over;

-- оконная функция
-- 2_1
WITH Tempor AS (
        SELECT header, user_do_id, priority,
				rank() OVER (PARTITION BY user_do_id ORDER BY priority DESC) AS enter_priority
		   FROM Task
   )
   SELECT * FROM Tempor
   WHERE enter_priority <= 3
   ORDER BY user_do_id;
   
WITH Tempor AS (
        --Получаем 3 последних строк в упорядоченном наборе
        SELECT header, user_do_id, priority,
				rank() OVER (PARTITION BY user_do_id ORDER BY priority) AS enter_priority
		   FROM Task
   )
   SELECT * FROM Tempor
   WHERE enter_priority <= 3
   ORDER BY user_do_id;
   
-- 2_2	
SELECT COUNT (*) AS "Number of tasks", 
		extract (month from p.data_begin) AS Month,
		extract (year from p.data_begin) AS Year,
		STRING_AGG(DISTINCT t.user_add_id::VARCHAR, ', ') AS user_add
 FROM Project p, Task t
 WHERE p.project_id = t.to_proj_id
 GROUP BY data_begin;
   
-- 2_3
SELECT user_do_id,
	(sum(grade-expenses)+sum(abs(grade-expenses)))/2 as "-",
	(sum(expenses-grade)+sum(abs(expenses-grade)))/2 as "+"
	FROM Task
	GROUP BY user_do_id;
	
-- пример с подзапросом
WITH Tempor AS ( 
	SELECT user_do_id,
		(sum(grade-expenses)+sum(abs(grade-expenses)))/2 as "-",
		(sum(expenses-grade)+sum(abs(expenses-grade)))/2 as "+"
		FROM Task
		GROUP BY user_do_id
	)
SELECT * FROM Tempor;
	
-- 2_4
-- меняются местами и distinct исключает
SELECT distinct
		case when user_add_id < user_do_id then user_add_id else user_do_id end as _add,
    	case when user_add_id < user_do_id then user_do_id else user_add_id end as _do
	from Task
	where user_do_id is not null
    order by _add;

-- жалкие попытки вывести 2 логина (но это, оказалось, не нужно)
SELECT distinct u.login as do, t.user_add_id
	from Task t, Users u 
	where user_do_id is not null
		and u.user_id = t.user_do_id;
	
WITH Tempor1 AS ( 
	SELECT login
		from Users 
		join Task on Users.user_id = Task.user_do_id
		where Task.user_do_id is not null
	), Tempor2 AS ( 
			SELECT login
			from Users 
			join Task on Users.user_id = Task.user_add_id
	)
	SELECT distinct Tempor1.login, Tempor2.login
	FROM Tempor1, Tempor2;

-- 2_5
select login, LENGTH(login) as Length
	from Users
	group by login
	ORDER BY LENGTH(login) DESC LIMIT 1;
	
-- 2_6
select login, octet_length(login), octet_length(login::char)
	from Users;
	
-- 2_7
select user_do_id, max(priority), min(priority)
	from Task
	group by user_do_id
	order by user_do_id;
	
-- 2_8
select avg(grade) 
	from Task
	where state <> 'Закрыта';

-- не работает (?)
select user_do_id, grade, sum(grade)
	from Task
	group by user_do_id, grade
		having grade > avg(grade) filter (where state <> 'Закрыта')
	order by user_do_id;
	
-- работает
with Temp as(
	select avg(grade) as avr
		from Task
		where state <> 'Закрыта'
	)
select t.user_do_id, sum(t.grade)
	from Task t, Temp te
	where t.grade > te.avr
	group by t.user_do_id
	order by t.user_do_id;
	
-- 2_9_a
create view task_counter as
	select user_do_id,
		   count (case when expenses <= grade and state = 'Закрыта' then 1 else null end) as completed,
		   count (case when expenses > grade then 1 else null end) as delayed
	from Task
	where user_do_id is not null
	group by user_do_id
	order by user_do_id;
select * from task_counter;

DROP view [ IF EXISTS ] task_counter;

-- 2_9_b
create view task_statistics as
	select user_do_id, 
	  count(case when state = 'Закрыта' then 1 else null end) as Closed,
	  count(case when state = 'Переоткрыта' then 1 else null end) as Opened,
	  count(case when state = 'Выполняется'  then 1 else null end) as Executing
	from Task
	  where user_do_id is not null
	  group by user_do_id
	  order by user_do_id;
select * from task_statistics;

-- 2_9_c
create view wasted_time as 
	select user_do_id,
	  sum(expenses) as time_gone,
	  (sum(grade - expenses) + sum(abs(grade - expenses)))/2 as underwork,
	  (sum(expenses - grade) + sum(abs(expenses - grade)))/2 as overwork
	from Task
	  group by user_do_id
	  order by user_do_id;
select * from wasted_time;

-- 2_9_d
create view task_def as
	select user_do_id, description, Task.header
	from Task
	group by user_do_id, description, Task.header
	order by user_do_id;
select * from task_def;

-- 2_10_a
select distinct login 
from Users, Task 
where user_id = user_add_id;

-- 2_10_b
select distinct login 
	from Users 
	join Task on user_id = user_add_id
	where user_add_id = (select user_add_id from Task where expenses = 13 limit 1);

-- 2_10_c
select distinct user_id, header, Task.description
	from (select user_id from Users where user_id not in (7)) as not_petrova
	join Task on not_petrova.user_id = user_add_id
	where header in (select header 
						 from Task 
						 join Project on Project.project_id = Task.to_proj_id
						 where (data_begin between '2022-01-01' and '2023-01-01'));
						 