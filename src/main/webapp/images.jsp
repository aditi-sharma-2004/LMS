<%@ page language="java" import="java.sql.*, java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Uploaded Images</title>
</head>
<body>
    <h2>Uploaded Images</h2>
    <ul>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                conn = com.example.DBConnection.getConnection();
                stmt = conn.prepareStatement("SELECT photo_path FROM students");
                rs = stmt.executeQuery();
                while (rs.next()) {
                    String imageName = rs.getString("photo_path");
        %>
                    <li>
                        <img src="image?name=<%= imageName %>" width="150" height="150" />
                        <p><%= imageName %></p>
                    </li>
        <%
                }
            } catch (Exception e) {
                out.println("<p>Error retrieving images.</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </ul>
    <a href="index.jsp">Upload More</a>
</body>
</html>
