<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Approved Leave Requests</title>
    <style>
        body {
           font-family: Arial, sans-serif;
           margin: 0;
           padding: 20px;
           background-color: #f8f9fa;
           overflow-x: hidden; /* Hide horizontal overflow */
           overflow-y: auto;   /* Allow vertical scrolling */
           display: flex;
           padding-top: 50px;
           flex-direction: column;
           align-items: center; /* Center content */
           min-height: 100vh; 
       }
       h2 {
           text-align: center;
           color: #333;
       }
       .container {
           max-width: 1000px;
           margin-top: 80px;
           margin-bottom: 60px;
           background: white;
           padding: 60px;
           border-radius: 10px;
           box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            overflow-x: hidden; /* Hide horizontal overflow */
    overflow-y: auto;   /* Allow vertical scrolling */
           display: flex;
           flex-direction: column; /* Stack items vertically */
           align-items: center;
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
           color: rgb(133, 33, 33);
           font-size: 14px;
           cursor: pointer;
       }
       .view-info { background-color: #6FA8DC; }
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
       .footer {
    text-align: center;
    padding: 15px 0;
    background-color: #333;
    color: white;
    font-size: 14px;
    position: fixed; /* Fixed at the bottom */
    bottom: 0;       /* Aligns to the bottom of the screen */
    width: 100%;     /* Spans the full width of the screen */
    z-index: 1000;   /* Ensures it stays on top of other elements */
}

    </style>
 
</head>
<body>
    <div class="container">
        <h2>Approved Leave Requests</h2>
        <div class="table-wrapper">
            <table>
                <tr>
                    <th>Leave ID</th>
                    <th>Student ID</th>
                    <th>Reason</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                </tr>
                <%
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    String hodId = (String) session.getAttribute("hodId");
    
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");
    
                        // Try to get HOD ID from request if not found in session
                        if (hodId == null) {
                            hodId = request.getParameter("hodId");
                            if (hodId != null) {
                                session.setAttribute("hodId", hodId);
                            }
                        }
    
                        if (hodId == null) {
                            out.println("<p style='color:red;'>HOD ID is not set in session. Please log in again.</p>");
                            return;
                        }
    
                        String query = "SELECT lr.* FROM LeaveRequests lr " +
                                       "JOIN Students s ON lr.student_id = s.student_id " +
                                       "JOIN departments d ON s.department_id = d.department_id " +
                                       "JOIN Hod h ON d.department_id = h.department_id " +
                                       "WHERE lr.final_status = 'Accepted' " +
                                       "AND lr.actual_return_date IS NULL " +
                                       "AND h.hod_id = ?";
    
                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, hodId);
                        rs = pstmt.executeQuery();
    
                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("leave_id") %></td>
                    <td><%= rs.getString("student_id") %></td>
                    <td><%= rs.getString("reason") %></td>
                    <td><%= rs.getDate("start_date") %></td>
                    <td><%= rs.getDate("end_date") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                    <tr><td colspan="5" style="color: red;">Error fetching data.</td></tr>
                <%
                    } finally {
                        try { if (rs != null) rs.close(); } catch (Exception e) {}
                        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                        try { if (con != null) con.close(); } catch (Exception e) {}
                    }
                %>
            </table>
        </div>
    </div>
    
    <div class="footer">
        &copy; 2025 Leave Management System | All rights reserved.
    </div>
    
    </body>
    </html>
    