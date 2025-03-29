<%@ page import="java.sql.*" %>
<%
// Ensure guardian is logged in
String guardianId = (String) session.getAttribute("guardianId");
if (guardianId == null) {
    response.sendRedirect("guardian.jsp");
    return;
}

Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String studentId = "", rollNumber = "", studentName = "", course = "", hostel = "", guardianName = "";
String courseId = "", hostelId = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

    //  Fetch student ID from Guardians table
    String query = "SELECT student_id FROM Guardians WHERE guardian_id = ?";
    pstmt = con.prepareStatement(query);
    pstmt.setString(1, guardianId);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        studentId = rs.getString("student_id");
    }
    rs.close();
    pstmt.close();

    // Fetch student details from Students table only if studentId is found
    if (!studentId.isEmpty()) {
        query = "SELECT rno, name, course_id, hostel_id FROM Students WHERE student_id = ?";
        pstmt = con.prepareStatement(query);
        pstmt.setString(1, studentId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            rollNumber = rs.getString("rno");
            studentName = rs.getString("name");
            courseId = rs.getString("course_id");  
            hostelId = rs.getString("hostel_id");  
        }
        rs.close();
        pstmt.close();
    }

    // Fetch course name only if courseId is valid
    if (courseId != null && !courseId.isEmpty()) {
        query = "SELECT name FROM Courses WHERE course_id = ?";
        pstmt = con.prepareStatement(query);
        pstmt.setString(1, courseId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            course = rs.getString("name");
        }
        rs.close();
        pstmt.close();
    }

    //  Fetch hostel name only if hostelId is valid
    if (hostelId != null && !hostelId.isEmpty()) {
        query = "SELECT name FROM Hostels WHERE hostel_id = ?";
        pstmt = con.prepareStatement(query);
        pstmt.setString(1, hostelId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            hostel = rs.getString("name");
        }
        rs.close();
        pstmt.close();
    }

    //  Fetch Guardian Name from Guardians table
    if (!studentId.isEmpty()) {
        query = "SELECT name FROM Guardians WHERE student_id = ?";
        pstmt = con.prepareStatement(query);
        pstmt.setString(1, studentId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            guardianName = rs.getString("name");
        }
        rs.close();
        pstmt.close();
    }

}catch (Exception e) {
    out.println("<p style='color: red;'>Error fetching student data: " + e.getMessage() + "</p>");
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Request Form</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
    font-family: 'Poppins', sans-serif;
    background: white;
    margin: 0;
    background-image: url('img.jpg'); /* Ensure correct path */
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed; /* This makes the background image static */
    padding: 2px;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    overflow-y: auto;
}

.container {
    background-color: rgba(255, 255, 255, 0.9);
    padding: 30px;
    position: relative;
    top: 180px; /* Adjust this value to move it down */
    border-radius: 10px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
    max-width: 800px;
    width: 100%;
    box-sizing: border-box;
    margin-top:  150px; /* Adjust this value based on your navbar height */
}
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #333;
    color: white;
    padding: 10px 20px;
    position: fixed; /* Fixes navbar at the top */
    left: 0;
    top: 0;
    width: 100%;
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
.navbar .nav-button {
    background-color:  #8E54E9;
    color: white;
    text-decoration: none;
    padding: 10px 15px;
    border-radius: 5px;
    font-size: 14px;
    transition: background-color 0.3s;
}

.navbar .nav-button:hover {
    background-color: #45a049;
}
.quick-links {
    position: relative;
}

.quick-links .dropdown {
    display: none;
    position: absolute;
    background-color: white;
    min-width: 150px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    z-index: 1;
    border-radius: 5px;
    overflow: hidden;
}

.quick-links .dropdown a {
    color: black;
    padding: 10px;
    display: block;
    text-decoration: none;
}

