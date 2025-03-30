<%@ page import="java.sql.*" %>

<html>
<head>
    <title>Update Leave Request</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background-color: #ffffff; 
            color: #4b0082;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px; 
        }
        th, td { 
            border: 1px solid #d8bfd8; 
            padding: 10px; 
            text-align: left; 
        }
        th { 
            background-color: #d8bfd8; 
            width: 30%; 
            color: #4b0082;
        }
        input, select, textarea { 
            width: 98%; 
            padding: 8px; 
            border: 1px solid #800080; 
            border-radius: 5px; 
        }
        button { 
            background-color: #800080; 
            color: white; 
            padding: 8px 15px; 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            width: 150px; 
            display: block; 
            margin: 20px auto;
        }
        .student-image { 
            width: 150px; 
            height: 150px; 
            border-radius: 10px; 
            border: 1px solid #ddd; 
            display: block; 
            margin: auto; 
        }
        h2 {
            text-align: center;
            color: #800080;
        }
    </style>
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body>
    <%
    String smartcardID = request.getParameter("smartcardID");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

        String query = "SELECT * FROM leaverequests WHERE student_id = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, smartcardID);
        rs = stmt.executeQuery();

        if (rs.next()) {
%>
    <h2>Update Leave Request</h2>
    <form action="UpdateLeaveRequestServlet" method="post">
        <input type="hidden" name="leave_id" value="<%= rs.getInt("leave_id") %>">

        <table>
            <tr>
                <th>Student Image</th>
                <td colspan="3">
                    <img src="StudentPhotoServlet?smartcardID=<%= smartcardID %>" alt="Student Image" class="student-image">

                </td>
            </tr>
            <tr>
                <th>Student ID</th>
                <td colspan="3"><%= smartcardID %></td>
            </tr>
            <tr>
                <th>Reason</th>
                <td colspan="3"><textarea name="reason"><%= rs.getString("reason") %></textarea></td>
            </tr>
            <tr>
                <th>Start Date</th>
                <td><input type="date" name="start_date" value="<%= rs.getDate("start_date") %>"></td>
                <th>End Date</th>
                <td><input type="date" name="end_date" value="<%= rs.getDate("end_date") %>"></td>
            </tr>
            <tr>
                <th>Status</th>
                <td colspan="3">
                    <select name="status">
                        <option value="Pending" <%= rs.getString("status").equals("Pending") ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= rs.getString("status").equals("Accepted") ? "selected" : "" %>>Accepted</option>
                        <option value="Rejected" <%= rs.getString("status").equals("Rejected") ? "selected" : "" %>>Rejected</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Leaving Address</th>
                <td colspan="3"><textarea name="leaving_address"><%= rs.getString("leaving_address") %></textarea></td>
            </tr>
            <tr>
                <th>Companion Name</th>
                <td><input type="text" name="companion_name" value="<%= rs.getString("companion_name") %>"></td>
                <th>Companion Relation</th>
                <td><input type="text" name="companion_relation" value="<%= rs.getString("companion_relation") %>"></td>
            </tr>
            <tr>
                <th>Companion Phone</th>
                <td colspan="3"><input type="text" name="companion_phone" value="<%= rs.getString("companion_phone") %>"></td>
            </tr>
            <tr>
                <th>Warden Status</th>
                <td>
                    <select name="warden_status">
                        <option value="Pending" <%= rs.getString("warden_status").equals("Pending") ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= rs.getString("warden_status").equals("Accepted") ? "selected" : "" %>>Accepted</option>
                        <option value="Rejected" <%= rs.getString("warden_status").equals("Rejected") ? "selected" : "" %>>Rejected</option>
                    </select>
                </td>
                <th>HOD Status</th>
                <td>
                    <select name="hod_status">
                        <option value="Pending" <%= rs.getString("hod_status").equals("Pending") ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= rs.getString("hod_status").equals("Accepted") ? "selected" : "" %>>Accepted</option>
                        <option value="Rejected" <%= rs.getString("hod_status").equals("Rejected") ? "selected" : "" %>>Rejected</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Verification Status</th>
                <td>
                    <select name="verification_status">
                        <option value="Pending" <%= rs.getString("verification_status").equals("Pending") ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= rs.getString("verification_status").equals("Accepted") ? "selected" : "" %>>Accepted</option>
                        <option value="Rejected" <%= rs.getString("verification_status").equals("Rejected") ? "selected" : "" %>>Rejected</option>
                    </select>
                </td>
                <th>Final Status</th>
                <td>
                    <select name="final_status">
                        <option value="Pending" <%= rs.getString("final_status").equals("Pending") ? "selected" : "" %>>Pending</option>
                        <option value="Accepted" <%= rs.getString("final_status").equals("Accepted") ? "selected" : "" %>>Accepted</option>
                        <option value="Rejected" <%= rs.getString("final_status").equals("Rejected") ? "selected" : "" %>>Rejected</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="4">
                    <button type="submit">submit</button>
                </td>
            </tr>
        </table>
    </form>
    <!-- Flatpickr JS -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        flatpickr("#start_date", {
            dateFormat: "Y-m-d",
            minDate: "today",
            disableMobile: true
        });

        flatpickr("#end_date", {
            dateFormat: "Y-m-d",
            minDate: "today",
            disableMobile: true
        });
    </script>

</body>
</html>
<%
        } else {
            out.println("<h2>No leave request found for the given Smartcard ID.</h2>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
