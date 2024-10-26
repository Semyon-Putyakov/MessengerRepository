package org.example.messenger;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


@WebServlet("/RegistrationPage")
public class Registration extends HttpServlet {
    private DBConnection dbConnection = new DBConnection(); //                      ДОДЕЛАТЬ
    private PreparedStatement ps;
    private ResultSet rs;
    private boolean error_user_bool = false;
    private String password;
    private String name;
    private String login;
    private String query = "insert into messenger(name,login,password) values(?,?,?)";
    private String query2 = "select * from messenger where login=?";
    String error_user = "Такой пользователь уже существует!";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("registration.jsp").forward(req, resp);;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        password = req.getParameter("password");
        name = req.getParameter("username");
        login = req.getParameter("login");

        try {
            ps = dbConnection.getConnection().prepareStatement(query2);
            ps.setString(1,login);
            rs = ps.executeQuery();
            if(rs.next()){
                req.setAttribute("error_user", error_user);
                RequestDispatcher rd = req.getRequestDispatcher("registration.jsp");
                rd.forward(req, resp);
                error_user_bool = true;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        if ((password != null && name != null && login != null) && !error_user_bool) {
            try {
                ps = dbConnection.getConnection().prepareStatement(query);
                ps.setString(1, name);
                ps.setString(2, login);
                ps.setString(3, password);

                ps.executeUpdate();

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            resp.sendRedirect("MainPage");
        }

    }

}
