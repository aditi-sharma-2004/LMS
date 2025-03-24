<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
    String leaveId = request.getParameter("leave_id");
    String role = request.getParameter("role"); // Fetch role parameter

    if (leaveId == null || leaveId.isEmpty()) {
        out.println("<h3>Error: No leave ID provided.</h3>");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

        String query = "SELECT * FROM LeaveRequests WHERE leave_id = ?";
        ps = conn.prepareStatement(query);
        ps.setInt(1, Integer.parseInt(leaveId));
        rs = ps.executeQuery();

        if (rs.next()) {
%>

<!DOCTYPE html>
<html>
<head>
    <title>Leave Details</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8f9fa; padding: 20px; }
        .container { max-width: 600px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; }
        .info { margin-bottom: 10px; }
        .signature-container { text-align: center; margin-top: 20px; }
        .signature-container img { max-width: 300px; max-height: 150px; border: 1px solid #000; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Leave Details</h2>
        <div class="info"><strong>Student ID:</strong> <%= rs.getString("student_id") %></div>
        <div class="info"><strong>Leave Type:</strong> <%= rs.getString("leave_type") %></div>
        <div class="info"><strong>Reason:</strong> <%= rs.getString("reason") %></div>
        <div class="info"><strong>Start Date:</strong> <%= rs.getDate("start_date") %></div>
        <div class="info"><strong>End Date:</strong> <%= rs.getDate("end_date") %></div>
        <div class="info"><strong>Number Of Days:</strong> <%= rs.getString("verification_status") %></div>
        <div class="info"><strong>Leaving Alone?</strong> <%= rs.getString("leaving_alone") %></div>
        <div class="info"><strong>Status:</strong> <%= rs.getString("verification_status") %></div>
        
        <div class="signature-container">
            <h3>Guardian's Signature</h3>
            <img src="getSignature.jsp?leave_id=<%= leaveId %>" alt="Signature not available">
        </div>

        <% if ("VO".equalsIgnoreCase(role)) { %>
            <div class="button-container" style="text-align:center; margin-top:20px;">
                <a href="acceptLeaveVo.jsp?leave_id=<%= leaveId %>" style="text-decoration:none; padding:10px 20px; background:#28a745; color:white; border-radius:5px; margin-right:10px;">Accept</a>
                <a href="rejectLeaveVo.jsp?leave_id=<%= leaveId %>" style="text-decoration:none; padding:10px 20px; background:#dc3545; color:white; border-radius:5px;">Reject</a>
            </div>
        <% } else if ("warden".equalsIgnoreCase(role)) { %>
            <div class="button-container" style="text-align:center; margin-top:20px;">
                <a href="acceptLeaveWarden.jsp?leave_id=<%= leaveId %>" style="text-decoration:none; padding:10px 20px; background:#28a745; color:white; border-radius:5px; margin-right:10px;">Accept</a>
                <a href="rejectLeaveWarden.jsp?leave_id=<%= leaveId %>" style="text-decoration:none; padding:10px 20px; background:#dc3545; color:white; border-radius:5px;">Reject</a>
            </div>
        <% } else if ("HOD".equalsIgnoreCase(role)) { %>
            <div class="button-container" style="text-align:center; margin-top:20px;">
                <a href="acceptLeaveHod.jsp?leave_id=<%= leaveId %>" style="text-decoration:none; padding:10px 20px; background:#28a745; color:white; border-radius:5px; margin-right:10px;">Accept</a>
                <a href="rejectLeaveHod.jsp?leave_id=<%= leaveId %>" style="text-decoration:none; padding:10px 20px; background:#dc3545; color:white; border-radius:5px;">Reject</a>
            </div>
        <% } %>
    </div>
</body>
</html>

<%
        } else {
            out.println("<h3>No leave request found for ID: " + leaveId + "</h3>");
        }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
