package org.example.messenger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/Chat")
public class Chat extends HttpServlet {
    private HttpSession session;
    private DBConnection dbConnection;
    private String create_table_query;
    private String insert_values_query;
    private String search_chat_query;
    private String tableName;


    private String getUser() {
        return (String) session.getAttribute("user");
    }

    private String getCompanionUser() {
        return (String) session.getAttribute("companion_user");
    }

    public String getNameMessengerDB1() {
        return getUser() + "_" + getCompanionUser();
    }

    public String getNameMessengerDB2() {
        return getCompanionUser() + "_" + getUser();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        session = request.getSession();
        String userTable = getNameMessengerDB1();
        String companionTable = getNameMessengerDB2();
        dbConnection = new DBConnection();

        search_chat_query = "SELECT table_name FROM information_schema.tables " +
                "WHERE table_schema = 'public' AND table_name IN (?, ?)";
        create_table_query = "CREATE TABLE IF NOT EXISTS \"" + userTable + "\" " +
                "(message_id SERIAL, name VARCHAR NOT NULL, message VARCHAR NOT NULL, " +
                "timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";

        try {
            PreparedStatement ps = dbConnection.getConnection().prepareStatement(search_chat_query);
            ps.setString(1, userTable);
            ps.setString(2, companionTable);
            ResultSet rs = ps.executeQuery();
            boolean tableExists = false;

            while (rs.next()) {
                tableName = rs.getString("table_name");
                if (tableName.equals(userTable) || tableName.equals(companionTable)) {
                    session.setAttribute("tableName", tableName);
                    tableExists = true;
                    rs.close();
                    ps.close();
                    break;
                }
            }

            if (!tableExists) {
                PreparedStatement preparedStatement1 = dbConnection.getConnection().prepareStatement(create_table_query);
                preparedStatement1.execute();
                insert_values_query = "INSERT INTO \"" + userTable + "\" (name, message) VALUES (?, ?)";
                preparedStatement1.close();
            }

            dbConnection.closeConnection();
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

        search_chat_query = "SELECT table_name FROM information_schema.tables " +
                "WHERE table_schema = 'public' AND table_name IN (?, ?)";

        String message = request.getParameter("message-input");
        if (!message.isEmpty()) {
            dbConnection = new DBConnection();
            try {
                PreparedStatement preparedStatement = dbConnection.getConnection().prepareStatement(search_chat_query);
                preparedStatement.setString(1, userTable);
                preparedStatement.setString(2, companionTable);
                ResultSet resultSet = preparedStatement.executeQuery();
                while (resultSet.next()) {
                    tableName = resultSet.getString("table_name");
                    if (tableName.equals(userTable) || tableName.equals(companionTable)) {
                        insert_values_query = "INSERT INTO \"" + tableName + "\" (name, message) VALUES (?, ?)";
                        session.setAttribute("tableName", tableName);
                        resultSet.close();
                        preparedStatement.close();
                        break;
                    }
                }

                PreparedStatement preparedStatement2 = dbConnection.getConnection().prepareStatement(insert_values_query);
                preparedStatement2.setString(1, getUser());
                preparedStatement2.setString(2, request.getParameter("message-input"));
                preparedStatement2.executeUpdate();
                preparedStatement2.close();

                dbConnection.closeConnection();

            } catch (SQLException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }


        }
        request.getRequestDispatcher("chat.jsp").forward(request, response);
    }
}
