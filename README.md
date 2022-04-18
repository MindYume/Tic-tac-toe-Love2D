# Tic-tac-toe-Love2D


## Описание
Данная игра была создана с помощью фреймворка Love2D на языке Lua

## Установка
### 1 Скачайте файлы игры в любую папку
```bash
git clone https://github.com/MindYume/Laravel-feedback.git
```

Реализованные 

### 1 Скачайте и установите Open Server
https://ospanel.io/

### 2 Зайдипе в папку \openserver\domains и скачайте проект
```bash
git clone https://github.com/MindYume/Laravel-feedback.git
```

### 3 Запустите Open Server, и зайдите в настройки
![](images/settings.png)
### 4 В настройках зайдите в раздел "Домены" и добавтье домен с любым именем
![](images/domain1.png)
![](images/domain2.png)
![](images/domain3.png)

### 5 Переименуйте .env.example в .env

### 6 Сгенерируйте ключ приложения
```bash
php artisan key:generate
```

### 7 Введите следующие данные в .env:
    DB_DATABASE=feedback_laravel - название базы данный
    DB_USERNAME - логин базы данный
    DB_PASSWORD - пароль базы данных
    MAIL_HOST - адрес s mtp сервера
    MAIL_PORT - порт mtp сервера
    MAIL_USERNAME - логин от почты для отправления писем
    MAIL_PASSWORD - пароль от почты
    MAIL_ENCRYPTION=lts
    MAIL_FROM_ADDRESS="hello@example.com" - почтовый адрес отправителя
![](images/env1.png)
![](images/env2.png)

### 8 Создайте базу данных с названием feedback_laravel и кодировкой utf8_unicode_ci

### 9 Создайте таблицы базы данных из миграций. 
Для этого запуствите консоль через Open Server, зайдите в папку с проектом и запустите следующую команду
```bash 
php artisan migrate
```
![](images/migration.png)
### 10 Теперь вы пожете запустить Open Server и в любом браузере ввести название домена, котрое вы дали проекту, и посмотреть на результат.
![](images/interface3.png)
