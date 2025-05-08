<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration</title>
</head>
<body>
    <h2>Student Registration Form</h2>
    <form action="StudentRegistration" method="post" enctype="multipart/form-data">
        <label>Name:</label>
        <input type="text" name="name" required><br><br>

        <label>Email:</label>
        <input type="email" name="email" required><br><br>

        <label>Course:</label>
        <input type="text" name="course" required><br><br>

        <label>Upload Photo:</label>
        <input type="file" name="photo" accept="image/*" required><br><br>

        <button type="submit">Register</button>
    </form>
</body>
</html>
