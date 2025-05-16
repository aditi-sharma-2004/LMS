
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Management System</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js" crossorigin="anonymous"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
     <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: url('img.jpg') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .menu {
    display: block !important; /* Ensure visibility */
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



        /* Sidebar */
        .sidebar {             
    width: 250px;             
    height: calc(100vh - 60px); /* Adjusted for navbar height */
    background: #333;             
    color: white;             
    padding: 10px;             
    position: fixed;             
    top: 60px; /* Adjusted to align with the navbar */
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
            background:  #333;
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
        .modal .update-btn { background-color:  #8E54E9;; color: white; }
        .modal .cancel-btn { background-color: red; color: white; }
    .close {
        position: absolute;
    top: 10px;
    right: 15px;
    font-size: 20px;
    cursor: pointer;
    }
    input {
        width: 80%;
        padding: 8px;
        margin-top: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .update-btn {
        background-color:  #8E54E9;;
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
            background-color:  #8E54E9;;
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
        #hodPopup {
            display: none;
            position: fixed;
            top: 30%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 20px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
            z-index: 1000;
            border-radius: 10px;
            text-align: center;
            width: 300px;
        }
    .popup-content {
        position: relative;
        text-align: center;
    }
    .remove-btn:hover {
        background-color: darkred;
    }
.popup {
    display: none;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    width: 300px;
    text-align: center;
}
.close-btn {
    position: absolute;
    top: 10px;
    right: 15px;
    font-size: 20px;
    cursor: pointer;
}
.remove-btn {
    background-color: red;
    color: white;
    border: none;
    padding: 10px 15px;
    margin-top: 10px;
    cursor: pointer;
    width: 100%;
    border-radius: 5px;
}
.modal {
    display: none !important; /* Ensure flexbox is applied */
    justify-content: center !important;
    align-items: center !important;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent background */
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal-content {
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    width: 50%;
    max-width: 600px;
    height: 80%;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
    position: relative;
}

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

    .custom-modal {
        display: none;
        position: fixed;
        z-index: 9999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
    }

    .custom-modal-content {
        background-color: white;
        padding: 30px;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 0 20px rgba(106, 13, 173, 0.3);
        width: 300px;
    }

    .custom-modal-content h2 {
        color: black;
    }

    .custom-modal-content input {
        padding: 8px;
        width: 90%;
        margin-top: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .custom-submit-btn {
        background-color:  #8E54E9;;
        color: white;
        border: none;
        padding: 8px 15px;
        margin: 5px;
        cursor: pointer;
        border-radius: 5px;
    }

    .custom-cancel-btn {
        background-color: red;
        color: white;
        border: none;
        padding: 8px 15px;
        margin: 5px;
        cursor: pointer;
        border-radius: 5px;
    }

    .custom-submit-btn:hover {
        opacity: 0.8;
    }

    .custom-cancel-btn:hover {
        opacity: 0.8;
    }
    .warden-popup-modal {
        display: none;
        position: fixed;
        z-index: 9999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        justify-content: center;
        align-items: center;
    }

    .warden-popup-content {
        background-color: white;
        padding: 25px;
        border-radius: 10px;
        text-align: center;
        box-shadow: 0 0 20px rgba(106, 13, 173, 0.3);
        width: 300px;
    }

    .warden-popup-content h2 {
        color:black;
    }

    .warden-popup-content input {
        padding: 8px;
        width: 90%;
        margin-top: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .warden-submit-btn {
        background-color:  #8E54E9;;
        color: white;
        border: none;
        padding: 8px 15px;
        margin: 5px;
        cursor: pointer;
        border-radius: 5px;
    }

    .warden-cancel-btn {
        background-color: red;
        color: white;
        border: none;
        padding: 8px 15px;
        margin: 5px;
        cursor: pointer;
        border-radius: 5px;
    }

    .warden-submit-btn:hover, .warden-cancel-btn:hover {
        opacity: 0.8;
    }

    .content {
    margin-top: 100px; /* This ensures content starts below the navbar */
    padding: 20px;
    max-width: 1000px;
    margin-left: auto;
    margin-right: auto;
    box-sizing: border-box;
}
.content h2 {
    margin-bottom: 20px;
}
.details-container {
    background-color: rgba(255, 255, 255, 0.7); /* Transparent effect */
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    display: flex;
    align-items: flex-start;
    gap: 30px;
    position: relative;
    left: 10%; /* Shift towards right */
    right: 50%; /* Shift towards left */
    transform: translate(10%, 150px); /* Fine-tune centering */
    width: 120%; /* Increase width */
}

.details-container h2 {
    margin-bottom: 20px;
    color: #333;
    font-size: 24px;
    width: 80%; /* Match container width */
    text-align: left;
}

.details-grid {
    display: grid;
    grid-template-columns: 1fr 2fr; /* Two columns: labels and textboxes */
    gap: 5px 5px;
    width: 50%; /* Match container width */
}

.details-grid label {
    font-size: 14px;
    color: #555;
    font-weight: bold;
    display: flex;
    align-items: center;
}

.details-grid input {
    padding: 5px 8px;
    font-size: 14px;
    border: 1px solid #ddd;
    border-radius: 4px;
    background-color: #f9f9f9;
    width: 100%; /* Stretch to column width */
}

.details-grid input:focus {
    border-color:  #8E54E9;;
    outline: none;
    background-color: #fff;
}

.photo-container {
    flex-shrink: 0;
}

.photo-container img {
    max-width: 200px;
    border-radius: 10px;
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
            document.getElementById('studentPopup').style.display = 'none';
            document.getElementById("overlay").style.display = "none";
        }

        function submitStudentId() {
            var studentId = document.getElementById("studentIdInputu").value.trim();
            if (studentId === "") {
                alert("Please enter a valid Student ID!");
                return;
            }
            window.location.href = "update_student.jsp?student_id=" + studentId;
        }

        // ✅ Open Warden Popup
function openWardenPopup() {
    console.log("Opening Warden popup...");
    let popup = document.getElementById("wardenPopup");
    if (!popup) {
        console.error("Warden popup not found!");
        return;
    }
    popup.style.display = "block";
    document.getElementById("overlay").style.display = "block";
}

// ✅ Close Warden Popup
function closeWardenPopup() {
    document.getElementById('wardenPopup').style.display = 'none';
    document.getElementById("overlay").style.display = "none";
}

// ✅ Validate Warden Email
function validateWardenEmail() {
    var emailInput = document.getElementById("wardenEmail");

    if (!emailInput) {
        alert("Email input field not found!");
        return;
    }

    var email = emailInput.value.trim();
    console.log("Entered email:", email);

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
//hod
// Open HOD Popup
function openHodPopup() {
            console.log("Opening HOD popup...");
            let popup = document.getElementById("hodPopup");
            document.getElementById("hodPopup").style.display = "block";
            document.getElementById("overlay").style.display = "block";
            if (!popup) {
                console.error("HOD popup not found!");
                return;
            }

            popup.style.display = "block";
}

        // Close HOD Popup
        function closeHodPopup() {
            document.getElementById("hodPopup").style.display = "none";
            document.getElementById("overlay").style.display = "none";
        }

        // Validate Email
        function validateHodEmail() {
            var emailInput = document.getElementById("hodEmail");

            if (!emailInput) {
                alert("Email input field not found!");
                return;
            }

            var email = emailInput.value.trim();
            console.log("Entered email:", email);

            if (email === "") {
                alert("Email field cannot be empty!");
                return;
            }

            var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,7}$/;

            if (emailPattern.test(email)) {  
                console.log("✅ Valid email. Redirecting...");
                window.location.href = "update_hod.jsp?email=" + encodeURIComponent(email);
            } else {
                console.log("❌ Invalid email format detected.");
                alert("Please enter a valid email address.");
            }
        }
//vo
        function openvoPopup() {
        document.getElementById("voPopup").style.display = "block";
        document.getElementById("overlay").style.display = "block";
    }

    function closevoPopup() {
        document.getElementById('voPopup').style.display = 'none';
        document.getElementById("overlay").style.display = "none";
    }

    function validateEmail() {
        var emailInput = document.getElementById("voEmail");
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
            window.location.href = "update_vo.jsp?email=" + encodeURIComponent(email);
        } else {
            console.log("❌ Invalid email format detected.");
            alert("Please enter a valid email address.");
        }
    }
    
//Admin
function openAdminPopup() {
    console.log("Opening Admin popup...");
    let popup = document.getElementById("adminPopup");
    let overlay = document.getElementById("overlay");
    let emailInput = document.getElementById("adminEmail");

    if (!popup) {
        console.error("Admin popup not found!");
        return;
    }

    popup.style.display = "block";
    overlay.style.display = "block";

    // ✅ Ensure the email field retains its value
    if (!emailInput.value) {
        emailInput.value = "";
    }
}

        // Close admin Popup
        function closeAdminPopup() {
    document.getElementById("adminPopup").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

function validateAdminEmail() {
    var emailInput = document.getElementById("adminEmail");

    if (!emailInput) {
        alert("Email input field not found!");
        return;
    }

    var email = emailInput.value.trim();
    console.log("Entered email:", email);

    if (email === "") {
        alert("Email field cannot be empty!");
        return;
    }

    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,7}$/;

    if (emailPattern.test(email)) {  
        console.log("✅ Valid email. Redirecting...");
        window.location.href = "update_admin.jsp?email=" + encodeURIComponent(email);
    } else {
        console.log("❌ Invalid email format detected.");
        alert("Please enter a valid email address.");
    }
}
// ✅ Remove Student
function removeStudent() {
    var studentId = document.getElementById("studentId").value.trim();

    if (!studentId) {
        document.getElementById("student-message").innerHTML = "<span style='color: red;'>Please enter Student ID!</span>";
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "RemoveStudentServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        var response = this.responseText.trim();
        if (response.startsWith("success:")) {
            document.getElementById("student-message").innerHTML = "<span style='color: green;'>" + response.substring(8) + "</span>";
            setTimeout(closeStudentPopup, 3000); // ✅ Close popup after success
        } else {
            document.getElementById("student-message").innerHTML = "<span style='color: red;'>" + response.substring(6) + "</span>";
        }
    };

    xhr.onerror = function () {
        document.getElementById("student-message").innerHTML = "<span style='color: red;'>Error: Failed to send request!</span>";
    };

    xhr.send("student_id=" + encodeURIComponent(studentId));
}

// ✅ Open Warden Modal
function openWardenRemovePopup() {
    document.getElementById("wardenremovePopup").style.display = "block";
    document.getElementById("warden-message").innerHTML = ""; // Clear old messages
}

// ✅ Close Warden Modal
function closeWardenPopup() {
    document.getElementById("wardenremovePopup").style.display = "none";
}

// ✅ Remove Warden
function removeWarden() {
    var wardenMail = document.getElementById("wardenMail").value.trim();

    if (!wardenMail) {
        document.getElementById("warden-message").innerHTML = "<span style='color: red;'>❌ Please enter Warden Email!</span>";
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "RemoveWardenServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        var response = this.responseText.trim();
        if (response.startsWith("success:")) {
            document.getElementById("warden-message").innerHTML = "<span style='color: green;'>✔ " + response.substring(8) + "</span>";
            setTimeout(closeWardenPopup, 3000); // ✅ Close popup after success
        } else {
            document.getElementById("warden-message").innerHTML = "<span style='color: red;'>❌ " + response.substring(6) + "</span>";
        }
    };

    xhr.onerror = function () {
        document.getElementById("warden-message").innerHTML = "<span style='color: red;'>⚠ Error: Failed to send request!</span>";
    };

    xhr.send("wardenMail=" + encodeURIComponent(wardenMail));
}

// ✅ Setup Event Listeners (Safely after DOM loads)
document.addEventListener("DOMContentLoaded", function () {
    // Attach event specifically to Warden Modal buttons
    document.querySelector("#wardenremovePopup .remove-btn").addEventListener("click", removewarden);
    document.querySelector("#wardenremovePopup .close-btn").addEventListener("click", closePopup);
});

//hod
document.addEventListener("DOMContentLoaded", function () {
    document.querySelector(".remove-hod-btn").addEventListener("click", removeHOD);
    document.querySelector(".close-hod-btn").addEventListener("click", closeHODPopup);
});

function openHODRemovePopup() {
    document.getElementById("hodremovePopup").style.display = "block";
    document.getElementById("hod-message").innerHTML = ""; // Clear messages
}

function closeHODPopup() {
    document.getElementById("hodremovePopup").style.display = "none";
}

function removeHOD() {
    console.log("Remove HOD button clicked"); // Debugging log

    var hodMail = document.getElementById("hodMail").value.trim();

    if (!hodMail) {
        document.getElementById("hod-message").innerHTML = "<span style='color: red;'>Please enter mail!</span>";
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "RemoveHODServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        console.log("Response received:", this.responseText); // Debugging log
        var response = this.responseText.trim();

        if (response.startsWith("success:")) {
            document.getElementById("hod-message").innerHTML = "<span style='color: green;'>HOD Removed Successfully!</span>";
            setTimeout(closeHODPopup, 3000); // ✅ Close popup after success
        } else {
            document.getElementById("hod-message").innerHTML = "<span style='color: red;'>" + response.substring(6) + "</span>";
        }
    };

    xhr.onerror = function () {
        document.getElementById("hod-message").innerHTML = "<span style='color: red;'>Error: Failed to send request!</span>";
    };

    console.log("Sending request with hodMail:", hodMail); // ✅ Debugging log
    xhr.send("hodMail=" + encodeURIComponent(hodMail));
}

document.addEventListener("DOMContentLoaded", function () {
    document.querySelector(".remove-vo-btn").addEventListener("click", removeVO);
    document.querySelector(".close-vo-btn").addEventListener("click", closeVOPopup);
});

function openVORemovePopup() {
    document.getElementById("voRemovePopup").style.display = "block";
    document.getElementById("vo-message").innerHTML = ""; // Clear messages
}

function closeVOPopup() {
    document.getElementById("voRemovePopup").style.display = "none";
}

function removeVO() {
    console.log("Remove VO button clicked"); // Debugging log

    var voMail = document.getElementById("voMail").value.trim();

    if (!voMail) {
        document.getElementById("vo-message").innerHTML = "<span style='color: red;'>Please enter mail!</span>";
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "RemoveVOServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        console.log("Response received:", this.responseText); // Debugging log
        var response = this.responseText.trim();

        if (response.startsWith("success:")) {
            document.getElementById("vo-message").innerHTML = "<span style='color: green;'>VO Removed Successfully!</span>";
            setTimeout(closeVOPopup, 3000); // ✅ Close popup after success
        } else {
            document.getElementById("vo-message").innerHTML = "<span style='color: red;'>" + response.substring(6) + "</span>";
        }
    };

    xhr.onerror = function () {
        document.getElementById("vo-message").innerHTML = "<span style='color: red;'>Error: Failed to send request!</span>";
    };

    console.log("Sending request with voMail:", voMail); // ✅ Debugging log
    xhr.send("voMail=" + encodeURIComponent(voMail));
}

//admin
document.addEventListener("DOMContentLoaded", function () {
    document.querySelector(".remove-admin-btn").addEventListener("click", removeAdmin);
    document.querySelector(".close-btn").addEventListener("click", closeAdminPopup);
});

function openAdminRemovePopup() {
    document.getElementById("adminRemovePopup").style.display = "block";
    document.getElementById("admin-message").innerHTML = ""; // Clear messages
}

function closeAdminPopup() {
    document.getElementById("adminRemovePopup").style.display = "none";
}

function removeAdmin() {
    console.log("Remove Admin button clicked"); // Debugging log

    var adminMail = document.getElementById("adminMail").value.trim();

    if (!adminMail) {
        document.getElementById("admin-message").innerHTML = "<span style='color: red;'>Please enter an email!</span>";
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "RemoveAdminServlet", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        console.log("Response received:", this.responseText); // Debugging log
        var response = this.responseText.trim();

        if (response.startsWith("success:")) {
            document.getElementById("admin-message").innerHTML = "<span style='color: green;'>Admin Removed Successfully!</span>";
            setTimeout(closeAdminPopup, 3000); // ✅ Close popup after success
        } else {
            document.getElementById("admin-message").innerHTML = "<span style='color: red;'>" + response.substring(6) + "</span>";
        }
    };

    xhr.onerror = function () {
        document.getElementById("admin-message").innerHTML = "<span style='color: red;'>Error: Failed to send request!</span>";
    };

    console.log("Sending request with adminMail:", adminMail); // ✅ Debugging log
    xhr.send("adminMail=" + encodeURIComponent(adminMail));
}

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

    function openUpdatePopup(role) {
        document.getElementById("updateRole").innerText = role;
        document.getElementById("updateModal").style.display = "block";
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
    function openPopup(page) {
    document.getElementById("popupFrame").src = page;
    document.getElementById("popupModal").style.display = "flex";
}

window.onload = function() {
    function openStudent_Popup() {
        document.getElementById("student_Popup").style.display = "block";
    }

    function closePopup() {
        document.getElementById("student_Popup").style.display = "none";
    }

    function submitSmartcardID() {
        var smartcardID = document.getElementById("smartcardID").value;
        if (smartcardID.trim() !== "") {
            window.location.href = "updateleave.jsp?smartcardID=" + encodeURIComponent(smartcardID);
        } else {
            alert("Please enter a valid Smartcard ID.");
        }
    }

    // Attach functions to global scope so they can be called from buttons
    window.openStudent_Popup = openStudent_Popup;
    window.closePopup = closePopup;
    window.submitSmartcardID = submitSmartcardID;
};

//for view
//student
function open_StudentPopup() {
        document.getElementById('studentIdModal').style.display = 'flex';
    }

    function closeStudentPopup() {
        document.getElementById('studentIdModal').style.display = 'none';
    }

    function submit_StudentID() {
        const studentID = document.getElementById('studentIdInput').value.trim();
        if (studentID === '') {
            alert('Please enter a Student ID.');
            return;
        }
        window.location.href = "viewstudent.jsp?student_id=" + encodeURIComponent(studentID);
    }

//warden
function open_WardenPopup() {
    document.getElementById('wardenEmailModal').style.display = 'flex';
}

function closeWardenPopup() {
    document.getElementById('wardenEmailModal').style.display = 'none';
}

function submit_WardenEmail() {
    const wardenEmail = document.getElementById('wardenEmailInput').value.trim();
    if (wardenEmail === '') {
        alert('Please enter a Warden Email.');
        return;
    }
    window.location.href = "viewwarden.jsp?email=" + encodeURIComponent(wardenEmail);
}
//view for hod
 // Open Email Popup
 function open_HODPopup() {
    document.getElementById('hodEmailModal').style.display = 'flex';
}

function closeHODPopup() {
    document.getElementById('hodEmailModal').style.display = 'none';
}

function submit_HODEmail() {
    const wardenEmail = document.getElementById('hodEmailInput').value.trim();
    if (wardenEmail === '') {
        alert('Please enter a Warden Email.');
        return;
    }
    window.location.href = "viewhod.jsp?email=" + encodeURIComponent(wardenEmail);
}
     // Open VO Email Popup
     function open_VoPopup() {
        document.getElementById('voEmailModal').style.display = 'flex';
    }

    // Close VO Email Popup
    function closeVoPopup() {
        document.getElementById('voEmailModal').style.display = 'none';
    }

    // Submit VO Email
    function submit_VoEmail() {
        const email = document.getElementById('voEmailInput').value.trim();
        if (email === '') {
            alert('Please enter an email.');
            return;
        }
        window.location.href = "viewvo.jsp?email=" + encodeURIComponent(email);
    }

    function open_Modal() {
            document.getElementById("adminModal").style.display = "flex";
        }

        function closeModal() {
            document.getElementById("adminModal").style.display = "none";
        }

        function submit_AdminEmail() {
            var email = document.getElementById("adminEmail").value.trim();
            if (email === "") {
                alert("Please enter an email!");
                return;
            }
            window.location.href = "viewadmin.jsp?email=" + encodeURIComponent(email);
        }
        function open_GPO() {
            document.getElementById('GPOEmailModal').style.display = 'flex';
        }
        
        function closeGPOPopup() {
            document.getElementById('GPOEmailModal').style.display = 'none';
        }
        
        function submit_GPOEmail() {
            const GPOEmail = document.getElementById('GPOEmailInput').value.trim();
            if (GPOEmail === '') {
                alert('Please enter a GPO Email.');
                return;
            }
            window.location.href = "viewGPO.jsp?email=" + encodeURIComponent(GPOEmail);
        }
</script>
</head>
<body>

    <!-- Popup for view  student -->
<!-- Student ID Popup -->
<div id="studentIdModal" class="custom-modal">
    <div class="custom-modal-content">
        <h2>Enter Student ID</h2>
        <input type="text" id="studentIdInput" placeholder="Enter Student ID">
        <div style="margin-top:15px;">
            <button class="custom-submit-btn" onclick="submit_StudentID()">Submit</button>
            <button class="custom-cancel-btn" onclick="closeStudentPopup()">Cancel</button>
        </div>
    </div>
</div>

<div id="hodEmailModal" class="custom-modal">
    <div class="custom-modal-content">
        <h2>Enter HOD Email</h2>
        <input type="email" id="hodEmailInput" placeholder="Enter HOD Email">
        <div style="margin-top:15px;">
            <button class="custom-submit-btn" onclick="submit_HODEmail()">Submit</button>
            <button class="custom-cancel-btn" onclick="closeHODPopup()">Cancel</button>
        </div>
    </div>
</div>
¬
<!-- VO Email Popup -->
<div id="voEmailModal" class="custom-modal">
    <div class="custom-modal-content">
        <h2>Enter VO Email</h2>
        <input type="email" id="voEmailInput" placeholder="Enter VO Email">
        <div style="margin-top:15px;">
            <button class="custom-submit-btn" onclick="submit_VoEmail()">Submit</button>
            <button class="custom-cancel-btn" onclick="closeVoPopup()">Cancel</button>
        </div>
    </div>
</div>

<!-- view Admin Email Popup -->
 <!-- Admin Popup Modal -->
 <div id="adminModal" class="custom-modal">
    <div class="custom-modal-content">
        <h2>Enter Admin Email</h2>
        <input type="email" id="adminEmail" placeholder="Enter admin email">
        <br><br>
        <button class="custom-submit-btn" onclick="submit_AdminEmail()">Submit</button>
        <button class="custom-cancel-btn" onclick="closeModal()">Cancel</button>
    </div>
</div>
<!-- view Warden Email Popup -->
<div id="wardenEmailModal" class="warden-popup-modal">
    <div class="warden-popup-content">
        <h2>Enter Warden Email</h2>
        <input type="text" id="wardenEmailInput" placeholder="Enter Warden Email">
        <div style="margin-top:15px;">
            <button class="warden-submit-btn" onclick="submit_WardenEmail()">Submit</button>
            <button class="warden-cancel-btn" onclick="closeWardenPopup()">Cancel</button>
        </div>
    </div>
</div>
<div id="GPOEmailModal" class="GPO-popup-modal" style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-50%, -50%); 
background: white; padding: 20px; box-shadow: 0px 0px 10px rgba(0,0,0,0.5); z-index: 1000; 
border-radius: 10px; text-align: center; width: 300px;">
    <div class="GPO-popup-content">
        <h2>Enter GPO Email</h2>
        <input type="text" id="GPOEmailInput" placeholder="Enter GPO Email">
        <div style="margin-top:15px;">
            <button class="GPO-submit-btn" onclick="submit_GPOEmail()">Submit</button>
            <button class="GPO-cancel-btn" onclick="closeGPOPopup()">Cancel</button>
        </div>
    </div>
</div>

     <!-- Overlay Background -->
     <div class="overlay" id="overlay"></div>
     <div id="studentPopup" style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-50%, -50%); 
background: white; padding: 20px; box-shadow: 0px 0px 10px rgba(0,0,0,0.5); z-index: 1000; 
border-radius: 10px; text-align: center; width: 300px;">

<h2 style="margin-bottom: 10px;">Enter Student Smartcard ID</h2>
<input type="text" id="studentIdInputu" placeholder="" required 
    style="width: 90%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px;" />

<div>
    <button onclick="submitStudentId()" style="background-color: green; color: white; border: none; 
        padding: 10px 15px; margin-right: 10px; border-radius: 5px; cursor: pointer;">
        Submit
    </button>
    
    <button onclick="closeStudentPopup()"style="background-color: red; color: white; border: none; 
        padding: 10px 15px; border-radius: 5px; cursor: pointer;">
        Cancel
    </button>
</div>
</div>

     <!-- Overlay Background -->
     <div class="overlay" id="overlay"></div>
     <div id="wardenPopup" style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-50%, -50%); 
background: white; padding: 20px; box-shadow: 0px 0px 10px rgba(0,0,0,0.5); z-index: 1000; 
border-radius: 10px; text-align: center; width: 300px;">

<h2 style="margin-bottom: 10px;">Enter Warden Email</h2>
<input type="email" id="wardenEmail" placeholder="" required 
    style="width: 90%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px;" />

<div>
    <button onclick="validateWardenEmail()" style="background-color: green; color: white; border: none; 
        padding: 10px 15px; margin-right: 10px; border-radius: 5px; cursor: pointer;">
        Submit
    </button>
    
    <button onclick="closeWardenPopup()"style="background-color: red; color: white; border: none; 
        padding: 10px 15px; border-radius: 5px; cursor: pointer;">
        Cancel
    </button>
</div>
</div>

    <!-- HOD Email Popup Modal -->
    <div id="hodPopup">
        <h2 style="margin-bottom: 10px;">Enter HOD Email</h2>
        <input type="email" id="hodEmail" placeholder="" required 
            style="width: 90%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px;" />
        <div>
            <button onclick="validateHodEmail()" style="background-color: green; color: white; border: none;
                padding: 10px 15px; margin-right: 10px; border-radius: 5px; cursor: pointer;">
                Submit
            </button>
            <button onclick="closeHodPopup()" style="background-color: red; color: white; border: none;
                padding: 10px 15px; border-radius: 5px; cursor: pointer;">
                Cancel
            </button>
        </div>
    </div>

</div>

<!-- Overlay for Popup -->
<div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
background: rgba(0, 0, 0, 0.5); z-index: 999;"></div>

<!-- Popup Modal for Verification Officer -->
<div id="voPopup" style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-50%, -50%); 
background: white; padding: 20px; box-shadow: 0px 0px 10px rgba(0,0,0,0.5); z-index: 1000; 
border-radius: 10px; text-align: center; width: 300px;">
    <h2 style="margin-bottom: 10px;">Enter VO Email</h2>
    <input type="email" id="voEmail" placeholder="" required 
        style="width: 90%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px;" />
    <button onclick="validateEmail()" style="background: green; color: white; padding: 5px 10px; border: none; border-radius: 5px; cursor: pointer;">Submit</button>
    <button onclick="closevoPopup()" style="background: red; color: white; padding: 5px 10px; border: none; border-radius: 5px; cursor: pointer;">Cancel</button>
</div>

<!-- ✅ Admin Popup (Ensure it's structured properly) -->
<div id="adminPopup" style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-50%, -50%); 
background: white; padding: 20px; box-shadow: 0px 0px 10px rgba(0,0,0,0.5); z-index: 1000; 
border-radius: 10px; text-align: center; width: 300px;">
    <h2 style="margin-bottom: 10px;">Enter Admin Email</h2>
    
    <!-- ✅ Ensure this input is NOT hidden or missing -->
    <input type="email" id="adminEmail" placeholder="Enter email" required 
        style="width: 90%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px;" />
    
    <div>
        <button onclick="validateAdminEmail()" style="background: green; color: white; padding: 5px 10px; border: none; border-radius: 5px; cursor: pointer;">
            Submit
        </button>
        <button onclick="closeAdminPopup()" style="background: red; color: white; padding: 5px 10px; border: none; border-radius: 5px; cursor: pointer;">
            Cancel
        </button>
    </div>
</div>

<!-- ✅ Overlay (if missing, add it) -->
<div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
background: rgba(0,0,0,0.5); z-index: 999;"></div>

<!-- ✅ Student Removal Modal -->
<div id="studentremovePopup" class="popup" style="display: none;">
    <div class="popup-content">
        <span class="close-btn" onclick="closeStudentPopup()">&times;</span> 
        <h2>Remove Student</h2>
        <form id="removeStudentForm">
            <label>Enter Student ID:</label>
            <input type="text" id="studentId" name="student_id" required>
            <button type="button" onclick="removeStudent()" class="remove-btn">Remove</button>
        </form>
        <p id="student-message"></p> <!-- ✅ Success/Error message appears here -->
    </div>
</div>

<!-- ✅ Warden Removal Modal -->
<div id="wardenremovePopup" class="popup" style="display: none;">
    <div class="popup-content">
        <span class="close-btn" onclick="closeWardenPopup()">&times;</span> <!-- Close Button -->
        <h2>Remove Warden</h2>
        <form id="removewardenForm">
            <label>Enter Warden Email:</label>
            <input type="text" id="wardenMail" name="wardenMail" required>
            <button type="button" onclick="removeWarden()" class="remove-btn">Remove</button>
        </form>
        <p id="warden-message"></p> <!-- ✅ Success/Error message appears here -->
    </div>
</div>

<!-- ✅ HOD Removal Modal -->
<div id="hodremovePopup" class="popup">
    <div class="popup-content">
        <!-- ✅ Close button (×) positioned at the top-right -->
        <span class="close-btn" onclick="closeHODPopup()">&times;</span> 
        
        <h2>Remove HOD</h2>
        <form id="removehodForm">
            <label>Enter Mail:</label>
            <input type="text" id="hodMail" name="hodMail" required>
            <button type="button" class="remove-btn">Remove</button> <!-- ✅ Red Remove Button -->
        </form>
        <p id="hod-message"></p> <!-- ✅ Success/Error message appears here -->
    </div>
</div>

<!-- ✅ VO Removal Modal -->
<div id="voRemovePopup" class="popup">
    <div class="popup-content">
        <!-- ✅ Close button (×) positioned at the top-right -->
        <span class="close-btn" onclick="closeVOPopup()">&times;</span> 
        
        <h2>Remove VO</h2>
        <form id="removeVOForm">
            <label>Enter Mail:</label>
            <input type="text" id="voMail" name="voMail" required>
            <button type="button" class="remove-btn">Remove</button> <!-- ✅ Red Remove Button -->
        </form>
        <p id="vo-message"></p> <!-- ✅ Success/Error message appears here -->
    </div>
</div>

<!-- ✅ Admin Removal Modal -->
<div id="adminRemovePopup" class="popup">
    <div class="popup-content">
        <!-- ✅ Close button (×) positioned at the top-right -->
        <span class="close-btn" onclick="closeAdminPopup()">&times;</span> 
        
        <h2>Remove Admin</h2>
        <form id="removeAdminForm">
            <label>Enter Mail:</label>
            <input type="text" id="adminMail" name="adminMail" required>
            <button type="button" class="remove-btn">Remove</button> <!-- ✅ Red Remove Button -->
        </form>
        <p id="admin-message"></p> <!-- ✅ Success/Error message appears here -->
    </div>
</div>
<!-- Modal for displaying pages -->
<div id="popupModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closePopup()">&times;</span>
        <iframe id="popupFrame"></iframe>
    </div>
</div>

<div id="student_Popup" style="display: none; position: fixed; top: 30%; left: 50%; transform: translate(-50%, -50%);
background: white; padding: 20px; box-shadow: 0px 0px 10px rgba(0,0,0,0.5); z-index: 1000;
border-radius: 10px; text-align: center; width: 300px;">

    <h2 style="margin-bottom: 10px;">Enter Smartcard ID</h2>
    <input type="email" id="smartcardID" placeholder="" required 
        style="width: 90%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 5px;" />

    <div>
        <button onclick="submitSmartcardID()" style="background-color: green; color: white; border: none; 
            padding: 10px 15px; margin-right: 10px; border-radius: 5px; cursor: pointer;">
            Submit
        </button>
        
        <button onclick="closePopup()" style="background-color: red; color: white; border: none; 
            padding: 10px 15px; border-radius: 5px; cursor: pointer;">
            Cancel
        </button>    
    </div>
</div>

    <!-- Navbar -->
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            
            <a href="admin_change_password.jsp" >Change Password</a>
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

        <!-- User Management -->
        <a onclick="toggleDropdown('userDropdown', 'userArrow')">
            <i class="fas fa-users"></i> User Management 
            <i id="userArrow" class="fas fa-chevron-right arrow"></i>
        </a>
        <div id="userDropdown" class="dropdown">
            <!-- View Section -->
            <a onclick="toggleDropdown('viewDropdown', 'viewArrow')">
                <i class="fas fa-eye"></i> View <i id="viewArrow" class="fas fa-chevron-right arrow"></i>
            </a>
            <div id="viewDropdown" class="dropdown">
                <a href="#" onclick="open_StudentPopup()">Student</a>
                <a href="#" onclick="open_WardenPopup()">Warden</a>
                <a href="#" onclick="open_HODPopup()">HOD</a>
                <a href="#" onclick="open_VoPopup()">Verification Officer</a>
                <a href="#" onclick="open_Modal()">Admin</a>
                <a href="#" onclick="open_GPO()">GPO</a>
            </div>
    
            <!-- Update Section -->
            <a onclick="toggleDropdown('updateDropdown', 'updateArrow')">
                <i class="fas fa-edit"></i> Update <i id="updateArrow" class="fas fa-chevron-right arrow"></i>
            </a>
            <div id="updateDropdown" class="dropdown">
                <a href="#" onclick="openStudentPopup()">Student</a>
                <a href="#" onclick="openWardenPopup()">Warden</a>
                <a href="#" onclick="openHodPopup()">HOD</a>
                <a href="#" onclick="openvoPopup()">Verification Officer</a>
                <a href="#" onclick="openAdminPopup()">Admin</a>
            </div>    
    
            <!-- Add Section -->
            <a onclick="toggleDropdown('addDropdown', 'addArrow')">
                <i class="fas fa-user-plus"></i> Add <i id="addArrow" class="fas fa-chevron-right arrow"></i>
            </a>
            <div id="addDropdown" class="dropdown">
                <a href="addstudent.jsp" onclick="openPopup('addstudent.jsp')">Student</a>
                <a href="addwarden.jsp" onclick="openPopup('addwarden.jsp')">Warden</a>
                <a href="addhod.jsp" onclick="openPopup('addhod.jsp')">HOD</a>
                <a href="addvo.jsp" onclick="openPopup('addvo.jsp')">Verification Officer</a>
                <a href="addadmin.jsp" onclick="openPopup('addadmin.jsp')">Admin</a>
            </div>
    
            <!-- Remove Section -->
            <a onclick="toggleDropdown('removeDropdown', 'removeArrow')">
                <i class="fas fa-user-minus"></i> Remove <i id="removeArrow" class="fas fa-chevron-right arrow"></i>
            </a>
            <div id="removeDropdown" class="dropdown">
                <a href="#" onclick="openStudentRemovePopup()">Student</a>
                <a href="#" onclick="openWardenRemovePopup()">Warden</a>
                <a href="#" onclick="openHODRemovePopup()">HOD</a>
                <a href="#" onclick="openVORemovePopup()">Verification Officer</a>
                <a href="#" onclick="openAdminRemovePopup()">Admin</a>

            </div>
        </div>
    
        <!-- Leave Management -->
        <a onclick="toggleDropdown('leaveDropdown', 'leaveArrow')">
            <i class="fas fa-calendar-alt"></i> Leave Management 
            <i id="leaveArrow" class="fas fa-chevron-right arrow"></i>
        </a>
        <div id="leaveDropdown" class="dropdown">
            <a href="viewallLeaves.jsp" onclick="openLeavePopup()"><i class="fas fa-list"></i> View Leaves</a>
            <a href="pendingLeaves.jsp"><i class="fas fa-list"></i> Pending Leaves</a>
            <a href="#" onclick="openStudent_Popup()"><i class="fas fa-edit"></i> Update Leave</a>

        </div>
    
        <!-- Logout -->
        <a href="index.jsp" class="logout" onclick="confirmLogout()">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    
    </div>
    <script>
        function openPopup(page) {
            console.log("Popup opened:", page);
            document.getElementById("popupFrame").src = page;
            document.getElementById("popupModal").style.display = "flex";
    
            // Hide admin details when popup opens
            document.getElementById("adminDetails").style.display = "none";  // Hide admin details
        }
    
        function closePopup() {
            document.getElementById("popupModal").style.display = "none";
            document.getElementById("popupFrame").src = "";
    
            // Show admin details again when popup closes
            document.getElementById("adminDetails").style.display = "block";  // Show admin details
        }
    

    function toggleDropdown(dropdownId, arrowId) {
    var dropdown = document.getElementById(dropdownId);
    var arrow = document.getElementById(arrowId);

    if (dropdown.style.display === "block") {
        dropdown.style.display = "none";
        arrow.classList.remove("rotate");
        document.getElementById("adminDetails").style.display = "none";  // Hide admin details
    } else {
        dropdown.style.display = "block";
        arrow.classList.add("rotate");
        document.getElementById("adminDetails").style.display = "none";  // Hide admin details
        
    }
}
</script>
<div id="popupModal" class="popup-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); justify-content: center; align-items: center;">
    <div class="popup-content" style="background: white; padding: 20px; border-radius: 10px;">
        <iframe id="popupFrame" style="width: 600px; height: 400px; border: none;"></iframe>
        <button onclick="closePopup()" style="margin-top: 10px; padding: 10px; background: red; color: white; border: none; cursor: pointer;">Close</button>
    </div>
</div>
<!-- Admin Details Container -->
<div class="content">
    <div id="adminDetails" class="details-container">
        <%
            String adminId = (String) session.getAttribute("adminId");
            if (adminId == null) {
                response.sendRedirect("admin.jsp");
                return;
            }
        %>

        <div class="photo-container">
            <img src="AdminPhotoServlet?adminId=<%= adminId %>" alt="Admin Photo">
        </div>
        <div class="details-grid">
            <%
                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

                    String query = "SELECT admin_id, name, phone, email FROM admin WHERE admin_id = ?";
                    pstmt = con.prepareStatement(query);
                    pstmt.setString(1, adminId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
            %>
            <label>Admin ID:</label>
            <input type="text" value="<%= rs.getString("admin_id") %>" readonly>

            <label>Name:</label>
            <input type="text" value="<%= rs.getString("name") %>" readonly>

            <label>Email:</label>
            <input type="text" value="<%= rs.getString("email") %>" readonly>

            <label>Phone:</label>
            <input type="text" value="<%= rs.getString("phone") %>" readonly>
            <%
                    } else {
                        out.println("<p style='color: red;'>No admin found with the provided ID.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p style='color: red;'>Error fetching data: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                    if (con != null) try { con.close(); } catch (Exception e) {}
                }
            %>
        </div>
    </div>
</div>

</body>
</html>
