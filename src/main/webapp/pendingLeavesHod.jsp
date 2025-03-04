<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<!DOCTYPE html>
<html>
<head>
    
    <title>Pending Leave Requests (HOD)</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .container {
            max-width: 1000px;
            margin: auto;
            background: white;
            padding: 60px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-wrapper {
            overflow-x: auto;
            display: block;
            width: 100%;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            table-layout: fixed; /* Ensures even column distribution */
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
            word-wrap: break-word;
            white-space: nowrap; /* Prevents text from wrapping */
        }

        th {
            background-color: #3ecd8d;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            color: white;
            padding: 3px 20px;
            position: absolute;
            left: 0;
            top: 0;
            width: 98%;
            z-index: 1000;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .navbar .logo {
            display: flex;
            align-items: center;
        }

        .navbar .logo img {
            width: 150px;
            height: auto;
            margin-right: 10px;
        }

        .navbar .logo h1 {
            font-size: 30px;
            margin: 0;
            font-weight: 500;
        }

        .navbar .nav-links {
            display: flex;
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
        .btn {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-size: 14px;
            cursor: pointer;
        }
        .accept { background-color: #28a745; }
        .reject { background-color: #dc3545; }
        .btn i { margin-right: 5px; }
        .btn:hover {
            opacity: 0.8;
        }
                .search-bar {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
            width: 100%;
        }

        .search-bar input {
            width: 50%;
            max-width: 400px;
            padding: 12px 40px 12px 20px; /* Right padding increased for icon */
            font-size: 16px;
            border: 2px solid #3ecd8d;
            border-radius: 25px;
            outline: none;
            transition: 0.3s ease-in-out;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .search-bar input:focus {
            border-color: #28a745;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
        }

        .search-bar i {
            position: absolute;
            right: 289px;
            font-size: 18px;
            color: #3ecd8d;
            cursor: pointer;
        }


    </style>
    <script>
        function searchStudent() {
            let input = document.getElementById("searchInput").value.toUpperCase();
            let table = document.getElementById("leaveTable");
            let tr = table.getElementsByTagName("tr");
            
            for (let i = 1; i < tr.length; i++) {
                let td = tr[i].getElementsByTagName("td")[1];
                if (td) {
                    let txtValue = td.textContent || td.innerText;
                    tr[i].style.display = txtValue.toUpperCase().indexOf(input) > -1 ? "" : "none";
                }
            }
        }
    </script>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
            
        </div>
        <div class="nav-links">
            <ul>
                <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/" target="_blank">HOME</a></li>
                <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/hgher-education/index.html" target="_blank">PROGRAMS</a></li>
                <li><a href="http://banasthali.org/banasthali/wcms/en/home/lower-menu/campus-tour/index.html" target="_blank">CAMPUS</a></li>
                <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/about-us/index.html" target="_blank">ABOUT US</a></li>
            </ul>
        </div>
    </div>
    <div class="container">
        <h2>Pending Leave Requests - HOD Panel</h2>
        <div class="search-bar">
            <input type="text" id="searchInput" onkeyup="searchStudent()" placeholder="Search by Student ID...">
            <i class="fas fa-search"></i>
        </div>
        
        <div class="table-wrapper">
    
    <table>
        <tr>
            <th>Leave ID</th>
            <th>Student ID</th>
            <th>Reason</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <%
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");
                stmt = con.createStatement();
                String query = "SELECT * FROM LeaveRequests WHERE warden_status = 'Accepted' AND verification_status = 'Accepted' AND hod_status = 'Pending'";
                rs = stmt.executeQuery(query);

                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("leave_id") %></td>
            <td><%= rs.getString("student_id") %></td>
            <td><%= rs.getString("reason") %></td>
            <td><%= rs.getDate("start_date") %></td>
            <td><%= rs.getDate("end_date") %></td>
            <td><%= rs.getString("hod_status") %></td>
            <td>
                <a href="acceptLeaveHod.jsp?leave_id=<%= rs.getInt("leave_id") %>" class="btn accept">Approve</a>
                <a href="rejectLeaveHod.jsp?leave_id=<%= rs.getInt("leave_id") %>" class="btn reject">Reject</a>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            }
        %>
    </table>
</div>
</div>
</body>
</html>
