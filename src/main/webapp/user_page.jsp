<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title><%= request.getAttribute("name") %> | buzzor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #ffffff;
            color: #333333;
        }

        #header {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        #header .logo {
            font-size: 28px;
            font-weight: bold;
            color: #333333;
            text-decoration: none;
            margin-right: 10px;
        }

        #header .search-bar {
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        #header .search-bar input[type="text"] {
            width: 200px;
            padding: 8px 10px;
            border: 1px solid #ccc;
            color: #333333;
            border-radius: 5px 0 0 5px;
            box-sizing: border-box;
        }

        #header .search-bar button {
            padding: 8px 10px;
            border: 1px solid #ccc;
            background-color: #ffffff;
            color: #333333;
            border-radius: 0 5px 5px 0;
            cursor: pointer;
            margin-left: -1px;
            transition: background-color 0.3s;
        }

        #header .search-bar button:hover {
            background-color: #f0f0f0;
        }

        #header .username {
            font-size: 18px;
            color: #333333;
            margin-left: 800px;
            cursor: pointer;
            position: relative;
            padding: 8px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        #header .username:hover {
            background-color: #f0f0f0;
        }

        #dropdownMenu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            width: 200px;
            background-color: #f9f9f9;
            color: #333333;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            padding: 10px;
            z-index: 100;
        }

        #dropdownMenu a {
            display: block;
            padding: 10px;
            color: #333333;
            text-decoration: none;
            font-size: 16px;
        }

        #dropdownMenu a:hover {
            background-color: #e0e0e0;
        }

        #searchDropdown {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            background-color: #ffffff;
            border: 1px solid #ddd;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            padding: 10px;
            z-index: 100;
        }

        #searchDropdown.active {
            display: block;
        }

        #searchDropdown ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        #searchDropdown ul li {
            display: flex;
            align-items: center;
            padding: 10px;
            background-color: #ffffff;
            border: 1px solid #ddd;
            margin-bottom: 5px;
            cursor: pointer;
            transition: background-color 0.3s, color 0.3s;
            border-radius: 5px;
        }

        #searchDropdown ul li:hover {
            background-color: #e0e0e0;
        }

        #searchDropdown ul li form {
            margin: 0;
        }
    </style>
    <script>
        function toggleDropdown() {
            var dropdownMenu = document.getElementById("dropdownMenu");
            var username = document.querySelector(".username");
            dropdownMenu.style.display = dropdownMenu.style.display === "block" ? "none" : "block";
            username.classList.toggle("active");
        }

        function toggleSearchDropdown() {
            var searchDropdown = document.getElementById("searchDropdown");
            var isActive = searchDropdown.classList.toggle("active");
            localStorage.setItem("searchDropdownOpen", isActive);
            localStorage.setItem("searchDropdownVisited", true);
        }

        function restoreSearchDropdown() {
            var searchDropdownOpen = localStorage.getItem("searchDropdownOpen");
            var searchDropdownVisited = localStorage.getItem("searchDropdownVisited");

            if (searchDropdownOpen === "true" && searchDropdownVisited === "true") {
                document.getElementById("searchDropdown").classList.add("active");
            }
        }

        window.onload = function () {
            restoreSearchDropdown();
        };

        window.onclick = function (event) {
            var dropdownMenu = document.getElementById("dropdownMenu");
            var username = document.querySelector(".username");
            var searchDropdown = document.getElementById("searchDropdown");
            var searchBarInput = document.querySelector(".search-bar input[type='text']");

            if (!username.contains(event.target) && dropdownMenu.style.display === "block") {
                dropdownMenu.style.display = "none";
                username.classList.remove("active");
            }

            if (!searchBarInput.contains(event.target) && !searchDropdown.contains(event.target)) {
                searchDropdown.classList.remove("active");
                localStorage.setItem("searchDropdownOpen", false);

                var userList = searchDropdown.querySelector("ul");
                if (userList) {
                    userList.innerHTML = '<li>Нет доступных пользователей</li>';
                }
            }
        };

        function submitUserForm(userName) {
            document.getElementById("selectedUser").value = userName;
            document.getElementById("userForm").submit();
        }
    </script>
</head>
<body>
<div id="header">
    <div class="logo">buzzor</div>
    <div class="search-bar">
        <form action="UserPage" method="post" style="display: flex;"
              onsubmit="localStorage.setItem('searchDropdownOpen', true)">
            <input type="text" name="search_for_a_person" placeholder="Поиск" onclick="toggleSearchDropdown()">
            <button type="submit">Найти</button>
        </form>
        <div id="searchDropdown">
            <ul>
                <% List<String> users = (List<String>) request.getAttribute("users"); %>
                <% if (users != null && !users.isEmpty()) { %>
                <% for (String user : users) { %>
                <li onclick="submitUserForm('<%= user %>')" style="cursor: pointer;">
                    <%= user %>
                </li>
                <% } %>
                <% } else { %>
                <li>Введите имя пользователя</li>
                <% } %>
            </ul>

            <form id="userForm" action="UserPage" method="post" style="display: none;">
                <input type="hidden" name="selected_user" id="selectedUser">
            </form>
            <p>${empty_name}</p>
            <p>${error_user}</p>
        </div>
    </div>
    <div class="username" onclick="toggleDropdown()">
        <%= request.getAttribute("name") %>
        <div id="dropdownMenu">
            <a href="MainPage">Выйти</a>
        </div>
    </div>
</div>

<div id="sidebar">
    <h3>Чаты</h3>
    <ul>
        <% List<String> chats = (List<String>) request.getAttribute("chats"); %>
        <% if (chats != null && !chats.isEmpty()) { %>
        <% for (String chat : chats) { %>
        <form action="UserPage" method="post">
            <input type="hidden" name="selected_chat" value="<%= chat %>">
            <button type="submit"><%= chat %>
            </button>
        </form>
        <% } %>
        <% } %>
    </ul>
</div>
</body>
</html>
