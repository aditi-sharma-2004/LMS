<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details - LMS</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('img.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed; /* Keeps the background fixed while scrolling */
            height: 100vh;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }
        .container {
    background: #ffffff;
    padding: 20px;
    border-radius: 9px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    max-width: 1000px;
    width: 90%;
    margin: auto;
    display: flex;
    align-items: center;
    gap: 20px;
    margin-top: 80px; /* Moves the container below the navbar */
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
    color: white;
    text-decoration: none;
    padding: 10px 15px;
    border-radius: 5px;
    font-size: 14px;
    transition: background-color 0.3s;
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
button {
            background-color:  #8E54E9;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }

        button:hover {
            background-color:  #8E54E9;
        }

        .content {
            max-width: 700px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(106, 13, 173, 0.3);
        }

        .photo-container {
    flex-shrink: 0;
    align-self: flex-start;
    margin-top: 50px;
}

.photo-container img {
    max-width: 200px;
    border-radius: 10px;
}

.details-container {
    display: flex;
    flex-direction: column;
    width: 100%;
}
.details-container h2 {
    margin-bottom: 20px;
    color: #333;
    font-size: 24px;
}

.details-grid {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 10px;
}

.details-grid label {
    font-size: 14px;
    color: #555;
    font-weight: bold;
    display: flex;
    align-items: center;
}

.details-grid .full-width {
    grid-column: span 2;
    display: flex;
    flex-direction: column;
}

.details-grid input {
    padding: 5px 8px;
    font-size: 14px;
    border: 1px solid #ddd;
    border-radius: 4px;
    background-color: #f9f9f9;
    width: 100%;
}

.details-grid input:focus {
    border-color: #6a5acd;
    outline: none;
    background-color: #fff;
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
        <div class="nav-links">
            
            <a href="resetPassword.jsp" >Change Password</a>
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


            <%
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                String base64Image = "default-profile.jpg"; // Default

                String studentID = request.getParameter("student_id");

                if (studentID != null && !studentID.trim().isEmpty()) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

                        // Join query to get names instead of ids
                        String query = "SELECT s.*, d.name AS dept_name, c.name AS course_name, h.name AS hostel_name FROM Students s " +
                                       "LEFT JOIN Departments d ON s.department_id = d.department_id " +
                                       "LEFT JOIN Courses c ON s.course_id = c.course_id " +
                                       "LEFT JOIN Hostels h ON s.hostel_id = h.hostel_id WHERE s.student_id = ?";

                        pstmt = con.prepareStatement(query);
                        pstmt.setString(1, studentID);
                        rs = pstmt.executeQuery();

                        if (rs.next()) {
                            byte[] imgData = rs.getBytes("image");
                            if (imgData != null && imgData.length > 0) {
                                base64Image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imgData);
                            }
            %>
            <div class="container">
                <div class="photo-container">
                    <img src="StudentPhotoServlet?studentId=<%= rs.getString("student_id") %>" alt="Student Photo">
                </div>

            <div class="details-container">

                <div class="row">
                    <label>Student ID:</label>
                    <div class="value"><%= rs.getString("student_id") %></div>
                </div>

                <div class="row">
                    <label>Name:</label>
                    <div class="value"><%= rs.getString("name") %></div>
                </div>

                <div class="row">
                    <label>Roll Number:</label>
                    <div class="value"><%= rs.getString("rno") %></div>
                </div>

                <div class="row">
                    <label>Email:</label>
                    <div class="value"><%= rs.getString("email") %></div>
                </div>

                <div class="row">
                    <label>Date of Birth:</label>
                    <div class="value"><%= rs.getString("dob") %></div>
                </div>

                <div class="row">
                    <label>Phone:</label>
                    <div class="value"><%= rs.getString("phone") %></div>
                </div>

                <div class="row">
                    <label>Address:</label>
                    <div class="value"><%= rs.getString("address") %></div>
                </div>

                <div class="row">
                    <label>Department:</label>
                    <div class="value"><%= rs.getString("dept_name") %></div>
                </div>

                <div class="row">
                    <label>Course:</label>
                    <div class="value"><%= rs.getString("course_name") %></div>
                </div>

                <div class="row">
                    <label>Hostel:</label>
                    <div class="value"><%= rs.getString("hostel_name") %></div>
                </div>

            </div>

            <%
                        } else {
                            out.println("<p style='color: red;'>No student found with this ID!</p>");
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
