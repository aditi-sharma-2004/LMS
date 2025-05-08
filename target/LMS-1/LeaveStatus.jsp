<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<html>
<head>
    <title>Leave Request Status</title>
</head>
<body>
    <h2>Your Leave Request Status</h2>
    <%
        String guardianId = request.getParameter("guardianId");
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","lms","lms");
            String query = "SELECT * FROM leave_requests WHERE guardian_id = ? ORDER BY id DESC LIMIT 1";
            ps = conn.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(guardianId));
            rs = ps.executeQuery();

            if (rs.next()) {
    %>
            <p>Leave ID: ${rs.getInt("id")}</p>
            <p>Status: ${rs.getString("status")}</p>
            <p>Reason: ${rs.getString("reason")}</p>
            <p>Leave Start Date: ${rs.getDate("leave_start_date")}</p>
            <p>Leave End Date: ${rs.getDate("leave_end_date")}</p>
    <%
            } else {
    %>
            <p>No leave request found.</p>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
