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
        String updateQuery = "UPDATE LeaveRequests SET warden_status = 'Accepted' WHERE leave_id = ?";
        ps = con.prepareStatement(updateQuery);
        ps.setInt(1, leaveId);
        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            %>
                <script>
                    alert("Leave Accepted Successfully!");
                    window.location.href = "pendingLeavesWarden.jsp";
                </script>
            <%
            } else {
                out.println("No rows updated. Check if leave_id exists.");
            }
            
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
