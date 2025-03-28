<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HOD Details - LMS</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f2ff;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .navbar {
            background-color: #6a0dad;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }

        .logo img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
        }

        .content {
            max-width: 700px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(106, 13, 173, 0.3);
        }

        .profile-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .photo-container img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 3px solid #6a0dad;
            margin-bottom: 20px;
        }

        .details-container {
            width: 100%;
        }

        .row {
            margin-bottom: 15px;
            padding: 10px;
            background: #f1eaff;
            border-radius: 5px;
        }

        .row label {
            font-weight: bold;
            color: #6a0dad;
            display: block;
        }

        .value {
            margin-top: 5px;
            color: #333;
            font-size: 15px;
        }

        @media(max-width: 600px) {
            .content {
                width: 90%;
                padding: 20px;
            }
        }
    </style>
</head>

<body>

    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div>
            <a href="logout.jsp" style="color:white; text-decoration:none;">Logout</a>
        </div>
    </div>

    <div class="content">
        <div class="profile-container">

            <%
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                String base64Image = "default-profile.jpg"; // Default Image

                String email = request.getParameter("email");

                if (email != null && !email.trim().isEmpty()) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

                        // Fetch HOD details with department name
                        String query = "SELECT h.*, d.name AS department_name FROM hod h " +
                                       "LEFT JOIN Departments d ON h.department_id = d.department_id WHERE h.email = ?";

                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, email);
                        rs = pstmt.executeQuery();

                        if (rs.next()) {
                            byte[] imgData = rs.getBytes("Image");
                            if (imgData != null && imgData.length > 0) {
                                base64Image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imgData);
                            }
            %>

            <div class="photo-container">
                <img src="<%= base64Image %>" alt="HOD Photo">
            </div>

            <div class="details-container">

                <div class="row">
                    <label>HOD ID:</label>
                    <div class="value"><%= rs.getString("hod_id") %></div>
                </div>

                <div class="row">
                    <label>Name:</label>
                    <div class="value"><%= rs.getString("name") %></div>
                </div>

                <div class="row">
                    <label>Phone:</label>
                    <div class="value"><%= rs.getString("phone") %></div>
                </div>

                <div class="row">
                    <label>Email:</label>
                    <div class="value"><%= rs.getString("email") %></div>
                </div>

                <div class="row">
                    <label>Department:</label>
                    <div class="value"><%= rs.getString("department_name") != null ? rs.getString("department_name") : "N/A" %></div>
                </div>

            </div>

            <%
                        } else {
                            out.println("<p style='color: red;'>No HOD found with this email!</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
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
