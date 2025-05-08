<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Connection con = null;
    PreparedStatement pstmt = null;

    try {
        String wardenId = (String) session.getAttribute("wardenId");

        if (wardenId == null) {
            out.println("<p style='color:red;'>Warden ID is not set in session. Please log in again.</p>");
            return;
        }

        String leaveId = request.getParameter("leave_id");
        String returnDateTime = request.getParameter("return_date_time");

        if (leaveId == null || returnDateTime == null) {
            out.println("<p style='color:red;'>Invalid form submission.</p>");
            return;
        }

        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

        String updateQuery = "UPDATE LeaveRequests SET actual_return_date = ? WHERE leave_id = ?";
        pstmt = con.prepareStatement(updateQuery);
        pstmt.setString(1, returnDateTime); // Should match DATETIME format
        pstmt.setString(2, leaveId);

        int rowsUpdated = pstmt.executeUpdate();

        if (rowsUpdated > 0) {
response.sendRedirect("viewLeavesWarden.jsp?wardenId=" + wardenId); // Redirect to avoid resubmission
        } else {
            out.println("<p style='color:red;'>Failed to update return date.</p>");
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>
