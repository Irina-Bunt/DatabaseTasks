SELECT * FROM public.Task;

SELECT * FROM Task2;

SELECT u.name,t.header
    FROM Users u, Task t
    WHERE u.user_id = t.user_do_id;
	
SELECT u.name,t.header
    FROM Users u, Task t;
	
SELECT * FROM Task
    WHERE user_do_id IS NULL;
	
CREATE TABLE Task2 AS (SELECT * FROM Task);

SELECT *
    FROM Users
    WHERE name NOT LIKE '%а'