<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Records</title>
    <style>
        table { width: 80%; border-collapse: collapse; margin: 20px auto; }
        th, td { padding: 10px; border: 1px solid black; text-align: center; }
        img { width: 100px; height: 100px; }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Student Records</h2>
    
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Course</th>
            <th>Photo</th>
        </tr>
        
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            String dbURL = "jdbc:mysql://localhost:3306/student_db";
            String dbUser = "project";  // Change if needed
            String dbPass = "aditi";  // Add your MySQL password

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
                String sql = "SELECT id, name, email, course FROM students";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String course = rs.getString("course");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= email %></td>
            <td><%= course %></td>
            <td><img src="DisplayPhoto?id=<%= id %>" alt="Student Photo"></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } 
                catch (Exception ex) { ex.printStackTrace(); }
            }
        %>
    </table>
</body>
</html>
