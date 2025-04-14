<!DOCTYPE html>
<html>
<head>
    <title>GPO Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('img.jpg');
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
       
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            color: white;
            padding: 2px 20px;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .navbar .logo {
            display: flex;
            align-items: center;
        }

        .navbar .logo img {
            width: 150px;
            height: auto;
            margin-right: 10px;
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
        .logout:hover {
            background-color: #d32f2f;
        }
        .hidden {
            display: none;
        }

        .logo img {
            display: block;
            margin: 0 auto 5px;
            width: 120px;
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
                <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/about-us/index.html" target="_blank">ABOUT US</a></li>
            </ul>
        </div>
    </div>
    <div class="login-container">
            <div class="logo" style="text-align: center;">
                <img src="logoo.png" alt="Banasthali Vidyapeeth Logo" style="width: 100px; height: auto; margin-bottom: 10px;">
            </div>
        <h1>GPO Login</h1>
        <form action="GPOLoginServlet" method="POST">
            <input type="text" id="gpoId" name="gpoId" placeholder="Enter your GPO ID" required>
            <input type="password" id="password" name="password" placeholder="Enter your Password" required>
            <button type="submit">Login</button>
        </form>
        <p>Forgot your password? <a href="resetPassword.jsp">Reset Password</a></p>
    </div>
</body>
</html>
