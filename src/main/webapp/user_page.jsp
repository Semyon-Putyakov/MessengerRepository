<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%= request.getAttribute("name") %> | buzzor</title>
</head>

<body>

<div id="sidebar">
    <h3>Чаты</h3>
    <ul>
        <%
            List<String> chats = (List<String>) request.getAttribute("chats");
            if (chats != null && !chats.isEmpty()) {
                for (String chat : chats) {
        %>
        <form action="UserPage" method="post">
            <input type="hidden" name="selected_chat" value="<%= chat %>">
            <button type="submit"><%= chat %>
            </button>
        </form>
        <%
                }
            }
        %>
    </ul>
</div>

<div id="main-content">
    <div class="search-bar">
        <label for="search_for_a_person">Поиск человека:</label>
        <form action="UserPage" method="post">
            <input type="text" id="search_for_a_person" name="search_for_a_person" placeholder="Введите имя...">
            <button type="submit">Найти</button>
        </form>
    </div>

    <h2><%= request.getAttribute("name") %>
    </h2>

    <ul>
        <%
            List<String> users = (List<String>) request.getAttribute("users");
            if (users != null && !users.isEmpty()) {
                for (String user : users) {
        %>
        <li>
            <%= user %>
            <form action='UserPage' method='post'>
                <input type='hidden' name='selected_user' value='<%= user %>'>
                <button type='submit'>Написать</button>
            </form>
        </li>
        <%
                }
            }
        %>
    </ul>

    <button onclick="window.location.href='MainPage'; return false;">На главную</button>

    <p>${empty_name}</p>
    <p>${error_user}</p>
    <p>Powered by ₽$</p>
</div>

</body>
</html>
