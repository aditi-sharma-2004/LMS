<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.DriverManager,java.sql.Statement,java.sql.ResultSet" %>
<html>
<head>
    <title>Add Student</title>
    <style>
         body {
    font-family: Arial, sans-serif;
    background-image: url('img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
    height: 100vh;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: auto; /* Allow scrolling */
}

.container {
    width: 50%;
    background: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    margin: auto;
    margin-top: 70px; /* Push it below the navbar */
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
        h2 {
            text-align: center;
        }
        input, select, textarea {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[type="submit"] {
            background-color:  #8E54E9;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            padding: 10px;
        }
        input[type="submit"]:hover {
            background-color:  #8E54E9;
        }
    </style>
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
        <h2>Add New Student</h2>
        <form action="UploadStudentServlet" method="post" enctype="multipart/form-data">
            Student ID: <input type="text" name="student_id" required><br>
            Name: <input type="text" name="name" required><br>
            Roll No: <input type="number" name="rno" required><br>
            Email: <input type="email" name="email" required><br>
            DOB: <input type="date" name="dob" required><br>
            Phone: <input type="text" name="phone" required><br>
            Address: <textarea name="address" required></textarea><br>
            Profile Image: <input type="file" name="image" accept="image/*"><br>
            
            Department:
            <select name="department_id" required>
                <option value="">Select Department</option>
                <% 
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT department_id, name FROM Departments");
                        while (rs.next()) {
                            out.println("<option value='" + rs.getString("department_id") + "'>" + rs.getString("name") + "</option>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option value=''>Error loading departments</option>");
                    }
                %>
            </select><br>
            
            Course:
            <select name="course_id" required>
                <option value="">Select Course</option>
                <% 
                    try {
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT course_id, name FROM Courses");
                        while (rs.next()) {
                            out.println("<option value='" + rs.getString("course_id") + "'>" + rs.getString("name") + "</option>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option value=''>Error loading courses</option>");
                    }
                %>
            </select><br>
            
            Hostel:
            <select name="hostel_id">
                <option value="">No Hostel</option>
                <% 
                    try {
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT hostel_id, name FROM Hostels");
                        while (rs.next()) {
                            out.println("<option value='" + rs.getString("hostel_id") + "'>" + rs.getString("name") + "</option>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option value=''>Error loading hostels</option>");
                    }
                %>
            </select><br>
            
            Year:
            <select name="year" required>
                <option value="1st">1st</option>
                <option value="2nd">2nd</option>
                <option value="3rd">3rd</option>
                <option value="4th">4th</option>
            </select><br>
            
            <input type="submit" value="Add Student">
        </form>
    </div>
</body>
</html>
