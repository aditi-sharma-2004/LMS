<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<html>
<head>
    <title>All Leave Requests</title>
</head>
<body>
    <h2>All Leave Requests</h2>
    <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        ArrayList<LeaveRequest> leaveRequests = new ArrayList<>();

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms","lms");
            stmt = conn.createStatement();
            String query = "SELECT * FROM leave_requests";
            rs = stmt.executeQuery(query);

            while (rs.next()) {
                LeaveRequest request = new LeaveRequest();
                request.setId(rs.getInt("id"));
                request.setGuardianId(rs.getInt("guardian_id"));
                request.setStudentId(rs.getInt("student_id"));
                request.setLeaveStartDate(rs.getDate("leave_start_date"));
                request.setLeaveEndDate(rs.getDate("leave_end_date"));
                request.setReason(rs.getString("reason"));
                request.setStatus(rs.getString("status"));
                leaveRequests.add(request);
            }
            request.setAttribute("leaveRequests", leaveRequests);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
    <table border="1">
        <thead>
            <tr>
                <th>Leave ID</th>
                <th>Guardian ID</th>
                <th>Student ID</th>
                <th>Leave Start Date</th>
                <th>Leave End Date</th>
                <th>Reason</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="request" items="${leaveRequests}">
                <tr>
                    <td>${request.id}</td>
                    <td>${request.guardian_id}</td>
                    <td>${request.student_id}</td>
                    <td>${request.leave_start_date}</td>
                    <td>${request.leave_end_date}</td>
                    <td>${request.reason}</td>
                    <td>${request.status}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
