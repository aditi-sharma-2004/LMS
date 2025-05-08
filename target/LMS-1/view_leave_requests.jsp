<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Leave Requests</title>
</head>
<body>
    <h2>Leave Requests</h2>
    <table border="1">
        <tr>
            <th>Leave ID</th>
            <th>Student ID</th>
            <th>Guardian ID</th>
            <th>Reason</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
        </tr>
<%
    String dbURL = "jdbc:mysql://localhost:3306/LMS"; 
    String dbUser = "lms"; 
    String dbPass = "lms"; 

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM LeaveRequests");

        while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("leave_id") %></td>
            <td><%= rs.getString("student_id") %></td>
            <td><%= rs.getString("guardian_id") %></td>
            <td><%= rs.getString("reason") %></td>
            <td><%= rs.getDate("start_date") %></td>
            <td><%= rs.getDate("end_date") %></td>
            <td><%= rs.getString("status") %></td>
        </tr>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>
    </table>
</body>
</html>
