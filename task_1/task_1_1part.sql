DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Project CASCADE;
DROP TABLE IF EXISTS Task CASCADE;

CREATE TABLE Users (
	user_id			int PRIMARY KEY,
    name		varchar(102) NOT NULL,
	login           varchar(20) NOT NULL,
	email           varchar(20) NOT NULL,
	department		varchar(23) NOT NULL,
	CONSTRAINT valid_department CHECK (department = 'Производство' OR department = 'Поддержка пользователей' OR department = 'Бухгалтерия' OR department = 'Администрация')
);

CREATE TABLE Project (
	project_id			int PRIMARY KEY,
    project_name		varchar(100) NOT NULL,
	description			text,
	data_begin          date NOT NULL,
	data_end			date
);

CREATE TABLE Task (
	task_id		int PRIMARY KEY,
	header			varchar(100) NOT NULL,
    priority		int NOT NULL,
	description		text,
	state			varchar(50) NOT NULL,
	CONSTRAINT valid_state CHECK (state = 'Новая' OR state = 'Переоткрыта' OR state = 'Выполняется' OR state = 'Закрыта'),
	grade			real NOT NULL,
	expenses		real NOT NULL,
	to_proj_id int REFERENCES Project (project_id) NOT NULL,
	user_do_id int REFERENCES users (user_id),
	user_add_id int REFERENCES users (user_id) NOT NULL
);