<%--
  Created by IntelliJ IDEA.
  User: Semyon
  Date: 13.10.2024
  Time: 18:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<head>
    <title>buzzor</title>
</head>
<h2>Регистрация</h2>
<form action="RegistrationPage" method="post">
    <label for="username">Отображаемое имя:</label>
    <input type="text" id="username" name="username"><br><br>

    <label for="login">Логин:</label>
    <input type="text" id="login" name="login"><br><br>

    <label for="password">Пароль:</label>
    <input type="password" id="password" name="password"><br><br>

    <button type="submit">Зарегистрироваться</button>

    <button onclick="window.location.href='MainPage'; return false;">На главную</button>
</form>
<p>${message}</p> <p>${error_user}</p>

<p>Powered by ₽$</p>
</body>
</html>
