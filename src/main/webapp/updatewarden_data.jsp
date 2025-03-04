<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>

<%
    // Retrieve form data
    String warden_id = request.getParameter("warden_id");
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String hostel_id = request.getParameter("hostel_id");

    Connection con = null;
    PreparedStatement pstmt = null;

    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

        // SQL query to update warden details
        String query = "UPDATE wardens SET name=?, phone=?, email=?, hostel_id=? WHERE warden_id=?";
        pstmt = con.prepareStatement(query);
        pstmt.setString(1, name);
        pstmt.setString(2, phone);
        pstmt.setString(3, email);
        pstmt.setString(4, hostel_id);
        pstmt.setString(5, warden_id);

        int rowsUpdated = pstmt.executeUpdate();

        if (rowsUpdated > 0) {
%>
            <p style="color: green; font-weight: bold;">Warden Updated Successfully</p>
<%
        } else {
%>
            <p style="color: red; font-weight: bold;">Update Failed: No record found</p>
<%
        }
    } catch (Exception e) {
%>
        <p style="color: red; font-weight: bold;">Error updating warden: <%= e.getMessage() %></p>
<%
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>
