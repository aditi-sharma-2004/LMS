<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
    int leaveId = Integer.parseInt(request.getParameter("leave_id"));
    Connection con = null;
    PreparedStatement ps = null;
    PreparedStatement ps2 = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");
        String updateQuery = "UPDATE LeaveRequests SET verification_status = 'Rejected',hod_status = 'Rejected',gpo_status = 'Rejected', final_status='Rejected' WHERE leave_id = ?";
        ps = con.prepareStatement(updateQuery);
        ps.setInt(1, leaveId);
        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            // Update current_stage to 'Rejected'
            String updateStageQuery = "UPDATE LeaveRequests SET current_stage = 'Rejected' WHERE leave_id = ?";
            ps2 = con.prepareStatement(updateStageQuery);
            ps2.setInt(1, leaveId);
            ps2.executeUpdate();
            response.sendRedirect("pendingLeavesVo.jsp"); // Redirect back to VO's pending leaves page
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (ps2 != null) ps2.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
