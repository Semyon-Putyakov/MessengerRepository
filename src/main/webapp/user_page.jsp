<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>buzzor</title>
    <style>
        /* Общий стиль страницы */
        body {
            display: flex;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Левая панель с чатами */
        #sidebar {
            width: 25%;
            padding: 20px;
            background-color: #f8f9fa;
            border-right: 1px solid #ddd;
        }

        #sidebar h3 {
            margin-top: 0;
            font-size: 1.2em;
            color: #333;
        }

        .chat-list {
            list-style-type: none;
            padding: 0;
        }

        .chat-list li {
            margin: 10px 0;
            font-size: 1em;
            color: #555;
        }

        /* Основной контент */
        #main-content {
            width: 75%;
            padding: 20px;
        }

        h2 {
            margin-top: 0;
            font-size: 1.5em;
            color: #333;
        }

        form {
            margin-bottom: 20px;
        }

        .user-list {
            list-style-type: none;
            padding: 0;
        }

        .user-list li {
            margin: 10px 0;
            font-size: 1em;
            color: #555;
        }

        button {
            padding: 8px 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>

<body>

<div id="sidebar">
    <h3>Чаты</h3>
    <ul class="chat-list">
        <%
            List<String> chats = (List<String>) request.getAttribute("chats");
            if (chats != null && !chats.isEmpty()) {
                for (String chat : chats) {
        %>
        <li><%= chat %></li>
        <%
                }
            }
        %>
    </ul>
</div>

<div id="main-content">
    <h2><%= request.getAttribute("name") %></h2>

    <form action="UserPage" method="post">
        <label for="find_user">Поиск человека:</label>
        <input type="text" id="find_user" name="find_user">
        <button type="submit">Найти</button>
    </form>

    <ul class="user-list">
        <%
            List<String> users = (List<String>) request.getAttribute("users");
            if (users != null && !users.isEmpty()) {
                for (String user : users) {
        %>
        <li><%= user %></li>
        <form action='UserPage' method='post'>
            <input type='hidden' name='selected_user' value='<%= user %>'>
            <button type='submit'>Написать</button>
        </form>
        <%
                }
            }
        %>
    </ul>

    <button onclick="window.location.href='MainPage'; return false;">На главную </button>

    <p>${empty_name}</p>
    <p>${error_user}</p>
    <p>Powered by ₽$</p>
</div>

</body>
</html>
