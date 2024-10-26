<%--
  Created by IntelliJ IDEA.
  User: Semyon
  Date: 16.10.2024
  Time: 23:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>buzzor</title>
</head>
<body>
<h1><%= "buzzor" %></h1
<p>С возвращением!</p>
<p><form action="MainPage" method="POST">
    <label for="login">Логин:</label>
    <input type="text" id="login" name="login"required><br><br>

    <label for="password">Пароль:</label>
    <input type="password" id="password" name="password" required><br><br>

    <button type="submit">Войти</button>
    <p>${error_login_and_password}</p>
</form>
</p>
<p>Нужна учетная запись? <a href="RegistrationPage">Зарегистрироваться</a></p>
<p>Powered by ₽$</p>
</body>
</html>
