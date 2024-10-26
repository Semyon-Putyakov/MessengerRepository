package org.example.messenger;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/UserPage")
public class UserPage extends HttpServlet {
    private String name;
    private String query = "SELECT * FROM messenger WHERE name LIKE ?";
    String empty_name = "Нужно ввести имя!";
    String error_user = "Пользователи не найдены";
    private String user;
    private DBConnection dbConnection = null;
    private String chat_user;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        name = (String) request.getSession().getAttribute("name");
        String query4 = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' and table_name like ?";

        try {
            dbConnection = new DBConnection();
            PreparedStatement preparedStatement = dbConnection.getConnection().prepareStatement(query4);
            preparedStatement.setString(1, "%" + name + "%");
            ResultSet resultSet = preparedStatement.executeQuery();

            List<String> chats = new ArrayList<>();
            while (resultSet.next()){
                chats.add(resultSet.getString("table_name"));
            }

            if(!chats.isEmpty()){
                request.setAttribute("chats", chats);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        request.setAttribute("name", name);
        request.getRequestDispatcher("user_page.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session123 = request.getSession();
        String is = (String) session123.getAttribute("finded_user");
        System.out.println(session123.getAttribute("chats"));
        if(is == null){
            if(!request.getParameter("find_user").isEmpty()) {
                user = request.getParameter("find_user");
                dbConnection = new DBConnection();
                HttpSession session = request.getSession();
                session.setAttribute("finded_user", user);
            } else {
                request.setAttribute("empty_name", empty_name);
            }
        } else {
            chat_user = request.getParameter("selected_user");
            if(chat_user != null){
                HttpSession session1 = request.getSession();
                session1.setAttribute("companion_user", chat_user);
                session1.setAttribute("user", name);
                response.sendRedirect(request.getContextPath() + "/Chat");
                return;
            }
        }

        try {
            PreparedStatement ps = dbConnection.getConnection().prepareStatement(query);
            ps.setString(1, "%" + user + "%");
            ResultSet rs = ps.executeQuery();
            List<String> users = new ArrayList<>();

            while (rs.next()) {
                if(!name.equals(rs.getString("name"))){
                    users.add(rs.getString("name"));
                }
            }
            if(!users.isEmpty()){
                request.setAttribute("users", users);
            } else {
                request.setAttribute("error_user", error_user);
            }
            session123.removeAttribute("finded_user");
            String query4 = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' and table_name like ?";
            PreparedStatement preparedStatement = dbConnection.getConnection().prepareStatement(query4);
            preparedStatement.setString(1, "%" + name + "%");
            ResultSet resultSet = preparedStatement.executeQuery();

            List<String> chats = new ArrayList<>();
            while (resultSet.next()) {
                chats.add(resultSet.getString("table_name"));
            }
            if (!chats.isEmpty()) {
                request.setAttribute("chats", chats);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        request.setAttribute("name", name);
        request.getRequestDispatcher("user_page.jsp").forward(request, response);

    }
}




//        PrintWriter printWriter = response.getWriter();
//        Cookie[] cookies = request.getCookies();
//        for (Cookie cookie : cookies) {
//            printWriter.println("<p>" + cookie.getName() + ": " + cookie.getValue() + "</p>");
//        }
//        String name = (String) request.getAttribute("name");
//        request.setAttribute("name", name);
//        RequestDispatcher requestDispatcher = request.getRequestDispatcher("page_user.jsp");
//        requestDispatcher.forward(request, response);
