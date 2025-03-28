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
    background: #ffffff;
    padding: 18px;
    border-radius: 9px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    max-width: 750px; /* Reduce width from right */
    width: 80%; /* Adjust percentage to make it smaller */
    margin: auto; /* Keep it centered */
    align-items: center;
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

        button {
            width: 100%;
            background: #6a5acd;
            color: white;
            border: none;
            padding: 14px;
            margin-top: 15px;
            cursor: pointer;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
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
