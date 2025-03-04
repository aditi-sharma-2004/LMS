<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Admin</title>
    <style>
       body {
            font-family: Arial, sans-serif;
            background-image: url('back.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            max-width: 800px;
            width: 100%;
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
            flex-wrap: wrap;
            box-sizing: border-box;
        }

        .navbar .logo img {
            width: 180px;
            height: auto;
            margin-right: 20px;
        }

        .navbar .nav-links {
            display: flex;
            gap: 15px;
            align-items: center;
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

        h1 {
            text-align: center;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .form-group {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        label {
            width: 40%;
            font-weight: bold;
            text-align: left;
        }

        input {
            width: 60%;
            padding: 8px;
            font-size: 14px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }

        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            <a href="contact.jsp" class="contact">Contact Us</a>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <h1>Add Admin</h1>
        <form action="UploadAdminServlet" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="name">Admin Name:</label>
                <input type="text" id="name" name="name" placeholder="Enter Admin's name" required>
            </div>

            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" placeholder="Enter Admin's email" required>
            </div>

            <div class="form-group">
                <label for="contact">Contact Number:</label>
                <input type="text" id="contact" name="contact" placeholder="Enter contact number" required>
            </div>

            <div class="form-group">
                <label for="photo">Upload Photo:</label>
                <input type="file" name="image" accept="image/*">
            </div>

            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
