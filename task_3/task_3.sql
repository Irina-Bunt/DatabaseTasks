DROP TABLE IF EXISTS members CASCADE;
DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS commanders CASCADE;
DROP TABLE IF EXISTS fights CASCADE;
DROP TABLE IF EXISTS rating CASCADE;

CREATE TABLE teams (
	team_id			int PRIMARY KEY,
    team_name		varchar(20) NOT NULL,
	quantity			int NOT NULL
);

CREATE TABLE members (
	member_id			int PRIMARY KEY,
    name		varchar(102) NOT NULL,
	team REFERENCES teams (team_id) NOT NULL
);

CREATE TABLE commanders (
	member REFERENCES members (member_id) NOT NULL,
    login		varchar(102) NOT NULL,
	team REFERENCES teams (team_id) NOT NULL
);

CREATE TABLE fights (
	vs		varchar(41) NOT NULL,
    winner REFERENCES teams (team_id) NOT NULL,
	loser REFERENCES teams (team_id) NOT NULL
);

CREATE TABLE rating (
	name_of_team REFERENCES teams (team_name) NOT NULL,
    number_of_win 			int NOT NULL,
	number_of_los 			int NOT NULL
);
------------------------------------------------------------
-- 3_1
create table A(
	id serial primary key,
	data varchar(255)
);

create table B(
	id serial primary key,
	data varchar(255),
	constraint aid foreign key(id) references A(id) on delete cascade 
);

select * from a,b;

alter table A
rename column data to Data;

insert into A(id, data) values(1, 'data 1');
insert into A(id, data) values(2, 'data 2' );

insert into B(id, data) values(1, 'data 1');

alter table B alter column data set not null; -- добавить ограничение not null
alter table A alter column data set not null;

alter table B add unique (data); -- добавить ограничение unique
alter table A add unique (data);

-- будет ошибка
update A
set data = null
where id = 1;

insert into A(id, data) values(3, null);
insert into A(id, data) values(null, 'data 3');
insert into A(id, data) values(3, 'data 3');
insert into B(id, data) values(3, 'data 3');
--

delete from B
where id = 1;
insert into B(id, data) values(1, 'data 1(2.0)');

-- будет ошибка
drop table A;
--

select * from A;
select * from B;

delete from A
where id = 1;

-- 3_2
DROP TABLE IF EXISTS online_skhool CASCADE;
DROP TABLE IF EXISTS link CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS status CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS admins CASCADE;
DROP TABLE IF EXISTS director CASCADE;

create table online_sсhool(
	sсhool_name varchar(255) not null primary key
);

create table link(
	sсhool_name varchar(255) not null primary key,
	link_name varchar(255) not null,
	constraint sk_n unique foreign key(sсhool_name) references online_sсhool(sсhool_name)
);

create table course(
	course_id serial primary key,
	skhool varchar(255) not null,
	course_name varchar(255) not null,
	teacher varchar(255) not null,
	constraint sk foreign key(sсhool) references online_sсhool(sсhool_name)
);

create table status(
	status_id serial primary key,
	status_ varchar(255) not null,
	constraint valid_status check (status_ = 'pupil' or status_ = 'teacher' or status_ = 'admin')
);

create table users(
	user_id serial primary key,
	login varchar(255) not null unique,
	fio varchar(255) not null,
	sсhool varchar(255) not null,
	constraint sk foreign key(sсhool) references online_sсhool(sсhool_name)
);

create table users_status(
	user_id serial not null,
	status_id serial not null,
	constraint us foreign key(user_id) references users(user_id),
	constraint st foreign key(status_id) references status(status_id),
	primary  key(user_id, status_id)
);

create table director(
	director_id serial primary key,
	director varchar(255) not null,
	skhool_id serial not null,
	skhool varchar(255) not null,
	constraint valid_skhool foreign key(skhool) references online_skhool(skhool_name)
);

insert into online_skhool(skhool_name) values
('Foxford'),
('АНОО «Дом знаний»'),
('Цифровая онлайн-школа «БИТ»'),
('ЧОУ «Онлайн-гимназия №1»');

insert into link(skhool_name, link_name) values
('Foxford', 'https://foxford.ru/'),
('АНОО «Дом знаний»', 'https://domznaniy.school/'),
('Цифровая онлайн-школа «БИТ»', 'https://school-bit.ru/'),
('ЧОУ «Онлайн-гимназия №1»', 'https://og1.ru/');

insert into course(skhool, course_name, teacher) values
('Foxford', 'матиматика', 'Петров И.И.'),
('АНОО «Дом знаний»', 'физика', 'Иванов А.А.');

