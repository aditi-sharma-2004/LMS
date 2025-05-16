<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VO Dashboard - Leave Management System</title>
    <style>
        body {
    font-family: Arial, sans-serif;
    background-image: url('img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed; /* Keeps the background fixed */
    margin: 0;
    padding: 0;
    overflow-x: hidden; /* Prevent horizontal scroll */
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
    background-color:  #8E54E9;
    color: white;
    text-decoration: none;
    padding: 10px 15px;
    border-radius: 5px;
    font-size: 14px;
    transition: background-color 0.3s;
}

.navbar .nav-button:hover {
    background-color:  #8E54E9;
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
        /* Main Content */
        .content {
            margin-top: 60px; /* This ensures content starts below the navbar */
            padding: 20px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            box-sizing: border-box;
        }
        
        .options {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 30px;
        }

        .options .button {
            background-color:  #8E54E9;
            color: white;
            text-decoration: none;
            padding: 15px 30px;
            border-radius: 5px;
            font-size: 16px;
            text-align: center;
            transition: background-color 0.3s, transform 0.2s;
            display: inline-block;
            position: relative;
        }

        .options .button:hover {
            background-color:  #8E54E9;
            transform: scale(1.05);
        }
        
        .details-container {
      background-color: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      display: flex;
      align-items: flex-start;
      gap: 30px;
    }

        .details-container h2 {
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
            width: 80%; /* Match container width */
            text-align: left;
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 2fr; /* Two columns: labels and textboxes */
            gap: 5px 5px;
            width: 50%; /* Match container width */
        }

        .details-grid label {
            font-size: 14px;
            color: #555;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .details-grid input {
            padding: 5px 8px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
            width: 100%; /* Stretch to column width */
        }

        .details-grid input:focus {
            border-color:  #8E54E9;
            outline: none;
            background-color: #fff;
        }
        .photo-container {
      flex-shrink: 0;
    }
    
    .photo-container img {
      max-width: 200px;
      border-radius: 10px;
    }
/* Badge styles for leave counts */
        .badge {
            position: absolute;
            top: -10px;
            right: -10px;
            background-color: #ff4757;
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 12px;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        /* Footer */
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

    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            
            <a href="vo_change_password.jsp" >Change Password</a>
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

    <div class="content">
        <div class="details-container">
            <%
                String voId = (String) session.getAttribute("voId");
                if (voId == null) {
                    response.sendRedirect("voLogin.jsp");
                    return;
                }
            
                // Variables to store leave counts
                int pendingLeaves = 0;
                int approvedLeaves = 0;
            %>

            <div class="photo-container">
                <img src="VOPhotoServlet?voId=<%= voId %>" alt="VO Photo">
            </div>
            <div class="details-grid">
                <%
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

                        // Query to fetch VO details along with department name
                        String query = "SELECT v.vo_id, v.name, v.email, v.phone, v.department_id, d.name AS department_name " +
                                       "FROM vo v LEFT JOIN departments d ON v.department_id = d.department_id " +
                                       "WHERE v.vo_id = ?";
                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, voId);
                        rs = pstmt.executeQuery();

                        if(rs.next()){
                            String departmentId = rs.getString("department_id");
                %>
                <label>VO ID:</label>
                <input type="text" value="<%= rs.getString("vo_id") %>" readonly>

                <label>Name:</label>
                <input type="text" value="<%= rs.getString("name") %>" readonly>

                <label>Email:</label>
                <input type="text" value="<%= rs.getString("email") %>" readonly>

                <label>Phone:</label>
                <input type="text" value="<%= rs.getString("phone") %>" readonly>

                <label>Department:</label>
                <input type="text" value="<%= rs.getString("department_name") != null ? rs.getString("department_name") : "Not Assigned" %>" readonly>
                <%
                            // Query to count pending leaves for the department
                            if(departmentId != null) {
                                // Close previous resources
                                rs.close();
                                pstmt.close();
                                
                                // Count pending leaves
                                String pendingQuery = "SELECT COUNT(*) AS pending_count FROM leaverequests lr " +
                                                     "JOIN students s ON lr.student_id = s.student_id " +
                                                     "WHERE s.department_id = ? AND lr.warden_status = 'Accepted' and lr.verification_status = 'Pending'";
                                pstmt = con.prepareStatement(pendingQuery);
                                pstmt.setString(1, departmentId);
                                rs = pstmt.executeQuery();
                                
                                if(rs.next()) {
                                    pendingLeaves = rs.getInt("pending_count");
                                }
                                
                                // Close previous resources
                                rs.close();
                                pstmt.close();
                                
                                // Count approved leaves
                                String approvedQuery = "SELECT COUNT(*) AS approved_count FROM LeaveRequests " +
                                "WHERE final_status = 'Accepted' " +
                                "AND actual_return_date IS NULL";
         pstmt = con.prepareStatement(approvedQuery);
         // Remove the line: pstmt.setString(1, departmentId);
         rs = pstmt.executeQuery();
                                
                                if(rs.next()) {
                                    approvedLeaves = rs.getInt("approved_count");
                                }
                            }
                            } else {
                            out.println("<p style='color: red;'>No VO found with the provided ID.</p>");
                        }
                    } catch(Exception e) {
                        out.println("<p style='color: red;'>Error fetching data: " + e.getMessage() + "</p>");
                    } finally {
                        if(rs != null) try { rs.close(); } catch(Exception e) {}
                        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                        if(con != null) try { con.close(); } catch(Exception e) {}
                    }
                %>
            </div>
        </div>
    </div>
    
    <div class="options">
        <a href="pendingLeavesVo.jsp" class="button">
            View Pending Applications
            <% if(pendingLeaves > 0) { %>
            <span class="badge"><%= pendingLeaves %></span>
            <% } %>
        </a>
        <a href="viewLeavesVo.jsp" class="button">
            View Approved Applications
            <% if(approvedLeaves > 0) { %>
            <span class="badge"><%= approvedLeaves %></span>
            <% } %>
        </a>
    </div>
</body>
</html>