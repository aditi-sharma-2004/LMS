<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Approved Applications</title>
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
    </style>
</head>
<body>
    <div class="container">
        <h2>Approved Applications</h2>
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
                String[][] approvedApps = {
                    {"A101", "John Doe", "Hostel A", "Medical Leave - 2 days"},
                    {"A102", "Jane Smith", "Hostel B", "Family Event - 3 days"}
                };
                for (String[] app : approvedApps) {
            %>
            <tr>
                <td><%= app[0] %></td>
                <td><%= app[1] %></td>
                <td><%= app[2] %></td>
                <td><%= app[3] %></td>
                <td class="action-buttons">
                    <a href="updateApplication.jsp?id=<%= app[0] %>" class="edit">Update</a>
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</body>
</html>