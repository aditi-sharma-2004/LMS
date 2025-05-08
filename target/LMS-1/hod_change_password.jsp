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
        .input-wrapper {
    position: relative;
    display: flex;
    align-items: center;
}

.input-wrapper input {
    width: 100%;
    padding-right: 35px; /* give space for eye icon */
}

.eye-icon {
    background-color: #fff; /* just for testing */
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    width: 20px;
    height: 20px;
    z-index: 2; /* ensures it's above input field */
}
    </style>
    <script>
        function togglePassword(fieldId, eyeIcon) {
           const input = document.getElementById(fieldId);
           if (input.type === "password") {
               input.type = "text";
               eyeIcon.src = "eye_slash_icon.jpg"; // closed eye
           } else {
               input.type = "password";
               eyeIcon.src = "eye_icon.jpg"; // open eye
           }
       }

       function validateForm() {
       const newPassword = document.getElementById("newPassword").value;
       const confirmPassword = document.getElementById("confirmPassword").value;

       // Check minimum length
       if (newPassword.length < 8) {
           alert("Password must be at least 8 characters long.");
           return false;
       }

       // Check for at least one uppercase letter
       if (!/[A-Z]/.test(newPassword)) {
           alert("Password must contain at least one uppercase letter.");
           return false;
       }

       // Check for at least one lowercase letter
       if (!/[a-z]/.test(newPassword)) {
           alert("Password must contain at least one lowercase letter.");
           return false;
       }

       // Check for at least one digit
       if (!/\d/.test(newPassword)) {
           alert("Password must contain at least one number.");
           return false;
       }

       // Check for at least one special character
       if (!/[#@$!%*?&]/.test(newPassword)) {
           alert("Password must contain at least one special character (#@$!%*?&).");
           return false;
       }

       // Check confirm password
       if (newPassword !== confirmPassword) {
           alert("New Password and Confirm Password do not match.");
           return false;
       }

       return true;
   }
   </script>
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
        <form action="HODChangePasswordServlet" method="post" onsubmit="return validateForm();">
            <div class="form-group">
                <label for="oldPassword">Old Password:</label>
                <div class="input-wrapper">
                    <input type="password" id="oldPassword" name="oldPassword" required>
                    <img src="eye_icon.jpg" class="eye-icon" onclick="togglePassword('oldPassword', this)">
                </div>
            </div>
            <div class="form-group">
                <label for="newPassword">New Password:</label>
                <div class="input-wrapper">
                    <input type="password" id="newPassword" name="newPassword" required>
                    <img src="eye_icon.jpg" class="eye-icon" onclick="togglePassword('newPassword', this)">
                </div>
               
               
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password:</label>
                <div class="input-wrapper">
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                    <img src="eye_icon.jpg" class="eye-icon" onclick="togglePassword('confirmPassword', this)">
                </div>
                
            </div>
            <button type="submit" class="btn">Change Password</button>
        </form>
    </div>
</body>
</html>
