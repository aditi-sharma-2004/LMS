<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warden Dashboard - Leave Management System</title>
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
            <a href="contact.jsp">Contact Us</a>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>

    <div class="content">
        <div class="details-container">
            <%
                String wardenId = (String) session.getAttribute("wardenId");
                if (wardenId == null) {
                    response.sendRedirect("wardenLogin.jsp");
                    return;
                }
            %>

            <div class="photo-container">
                <img src="WardenPhotoServlet?wardenId=<%= wardenId %>" alt="Warden Photo">
            </div>
            <div class="details-grid">
                <%
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","lms","lms");

                // Query to fetch warden details along with hostel name
                String query = "SELECT w.warden_id, w.name, w.email, w.phone, w.hostel_id, h.name " +
                               "FROM wardens w LEFT JOIN hostels h ON w.hostel_id = h.hostel_id " +
                               "WHERE w.warden_id = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, wardenId);
                rs = pstmt.executeQuery();

                if(rs.next()){
        %>
        <label>Warden ID:</label>
        <input type="text" value="<%= rs.getString("warden_id") %>" readonly>

        <label>Name:</label>
        <input type="text" value="<%= rs.getString("name") %>" readonly>

        <label>Email:</label>
        <input type="text" value="<%= rs.getString("email") %>" readonly>

        <label>Phone:</label>
        <input type="text" value="<%= rs.getString("phone") %>" readonly>

        <label>Hostel Name:</label>
        <input type="text" value="<%= rs.getString("h.name") != null ? rs.getString("h.name") : "Not Assigned" %>" readonly>
        <%
                } else {
                    out.println("<p style='color: red;'>No warden found with the provided ID.</p>");
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
        <a href="viewLeavesWarden.jsp" class="button">View Approved Applications</a>
        <a href="pendingLeavesWarden.jsp" class="button">View Pending Applications</a>
    </div>
    <div class="footer">
        <p>&copy; 2025 Leave Management System - Banasthali Vidyapith</p>
    </div>

</body>
</html>