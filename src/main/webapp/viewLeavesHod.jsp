<%@ page import="java.sql.*" %>
<table border="1">
    <tr>
        <th>Leave ID</th>
        <th>Student ID</th>
        <th>Reason</th>
        <th>Start Date</th>
        <th>End Date</th>
        <th>Status</th>
    </tr>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

            String sql = "SELECT * FROM LeaveRequests ORDER BY start_date DESC";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                int leaveId = rs.getInt("leave_id");
                String studentId = rs.getString("student_id");
                String reason = rs.getString("reason");
                String startDate = rs.getString("start_date");
                String endDate = rs.getString("end_date");
                String status = rs.getString("status");
    %>
    <tr>
        <td><%= leaveId %></td>
        <td><%= studentId %></td>
        <td><%= reason %></td>
        <td><%= startDate %></td>
        <td><%= endDate %></td>
        <td><%= status %></td>
    </tr>
    <%
            }
            conn.close();
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>
</table>
