<%@ page import="java.sql.*" %>
<%
    String leaveId = request.getParameter("leave_id");
    String startDate = request.getParameter("start_date");
    String endDate = request.getParameter("end_date");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

        String sql = "UPDATE LeaveRequests SET start_date = ?, end_date = ? WHERE leave_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, startDate);
        ps.setString(2, endDate);
        ps.setString(3, leaveId);

        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            out.println("<script>alert('Leave dates updated successfully!'); window.location='leaveDetails.jsp?leave_id=" + leaveId + "';</script>");
        } else {
            out.println("<script>alert('Error updating leave dates.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Database error: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
