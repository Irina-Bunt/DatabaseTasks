-- 2_4 вывести именно 2 логина,  все уникальные пары постановщик-исполнитель

WITH Tempor1 AS ( 
	SELECT login, task_id
		from Users 
		join Task on Users.user_id = Task.user_do_id
		where Task.user_do_id is not null
	), Tempor2 AS ( 
			SELECT login, task_id
			from Users 
			join Task on Users.user_id = Task.user_add_id
	)
	SELECT distinct
		case when Tempor1.login > Tempor2.login then Tempor1.login else Tempor2.login end as _add, 
    	case when Tempor1.login > Tempor2.login then Tempor2.login else Tempor1.login end as _do
	FROM Tempor1, Tempor2
	where Tempor1.task_id = Tempor2.task_id
	order by _add;