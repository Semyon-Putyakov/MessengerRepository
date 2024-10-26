package org.example.messenger;

import java.io.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/MainPage")
public class MainPage extends HttpServlet {
    private String login;
    private String password;
    private DBConnection dbConnection;
    private String query = "select * from messenger where login = ? and password = ?";
    private String error_login_and_password = "Неправильно введен пароль или логин!";
    private String name;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("main_page.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        login = request.getParameter("login");
        password = request.getParameter("password");
        if(!(login.equals("") && password.equals(""))){
           dbConnection = new DBConnection();
        }

        try {
            PreparedStatement preparedStatement = dbConnection.getConnection().prepareStatement(query);

            preparedStatement.setString(1, login);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                if (login.equals(resultSet.getString("login")) && password.equals(resultSet.getString("password"))) {
                    name = resultSet.getString("name");

                    HttpSession session = request.getSession();
                    session.setAttribute("name", name);
                    session.setAttribute("login", login);
                    session.setAttribute("password", password);

                    response.sendRedirect(request.getContextPath() + "/UserPage");
                    resultSet.close();
                    preparedStatement.close();
                    dbConnection.closeConnection();
                }
            } else {
                request.setAttribute("error_login_and_password", error_login_and_password);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("main_page.jsp");
                requestDispatcher.forward(request, response);
            }
        } catch (SQLException | ServletException e) {
            throw new RuntimeException(e);
        }
    }
}
