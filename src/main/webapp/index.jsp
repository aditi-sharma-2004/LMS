<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('img.jpg'); /* Ensure correct path */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h2 {
            text-align: center;
            margin-bottom: 15px;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            width: 100%;
            gap: 15px;
        }

        select, button {
            padding: 10px;
            font-size: 14px;
            border-radius: 5px;
            border: 1px solid #ccc;
            width: 100%;
        }

        button {
            background-color:  #8E54E9;
            color: white;
            border: none;
            cursor: pointer;
        }

        button:hover {
            background-color: #8E54E9;
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
            width: 98%;
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
    </style>
    <script>
        function handleRoleChange() {
            const role = document.getElementById("role").value;
            const staffRole = document.getElementById("staffRoleSelect");
            if (role === "employee") {
                staffRole.classList.remove("hidden");
            } else {
                staffRole.classList.add("hidden");
                staffRole.value = ""; // Clear the selection if it's hidden
            }
        }
    </script>
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
    <div class="container">
        <h1>Select Your Role</h1>
        <form action="processRole.jsp" method="POST">
            <label for="role"><select id="role" name="role" onchange="handleRoleChange()" required>
                <option value="" disabled selected>Select Role</option>
                <option value="student">Student</option>
                <option value="guardian">Guardian</option>
                <option value="employee">Employee</option>
                <option value="admin">Admin</option>
            </select></label>
        
            <select id="staffRoleSelect" name="employeeType" class="hidden">
                <option value="" disabled selected>Select Staff Role</option>
                <option value="warden">Warden</option>
                <option value="hod">HOD</option>
                <option value="verificationOfficer">Verification Officer</option>
                <option value="gpo">GatePass Officer</option>
            </select>

            <button type="submit">Continue</button>
        </form>
    </div>
</body>
</html>

