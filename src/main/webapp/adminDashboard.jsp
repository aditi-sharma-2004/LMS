<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Management System</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js" crossorigin="anonymous"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: url('back.jpg') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navbar */
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

        .navbar, .sidebar {
    background-color: #264653 !important; /* Charcoal Blue */
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
        /* Sidebar */
        .sidebar {
            width: 250px;
            height: calc(100vh - 60px);
            background: #2c3e50;
            color: white;
            padding: 10px;
            position: fixed;
            top: 50px;
            left: 0;
            overflow-y: auto;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
        }

        .sidebar a {
            display: flex;
            align-items: center;
            color: white;
            padding: 12px;
            text-decoration: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
            transition: 0.3s;
        }

        .sidebar a i {
            margin-right: 15px;
            font-size: 18px;
        }

        .sidebar a:hover, .sidebar .active {
            background: #34495e;
        }

        .dropdown {
        display: none;
        padding-left: 15px;
    }

        .dropdown, .sub-dropdown {
            display: none;
            padding-left: 20px;
        }

        .dropdown a, .sub-dropdown a {
            font-size: 14px;
            padding: 8px 10px;
        }

        .dropdown a:hover, .sub-dropdown a:hover {
            background: #1abc9c;
        }

        .arrow {
            margin-left: auto;
            transition: transform 0.3s ease;
            float: right;
        }

        .rotate {
            transform: rotate(90deg);
        }

        .logout {
    background: #e74c3c;
    color: white;
    text-align: center;
    padding: 10px;
    border-radius: 5px;
    font-size: 14px;
    width: 90%;
    display: block;
    margin: 20px auto;
    text-decoration: none;
}

.logout:hover {
    background: #c0392b;
}


        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 30%;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .modal input {
            width: 80%;
            padding: 8px;
            margin-top: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .modal button {
            margin-top: 10px;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .modal .update-btn { background-color: green; color: white; }
        .modal .cancel-btn { background-color: red; color: white; }
    .close {
        position: absolute;
    top: 10px;
    right: 15px;
    font-size: 20px;
    cursor: pointer;
    }

    iframe {
        flex-grow: 1;
        width: 100%;
        height: 100%;
        border: none;
    }
    input {
        width: 80%;
        padding: 8px;
        margin-top: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .update-btn {
        background-color: green;
        color: white;
        padding: 8px 15px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .cancel-btn {
        background-color: red;
        color: white;
        padding: 8px 15px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .popup {
            display: none; /* Hide popups by default */
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px gray;
            width: 300px;
            text-align: center;
            z-index: 1000;
        }

        /* Ensure overlay is hidden initially */
        .overlay {
            display: none; /* Hide overlay by default */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        .popup input {
            width: 80%;
            padding: 8px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .popup-buttons {
            display: flex;
            justify-content: space-around;
            margin-top: 10px;
        }

        .btn-submit {
            background-color: green;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .btn-cancel {
            background-color: red;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
        
    </style>

<script>
    function toggleDropdown(id, arrowId) {
        var dropdown = document.getElementById(id);
        var arrow = document.getElementById(arrowId);

        if (dropdown.style.display === "block") {
            dropdown.style.display = "none";
            arrow.classList.remove("fa-chevron-down");
            arrow.classList.add("fa-chevron-right");
        } else {
            dropdown.style.display = "block";
            arrow.classList.remove("fa-chevron-right");
            arrow.classList.add("fa-chevron-down");
        }
    }

    function closeUpdatePopup() {
        document.getElementById("updateModal").style.display = "none";
    }

    function updateUser() {
        var role = document.getElementById("updateRole").innerText;
        var email = document.getElementById("updateEmail").value;
        if (email.trim() !== "") {
            window.location.href = "updateUser.jsp?role=" + role + "&email=" + email;
        } else {
            alert("Please enter an Email ID.");
        }
    }
    function openLeavePopup() {
        document.getElementById("leavePopupModal").style.display = "flex";
    }

    function closeLeavePopup() {
        document.getElementById("leavePopupModal").style.display = "none";
    }
    function openStudentPopup() {
            document.getElementById("studentPopup").style.display = "block";
            document.getElementById("overlay").style.display = "block";
        }

        function closeStudentPopup() {
            document.getElementById("studentPopup").style.display = "none";
            document.getElementById("overlay").style.display = "none";
        }

        function submitStudentId() {
            var studentId = document.getElementById("studentIdInput").value.trim();
            if (studentId === "") {
                alert("Please enter a valid Student ID!");
                return;
            }
            window.location.href = "update_student.jsp?student_id=" + studentId;
        }

        function openWardenPopup() {
        document.getElementById("wardenPopup").style.display = "block";
        document.getElementById("overlay").style.display = "block";
    }

    function closeWardenPopup() {
        document.getElementById("wardenPopup").style.display = "none";
        document.getElementById("overlay").style.display = "none";
    }

    function validateEmail() {
    var emailInput = document.getElementById("wardenEmail");

    if (!emailInput) {
        alert("Email input field not found!");
        return;
    }

    var email = emailInput.value.trim();
    console.log("Entered email:", email); // Debugging

    if (email === "") {
        alert("Email field cannot be empty!");
        return;
    }

    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,7}$/;

    if (emailPattern.test(email)) {  
        console.log("✅ Valid email. Redirecting...");
        window.location.href = "update_warden.jsp?email=" + encodeURIComponent(email);
    } else {
        console.log("❌ Invalid email format detected.");
        alert("Please enter a valid email address.");
    }
}



        function openEmailPopup(role) {
            document.getElementById("emailPopupRole").innerText = role;
            document.getElementById("emailPopupModal").style.display = "block";
            document.getElementById("overlay").style.display = "block";
        }

        function closeEmailPopup() {
            document.getElementById("emailPopupModal").style.display = "none";
            document.getElementById("overlay").style.display = "none";
        }
    
</script>
</head>
<body>

     <!-- Overlay Background -->
     <div class="overlay" id="overlay"></div>

     <!-- Student Popup Modal -->
     <div class="popup" id="studentPopup">
         <h3>Enter Student Smartcard ID</h3>
         <input type="text" id="studentIdInput" placeholder="Enter Student ID">
         <div class="popup-buttons">
             <button class="btn-submit" onclick="submitStudentId()">Submit</button>
             <button class="btn-cancel" onclick="closeStudentPopup()">Cancel</button>
         </div>
     </div>

     <!-- Popup Modal -->
<div id="wardenPopup" style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-50%, -50%); 
background: white; padding: 20px; box-shadow: 0px 0px 10px rgba(0,0,0,0.5); z-index: 1000; 
border-radius: 10px; text-align: center; width: 300px;">

<h2 style="margin-bottom: 10px;">Enter Email</h2>
<input type="email" id="wardenEmail" placeholder="Enter your email" required 
    style="width: 90%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px;" />

<div>
    <button onclick="validateEmail()" style="background-color: green; color: white; border: none; 
        padding: 10px 15px; margin-right: 10px; border-radius: 5px; cursor: pointer;">
        Submit
    </button>
    
    <button onclick="closeWardenPopup()" style="background-color: red; color: white; border: none; 
        padding: 10px 15px; border-radius: 5px; cursor: pointer;">
        Cancel
    </button>
</div>
</div>

<!-- Overlay Background -->
<div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
background: rgba(0,0,0,0.5); z-index: 999;"></div>

    <!-- Navbar -->
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <ul>
            <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/" target="_blank">HOME</a></li>
            <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/hgher-education/index.html" target="_blank">PROGRAMS</a></li>
            <li><a href="http://banasthali.org/banasthali/wcms/en/home/lower-menu/campus-tour/index.html" target="_blank">CAMPUS</a></li>
            <li><a href="http://www.banasthali.org/banasthali/wcms/en/home/about-us/index.html" target="_blank">ABOUT US</a></li>
        </ul>
    </div>

    <% 
        String message = request.getParameter("message");
        if ("student_added".equals(message)) { 
    %>
        <div id="successMessage" style="color: green; font-weight: bold;">
            Student added successfully!
        </div>
    <% } %>

    <script>
        setTimeout(function() {
            let messageDiv = document.getElementById("successMessage");
            if (messageDiv) {
                messageDiv.style.display = "none";
            }
        }, 3000); // Message disappears after 3 seconds
    </script>

    <div id="updateModal" class="modal">
        <span class="close" onclick="closeUpdatePopup()">&times;</span>
        <h3>Update <span id="updateRole"></span></h3>
        <input type="email" id="updateEmail" placeholder="Enter Email ID">
        <br>
        <button class="update-btn" onclick="updateUser()">Update</button>
        <button class="cancel-btn" onclick="closeUpdatePopup()">Cancel</button>
    </div>
    
    <!-- Sidebar -->
<div class="sidebar">

    <!-- Leave Management -->
    <a href="#"><i class="fas fa-calendar-alt"></i> Leave Management</a>

    <!-- User Management -->
    <a onclick="toggleDropdown('userDropdown', 'userArrow')">
        <i class="fas fa-users"></i> User Management <i id="userArrow" class="fas fa-chevron-right arrow"></i>
    </a>
    <div id="userDropdown" class="dropdown">
        <!-- View Section -->
        <a onclick="toggleDropdown('viewDropdown', 'viewArrow')">
            <i class="fas fa-eye"></i> View <i id="viewArrow" class="fas fa-chevron-right arrow"></i>
        </a>
        <div id="viewDropdown" class="dropdown">
            <a href="#" onclick="openStudentPopup('openStudentPopup')">Student</a>
            <a href="#" onclick="openEmailPopup('openWardenPopup')">Warden</a>
            <a href="#" onclick="openEmailPopup('HOD')">HOD</a>
            <a href="#" onclick="openEmailPopup('Verification Officer')">Verification Officer</a>
            <a href="#" onclick="openEmailPopup('Admin')">Admin</a>
        </div>

        <!-- Update Section -->
        <a onclick="toggleDropdown('updateDropdown', 'updateArrow')">
            <i class="fas fa-edit"></i> Update <i id="updateArrow" class="fas fa-chevron-right arrow"></i>
        </a>
        <div id="updateDropdown" class="dropdown">
            <a href="#" onclick="openStudentPopup()">Student</a>
            <a href="#" onclick="openWardenPopup()">Warden</a>
            <a href="#" onclick="openEmailPopup('HOD')">HOD</a>
            <a href="#" onclick="openEmailPopup('Verification Officer')">Verification Officer</a>
            <a href="#" onclick="openEmailPopup('Admin')">Admin</a>
        </div>    

        <!-- Add Section -->
        <a onclick="toggleDropdown('addDropdown', 'addArrow')">
            <i class="fas fa-user-plus"></i> Add <i id="addArrow" class="fas fa-chevron-right arrow"></i>
        </a>
        <div id="addDropdown" class="dropdown">
            <a href="addstudent.jsp" onclick>Student</a>
            <a href="addwarden.jsp" onclick>Warden</a>
            <a href="addhod.jsp" onclick>HOD</a>
            <a href="addvo.jsp" onclick>Verification Officer</a>
            <a href="addadmin.jsp" onclick>Admin</a>
        </div>

        <!-- Remove Section -->
        <a onclick="toggleDropdown('removeDropdown', 'removeArrow')">
            <i class="fas fa-user-minus"></i> Remove <i id="removeArrow" class="fas fa-chevron-right arrow"></i>
        </a>
        <div id="removeDropdown" class="dropdown">
            <a href="#" onclick="openStudentPopup('Student')">Student</a>
            <a href="#" onclick="openEmailPopup('Warden')">Warden</a>
            <a href="#" onclick="openEmailPopup('HOD')">HOD</a>
            <a href="#" onclick="openEmailPopup('Verification Officer')">Verification Officer</a>
            <a href="#" onclick="openEmailPopup('Admin')">Admin</a>
        </div>
        <a href="index.jsp" class="logout" onclick="confirmLogout()">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</div>

 <!-- Leave Management -->
<a onclick="toggleDropdown('leaveDropdown', 'leaveArrow')">
    <i class="fas fa-calendar-alt"></i> Leave Management <i id="leaveArrow" class="fas fa-chevron-right arrow"></i>
</a>
<div id="leaveDropdown" class="dropdown">
    <a href="#" onclick="openLeavePopup()"><i class="fas fa-list"></i> View Leaves</a>
    <a href="pendingLeaves.jsp"><i class="fas fa-list"></i> Pending Leaves</a>
    <a href="acceptLeave.jsp"><i class="fas fa-check-circle"></i> Accept Leave</a>
    <a href="rejectLeave.jsp"><i class="fas fa-times-circle"></i> Reject Leave</a>
    <a href="updateLeave.jsp"><i class="fas fa-edit"></i> Update Leave</a>
</div>

<script>
    function openPopup(page) {
        document.getElementById("popupFrame").src = page;
        document.getElementById("popupModal").style.display = "flex";
    }

    function closePopup() {
        document.getElementById("popupModal").style.display = "none";
        document.getElementById("popupFrame").src = "";
    }
    function confirmLogout() {
    let confirmAction = confirm("Are you sure you want to logout?");
    if (confirmAction) {
        window.location.href = "logout.jsp"; // Redirect to logout page
    }
    function toggleDropdown(dropdownId, arrowId) {
        var dropdown = document.getElementById(dropdownId);
        var arrow = document.getElementById(arrowId);
        if (dropdown.style.display === "block") {
            dropdown.style.display = "none";
            arrow.classList.remove("fa-chevron-down");
            arrow.classList.add("fa-chevron-right");
        } else {
            dropdown.style.display = "block";
            arrow.classList.remove("fa-chevron-right");
            arrow.classList.add("fa-chevron-down");
        }
    }
}
</script>

</body>
</html>

