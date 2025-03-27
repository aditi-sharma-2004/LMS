<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Request Form</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            box-sizing: border-box;
            overflow-y: auto; /* Enable vertical scrolling */
        }

        /* Navigation Bar Styling */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            color: white;
            padding: 3px 8px;
            position: fixed;
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

        .navbar .logout {
            color: white;
            background-color: #f44336;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .navbar .logout:hover {
            background-color: #d32f2f;
        }

        /* Content Container */
        .content {
            margin-top: 60px; /* Adjust for fixed navbar */
            padding: 20px;
            max-width: 750px;
            margin-left: auto;
            margin-right: auto;
        }

        .container {
            background: #ffffff;
            padding: 18px;
            border-radius: 9px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
        }

        h2 {
            text-align: center;
            color: #222;
            font-size: 18px;
            margin-bottom: 10px;
        }

        label {
            font-weight: 600;
            display: block;
            margin-top: 10px;
            color: #444;
            font-size: 12px;
            margin-left: 25px;
        }

        input, select, textarea {
            width: 90%;
            padding: 10px;
            margin-top: 3px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 10px;
            background: #f9f9f9;
            margin-left: 25px;
        }

        input:focus, select:focus, textarea:focus {
            border-color: #6a5acd;
            outline: none;
            box-shadow: 0 0 8px rgba(106, 90, 205, 0.3);
            background: #fff;
        }

        button {
            width: 50%;
            background: #6a5acd;
            color: white;
            border: none;
            padding: 14px;
            margin-left: 200px;
            margin-top: 15px;
            cursor: pointer;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
            box-shadow: 0 4px 10px rgba(106, 90, 205, 0.2);
            align-self: center;
        }

        button:hover {
            background: #5a4ecf;
            box-shadow: 0 6px 15px rgba(106, 90, 205, 0.3);
            transform: translateY(-2px);
        }

        #companionFields {
            padding: 10px;
            background: #f8f8ff;
            border-radius: 8px;
            margin-top: 5px;
            display: none;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 15px 0;
            background-color: #333;
            color: white;
            font-size: 14px;
            position: fixed;
            bottom: 0;
            width: 100%;
            z-index: 1000;
        }
    </style>
    <script>
        function toggleCompanionFields() {
            var leavingAlone = document.getElementById("leaving_alone").value;
            var companionFields = document.getElementById("companionFields");
            
            if (leavingAlone === "Yes") {
                companionFields.style.display = "none";
            } else {
                companionFields.style.display = "block";
            }
        }

        function calculateDays() {
            var startDate = new Date(document.getElementById("start_date").value);
            var endDate = new Date(document.getElementById("end_date").value);
            if (!isNaN(startDate) && !isNaN(endDate)) {
                var timeDiff = endDate.getTime() - startDate.getTime();
                var dayDiff = Math.ceil(timeDiff / (1000 * 3600 * 24)) + 1;
                document.getElementById("num_days").value = dayDiff;
            }
        }
    </script>
</head>
<body>
    <!-- Top Navigation Bar -->
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            <a href="change_password.jsp">Change Password</a>
            <a href="guardian_dashboard.jsp">Dashboard</a>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>

    <div class="content">
        <div class="container">
            <h2>Submit Leave Request</h2>
            <form action="submit_leave" method="post" enctype="multipart/form-data">
                <label>Student ID:</label>
                <input type="text" name="student_id" required>
                
                <label>Reason:</label>
                <textarea name="reason" required></textarea>
                
                <label>Start Date:</label>
                <input type="date" id="start_date" name="start_date" required onchange="calculateDays()">
                
                <label>End Date:</label>
                <input type="date" id="end_date" name="end_date" required onchange="calculateDays()">
                
                <label>Number of Days:</label>
                <input type="text" id="num_days" name="num_days" readonly>
                
                <label>Leave Type:</label>
                <select name="leave_type" required>
                    <option value="Casual">Casual</option>
                    <option value="Academic">Academic</option>
                    <option value="Emergency">Emergency</option>
                    <option value="Holiday">Holiday</option>
                </select>
                
                <label>Leaving Alone?</label>
                <select id="leaving_alone" name="leaving_alone" onchange="toggleCompanionFields()" required>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                </select>
                
                <div id="companionFields" style="display:none;">
                    <label>Companion Name:</label>
                    <input type="text" name="companion_name">
                    
                    <label>Companion Relation:</label>
                    <input type="text" name="companion_relation">
                    
                    <label>Companion Address:</label>
                    <input type="text" name="companion_address">
                    
                    <label>Companion Phone:</label>
                    <input type="text" name="companion_phone">
                </div>
                
                <label>Leaving Address:</label>
                <input type="text" name="leaving_address" required>
                
                <label>Signature Upload:</label>
                <input type="file" name="signature" accept="image/*" required>
                
                <button type="submit" class="btn">Submit Application</button>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 Leave Management System - Banasthali Vidyapith</p>
    </div>
</body>
</html>