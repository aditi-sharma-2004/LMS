<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*, jakarta.servlet.http.*, jakarta.servlet.jsp.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <style>
         body {
            font-family: Arial, sans-serif;
            background-image: url('img.jpg'); /* Ensure the correct path */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed; /* Keeps the background fixed */
            height: 100vh;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
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
    width: 100%;
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
    color:  #8E54E9;
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
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 370px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            width: 100%;
            background-color:  #8E54E9;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #8E54E9;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            
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
        <h2>Change Password</h2>
        <form action="GPOChangePasswordServlet" method="post">
            <div class="form-group">
                <label for="oldPassword">Old Password:</label>
                <input type="password" id="oldPassword" name="oldPassword" required>
            </div>
            <div class="form-group">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <button type="submit" class="btn">Change Password</button>
        </form>
    </div>
</body>
</html>
