<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.DriverManager,java.sql.Statement,java.sql.ResultSet" %>
<html>
<head>
    <title>Add Student</title>
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
        }
        input, select, textarea {
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
    </style>
</head>
<body>
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
