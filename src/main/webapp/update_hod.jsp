<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HOD Dashboard - Leave Management System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }
        
        /* ✅ Fixed Navbar Styling */
        .navbar { 
            background-color: #333; 
            color: white; 
            padding: 20px 50px; 
            display: flex; 
            justify-content: space-between;
            align-items: center; 
            font-size: 18px;
        }

        .nav-links { display: flex; align-items: center; }
        .nav-links a, .update-btn { 
            color: white; 
            margin: 0 15px; 
            text-decoration: none; 
            font-weight: bold;
            padding: 10px 15px; 
            border-radius: 5px;
            transition: 0.3s;
        }

        .nav-links a:hover, .update-btn:hover { background-color: rgba(255, 255, 255, 0.2); }

        .content { 
            width: 60%; 
            margin: 30px auto; 
            background: white; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0px 0px 15px gray; 
        }

        .profile-container { 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            flex-direction: column; 
        }

        .photo-container img { 
            width: 170px; 
            height: 170px; 
            border-radius: 50%; 
            object-fit: cover; 
            border: 3px solid #ccc; 
        }

        .details-container { margin-top: 20px; width: 100%; }
        input, select { width: 100%; padding: 10px; margin-top: 8px; border: 1px solid #ccc; border-radius: 5px; }

        .update-btn { 
            background-color: green; 
            color: white; 
            padding: 12px 15px; 
            border: none; 
            cursor: pointer;
            font-size: 16px;
        }
    </style>
</head>
<body>

    <!-- ✅ Improved Navbar -->
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo" height="50">
        </div>
        <div class="nav-links">
            <a href="contact.jsp">Contact Us</a>
            <button type="submit" class="update-btn" form="hod-form">Update</button>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="profile-container">
            <% 
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                String base64Image = "default-profile.jpg"; // Default image
                String departmentName = "N/A"; // Default department name
                String hodEmail = request.getParameter("email"); // Get email from popup

                if (hodEmail != null && !hodEmail.trim().isEmpty()) { // Only fetch if email is provided
                    try {
                        // Database Connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

                        // ✅ FIXED: Use correct column name `d.name AS department_name`
                        String query = "SELECT h.*, d.name AS department_name FROM hod h " +
                                       "LEFT JOIN Departments d ON h.department_id = d.department_id " +
                                       "WHERE h.email = ?";
                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, hodEmail);
                        rs = pstmt.executeQuery();

                        if (rs.next()) { // If HOD is found
                            byte[] imgData = rs.getBytes("image");
                            if (imgData != null && imgData.length > 0) {
                                base64Image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imgData);
                            }

                            // ✅ Fetch Correct Department Name
                            departmentName = rs.getString("department_name") != null ? rs.getString("department_name") : "N/A";
            %>

            <!-- Profile Picture -->
            <div class="photo-container">
                <img src="<%= base64Image %>" alt="HOD Photo" id="hod-photo">
            </div>

            <!-- ✅ Editable Form with Image Update -->
            <div class="details-container">
                <form id="hod-form" action="UpdateHodServlet" method="post" enctype="multipart/form-data">
                    <div class="details-grid">
                        <label>HOD ID:</label>
                        <input type="text" name="hod_id" value="<%= rs.getString("hod_id") %>" readonly>

                        <label>Name:</label>
                        <input type="text" name="name" value="<%= rs.getString("name") %>">

                        <label>Email:</label>
                        <input type="email" name="email" value="<%= rs.getString("email") %>" required>

                        <label>Phone:</label>
                        <input type="text" name="phone" value="<%= rs.getString("phone") %>">

                        <!-- ✅ Correctly Fetching Department Name -->
                        <label>Department:</label>
                        <input type="text" name="department_name" value="<%= departmentName %>" readonly>

                        <!-- ✅ Image Upload Option -->
                        <label>Upload New Image:</label>
                        <input type="file" name="image" accept="image/*">

                    </div>

                    <button type="submit" class="update-btn">Update</button>
                </form>
            </div>

            <%
                        } else {
                            out.println("<p style='color: red;'>No HOD found with this email!</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color: red;'>Error fetching data: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (con != null) con.close();
                    }
                }
            %>
        </div>
    </div>

</body>
</html>