insert into users(user_id, login, fio, skhool) values
(1, 'Саня', 'Белов А.А.', 'Foxford'),
(2, 'Андрей', 'Комаров А.С.', 'АНОО «Дом знаний»'),
(3, 'Сергей', 'Сергеев', 'ЧОУ «Онлайн-гимназия №1»'),
(4, 'Вика', 'Кучендаева А.И', 'Foxford'),
(5, 'Рома', 'Шипилов Р.Э', 'Foxford');

insert into status(status_) values
('pupil'),
('teacher'),
('admin');

insert into admins(user_id, status_id) values
(1,1),
(2,2),
(3,2),
(4,1),
(5,1);

-- users, status, users_status многие ко многим
-- online_skhool, users один ко многим
-- online_skhool, link один к одному

--3_3
--аномалии 
--(select anomaly)
create table certification(
	id serial primary key,
	fio varchar(255) not null,
	DOB varchar(255) not null unique
);

insert into certification(fio, DOB) values 
('Белов Сергей Игоречив', '07.10.2000'),
('Комаров Константин', '22.07 1977 г.'),
('Иванов В.И.', '18.03');

select --неправильный ввод, из-за чего потеря data
	split_part(fio, ' ', 1) as surname, 
	split_part(fio, ' ', 2) as name, 
	split_part(fio, ' ', 3) as patronymic,
	split_part(DOB, '.', 1) as day,
	split_part(DOB, '.', 2) as month,
	split_part(DOB, '.', 3) as year
from certification;

--(insertion anomaly)
create table play(
	player_name varchar(10), 
	team_name varchar(50),
	primary key(team_name)
)

insert into play(player_name, team_name) values
('Аня','Огонь'),
('Лиза', 'Тюлень');

insert into play(player_name, team_name) values('Саша', null); --нарушение условий ключа

--(deletion, update anomaly)
create table list(
	note varchar(255) primary key
);

create table system(
	id int primary key,
	name varchar(255) not null,
	notebook varchar(255) not null unique,
	constraint n foreign key(notebook) references list(note)
);

insert into list(note) values
('jojo'),
('888-555');

insert into system(id, name, notebook) values
(1, 'Alex', 'jojo'),
(2, 'Dima', '888-555');

delete from list where note = 'jojo';  --потеря информации

insert into list(note) values ('ttt');
insert into system(id, name, notebook) values (3, 'Alex', 'ttt');
update system set name = 'Alan' where name = 'Alex'; --при смене имени нужно менять data во всей таблице, а не в ячейке

select * from list;
select * from system;

--3_4
--1нф----------
create table users(
	user_id serial not null,
	login varchar(255) not null unique,
	fio varchar(255) not null,
	place_learn varchar(255) not null
);

create table users1nf(
	user_id serial not null,
	login varchar(255) not null unique,
	fio varchar(255) not null,
	scholl_name varchar(255) not null,
	link varchar(255) not null
);
--------------

--2нф--------------
create table users2nf(
	user_id serial primary key,
	login varchar(255) not null unique,
	fio varchar(255) not null,
	scholl_name varchar(255) not null,
	link varchar(255) not null,
	course_id serial not null,
	constraint cor foreign key(course_id) references course2nf(course_id)
);

create table course2nf(
	course_id serial primary key,
	teacher varchar(255) not null,
	subject varchar(255) not null 
);
-----------------

--3нф--------------
create table users3nf(
	user_id serial primary key,
	login varchar(255) not null unique,
	fio varchar(255) not null,
	scholl_name varchar(255) not null,
	course_id serial not null,
	constraint cor foreign key(course_id) references course3nf(course_id),
	constraint sch foreign key(scholl_name) references scholl3nf(scholl_name)
);

create table scholl3nf(
	scholl_name varchar(255) primary key,
	link varchar(255) not null
);

create table course3nf(
	course_id serial primary key,
	teacher varchar(255) not null,
	subject varchar(255) not null
);
-----------------

--4нф--------------
create table users4nf(
	user_id serial primary key,
	login varchar(255) not null unique,
	fio varchar(255) not null,
	scholl_name varchar(255) not null,
	course_id serial not null,
	constraint cor foreign key(course_id) references course4nf(course_id),
	constraint sch foreign key(scholl_name) references scholl4nf(scholl_name)
);

create table scholl4nf(
	scholl_name varchar(255) primary key,
	link varchar(255) not null
);

create table course3nf(
	course_id serial primary key,
	teacher varchar(255) not null,
	subject varchar(255) not null,
	classroom int not null,
);

create table course4nf(
	course_id serial primary key,
	teacher varchar(255) not null,
	subject varchar(255) not null,
	constraint sub foreign key(subject) references subject4nf(subject)
);

create table subject4nf(
	subject varchar(255) primary key,
	classroom int not null
);
--------------