<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.example.messenger.DBConnection" %>
<%@ page import="java.sql.Statement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Чат | buzzor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        .container {
            width: 100%;
            max-width: 600px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        #chat-window {
            width: 100%;
            height: 400px;
            border: 1px solid #ccc;
            overflow-y: auto;
            padding: 10px;
            background-color: #fafafa;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .chat-message { margin-bottom: 10px; }
        .message-name { font-weight: bold; color: #333; }
        .message-text { margin: 5px 0; color: #555; }
        .message-time { font-size: 0.8em; color: #aaa; }
        input[type="text"] {
            width: calc(100% - 80px);
            padding: 10px;
            margin-right: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            width: 60px;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<div class="container">
    <h2>Чат с <%= (String) request.getSession().getAttribute("companion_user") %></h2>

    <div id="chat-window">
        <%
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

                        chatMessages.append("<div class='chat-message'>")
                                .append("<div class='message-name'>").append(messageName).append("</div>")
                                .append("<div class='message-text'>").append(messageText).append("</div>")
                                .append("<div class='message-time'>").append(timestamp.substring(11, 16)).append("</div>")
                                .append("</div><hr>");
                    }
                }
            } catch (SQLException e) {
                chatMessages.append("<p>Ошибка загрузки сообщений...</p>");
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
            xhr.open("POST", "Chat", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onload = function () {
                if (xhr.status === 200) {
                    messageInput.value = "";
                    loadChat();
                }
            };
            xhr.send("message-input=" + encodeURIComponent(message));
        }
    }

    function loadChat() {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "Chat", true);
        xhr.onload = function () {
            if (xhr.status === 200) {
                document.getElementById("chat-window").innerHTML = xhr.responseText;
                scrollToBottom();
            }
        };
        xhr.send();
    }

    setInterval(loadChat, 1000);
    window.onload = scrollToBottom;
</script>
</body>
</html>
