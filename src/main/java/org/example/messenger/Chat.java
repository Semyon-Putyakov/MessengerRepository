package org.example.messenger;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/Chat")
public class Chat extends HttpServlet {
    private HttpSession session;
    private DBConnection dbConnection;
    private String query1;
    private String query2;
    private String query3;
    private String tableName;
    private boolean table_name = false;

    private String getUser(){
        return (String) session.getAttribute("user");
    }

    private String getCompanionUser(){
        return (String) session.getAttribute("companion_user");
    }

    public String getNameMessengerDB1(){
        return "CHAT" + getUser() + getCompanionUser();
    }
    public String getNameMessengerDB2(){
        return "CHAT" + getCompanionUser() + getUser();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();
        String userTable = getNameMessengerDB1();
        String companionTable = getNameMessengerDB2();
        dbConnection = new DBConnection();
        query3 = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN (?, ?)";

        try {
            PreparedStatement ps = dbConnection.getConnection().prepareStatement(query3);
            ps.setString(1, userTable);
            ps.setString(2, companionTable);
            ResultSet rs = ps.executeQuery();


            while (rs.next()) {
                tableName = rs.getString("table_name");
                session.setAttribute("tableName", tableName);
                if (tableName.equals(userTable) || tableName.equals(companionTable)) {
                    session.setAttribute("tableName", tableName);
                    table_name = true;
                    request.getRequestDispatcher("chat.jsp").forward(request, response);

                }
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        request.getRequestDispatcher("chat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();
        String userTable = getNameMessengerDB1();
        String companionTable = getNameMessengerDB2();

        query1 = "CREATE TABLE IF NOT EXISTS \"" + userTable + "\" " + "(message_id SERIAL, name VARCHAR NOT NULL, message VARCHAR NOT NULL, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
        query3 = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN (?, ?)";

        if (!request.getParameter("message-input").isEmpty()) {
            dbConnection = new DBConnection();
            try {
                PreparedStatement ps = dbConnection.getConnection().prepareStatement(query3);
                ps.setString(1, userTable);
                ps.setString(2, companionTable);
                ResultSet rs = ps.executeQuery();
                boolean if_db_exists = false;
                while (rs.next()) {
                    tableName = rs.getString("table_name");
                    if (tableName.equals(userTable) || tableName.equals(companionTable)) {
                        query2 = "INSERT INTO \"" + tableName + "\" (name, message) VALUES (?, ?)";
                        if_db_exists = true;
                        break;
                    }
                }
                if (!if_db_exists) {
                    PreparedStatement preparedStatement1 = dbConnection.getConnection().prepareStatement(query1);
                    preparedStatement1.execute();
                    query2 = "INSERT INTO \"" + userTable + "\" (name, message) VALUES (?, ?)";
                }

                PreparedStatement preparedStatement2 = dbConnection.getConnection().prepareStatement(query2);
                preparedStatement2.setString(1, getUser());
                preparedStatement2.setString(2, request.getParameter("message-input"));
                preparedStatement2.executeUpdate();

            } catch (SQLException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }
        }
        request.getRequestDispatcher("chat.jsp").forward(request, response);
    }

}
