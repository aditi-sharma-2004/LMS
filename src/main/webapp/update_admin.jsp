<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Leave Management System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }
        
        /* ✅ Navbar Styling */
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
        input { width: 100%; padding: 10px; margin-top: 8px; border: 1px solid #ccc; border-radius: 5px; }

        .update-btn { 
            background-color: green; 
            color: white; 
            padding: 12px 15px; 
            border: none; 
            cursor: pointer;
            font-size: 16px;
        }

        /* ✅ Read-only Email Field */
        .readonly-input {
            background: #e9ecef; 
            cursor: not-allowed; 
            color: #333; 
            font-weight: bold;
        }
    </style>
</head>
<body>

    <!-- ✅ Navbar -->
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo" height="50">
        </div>
        <div class="nav-links">
            <a href="contact.jsp">Contact Us</a>
            <button type="submit" class="update-btn" form="admin-form">Update</button>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>

    <!-- ✅ Admin Profile Section -->
    <div class="content">
        <div class="profile-container">
            <%
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                String base64Image = "default-profile.jpg"; // Default image
                String name = "", phone = "";
                String adminEmail = request.getParameter("email"); // Get email from request

                if (adminEmail != null && !adminEmail.trim().isEmpty()) {
                    try {
                        // Database Connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "priyanshi", "2004@seth");

                        // Fetch Admin Data
                        String query = "SELECT name, phone, image FROM admin WHERE email=?";
                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, adminEmail);
                        rs = pstmt.executeQuery();

                        if (rs.next()) { // If admin is found
                            name = rs.getString("name");
                            phone = rs.getString("phone");
                            byte[] imgData = rs.getBytes("image");

                            // Convert image to Base64 if available
                            if (imgData != null && imgData.length > 0) {
                                base64Image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imgData);
                            }
            %>

            <!-- ✅ Profile Picture -->
            <div class="photo-container">
                <img src="<%= base64Image %>" alt="Admin Photo" id="admin-photo">
            </div>

            <!-- ✅ Editable Form -->
            <div class="details-container">
                <form id="admin-form" action="UpdateAdminServlet" method="post" enctype="multipart/form-data">
                    
                    <!-- ✅ Read-only Email Field -->
                    <label>Email:</label>
                    <input type="email" name="email" value="<%= adminEmail %>" class="readonly-input" readonly><br><br>

                    <!-- ✅ Editable Name -->
                    <label>Name:</label>
                    <input type="text" name="name" value="<%= name %>" required><br><br>

                    <!-- ✅ Editable Phone -->
                    <label>Phone:</label>
                    <input type="text" name="phone" value="<%= phone %>" required><br><br>

                    <!-- ✅ Image Upload -->
                    <label>Upload New Profile Image:</label>
                    <input type="file" name="image" accept="image/*"><br><br>

                    <button type="submit" class="update-btn">Update</button>
                </form>
            </div>

            <%
                        } else {
                            out.println("<p style='color: red;'>No Admin found with this email!</p>");
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
