<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
String guardianId = request.getParameter("guardianId");
if (guardianId == null) {
    guardianId = (String) session.getAttribute("guardianId");
}

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

        String query = "SELECT leave_id, student_id, start_date, end_date, verification_status, current_stage, " +
                      "leave_type, num_days, warden_status, hod_status, final_status, gpo_status " +
                      "FROM LeaveRequests WHERE guardian_id = ?";
        ps = conn.prepareStatement(query);
        ps.setString(1, guardianId);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Guardian - Track Leave Requests</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
    font-family: Arial, sans-serif;
    background-image: url('img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed; /* Keeps the background fixed */
    margin: 0;
    padding: 0;
    overflow-x: hidden; /* Prevent horizontal scroll */
}
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 0, 0, 0.05);
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
        
        .header {
    background: linear-gradient(135deg, #4776E6, #8E54E9);
    color: white;
    padding: 30px;
    position: relative;
    margin-top: 60px; /* Adjusted to ensure it appears below the navbar */
}

.header h2 {
    font-weight: 600;
    font-size: 24px;
    margin-bottom: 8px;
    letter-spacing: -0.5px;
}

.header p {
    opacity: 0.85;
    font-size: 15px;
    font-weight: 300;
    letter-spacing: 0.2px;
}
        
        .content {
            padding: 30px;
        }
        
        .leave-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.03);
            margin-bottom: 25px;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.06);
        }
        
        .leave-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
        }
        
        .leave-header {
            padding: 22px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f0f0f0;
            background: #fcfcfc;
        }
        
        .leave-details {
            padding: 25px;
        }
        
        .leave-id-container {
            display: flex;
            align-items: center;
        }
        
        .leave-id-container strong {
            font-weight: 600;
            color: #444;
        }
        
        .student-id-badge {
            display: inline-block;
            background: #f0f4ff;
            color: #4776E6;
            font-size: 12px;
            padding: 4px 12px;
            border-radius: 20px;
            margin-top: 5px;
            font-weight: 500;
        }
        
        .leave-dates {
            display: flex;
            margin-bottom: 30px;
            padding: 15px 0;
            position: relative;
        }
        
        .leave-dates:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(to right, transparent, #f0f0f0, transparent);
        }
        
        .leave-date {
            flex: 1;
            text-align: center;
            padding: 10px;
            position: relative;
        }
        
        .leave-date:first-child:after {
            content: '';
            position: absolute;
            top: 50%;
            right: 0;
            transform: translateY(-50%);
            width: 1px;
            height: 70%;
            background: #f0f0f0;
        }
        
        .leave-date span {
            display: block;
            color: #8a94a6;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.7px;
        }
        
        .leave-date strong {
            color: #333;
            font-size: 16px;
            font-weight: 600;
        }
        
        /* Timeline progress styles */
        .timeline-container {
            margin: 35px 0;
            position: relative;
            padding: 0 10px;
        }
        
        .timeline-track {
            height: 5px;
            background: #eef2f7;
            width: 100%;
            position: absolute;
            top: 25px;
            z-index: 1;
            border-radius: 10px;
        }
        
        .timeline-progress {
            height: 5px;
            background: linear-gradient(90deg, #4776E6, #8E54E9);
            position: absolute;
            top: 25px;
            z-index: 2;
            transition: width 0.8s cubic-bezier(0.19, 1, 0.22, 1);
            border-radius: 10px;
        }
        
        .timeline-steps {
            display: flex;
            justify-content: space-between;
            position: relative;
            z-index: 3;
        }
        
        .timeline-step {
            flex: 1;
            text-align: center;
            padding-top: 40px;
            position: relative;
        }
        
        .timeline-dot {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: white;
            border: 5px solid #eef2f7;
            position: absolute;
            top: 15px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 4;
            transition: all 0.4s cubic-bezier(0.19, 1, 0.22, 1);
            box-shadow: 0 0 0 5px rgba(238, 242, 247, 0.5);
        }
        
        .timeline-step.completed .timeline-dot {
            border-color: #4CAF50;
            background: #4CAF50;
            box-shadow: 0 0 0 5px rgba(76, 175, 80, 0.2);
        }
        
        .timeline-step.active .timeline-dot {
            border-color: #4776E6;
            background: white;
            box-shadow: 0 0 0 5px rgba(71, 118, 230, 0.2);
            animation: pulse 1.5s infinite;
        }
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(71, 118, 230, 0.4);
            }
            70% {
                box-shadow: 0 0 0 8px rgba(71, 118, 230, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(71, 118, 230, 0);
            }
        }
        
        .timeline-step.rejected .timeline-dot {
            border-color: #F44336;
            background: #F44336;
            box-shadow: 0 0 0 5px rgba(244, 67, 54, 0.2);
        }
        
        .timeline-label {
            font-size: 13px;
            font-weight: 600;
            color: #8a94a6;
            margin-bottom: 5px;
            transition: all 0.3s ease;
        }
        
        .timeline-step.completed .timeline-label {
            color: #4CAF50;
        }
        
        .timeline-step.active .timeline-label {
            color: #4776E6;
        }
        
        .timeline-step.rejected .timeline-label {
            color: #F44336;
        }
        
        .timeline-status {
            font-size: 11px;
            color: #8a94a6;
            padding: 2px 0;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .timeline-step.completed .timeline-status {
            color: #4CAF50;
        }
        
        .timeline-step.active .timeline-status {
            color: #4776E6;
        }
        
        .timeline-step.rejected .timeline-status {
            color: #F44336;
        }
        
        /* Alternative approach using a background image */
        .timeline-step.completed .timeline-dot {
            border-color: #4CAF50;
            background: #4CAF50 url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>') center no-repeat;
            box-shadow: 0 0 0 5px rgba(76, 175, 80, 0.2);
        }

        /* Remove the :after pseudo-element if using this approach */
        .timeline-step.completed .timeline-dot:after {
            content: none;
        }
                
                /* Alternative approach using a background image */
        .timeline-step.rejected .timeline-dot {
            border-color: #F44336;
            background: #F44336 url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>') center no-repeat;
            box-shadow: 0 0 0 5px rgba(244, 67, 54, 0.2);
        }

        /* Remove the :after pseudo-element if using this approach */
        .timeline-step.rejected .timeline-dot:after {
            content: none;
        }
        
        .leave-status {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 600;
        }
        
        .status-pending {
            background-color: #FFF8E1;
            color: #FF9800;
        }
        
        .status-approved {
            background-color: #E8F5E9;
            color: #4CAF50;
        }
        
        .status-rejected {
            background-color: #FFEBEE;
            color: #F44336;
        }
        
        .leave-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        .view-btn {
            text-decoration: none;
            padding: 10px 22px;
            background: linear-gradient(135deg, #4776E6, #8E54E9);
            color: white;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            box-shadow: 0 4px 15px rgba(142, 84, 233, 0.2);
        }
        
        .view-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(142, 84, 233, 0.3);
        }
        
        .view-btn:after {
            content: "→";
            margin-left: 8px;
            transition: transform 0.2s ease;
        }
        
        .view-btn:hover:after {
            transform: translateX(4px);
        }
        
        .back-btn {
            display: block;
            text-align: center;
            padding: 14px;
            background: linear-gradient(135deg, #4776E6, #8E54E9);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            margin-top: 15px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(142, 84, 233, 0.2);
        }
        
        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(142, 84, 233, 0.3);
        }
        
        .empty-message {
            text-align: center;
            padding: 60px 20px;
            color: #8a94a6;
        }
        
        .empty-message h3 {
            font-weight: 600;
            margin-bottom: 15px;
            color: #4776E6;
            font-size: 22px;
        }
        
        .empty-message p {
            font-size: 15px;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.6;
        }
        
        .gatepass-notification {
            background-color: #E8F5E9;
            border-left: 4px solid #4CAF50;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
            display: flex;
            align-items: center;
        }
        
        .gatepass-notification svg {
            margin-right: 12px;
            flex-shrink: 0;
        }
        
        .gatepass-notification-content {
            flex-grow: 1;
        }
        
        .gatepass-notification h4 {
            color: #2E7D32;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .gatepass-notification p {
            color: #4CAF50;
            margin: 0;
            font-size: 14px;
        }
        
        .leave-type-badge {
            display: inline-block;
            background: #E3F2FD;
            color: #1976D2;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 20px;
            margin-left: 10px;
            font-weight: 500;
        }
        
        .leave-days {
            display: flex;
            align-items: center;
            margin-top: 5px;
            font-size: 13px;
            color: #757575;
        }
        
        .leave-days svg {
            margin-right: 5px;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .header {
                padding: 25px 20px;
            }
            
            .content {
                padding: 20px 15px;
            }
            
            .leave-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .leave-status {
                margin-top: 10px;
            }
            
            .timeline-label {
                font-size: 11px;
            }
            
            .timeline-status {
                font-size: 10px;
            }
            
            .timeline-dot {
                width: 20px;
                height: 20px;
                border-width: 4px;
            }
        }
        
        @media (max-width: 576px) {
            .leave-dates {
                flex-direction: column;
            }
            
            .leave-date {
                margin-bottom: 20px;
                text-align: left;
            }
            
            .leave-date:first-child:after {
                display: none;
            }
            
            .timeline-step .timeline-label {
                font-size: 10px;
            }
            
            .timeline-status {
                font-size: 9px;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">
            <img src="Logoos.jpg" alt="Logo">
        </div>
        <div class="nav-links">
            <a href="resetPassword.jsp">Change Password</a>
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
        <div class="header">
            <h2>Track Your Child's Leave Requests</h2>
            <p>Monitor leave application status in real-time</p>
        </div>
        
        <div class="content">
            <% 
            boolean hasRecords = false;
            while (rs.next()) { 
                hasRecords = true;
                int leaveId = rs.getInt("leave_id");
                String studentId = rs.getString("student_id");
                Date startDate = rs.getDate("start_date");
                Date endDate = rs.getDate("end_date");
                String verificationStatus = rs.getString("verification_status");
                String currentStage = rs.getString("current_stage");
                String leaveType = rs.getString("leave_type");
                int numDays = rs.getInt("num_days");
                String wardenStatus = rs.getString("warden_status");
                String hodStatus = rs.getString("hod_status");
                String finalStatus = rs.getString("final_status");
                String gpoStatus = rs.getString("gpo_status");
        
                String statusClass = "status-pending";
                if ("Accepted".equals(finalStatus)) {
                    statusClass = "status-approved";
                } else if ("Rejected".equals(finalStatus)) {
                    statusClass = "status-rejected";
                }
        
                // Rejection & Approval flags
                boolean wardenRejected = "Rejected".equals(wardenStatus);
                boolean voRejected = "Rejected".equals(verificationStatus);
                boolean hodRejected = "Rejected".equals(hodStatus);
                boolean finalRejected = "Rejected".equals(gpoStatus) || "Rejected".equals(finalStatus);
        
                boolean isRejected = wardenRejected || voRejected || hodRejected || finalRejected;
                boolean isApproved = "Accepted".equals(finalStatus);
        
                // Stage-wise completion
                boolean wardenCompleted = "Accepted".equals(wardenStatus);
                boolean voCompleted = currentStage.equals("HOD") || currentStage.equals("GPO") || currentStage.equals("Complete");
                boolean hodCompleted = "Accepted".equals(hodStatus);
                boolean finalCompleted = "Accepted".equals(finalStatus) || "Accepted".equals(gpoStatus);
        
                int progressWidth = 0;
                switch(currentStage) {
                    case "Warden":
                        progressWidth = 0;
                        break;
                    case "VO":
                        wardenCompleted = true;
                        progressWidth = 40;
                        break;
                    case "HOD":
                        wardenCompleted = true;
                        voCompleted = true;
                        progressWidth = 66;
                        break;
                    case "GPO":
                        wardenCompleted = true;
                        voCompleted = true;
                        hodCompleted = true;
                        progressWidth = 88;
                        break;
                    case "Complete":
                        wardenCompleted = true;
                        voCompleted = true;
                        hodCompleted = true;
                        finalCompleted = isApproved;
                        progressWidth = 100;
                        break;
                }
        
                // Handle rejection rollback
                if (isRejected) {
                    if (wardenRejected || currentStage.equals("Warden")) {
                        wardenCompleted = false;
                    } else if (voRejected || currentStage.equals("VO")) {
                        voCompleted = false;
                    } else if (hodRejected || currentStage.equals("HOD")) {
                        hodCompleted = false;
                    } else if (finalRejected || currentStage.equals("GPO") || currentStage.equals("Complete")) {
                        finalCompleted = false;
                    }
                }
        
                boolean hodApprovedPendingFinal = "Accepted".equals(hodStatus) && !finalCompleted && !isRejected;
            %>
        
            <!-- Leave Card Starts -->
            <div class="leave-card">
                <div class="leave-header">
                    <div>
                        <div class="leave-id-container">
                            <strong>Leave ID: <%= leaveId %></strong>
                            <span class="leave-type-badge"><%= leaveType %></span>
                        </div>
                        <div class="leave-days">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <%= numDays %> day<%= numDays > 1 ? "s" : "" %> - Student ID: <%= studentId %>
                        </div>
                    </div>
                    <div class="leave-status <%= statusClass %>">
                        <%= verificationStatus %>
                    </div>
                </div>
        
                <div class="leave-details">
                    <div class="leave-dates">
                        <div class="leave-date">
                            <span>From</span>
                            <strong><%= startDate %></strong>
                        </div>
                        <div class="leave-date">
                            <span>To</span>
                            <strong><%= endDate %></strong>
                        </div>
                    </div>
        
                    <% if ("GPO".equals(currentStage)) { %>
                    <div class="gatepass-notification">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" stroke="#4CAF50">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                        <div class="gatepass-notification-content">
                            <h4>Gatepass Ready for Collection</h4>
                            <p>The HOD has approved this request. The student can now collect the printed gatepass from the department.</p>
                        </div>
                    </div>
                    <% } %>
        
                    <div class="timeline-container">
                        <div class="timeline-track"></div>
                        <div class="timeline-progress" id="progressBar<%= leaveId %>"></div>
                        <script>
                            document.getElementById("progressBar<%= leaveId %>").style.width = "<%= progressWidth %>%";
                        </script>
                        <div class="timeline-steps">
                            <div class="timeline-step <%= wardenRejected ? "rejected" : (wardenCompleted ? "completed" : (currentStage.equals("Warden") ? "active" : "")) %>">
                                <div class="timeline-dot"></div>
                                <div class="timeline-label">Warden</div>
                                <div class="timeline-status">
                                    <%= wardenRejected ? "Rejected" : (wardenCompleted ? "Accepted" : (currentStage.equals("Warden") ? "In Progress" : "Pending")) %>
                                </div>
                            </div>
        
                            <div class="timeline-step <%= voRejected ? "rejected" : (voCompleted ? "completed" : (currentStage.equals("VO") ? "active" : "")) %>">
                                <div class="timeline-dot"></div>
                                <div class="timeline-label">Verification</div>
                                <div class="timeline-status">
                                    <%= voRejected ? "Rejected" : (voCompleted ? "Accepted" : (currentStage.equals("VO") ? "In Progress" : "Pending")) %>
                                </div>
                            </div>
        
                            <div class="timeline-step <%= hodRejected ? "rejected" : (hodCompleted ? "completed" : (currentStage.equals("HOD") ? "active" : "")) %>">
                                <div class="timeline-dot"></div>
                                <div class="timeline-label">HOD</div>
                                <div class="timeline-status">
                                    <%= hodRejected ? "Rejected" : (hodCompleted ? "Accepted" : (currentStage.equals("HOD") ? "In Progress" : "Pending")) %>
                                </div>
                            </div>
        
                            <div class="timeline-step <%= finalRejected ? "rejected" : (finalCompleted ? "completed" : ((currentStage.equals("GPO") || currentStage.equals("Complete")) ? "active" : "")) %>">
                                <div class="timeline-dot"></div>
                                <div class="timeline-label">Final</div>
                                <div class="timeline-status">
                                    <%= finalRejected ? "Rejected" : (finalCompleted ? "Accepted" : ((currentStage.equals("GPO") || currentStage.equals("Complete")) ? "In Progress" : "Pending")) %>
                                </div>
                            </div>
                        </div>
                    </div>
        
                    <div class="leave-actions">
                        <a href="leaveDetailsGuard.jsp?leave_id=<%= leaveId %>" class="view-btn">View Details</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
            
            <% if (!hasRecords) { %>
            <div class="empty-message">
                <h3>No leave requests found</h3>
                <p>When your child submits a leave request, you'll be able to track it here.</p>
            </div>
            <% } %>
            
            <a href="guardianDashboard.jsp" class="back-btn">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>

<%
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>