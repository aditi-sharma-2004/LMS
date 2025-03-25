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
        String updateQuery = "UPDATE LeaveRequests SET verification_status = 'Accepted', final_status = 'Accepted' WHERE leave_id = ?";
        ps = con.prepareStatement(updateQuery);
        ps.setInt(1, leaveId);
        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
<<<<<<< HEAD
            %>
            <script>
                alert("Leave Accepted Successfully!");
                window.location.href = "pendingLeavesVo.jsp";
            </script>
        <%
=======
            String updateStageQuery = "UPDATE LeaveRequests SET current_stage = 'HOD' WHERE leave_id = ?";
            ps2 = con.prepareStatement(updateStageQuery);
            ps2.setInt(1, leaveId);
            ps2.executeUpdate();
            response.sendRedirect("pendingLeavesVo.jsp"); // Redirect back to VO's pending leaves page
>>>>>>> 4e6767abb017a58d23f9125b8f3ce077a8dba87a
        }
    else {
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
