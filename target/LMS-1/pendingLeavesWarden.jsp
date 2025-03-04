<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Leave Requests(Warden)</title>
    <style>
        body {
           font-family: Arial, sans-serif;
           margin: 0;
           padding: 20px;
           background-color: #f8f9fa;
           overflow: hidden;
           display: flex;
    justify-content: center; /* Centers horizontally */
       }
       h2 {
           text-align: center;
           color: #333;
       }
       .container {
           max-width: 1000px;
           margin-top: 60px;
           margin-bottom: 60px;
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
           width: 95%;
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
.footer {
    text-align: center;
    padding: 15px 0;
    background-color: #333;
    color: white;
    margin-left: 0px;
    left: 0;
    right: 0;
    font-size: 14px;
    position: fixed; /* Fixed at the bottom */
    bottom: 0;       /* Aligns to the bottom of the screen */
    width: 100%;     /* Spans the full width of the screen */
    z-index: 1000;   /* Ensures it stays on top of other elements */
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
        let studentID = tr[i].getElementsByTagName("td")[1]; // Student ID column
        let startDate = tr[i].getElementsByTagName("td")[3]; // Start Date column
        let endDate = tr[i].getElementsByTagName("td")[4]; // End Date column
        
        if (studentID && startDate && endDate) {
            let studentText = studentID.textContent || studentID.innerText;
            let startText = startDate.textContent || startDate.innerText;
            let endText = endDate.textContent || endDate.innerText;

            // Show row if input matches any column
            if (studentText.toUpperCase().indexOf(input) > -1 || 
                startText.toUpperCase().indexOf(input) > -1 || 
                endText.toUpperCase().indexOf(input) > -1) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
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
            
            <a href="change_password.jsp" >Change Password</a>
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
    <h2>Pending Leave Requests - Warden Panel</h2>
    <div class="search-bar">
        <input type="text" id="searchInput" onkeyup="searchStudent()" placeholder="Search by Student ID, Start Date or End Date">
        <i class="fas fa-search"></i>
    </div>
    <div class="table-wrapper">
    <table id="leaveTable">
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
                String query = "SELECT * FROM LeaveRequests WHERE warden_status = 'Pending'";
                rs = stmt.executeQuery(query);

                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("leave_id") %></td>
            <td><%= rs.getString("student_id") %></td>
            <td><%= rs.getString("reason") %></td>
            <td><%= rs.getDate("start_date") %></td>
            <td><%= rs.getDate("end_date") %></td>
            <td><%= rs.getString("warden_status") %></td>
            <td>
                <a href="acceptLeaveWarden.jsp?leave_id=<%= rs.getInt("leave_id") %>" class="btn accept">Accept</a>
                <a href="rejectLeaveWarden.jsp?leave_id=<%= rs.getInt("leave_id") %>" class="btn reject">Reject</a>
                
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
    <div class="footer">
        <p>&copy; 2025 Leave Management System - Banasthali Vidyapith</p>
    </div>
</body>
</html>

