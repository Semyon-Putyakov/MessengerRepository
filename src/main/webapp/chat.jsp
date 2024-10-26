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
            e.printStackTrace();
            chatMessages.append("Ошибка запроса к базе данных: ").append(e.getMessage());
        }
    %>
    <%= chatMessages.toString() %>
    <%%>
</div>

<script>
    window.onload = scrollToBottom;
</script>

<form method="post" action="Chat" onsubmit="scrollToBottom();">
    <input type="text" id="message-input" name="message-input" placeholder="Введите сообщение...">
    <button type="submit" id="send-button">Отправить</button>
</form>
<p>Powered by ₽$</p>
</body>
</html>
