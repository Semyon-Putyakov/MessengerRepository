package org.example.messenger;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private Connection connection;
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USER = "postgres";
    private static final String PASSWORD = "root";
    public DBConnection(){
        try {
            Class.forName("org.postgresql.Driver");

            connection = DriverManager.getConnection(URL,USER,PASSWORD);
//            if(!connection.isClosed()){
//                System.out.println("Connection established");
//            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
    public Connection getConnection(){
        return connection;
    }
    public void closeConnection() throws SQLException {
        connection.close();
    }
}
