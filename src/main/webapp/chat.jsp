<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.messenger.DBConnection" %>
<%@ page import="java.sql.Statement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Чат | buzzor</title>
</head>
<body>
<div>
    <h2>Чат с <%= (String) request.getSession().getAttribute("companion_user") %></h2>

    <div id="chat-window">
        <%
            // Код для загрузки сообщений только при первоначальной загрузке страницы
            StringBuilder chatMessages = new StringBuilder();
            String tableName = (String) request.getSession().getAttribute("tableName");
            String query = "SELECT * FROM \"" + tableName + "\" ORDER BY timestamp ASC";
            DBConnection dbConnection = new DBConnection();

            try (Statement statement = dbConnection.getConnection().createStatement();
                 ResultSet rs = statement.executeQuery(query)) {

                if (!rs.isBeforeFirst()) {
                    chatMessages.append("<p>Сообщений пока нет...</p>");
                } else {
                    while (rs.next()) {
                        String messageName = rs.getString("name");
                        String messageText = rs.getString("message");
                        String timestamp = rs.getString("timestamp");

                        chatMessages.append("<div>")
                                .append("<strong>").append(messageName).append("</strong><br>")
                                .append("<span>").append(messageText).append("</span><br>")
                                .append("<small>").append(timestamp.substring(11, 16)).append("</small><br><hr>")
                                .append("</div>");
                    }
                }
            } catch (SQLException e) {
                chatMessages.append("<p>Сообщений пока нет...</p>");
            }
        %>
        <%= chatMessages.toString() %>
    </div>

    <form id="chat-form" onsubmit="sendMessage(event);">
        <input type="text" id="message-input" name="message-input" placeholder="Введите сообщение...">
        <button type="submit">Отправить</button>
    </form>
</div>

<script>
    function scrollToBottom() {
        const chatWindow = document.getElementById('chat-window');
        chatWindow.scrollTop = chatWindow.scrollHeight;
    }

    function sendMessage(event) {
        event.preventDefault();
        const messageInput = document.getElementById("message-input");
        const message = messageInput.value.trim();

        if (message) {
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "Chat", true);  // Убедитесь, что ваш контроллер/сервлет обрабатывает запрос
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onload = function () {
                if (xhr.status === 200) {
                    messageInput.value = "";
                    loadChat(); // Обновить чат после отправки нового сообщения
                }
            };
            xhr.send("message-input=" + encodeURIComponent(message));
        }
    }

    function loadChat() {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", window.location.href, true); // Загружаем ту же страницу
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest"); // Указываем, что это AJAX-запрос
        xhr.onload = function () {
            if (xhr.status === 200) {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xhr.responseText, "text/html");
                const chatContent = doc.getElementById("chat-window").innerHTML;  // Извлекаем только сообщения
                document.getElementById("chat-window").innerHTML = chatContent;  // Обновляем сообщения на странице
                scrollToBottom();
            }
        };
        xhr.send();
    }

    // Регулярное обновление сообщений для показа новых
    setInterval(loadChat, 1000);
    // Прокрутка вниз при первой загрузке страницы
    window.onload = scrollToBottom;
</script>
</body>
</html>
