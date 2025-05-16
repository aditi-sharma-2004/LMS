<%@ page import="java.util.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Track Leave</title>
    <style>
        body { font-family: Arial, sans-serif; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid black; text-align: left; }
    </style>
</head>
<body>
    <h2>Leave Tracking</h2>
    <table>
        <tr>
            <th>Leave ID</th>
            <th>Reason</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
            <th>Warden Status</th>
            <th>HOD Status</th>
            <th>Verification Officer Status</th>
            <th>GPO Status</th>
            <th>Final Status</th>
        </tr>
        <% List<Map<String, String>> leaveRecords = (List<Map<String, String>>) request.getAttribute("leaveRecords"); %>
        <% if (leaveRecords != null && !leaveRecords.isEmpty()) { %>
            <% for (Map<String, String> record : leaveRecords) { %>
                <tr>
                    <td><%= record.get("leave_id") %></td>
                    <td><%= record.get("reason") %></td>
                    <td><%= record.get("start_date") %></td>
                    <td><%= record.get("end_date") %></td>
                    <td><%= record.get("status") %></td>
                    <td><%= record.get("warden_status") %></td>
                    <td><%= record.get("hod_status") %></td>
                    <td><%= record.get("verification_status") %></td>
                    <td><%= record.get("gpo_status") %></td>
                    <td><%= record.get("final_status") %></td>
                </tr>
            <% } %>
        <% } else { %>
            <tr><td colspan="10">No leave records found.</td></tr>
        <% } %>
    </table>
    <br>
    <a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>
