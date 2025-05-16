<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add Guardian</title>
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
            overflow: hidden;
        }
        .container {
            width: 50%;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: auto;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        input, textarea {
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
        label {
            font-weight: bold;
        }
        .navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #333;
    color: white;
    padding: 3px 8px;
    position: fixed;  /* 🔹 Keeps navbar fixed at top */
    top: 0;           /* 🔹 Sticks it to the top */
    left: 0;
    width: 99%;      /* 🔹 Makes it span full width */
    z-index: 1000;    /* 🔹 Ensures it stays above other elements */
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
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("guardianForm").addEventListener("submit", function (event) {
                if (!validateForm()) {
                    event.preventDefault(); // Prevent form submission if validation fails
                }
            });
        });
    
        function validateForm() {
    let name = document.getElementById("name").value.trim();
    let email = document.getElementById("email").value.trim();
    let phone = document.getElementById("phone").value.trim();
    let address = document.getElementById("address").value.trim();
    let image = document.getElementById("image");
    let signature = document.getElementById("signature");

    let nameRegex = /^[A-Za-z\s]+$/;
    let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    let phoneRegex = /^\d{10}$/;
    let imageRegex = /\.(jpg|jpeg|png|gif)$/i;
    let signatureRegex = /\.(jpg|jpeg|png|gif)$/i;

    if (!nameRegex.test(name)) {
        alert("Name should only contain alphabets and spaces.");
        return false;
    }
    if (!emailRegex.test(email)) {
        alert("Please enter a valid email address.");
        return false;
    }
    if (phone !== "" && !phoneRegex.test(phone)) {
        alert("Phone number must be exactly 10 digits.");
        return false;
    }
    if (address === "") {
        alert("Address cannot be empty.");
        return false;
    }
    if (image.files.length > 0 && !imageRegex.test(image.files[0].name)) {
        alert("Please upload a valid image file (jpg, jpeg, png, gif).");
        return false;
    }
    if (signature.files.length === 0) {
        alert("Please upload the guardian's signature.");
        return false;
    }
    if (!signatureRegex.test(signature.files[0].name)) {
        alert("Signature must be a valid image file (jpg, jpeg, png, gif).");
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
            
            <a href="admin_change_password.jsp" >Change Password</a>
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
        <h2>Add New Guardian</h2>
        <%
            // Ensure student_id is stored in the session
            String studentId = (String) session.getAttribute("studentId");
            if (studentId == null) {
                studentId = request.getParameter("student_id"); // Fallback
            }
            
            // If still null, redirect to login page
            if (studentId == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <form id="guardianForm" action="UploadGuardianServlet" method="post" enctype="multipart/form-data">
            <label>Guardian Name:</label>
            <input type="text" id="name" name="name" required>
            
            <label>Email:</label>
            <input type="email" id="email" name="email" required>
            
            <label>Phone:</label>
            <input type="text" id="phone" name="phone" required>
            
            <label>Address:</label>
            <textarea id="address" name="address" required></textarea>
            
            <label>Profile Image:</label>
            <input type="file" id="image" name="image" accept="image/*">

            <label>Guardian Signature:</label>
            <input type="file" id="signature" name="signature" accept="image/*" required>
            
            <!-- Hidden field to store student_id -->
            <input type="hidden" name="student_id" value="<%= studentId %>">
            
            <input type="submit" value="Add Guardian">
        </form>
    </div>
 
</body>
</html>
