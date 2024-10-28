package org.example.messenger;

import jakarta.servlet.RequestDispatcher;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Test {

    public static void main(String[] args) {
        DBConnection dbConnection = new DBConnection();
        try {
            PreparedStatement preparedStatement = dbConnection.getConnection().prepareStatement("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' and (table_name = 'messenger' or table_name = 'messenger2')");
            preparedStatement.execute();
            ResultSet resultSet = preparedStatement.getResultSet();
            while (resultSet.next()) {
                System.out.println(resultSet.getString("table_name"));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
