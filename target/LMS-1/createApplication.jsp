<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Leave Application</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }

        .container {
            width: 60%;
            margin: 0 auto;
            background: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        form {
            display: block;
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
    </style>
    <script>
        // Function to show/hide the companion details field based on the "Leaving Alone" radio button selection
        function toggleCompanionDetails() {
            var leavingAloneNo = document.getElementById('leavingAloneNo');
            var companionDetails = document.getElementById('companionDetailsGroup');
           
            if (leavingAloneNo.checked) {
                companionDetails.style.display = 'block';
            } else {
                companionDetails.style.display = 'none';
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Student Leave Application</h1>
        <form action="processLeave.jsp" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="studentId">Student ID</label>
                <input type="text" id="studentId" name="studentId" required>
            </div>
            <div class="form-group">
                <label for="rollNumber">Roll Number</label>
                <input type="text" id="rollNumber" name="rollNumber" required>
            </div>
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="class">Class</label>
                <input type="text" id="class" name="class" required>
            </div>
            <div class="form-group">
                <label for="hostelName">Hostel Name</label>
                <input type="text" id="hostelName" name="hostelName" required>
            </div>
            <div class="form-group">
                <label for="guardianName">Guardian's Name</label>
                <input type="text" id="guardianName" name="guardianName" required>
            </div>
            <div class="form-group">
                <label for="reason">Reason for Leave</label>
                <textarea id="reason" name="reason" required></textarea>
            </div>
            <div class="form-group">
                <label for="fromDate">From</label>
                <input type="date" id="fromDate" name="fromDate" required>
            </div>
            <div class="form-group">
                <label for="toDate">To</label>
                <input type="date" id="toDate" name="toDate" required>
            </div>
            <div class="form-group">
                <label for="days">Number of Days</label>
                <input type="number" id="days" name="days" required>
            </div>
            <div class="form-group">
                <label>Leaving Alone?</label>
                <input type="radio" id="leavingAloneYes" name="leavingAlone" value="Yes" onclick="toggleCompanionDetails()">
                <label for="leavingAloneYes">Yes</label>
                <input type="radio" id="leavingAloneNo" name="leavingAlone" value="No" onclick="toggleCompanionDetails()" checked>
                <label for="leavingAloneNo">No</label>
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