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
        String updateQuery = "UPDATE leaverequests SET warden_status = 'Rejected' ,warden_status = 'Rejected',verification_status = 'Rejected',hod_status = 'Rejected',gpo_status = 'Rejected', final_status='Rejected' WHERE leave_id = ?";
        ps = con.prepareStatement(updateQuery);
        ps.setInt(1, leaveId);
        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            String updateStageQuery = "UPDATE leaverequests SET current_stage = 'Rejected' WHERE leave_id = ?";
            ps2 = con.prepareStatement(updateStageQuery);
            ps2.setInt(1, leaveId);
            ps2.executeUpdate();
            %>
                <script>
                    alert("Leave Rejected Successfully!");
                    window.location.href = "pendingLeavesWarden.jsp";  // Fixed redirect
                </script>
            <%
            } else {
                out.println("No rows updated. Check if leave_id exists.");
            }
            
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (ps2 != null) ps2.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>