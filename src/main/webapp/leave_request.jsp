<!-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %> -->
<!DOCTYPE html>
<html>
<head>
    <title>Leave Request Form</title>
    <style>
            body {
        font-family: 'Poppins', sans-serif;
        background: white;
        margin: 0;
        background-image: url('back.jpg'); /* Ensure correct path */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        padding: 2px;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        overflow: hidden;
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
            
            <button type="submit">Submit Leave Request</button>
        </form>
    </div>
</body>
</html>
