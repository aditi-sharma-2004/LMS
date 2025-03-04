<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approved Leaves - Gatepass</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 50px;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #343a40;
        }
        table {
            width: 100%;
            background: #fff;
        }
        th {
            background: #007bff;
            color: white;
        }
        th, td {
            text-align: center;
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .btn-print {
            background-color: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
        }
        .btn-print:hover {
            background-color: #218838;
            color: white;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Approved Leaves - Print Gatepass</h2>
    
    <table class="table table-striped table-bordered">
        <thead>
            <tr>
                <th>Leave ID</th>
                <th>Student ID</th>
                <th>Reason</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection con = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");
                    stmt = con.createStatement();
                    
                    // Fetch applications where all approvals are done
                    String query = "SELECT * FROM LeaveRequests WHERE warden_status = 'Accepted' AND verification_status = 'Accepted' AND hod_status = 'Accepted'";
                    rs = stmt.executeQuery(query);

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("leave_id") %></td>
                <td><%= rs.getString("student_id") %></td>
                <td><%= rs.getString("reason") %></td>
                <td>
                    <a href="printGatepass.jsp?leave_id=<%= rs.getInt("leave_id") %>" class="btn-print">Print Gatepass</a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='4' class='text-center text-danger'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>
