package org.example.messenger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/UserPage")
public class UserPage extends HttpServlet {
    private String name;
    private String list_names_query = "SELECT * FROM messenger WHERE name LIKE ?";
    private DBConnection dbConnection = null;
    private String search_chat_query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' and table_name like ?";


    private void getChat(HttpServletRequest request){
        try {
            dbConnection = new DBConnection();
            PreparedStatement preparedStatement = dbConnection.getConnection().prepareStatement(search_chat_query);
            preparedStatement.setString(1, "%" + name + "%");
            ResultSet resultSet = preparedStatement.executeQuery();
            String[] chat;
            List<String> chats = new ArrayList<>();
            while (resultSet.next()){
                chat = resultSet.getString("table_name").split("_");
                for(String str: chat){
                    if(str.equals(name)){
                        for(String str2: chat){
                            if(!str2.equals(name)){
                                chats.add(resultSet.getString("table_name") + "_" + str2);
                            }
                        }
                    }
                }
            }

            if(!chats.isEmpty()){
                request.setAttribute("chats", chats);
            }

            preparedStatement.close();
            resultSet.close();
            dbConnection.closeConnection();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        name = (String) request.getSession().getAttribute("name");
        getChat(request);
        request.setAttribute("name", name);
        request.getRequestDispatcher("user_page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search_for_a_person = request.getParameter("search_for_a_person");
        if (search_for_a_person == null || search_for_a_person.equals("")) {
            request.setAttribute("empty_name", "Нужно ввести имя!");
        } else {
            try {
                List<String> users = new ArrayList<>();

                dbConnection = new DBConnection();

                PreparedStatement preparedStatement = dbConnection.getConnection().prepareStatement(list_names_query);
                preparedStatement.setString(1, "%" + search_for_a_person + "%");
                ResultSet resultSet = preparedStatement.executeQuery();

                while (resultSet.next()){
                    if(!name.equals(resultSet.getString("name"))){
                        users.add(resultSet.getString("name"));
                    }
                }

                if(!users.isEmpty()){
                    request.setAttribute("users", users);
                } else {
                    request.setAttribute("error_user", "Пользователи не найдены");
                }

                preparedStatement.close();
                resultSet.close();
                dbConnection.closeConnection();
            }catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        String selected_user = request.getParameter("selected_user");
        if (selected_user != null) {
            HttpSession session1 = request.getSession();
            session1.setAttribute("companion_user", selected_user);
            session1.setAttribute("user", name);
            response.sendRedirect(request.getContextPath() + "/Chat");
            return;
        }

        getChat(request);
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
