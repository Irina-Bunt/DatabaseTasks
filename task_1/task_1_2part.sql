INSERT INTO Users 
VALUES 
(1, 'Касаткин Артём', 'Артём', 'artem@gmail.com', 'Администрация'),
(2, 'Петрова София', 'Софа', 'sofia@gmail.com', 'Бухгалтерия'),
(3, 'Дроздов Федр', 'Федя', 'fedr@gmail.com', 'Администрация'),
(4, 'Иванова Василина', 'Вася', 'vasilina@gmail.com', 'Бухгалтерия'),
(5, 'Беркут Алексей', 'Алекс', 'alexey.b@gmail.com', 'Поддержка пользователей'),
(6, 'Белова Вера', 'Вера', 'vera@gmail.com', 'Производство'),
(7, 'Макенрой Алексей', 'Лёха', 'alexey.m@gmail.com', 'Производство');

SELECT * FROM public.users;

DELETE FROM Users;
