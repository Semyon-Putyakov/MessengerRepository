<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>buzzor</title>
    <style>
        /* Global styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #2C2F33;
            color: #FFFFFF;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            position: relative;
            overflow: hidden;
        }

        /* Main container */
        .register-container {
            background-color: #40444B;
            padding: 1.5rem; /* Reduced padding */
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            max-width: 340px; /* Match login form width */
            width: 100%;
            text-align: center;
            z-index: 1;
        }

        /* Heading */
        h2 {
            font-size: 1.8rem;
            margin-bottom: 1rem;
            color: #7289DA;
        }

        p {
            font-size: 1rem;
            color: #B9BBBE;
            margin-top: 0.5rem;
        }

        /* Form styles */
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
        }

        label {
            font-weight: bold;
            color: #B9BBBE;
            font-size: 0.9rem;
            margin-bottom: 0.3rem;
            width: 90%;
            text-align: left;
            box-sizing: border-box;
        }

        input[type="text"], input[type="password"] {
            padding: 0.6rem;
            width: 90%;
            border-radius: 5px;
            border: none;
            background-color: #2C2F33;
            color: #FFFFFF;
            margin-bottom: 1rem;
            font-size: 1rem;
            box-sizing: border-box;
        }

        /* Button styles */
        .submit-button {
            padding: 0.7rem;
            width: 90%;
            background-color: #5865F2;
            color: #FFFFFF;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-bottom: 1rem;
        }

        .submit-button:hover {
            background-color: #4a5ac4;
        }

        /* "На главную" button as link */
        .back-button {
            padding: 0.7rem;
            width: 90%;
            background-color: transparent;
            color: #7289DA;
            border: 2px solid #7289DA;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.2s, color 0.2s;
        }

        .back-button:hover {
            background-color: #7289DA;
            color: #FFFFFF;
        }

        /* Links and messages */
        .error-message {
            color: #E53E3E;
            font-size: 0.9rem;
            margin: 0.5rem 0;
        }

        .powered-by {
            font-size: 0.9rem;
            color: #99AAB5;
            margin-top: 1rem;
        }

        /* Background pattern */
        .background-pattern {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 0;
            background-color: #23272A;
        }

        .pattern-shape {
            position: absolute;
            opacity: 0.1;
        }

        /* Adding squares with different sizes and positions */
        .shape-1 { width: 100px; height: 100px; background-color: #7289DA; top: 20px; left: 20px; }
        .shape-2 { width: 120px; height: 120px; background-color: #99AAB5; top: 50px; left: 150px; }
        .shape-3 { width: 90px; height: 90px; background-color: #A1C4E3; top: 200px; left: 80px; }
        .shape-4 { width: 130px; height: 130px; background-color: #5B6E9A; bottom: 150px; right: 30px; }
        .shape-5 { width: 140px; height: 140px; background-color: #7289DA; top: 300px; left: 100px; }
        .shape-6 { width: 110px; height: 110px; background-color: #A1C4E3; top: 100px; right: 50px; }
        .shape-7 { width: 150px; height: 150px; background-color: #99AAB5; bottom: 100px; left: 40px; }
        .shape-8 { width: 160px; height: 160px; background-color: #5B6E9A; bottom: 50px; left: 150px; }
        .shape-9 { width: 180px; height: 180px; background-color: #7289DA; top: 180px; right: 20px; }
        .shape-10 { width: 140px; height: 140px; background-color: #A1C4E3; top: 250px; left: 200px; }
    </style>
</head>
<body>
<div class="background-pattern">
    <div class="pattern-shape shape-1"></div>
    <div class="pattern-shape shape-2"></div>
    <div class="pattern-shape shape-3"></div>
    <div class="pattern-shape shape-4"></div>
    <div class="pattern-shape shape-5"></div>
    <div class="pattern-shape shape-6"></div>
    <div class="pattern-shape shape-7"></div>
    <div class="pattern-shape shape-8"></div>
    <div class="pattern-shape shape-9"></div>
    <div class="pattern-shape shape-10"></div>
</div>

<div class="register-container">
    <h2>Регистрация</h2>

    <form action="RegistrationPage" method="post">
        <label for="username">Отображаемое имя:</label>
        <input type="text" id="username" name="username" required>

        <label for="login">Логин:</label>
        <input type="text" id="login" name="login" required>

        <label for="password">Пароль:</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="submit-button">Зарегистрироваться</button>
        <button onclick="window.location.href='MainPage'; return false;" class="back-button">На главную</button>

        <p class="error-message">${message}</p>
        <p class="error-message">${error_user}</p>
    </form>

    <p class="powered-by">Powered by ₽$</p>
</div>
</body>
</html>
