<%@ page import="java.sql.*" %>
<%
    String leaveId = request.getParameter("leave_id");

    if (leaveId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

            String sql = "UPDATE LeaveRequests SET status = 'Accepted' WHERE leave_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(leaveId));

            int updated = stmt.executeUpdate();

            if (updated > 0) {
                out.println("<script>alert('Leave Accepted Successfully!'); window.location='viewLeave.jsp';</script>");
            } else {
                out.println("<script>alert('Error: Leave not found!'); window.location='viewLeave.jsp';</script>");
            }

            conn.close();
        } catch (Exception e) {
            out.println("<script>alert('Database Error: " + e.getMessage() + "'); window.location='viewLeave.jsp';</script>");
        }
    }
%>
