<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>

<%
    // Retrieve form data
    String student_id = request.getParameter("student_id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String dob = request.getParameter("dob");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String department_id = request.getParameter("department");
    String course_id = request.getParameter("course");
    String year = request.getParameter("year");

    Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmtFetch = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

        // Update student details
        String updateQuery = "UPDATE Students SET name=?, email=?, dob=?, phone=?, address=?, department_id=?, course_id=?, year=? WHERE student_id=?";
        pstmt = con.prepareStatement(updateQuery);
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, dob);
        pstmt.setString(4, phone);
        pstmt.setString(5, address);
        pstmt.setString(6, department_id);
        pstmt.setString(7, course_id);
        pstmt.setString(8, year);
        pstmt.setString(9, student_id);

        int rowsUpdated = pstmt.executeUpdate();

        // Fetch department and course names
        String fetchQuery = "SELECT d.name, c.name FROM Departments d, Courses c WHERE d.department_id=? AND c.course_id=?";
        pstmtFetch = con.prepareStatement(fetchQuery);
        pstmtFetch.setString(1, department_id);
        pstmtFetch.setString(2, course_id);
        rs = pstmtFetch.executeQuery();

        String department_name = "Unknown";
        String course_name = "Unknown";

        if (rs.next()) {
            department_name = rs.getString("d.name");
            course_name = rs.getString("c.name");
        }
%>
        <% if (rowsUpdated > 0) { %>
            <p style="color: green; font-weight: bold;">Updated Successfully</p>
            <p><strong>Department:</strong> <%= department_name %></p>
            <p><strong>Course:</strong> <%= course_name %></p>
        <% } else { %>
            <p style="color: red; font-weight: bold;">Update Failed</p>
        <% } %>

<%  
    } catch (Exception e) { 
%>
    <p style="color: red; font-weight: bold;">Error updating details: <%= e.getMessage() %></p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if
