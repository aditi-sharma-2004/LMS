<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parent Dashboard - Leave Management System</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            box-sizing: border-box;
        }
    
        /* Top Navigation Bar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            color: white;
            padding: 10px 20px;
            position: fixed;
            top: 0;
            width: 100%; /* Changed width to 100% for consistency */
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            height: 80px; /* Ensure the height is fixed */
            flex-wrap: wrap; /* Ensures content wraps instead of overflowing */
            box-sizing: border-box;
        }
    
        .navbar .logo {
            display: flex;
            align-items: center;
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

    

        /* Hero Section */
       /* .hero {
            padding: 20px;
            text-align: center;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .hero h2 {
            color: #333;
            margin: 0 0 10px;
        }

        .hero p {
            color: #555;
            margin: 5px 0;
            font-size: 14px;
        }  */

        /* Options Section */
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

     <!-- Top Navigation Bar -->
  <div class="navbar">
    <div class="logo">
      <img src="Logoos.jpg" alt="Logo">
    </div>
    <div class="nav-links">
      <a href="contact.jsp">Contact Us</a>
      <a href="logout.jsp" class="logout">Logout</a>
    </div>
  </div>

    <!-- Hero Section -->
    <div class="content">
        <div class="details-container">
            <%
                // Use the implicit session object. Ensure that your login servlet sets "studentId"
                String guardianId = (String) session.getAttribute("guardianId");
                if(guardianId == null) {
                    response.sendRedirect("glogin.jsp");
                    return;
                }
            %>

      
            <div class="photo-container">
                <img src="GuardianPhotoServlet?guardianId=<%= guardianId %>" alt="Guardian Photo">
            </div>
            <div class="details-grid">
                <%
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms","lms");
                        String query = "SELECT guardian_id, name, email, phone, address FROM Guardians WHERE guardian_id = ?";
                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, guardianId);
                        rs = pstmt.executeQuery();
                        if(rs.next()){
                %>
                <label>Guardian ID:</label>
                <input type="text" value="<%= rs.getString("guardian_id") %>" readonly>
                
                <label>Name:</label>
                <input type="text" value="<%= rs.getString("name") %>" readonly>
                
                <label>Email:</label>
                <input type="text" value="<%= rs.getString("email") %>" readonly>
                
                <label>Phone:</label>
                <input type="text" value="<%= rs.getString("phone") %>" readonly>
                
                <label>Address:</label>
                <input type="text" value="<%= rs.getString("address") %>" readonly>
                <%
                        } else {
                            out.println("<p style='color: red;'>No guardian found with the provided ID.</p>");
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
    <!-- Options Section -->
    <div class="options">
        <a href="leave_request.jsp" class="button">Create Application</a>
        <a href="track.jsp" class="button">Track Applications</a>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2025 Leave Management System - Banasthali Vidyapith</p>
</div>

</body>
</html>
      