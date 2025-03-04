<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Login - Leave Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('back.jpg'); /* Ensure the correct path */
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
        .login-container {
            margin: 100px auto;
            background: #fff;
            padding: 20px;
            width: 300px;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0,0,0,0.1);
        }
        input, button {
            width: 90%;
            margin: 10px 0;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background: #28a745;
            color: white;
            border: none;
        }
        button:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Student Login</h1>
        <form action="StudentLoginServlet" method="POST">
            <label for="studentId">Student Smart Card ID:</label>
            <input type="text" id="studentId" name="studentId" placeholder="Enter your Student ID" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Enter your Password" required>
            
            <button type="submit">Login</button>
        </form>
        <p>Forgot your password? <a href="resetPassword.jsp">Reset Password</a></p>
    </div>
</body>
</html>
