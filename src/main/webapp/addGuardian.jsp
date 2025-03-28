<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Add Guardian</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
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
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            padding: 10px;
        }
        input[type="submit"]:hover {
            background-color: #218838;
        }
        label {
            font-weight: bold;
        }
    </style>
</head>
<body>
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
        <form action="UploadGuardianServlet" method="post" enctype="multipart/form-data">
            <label>Guardian Name:</label>
            <input type="text" name="name" required>
            
            <label>Email:</label>
            <input type="email" name="email" required>
            
            <label>Phone:</label>
            <input type="text" name="phone" required>
            
            <label>Address:</label>
            <textarea name="address" required></textarea>
            
            <label>Profile Image:</label>
            <input type="file" name="image" accept="image/*">

            <label>Guardian Signature:</label>
            <input type="file" name="signature" accept="image/*" required>
            
            <!-- Hidden field to store student_id -->
            <input type="hidden" name="student_id" value="<%= studentId %>">
            
            <input type="submit" value="Add Guardian">
        </form>
    </div>
</body>
</html>
