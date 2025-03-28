<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
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
        .footer {
            text-align: center;
            padding: 15px 0;
            background-color: #333;
            color: white;
            font-size: 14px;
            position: fixed; 
            bottom: 0;  
            left: 0; 
            right: 0;    /* Aligns to the bottom of the screen */
            width: 100%;     /* Spans the full width of the screen */
            z-index: 1000;   /* Ensures it stays on top of other elements */
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
            
        </div>
        <div class="nav-links">
            <ul>
                <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/" target="_blank">HOME</a></li>
                <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/hgher-education/index.html" target="_blank">PROGRAMS</a></li>
                <li><a href="http://banasthali.org/banasthali/wcms/en/home/lower-menu/campus-tour/index.html" target="_blank">CAMPUS</a></li>
                <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/about-us/index.html" target="_blank">ABOUT</a></li>
            </ul>
        </div>
    </div>
    <div class="container">
    <div class="login-container">
        <h1>Admin Login</h1>
        <form action="AdminLoginServlet.jsp" method="POST">
            <input type="text" name="adminId" placeholder="Admin ID" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <p>Forgot your password? <a href="resetPassword.jsp">Reset Password</a></p>
    </div>
    <div class="footer">
        <p>&copy; 2025 Leave Management System - Banasthali Vidyapith</p>
    </div>
</body>

</html>
