<%
    int leaveId = Integer.parseInt(request.getParameter("leave_id"));
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

        String query = "SELECT * FROM LeaveRequests WHERE leave_id = ?";
        ps = con.prepareStatement(query);
        ps.setInt(1, leaveId);
        rs = ps.executeQuery();

        if (rs.next()) {
%>
        <h2>Gate Pass</h2>
        <p><strong>Student ID:</strong> <%= rs.getString("student_id") %></p>
        <p><strong>Leave ID:</strong> <%= rs.getInt("leave_id") %></p>
        <p><strong>Reason:</strong> <%= rs.getString("reason") %></p>
        <p><strong>Leave Dates:</strong> <%= rs.getString("leave_dates") %></p>
        <p><strong>All Approvals Done</strong></p>

        <button onclick="window.print()">Print Gatepass</button>
<%
        } else {
            out.println("No record found.");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
