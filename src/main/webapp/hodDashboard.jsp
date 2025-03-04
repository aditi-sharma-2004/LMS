<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HOD Dashboard - Leave Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            box-sizing: border-box;
        }
        
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            color: white;
            padding: 10px 20px;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            height: 80px;
        }
        
        .navbar .logo img {
            width: 180px;
            height: auto;
            margin-right: 20px;
        }
    
        .navbar .logo h1 {
            font-size: 20px;
            margin: 0;
            font-weight: 500;
        }
    
        .navbar .nav-links {
            display: flex;
            gap: 15px; /* Adjusted spacing for better layout */
            align-items: center;
            flex-shrink: 0; /* Prevents shrinking of links */
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
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            box-sizing: border-box;
        }
        
        .options {
            display: flex;
            justify-content: center;
            gap: 30px;
        }

        .options .button {
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            padding: 15px 30px;
            border-radius: 5px;
            font-size: 16px;
            text-align: center;
            transition: background-color 0.3s, transform 0.2s;
            display: inline-block;
        }

        .options .button:hover {
            background-color: #45a049;
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
            border-color: #4CAF50;
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

        .footer {
            text-align: center;
            padding: 15px 0;
            background-color: #333;
            color: white;
            font-size: 14px;
            position: fixed;
            bottom: 0;
            width: 100%;
            z-index: 1000;
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            <a href="contact.jsp">Contact Us</a>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>

    <div class="content">
        <div class="details-container">
            <%
                String hodId = (String) session.getAttribute("hodId");
                if (hodId == null) {
                    response.sendRedirect("hodLogin.jsp");
                    return;
                }
            %>

            <div class="photo-container">
                <img src="HODPhotoServlet?hodId=<%= hodId %>" alt="HOD Photo">
            </div>
            <div class="details-grid">
                <%
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms","lms");

                        String query = "SELECT h.hod_id, h.name, h.email, h.phone, h.department_id, d.name AS department_name " +
                                       "FROM hod h LEFT JOIN departments d ON h.department_id = d.department_id " +
                                       "WHERE h.hod_id = ?";
                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, hodId);
                        rs = pstmt.executeQuery();

                        if(rs.next()){
                %>
                <label>HOD ID:</label>
                <input type="text" value="<%= rs.getString("hod_id") %>" readonly>

                <label>Name:</label>
                <input type="text" value="<%= rs.getString("name") %>" readonly>

                <label>Email:</label>
                <input type="text" value="<%= rs.getString("email") %>" readonly>

                <label>Phone:</label>
                <input type="text" value="<%= rs.getString("phone") %>" readonly>

                <label>Department:</label>
                <input type="text" value="<%= rs.getString("department_name") != null ? rs.getString("department_name") : "Not Assigned" %>" readonly>
                <%
                        } else {
                            out.println("<p style='color: red;'>No HOD found with the provided ID.</p>");
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
        <a href="pendingLeavesHod.jsp" class="button">Approve Leave Requests</a>
        <a href="viewLeavesHod.jsp" class="button">View Approved Applications</a>
    </div>

    <div class="footer">
        <p>&copy; 2025 Leave Management System - Banasthali Vidyapith</p>
    </div>

</body>
</html>
