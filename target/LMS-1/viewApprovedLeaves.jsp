<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Approved Leave Requests</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>
    <h2>Approved Leave Requests</h2>
    <table>
        <tr>
            <th>Leave ID</th>
            <th>Student ID</th>
            <th>Reason</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
        </tr>

        <%
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");
                stmt = con.createStatement();
                String query = "SELECT * FROM LeaveRequests WHERE final_status = 'Accepted'";
                rs = stmt.executeQuery(query);

                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("leave_id") %></td>
            <td><%= rs.getString("student_id") %></td>
            <td><%= rs.getString("reason") %></td>
            <td><%= rs.getDate("start_date") %></td>
            <td><%= rs.getDate("end_date") %></td>
            <td><%= rs.getString("final_status") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            }
        %>
    </table>
</body>
</html>
