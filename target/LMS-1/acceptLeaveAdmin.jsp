<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
    int leaveId = Integer.parseInt(request.getParameter("leave_id"));
    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

        // Update leave request status to Accepted
        String updateQuery = "UPDATE LeaveRequests SET final_status = 'Accepted', warden_status = 'Accepted', verification_status = 'Accepted', hod_status = 'Accepted' WHERE leave_id = ?";
        ps = con.prepareStatement(updateQuery);
        ps.setInt(1, leaveId);
        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
%>
            <script>
                alert("Leave Accepted Successfully!");
                window.location.href = "pendingLeaves.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("Error: Leave not found!");
                window.location.href = "pendingLeaves.jsp";
            </script>
<%
        }
    } catch (Exception e) {
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.location.href='pendingLeaves.jsp';</script>");
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
