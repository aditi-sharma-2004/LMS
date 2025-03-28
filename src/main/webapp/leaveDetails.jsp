<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
    String leaveId = request.getParameter("leave_id");
    String role = request.getParameter("role");

    if (leaveId == null || leaveId.isEmpty()) {
        out.println("<h3>Error: No leave ID provided.</h3>");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms");

        String query = "SELECT lr.*,s.student_id,s.name AS student_name,s.rno AS roll_number,c.name AS course_name,h.name AS hostel_name,g.name AS guardian_name  " +
                       "FROM LeaveRequests lr " +
                       "JOIN Students s ON lr.student_id = s.student_id " +
                       "JOIN Courses c ON s.course_id = c.course_id " +
                       "LEFT JOIN Hostels h ON s.hostel_id = h.hostel_id " +
                       "LEFT JOIN Guardians g ON s.student_id = g.student_id " +
                       "WHERE lr.leave_id = ?";

        ps = conn.prepareStatement(query);
        ps.setInt(1, Integer.parseInt(leaveId));
        rs = ps.executeQuery();

        if (rs.next()) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Details</title>
    <style>
       
       body {
        font-family: 'Poppins', sans-serif;
        background: white;
        margin: 0;
        background-image: url('img.jpg');
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        background-attachment: fixed;
        padding: 2px;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        overflow-y: auto;
    }

    .container {
        background: #ffffff;
        padding: 20px;
        border-radius: 9px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        max-width: 1000px;
        width: 90%;
        margin: auto;
        display: flex;
        align-items: center;
        gap: 20px; /* Space between photo and details */
    }

    .photo-container {
        flex-shrink: 0;
        align-self: flex-start; /* Move photo upwards */
        margin-top: 50px; /* Add margin to shift the photo down */
    }

    .photo-container img {
        max-width: 200px;
        border-radius: 10px;
    }

 
    .details-container {
        display: flex;
        flex-direction: column;
        width: 100%;
    }

    .details-container h2 {
        margin-bottom: 20px;
        color: #333;
        font-size: 24px;
    }

    .details-grid {
        display: grid;
        grid-template-columns: 1fr 2fr;
        gap: 10px;
    }

    .details-grid label {
        font-size: 14px;
        color: #555;
        font-weight: bold;
        display: flex;
        align-items: center;
    }

    /* Ensure Student ID is displayed below its label */
    .details-grid .full-width {
        grid-column: span 2;
        display: flex;
        flex-direction: column;
    }

    .details-grid input {
        padding: 5px 8px;
        font-size: 14px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background-color: #f9f9f9;
        width: 100%;
    }

    .details-grid input:focus {
        border-color: #6a5acd;
        outline: none;
        background-color: #fff;
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
    color:#6a5acd;;
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
    background-color: #6a5acd;;
    color: white;
    text-decoration: none;
    padding: 10px 15px;
    border-radius: 5px;
    font-size: 14px;
    transition: background-color 0.3s;
}

.navbar .nav-button:hover {
    background-color:#6a5acd;;
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
.info-box {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0px 2px 5px rgba(0,0,0,0.1);
            width: 80%;
            margin-bottom: 10px;
        }
        .button-container {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            margin: 5px;
            transition: 0.3s ease;
        }
        .btn-accept { background-color: #6a5acd; }
        .btn-accept:hover { background-color: #6a5acd; }
        .btn-reject { background-color: #dc3545; }
        .btn-reject:hover { background-color: #c82333; }
        .signature-container {
    display: flex;
    justify-content: space-around;  /* Keeps them spaced properly */
    align-items: center;  /* Aligns items vertically */
    gap: 5px;  /* Adds space between the signatures */
    margin-top: 20px; /* Adds spacing from above */
}

.signature-box {
    text-align: center; /* Centers the heading and image */
}
        .signature-container img {
            max-width: 300px;
            max-height: 150px;
            border: 1px solid #000;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="photo-container">
            <img src="StudentPhotoServlet?studentId=<%= rs.getString("student_id") %>" alt="Student Photo">
        </div>
        <div class="details-container">
            <h2>Leave Details</h2>
            <div class="details-grid">
                <div class="full-width">
                    <label for="student_id">Student ID:</label>
                    <input type="text" id="student_id" name="student_id" value="<%= rs.getString("student_id") %>" readonly>
                </div>
    
                <div class="full-width">
                <label for="student_name">Student Name:</label>
                <input type="text" id="student_name" name="student_name" value="<%= rs.getString("student_name") %>" readonly>
            </div>

                <div class="full-width">
                <label for="roll_number">Roll Number:</label>
                <input type="text" id="roll_number" name="roll_number" value="<%= rs.getString("roll_number") %>" readonly>
            </div>

                <div class="full-width">
                <label for="course_name">Course:</label>
                <input type="text" id="course_name" name="course_name" value="<%= rs.getString("course_name") %>" readonly>
            </div>

                <div class="full-width">
                <label for="hostel_name">Hostel:</label>
                <input type="text" id="hostel_name" name="hostel_name" value="<%= rs.getString("hostel_name") != null ? rs.getString("hostel_name") : "N/A" %>" readonly>
            </div>

                <div class="full-width">
                <label for="guardian_name">Guardian Name:</label>
                <input type="text" id="guardian_name" name="guardian_name" value="<%= rs.getString("guardian_name") != null ? rs.getString("guardian_name") : "N/A" %>" readonly>
            </div>

                <div class="full-width">
                <label for="leave_type">Leave Type:</label>
                <input type="text" id="leave_type" name="leave_type" value="<%= rs.getString("leave_type") %>" readonly>
            </div>

                <div class="full-width">
                <label for="reason">Reason:</label>
                <input type="text" id="reason" name="reason" value="<%= rs.getString("reason") %>" readonly>
            </div>
            
                <div class="full-width">
                <label for="start_date">Start Date:</label>
                <input type="text" id="start_date" name="start_date" value="<%= rs.getDate("start_date") %>" readonly>
            </div>

                <div class="full-width">
                <label for="end_date">End Date:</label>
                <input type="text" id="end_date" name="end_date" value="<%= rs.getDate("end_date") %>" readonly>
            </div>

                <div class="full-width">
                <label for="leaving_alone">Leaving Alone?</label>
                <input type="text" id="leaving_alone" name="leaving_alone" value="<%= rs.getString("leaving_alone") %>" readonly>
            </div>

                <div class="full-width">
                <label for="verification_status">Status:</label>
                <input type="text" id="verification_status" name="verification_status" value="<%= rs.getString("verification_status") %>" readonly>
                </div>
            </div>
    
            <div class="signature-container">
                <div class="signature-box">
                    <h3>Guardian's Signature</h3>
                    <img src="GetSignatureServletG?guardian_id=<%= rs.getString("guardian_id") %>" alt="Guardian Signature not available">
                </div>
                <div class="signature-box">
                    <h3>Leave Signature</h3>
                    <img src="GetSignatureServletL?leave_id=<%= leaveId %>" alt="Leave Signature not available">
                </div>
            </div>
    
            <% if ("VO".equalsIgnoreCase(role)) { %>
                <div class="button-container">
                    <a href="acceptLeaveVo.jsp?leave_id=<%= leaveId %>" class="btn btn-accept">Accept</a>
                    <a href="rejectLeaveVo.jsp?leave_id=<%= leaveId %>" class="btn btn-reject">Reject</a>
                </div>
            <% } else if ("warden".equalsIgnoreCase(role)) { %>
                <div class="button-container">
                    <a href="acceptLeaveWarden.jsp?leave_id=<%= leaveId %>" class="btn btn-accept">Accept</a>
                    <a href="rejectLeaveWarden.jsp?leave_id=<%= leaveId %>" class="btn btn-reject">Reject</a>
                </div>
            <% } else if ("HOD".equalsIgnoreCase(role)) { %>
                <div class="button-container">
                    <a href="acceptLeaveHod.jsp?leave_id=<%= leaveId %>" class="btn btn-accept">Accept</a>
                    <a href="rejectLeaveHod.jsp?leave_id=<%= leaveId %>" class="btn btn-reject">Reject</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>

<%
        } else {
            out.println("<h3>No leave request found for ID: " + leaveId + "</h3>");
        }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>
