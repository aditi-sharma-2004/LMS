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
            margin-top: 60px; /* Added to prevent navbar overlap */
        }
        .container {
            margin-top: 20px;
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
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            color: white;
            padding: 3px 8px;
            position: absolute;
            left: 0;
            top: 0;
            width: 99%;
            z-index: 1000;
            box-shadow: 0 2px 2px rgba(0, 0, 0, 0.2);
           }
           
           .navbar .logo {
            display: flex;
            align-items: center;
           }
           
           .navbar .logo img {
            width: 150px;
            height: auto;
            margin-right: 10px;
            margin-left: 0px;
           }
           
           .navbar .logo h1 {
            font-size: 30px;
            margin: 0;
            font-weight: 500;
           }
           
           .navbar .nav-links {
            display: flex;
            align-items: center;
            gap: 20px;
           }
           
           .navbar .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
           }
           
           .navbar .nav-links a:hover {
            color: #4CAF50;
           }
           .contact{
            margin-top: 10px;
           }
           .navbar ul li {
            list-style: none;
            display: inline-block;
            margin: 0 20px;
            position: relative;
           }
           .navbar ul li a{
            text-decoration: none;
            color: #fff;
           }
           .navbar ul li::after{
            content: '';
           height: 3px;
           width: 0;
           background: #6386a6;
           position: absolute;
           left: 0;
           bottom: -10px; 
           transition: 0.5s;
           }
           .navbar ul li:hover::after{
            width: 100%;
           }
           .navbar .nav-button {
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-size: 14px;
            transition: background-color 0.3s;
           }
           
           .navbar .nav-button:hover {
            background-color: #45a049;
           }
           .quick-links {
            position: relative;
           }
           
           .quick-links .dropdown {
            display: none;
            position: absolute;
            background-color: white;
            min-width: 150px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 5px;
            overflow: hidden;
           }
           
           .quick-links .dropdown a {
            color: black;
            padding: 10px;
            display: block;
            text-decoration: none;
           }
           
           .quick-links:hover .dropdown {
           display: block;
           }
           
           .logout {
            color: white;
            background-color: #f44336;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-size: 14px;
            transition: background-color 0.3s;
           }
           
           .logout:hover {
            background-color: #d32f2f;
           }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            <a href="resetPassword.jsp">Change Password</a>
            <div class="quick-links">
                <button class="dropdown-button">Quick Links</button>
                <div class="dropdown">
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/" target="_blank">Home</a>
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/hgher-education/index.html" target="_blank">Programs</a>
                    <a href="http://banasthali.org/banasthali/wcms/en/home/lower-menu/campus-tour/index.html" target="_blank">Campus</a>
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/about-us/index.html" target="_blank">About Us</a>
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/lower-menu/contact_us/index.html" target="_blank">Contact Us</a>
                </div>
            </div>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>

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
                        String query = "SELECT * FROM LeaveRequests WHERE warden_status = 'Accepted' AND verification_status = 'Accepted' AND hod_status = 'Accepted' AND gpo_status='Pending'";
                        rs = stmt.executeQuery(query);
                        
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("leave_id") %></td>
                    <td><%= rs.getString("student_id") %></td>
                    <td><%= rs.getString("reason") %></td>
                    <td>
                        <a href="gatepasshtml.jsp?leave_id=<%= rs.getInt("leave_id") %>&student_id=<%= rs.getString("student_id") %>" class="btn-print">Print Gatepass</a>
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