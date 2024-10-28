<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="org.example.messenger.DBConnection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="org.example.messenger.Chat" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<html>
<head>
    <title>buzzor</title>
    <style>
        #chat-window {
            width: 80%;
            height: 600px;
            border: 1px solid #000000;
            overflow-y: auto;
            padding: 10px;
            margin-bottom: 10px;
        }
        .chat-message {
            margin-bottom: 10px;
        }
        .message-name {
            font-weight: bold;
            font-size: 1.1em;
        }
        .message-text {
            margin-top: 5px;
            margin-bottom: 5px;
        }
        .message-time {
            font-size: 0.8em;
            color: rgba(0, 0, 0, 0.5);
        }
        #message-input {
            width: 75%;
            padding: 10px;
            margin-right: 10px;
        }
        #send-button {
            padding: 10px 20px;
        }
    </style>
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
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(xhr.responseText, "text/html");
                    const chatWindow = document.getElementById("chat-window");
                    chatWindow.innerHTML = doc.getElementById("chat-window").innerHTML;
                    scrollToBottom();
                }
            };
            xhr.send();
        }

        setInterval(loadChat, 500);
        window.onload = scrollToBottom;
    </script>
</head>
<body>
<h1>Chat</h1>
<%
    HttpSession session1 = request.getSession();
    String name = (String) session1.getAttribute("companion_user");
%>
<h2><%= name %></h2>

<div id="chat-window">
    <%
        StringBuilder chatMessages = new StringBuilder();
        String table = (String) session1.getAttribute("tableName");

        String query = "SELECT * FROM \"" + table + "\"";
        DBConnection dbConnection = new DBConnection();
        try (Statement statement = dbConnection.getConnection().createStatement();
             ResultSet rs = statement.executeQuery(query)) {

            if (!rs.isBeforeFirst()) {
                chatMessages.append("<p>Нет сообщений в базе данных.</p>");
            } else {
                while (rs.next()) {
                    String messageName = rs.getString("name");
                    String messageText = rs.getString("message");
                    String timestamp = rs.getString("timestamp");

                    String timeFormatted = timestamp.substring(11, 16);

                    chatMessages.append("<div class='chat-message'>")
                            .append("<div class='message-name'>")
                            .append(messageName)
                            .append("</div>")
                            .append("<div class='message-text'>")
                            .append(messageText)
                            .append("</div>")
                            .append("<div class='message-time'>")
                            .append(timeFormatted)
                            .append("</div>")
                            .append("</div><hr>");
                }
            }

        } catch (SQLException e) {
            chatMessages.append("Здесь пока ничего нет");
        }
    %>
    <%= chatMessages.toString() %>
</div>

<form id="chat-form" onsubmit="sendMessage(event);">
    <input type="text" id="message-input" name="message-input" placeholder="Введите сообщение...">
    <button type="submit" id="send-button">Отправить</button>
</form>
<p>Powered by ₽$</p>
</body>
</html>