.quick-links:hover .dropdown {
   display: block;
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

        h2 {
            text-align: center;
            color: #222;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
            color: #444;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        #companionFields {
            padding: 10px;
            background: #f8f8ff;
            border-radius: 8px;
            margin-top: 5px;
            display: none;
        }
    </style>
   <script>
    function setMinDate() {
        let today = new Date();
        today.setDate(today.getDate() + 1); 
        let minDate = today.toISOString().split("T")[0]; 
        document.getElementById("start_date").setAttribute("min", minDate);
        document.getElementById("end_date").setAttribute("min", minDate);
    }

    function toggleCompanionFields() {
        let leavingAlone = document.getElementById("leaving_alone").value;
        document.getElementById("companionFields").style.display = (leavingAlone === "No") ? "block" : "none";
    }

    function calculateDays() {
        let fromDate = document.getElementById('start_date').value;
        let toDate = document.getElementById('end_date').value;
        let daysField = document.getElementById('num_days');

        if (fromDate && toDate) {
            let from = new Date(fromDate);
            let to = new Date(toDate);
            let timeDifference = to - from;
            let days = timeDifference / (1000 * 60 * 60 * 24) + 1; 

            if (days > 0) {
                daysField.value = days;
            } else {
                daysField.value = "";
                alert("Invalid date range. Please check your input.");
            }
        } else {
            daysField.value = "";
        }
    }

    window.onload = function () {
        setMinDate();
    };
</script>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            
            <a href="guardian_change_password.jsp" >Change Password</a>
            <div class="quick-links">
                <button class="dropdown-button">Quick Links</button>
                <div class="dropdown">
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/" target="_blank">Home</a>
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/hgher-education/index.html" target="_blank">Programs</a>
                    <a href="http://banasthali.org/banasthali/wcms/en/home/lower-menu/campus-tour/index.html" target="_blank">Campus</a>
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/about-us/index.html" target="_blank">About Us</a>
                    <a href="http://www.banasthali.org/banasthali/wcms/en/home/lower-menu/contact_us/index.html" target="_blank">Contact Us</a>
                </div>
            </div>
            <a href="logout.jsp" class="logout">Logout</a>
        </div>
    </div>
    <div class="container">
        <h2>Leave Request</h2>
        <form action="submit_leave" method="post" enctype="multipart/form-data">
            <label>Student ID:</label>
            <input type="text" name="student_id" value="<%= studentId %>" readonly required>

            <label for="rno">Roll Number</label>
            <input type="text" id="rno" name="rno" value="<%= rollNumber %>" readonly required>

            <label for="name">Name</label>
            <input type="text" id="name" name="name" value="<%= studentName %>" readonly required>

            <label for="courses">Course</label>
            <input type="text" id="courses" name="courses" value="<%= course %>" readonly required>

            <label for="hostels">Hostel Name</label>
            <input type="text" id="hostels" name="hostels" value="<%= hostel %>" readonly required>

            <label for="guardianName">Guardian's Name</label>
            <input type="text" id="guardianName" name="guardianName" value="<%= guardianName %>" readonly required>


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

            <div id="companionFields">
                <label>Companion Name:</label>
                <input type="text" name="companion_name">

                <label>Companion Relation:</label>
                <input type="text" name="companion_relation">

                <label>Companion Address:</label>
                <input type="text" name="companion_address">

                <label>Companion Phone:</label>
                <input type="text" name="companion_phone">
            </div>

            <div class="form-group">
                <label for="leaving_address">Leave Address</label>
                <textarea id="leaving_address" name="leaving_address" required></textarea>
            </div>
            <div class="form-group">
                <label for="senders_address">Sender's Address</label>
                <textarea id="senders_address" name="senders_address" required></textarea>
            </div>
            <div class="form-group">
                <label for="signature">Signature (Upload Image)</label>
                <input type="file" id="signature" name="signature" accept="image/*" required>
            </div>
            <div class="form-group">
                <label for="date">Date</label>
                <input type="date" id="date" name="date" required>
            </div>
            <script>
                // Set the current date as the default value for the date input
                document.addEventListener("DOMContentLoaded", function () {
                    let today = new Date().toISOString().split("T")[0]; // Get current date in YYYY-MM-DD format
                    document.getElementById("date").value = today;
                });
            </script>
            
            <button type="submit" class="btn">Submit Application</button>
        </form>
    </div>
</body>
</html>
