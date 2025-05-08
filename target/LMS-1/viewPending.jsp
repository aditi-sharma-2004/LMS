<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Pending Applications</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f9f9f9; }
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; background-color: #fff; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); border-radius: 10px; }
        h2 { text-align: center; color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .action-buttons a { text-decoration: none; padding: 8px 12px; border-radius: 5px; font-size: 14px; margin-right: 10px; }
        .edit { background-color: #ff9800; color: white; }
        .approve { background-color: #4CAF50; color: white; }
        .reject { background-color: #c02d2d; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Pending Applications</h2>
        <table>
            <tr>
                <th>Application ID</th>
                <th>Student Name</th>
                <th>Hostel</th>
                <th>Details</th>
                <th>Actions</th>
            </tr>
            <%
                // Example hardcoded data; replace with database logic
                String[][] pendingApps = {
                    {"P201", "Alice Johnson", "Hostel C", "Sick Leave - 1 day"},
                    {"P202", "Bob Lee", "Hostel D", "Urgent Family Event - 5 days"}
                };
                for (String[] app : pendingApps) {
            %>
            <tr>
                <td><%= app[0] %></td>
                <td><%= app[1] %></td>
                <td><%= app[2] %></td>
                <td><%= app[3] %></td>
                <td class="action-buttons">
                    <a href="updateApplication.jsp?id=<%= app[0] %>" class="edit">Update</a>
                    <a href="approveApplication.jsp?id=<%= app[0] %>" class="approve">Approve</a>
                    <a href="rejectApplication.jsp?id=<%= app[0] %>" class="reject">Reject</a>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</body>
</html>
