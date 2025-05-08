<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('back.jpg'); /* Ensure correct path */
            background-size: cover;
            background-position: center;
            background-attachment: fixed; /* Fix the background */
            background-repeat: no-repeat;
            height: 100%;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }
    
        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 1000px;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 80px; /* Add margin to offset navbar height */
        }
    
        h1 {
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
        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }

        input[type="text"],
        input[type="date"],
        input[type="number"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }

        textarea {
            resize: none;
            height: 80px;
        }

        .btn {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-align: center;
            width: 100%;
            margin-top: 20px;
        }

        .btn:hover {
            background-color:  #218838;
        }
    
        select, button, input, textarea {
            padding: 10px;
            font-size: 14px;
            border-radius: 5px;
            border: 1px solid #ccc;
            width: 100%;
        }
    
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
    
        button:hover {
            background-color: #45a049;
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
            width: 98%;
            z-index: 1000;
            height: 50px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .navbar .logo {
            display: flex;
            align-items: center;
        }

        .navbar .logo img {
            width: 120px;
            height: auto;
            margin-right: 5px;
        }

        .navbar .logo h1 {
            font-size: 20px;
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
        
        .logout:hover {
            background-color: #d32f2f;
        }
    
        .hidden {
            display: none;
        }
    
        .logo img {
            display: block;
            margin: 0 auto 20px;
            width: 120px;
        }

    </style>
    <script>
        // Function to calculate the number of days
        function calculateDays() {
            const fromDate = document.getElementById('fromDate').value;
            const toDate = document.getElementById('toDate').value;
            const daysField = document.getElementById('days');

            if (fromDate && toDate) {
                const from = new Date(fromDate);
                const to = new Date(toDate);

                // Calculate the difference in time and convert it to days
                const timeDifference = to - from;
                const days = timeDifference / (1000 * 60 * 60 * 24) + 1; // Include both start and end dates

                if (days > 0) {
                    daysField.value = days; // Update the field with calculated days
                } else {
                    daysField.value = ""; // Clear the field if dates are invalid
                    alert("Invalid date range. Please check your input.");
                }
            } else {
                daysField.value = ""; // Clear the field if one of the dates is missing
            }
        }
    </script>

<script>
    function fetchStudentDetails() {
        const smartCardId = document.getElementById("smartCardId").value;

        if (smartCardId) {
            fetch(`fetchStudentDetails.jsp?smartCardId=${smartCardId}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById("rno").value = data.rno || "";
                        document.getElementById("name").value = data.name || "";
                        document.getElementById("guardianName").value = data.guardianName || "";

                        // Populate Course dropdown
                        populateCourseDropdown(data.courses);

                        // Populate Hostel dropdown
                        populateHostelDropdown(data.hostels);
                    } else {
                        alert(data.message || "No student found for the given Smart Card ID.");
                    }
                })
                .catch(error => {
                    alert("An error occurred while fetching student details.");
                    console.error(error);
                });
        } else {
            alert("Please enter a valid Smart Card ID.");
        }
    }

    function populateCourseDropdown(courses) {
        const courseSelect = document.getElementById("courses");
        courseSelect.innerHTML = "<option value='' disabled selected>Select Course</option>"; // Reset options

        courses.forEach(course => {
            const option = document.createElement("option");
            option.value = course.course_id;
            option.textContent = course.course_name;
            courseSelect.appendChild(option);
        });
    }

    function populateHostelDropdown(hostels) {
        const hostelSelect = document.getElementById("hostels");
        hostelSelect.innerHTML = "<option value='' disabled selected>Select Hostel</option>"; // Reset options

        hostels.forEach(hostel => {
            const option = document.createElement("option");
            option.value = hostel.hostel_id;
            option.textContent = hostel.hostel_name;
            hostelSelect.appendChild(option);
        });
    }
</script>

<script>
    function toggleCompanionDetails() {
        const leavingAloneNo = document.getElementById('leavingAloneNo');
        const companionDetailsGroup = document.getElementById('companionDetailsGroup');
        
        // Show or hide the companion details based on the radio button selection
        if (leavingAloneNo.checked) {
            companionDetailsGroup.style.display = 'block'; // Show the companion details
        } else {
            companionDetailsGroup.style.display = 'none'; // Hide the companion details
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
        <h1>Student Leave Application</h1>
        <form action="leave_data.jsp" method="POST">
            <label for="smartCardId">Student ID</label>
            <input type="text" id="smartCardId" name="smartCardId" required onblur="fetchStudentDetails()">

            <label for="rno">Roll Number</label>
            <input type="text" id="rno" name="rno" required>

            <label for="name">Name</label>
            <input type="text" id="name" name="name" required>

            <label for="courses">Course</label>
            <select name="courses" id="courses" required onblur="populateCourseDropdown(courses)"></select>>
                <option value="" disabled selected>Select Course</option>
                <%
                    try {
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/myproject", "lms","lms");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT course_id, course_name FROM Courses");

                        while (rs.next()) {
                %>
                            <option value="<%= rs.getInt("course_id") %>"><%= rs.getString("course_name") %></option>
                <%
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading courses</option>");
                    }
                %>
            </select>
            

            <label for="hostels">Hostel Name</label>
            <select name="hostels" id="hostels" required onblur="populateHostelDropdown(hostels)">
                <option value="" disabled selected>Select Hostel</option>
                <%
                    try {
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/myproject", "lms","lms");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT hostel_id, hostel_name FROM Hostels");

                        while (rs.next()) {
                %>
                            <option value="<%= rs.getInt("hostel_id") %>"><%= rs.getString("hostel_name") %></option>
                <%
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading hostels</option>");
                    }
                %>
            </select>

            <label for="guardianName">Guardian's Name</label>
            <input type="text" id="guardianName" name="guardianName" required>

            <label for="reason">Reason for Leave</label>
            <textarea id="reason" name="reason" required></textarea>

            <label for="fromDate">From Date</label>
            <input type="date" id="fromDate" name="fromDate" required onchange="calculateDays()">

            <label for="toDate">To Date</label>
            <input type="date" id="toDate" name="toDate" required onchange="calculateDays()">
            <div class="form-group">
            <label for="days">Number of Days</label>
            <input type="number" id="days" name="days" readonly>

        </div>

        <div class="form-group">
    <label>Leaving Alone?</label>
    <div style="display: flex; align-items: center; gap: 20px;">
        <div style="display: flex; align-items: center; gap: 5px;">
            <input type="radio" id="leavingAloneYes" name="leavingAlone" value="Yes" onclick="toggleCompanionDetails()">
            <label for="leavingAloneYes" style="margin: 0;">Yes</label>
        </div>
        <div style="display: flex; align-items: center; gap: 5px;">
            <input type="radio" id="leavingAloneNo" name="leavingAlone" value="No" onclick="toggleCompanionDetails()" checked>
            <label for="leavingAloneNo" style="margin: 0;">No</label>
        </div>
    </div>
</div>

        

            <!-- Companion Details section (Hidden by default) -->
            <div class="form-group" id="companionDetailsGroup" style="display: none;">
                <label for="companionName">Companion's Name</label>
                <input type="text" id="companionName" name="companionName">

                <label for="companionRelation">Relation with Student</label>
                <input type="text" id="companionRelation" name="companionRelation">

                <label for="companionAddress">Companion's Address</label>
                <textarea id="companionAddress" name="companionAddress"></textarea>

                <label for="companionPhone">Companion's Phone Number</label>
                <input type="text" id="companionPhone" name="companionPhone">
            </div>

            <div class="form-group">
                <label for="leaveAddress">Leave Address</label>
                <textarea id="leaveAddress" name="leaveAddress" required></textarea>
            </div>
            <div class="form-group">
                <label for="senderAddress">Sender's Address</label>
                <textarea id="senderAddress" name="senderAddress" required></textarea>
            </div>
            <div class="form-group">
                <label for="signature">Signature (Upload Image)</label>
                <input type="file" id="signature" name="signature" accept="image/*" required>
            </div>
            <div class="form-group">
                <label for="date">Date</label>
                <input type="date" id="date" name="date" required>
            </div>
            
            <button type="submit" class="btn">Submit Application</button>
        </form>
    </div>
</body>
</html>