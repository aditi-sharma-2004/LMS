<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

Connection conn = null;
PreparedStatement stmt = null;
PreparedStatement ps = null;
PreparedStatement ps2 = null;
ResultSet rs = null;

String leaveId = request.getParameter("leave_id"); 
String studentId = request.getParameter("student_id");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms","lms");

    // First, verify the leave request exists
    String verifyQuery = "SELECT * FROM leaverequests WHERE leave_id = ? AND student_id = ?";
    ps = conn.prepareStatement(verifyQuery);
    ps.setString(1, leaveId);
    ps.setString(2, studentId);
    rs = ps.executeQuery();

    if (rs.next()) {
        // SQL query to join tables and retrieve required data
        String sql = "SELECT l.leave_id, l.start_date, l.end_date, l.companion_name, l.companion_relation, " +
                     "s.name AS student_name, g.name AS guardian_name, c.name, h.name " +
                     "FROM leaverequests l " +
                     "JOIN students s ON l.student_id = s.student_id " +
                     "JOIN courses c ON s.course_id = c.course_id " +
                     "JOIN hostels h ON s.hostel_id = h.hostel_id " +
                     "JOIN guardians g ON s.student_id = g.student_id " +
                     "WHERE l.leave_id = ? AND l.student_id = ?";

        stmt = conn.prepareStatement(sql);
        stmt.setString(1, leaveId);
        stmt.setString(2, studentId);
        rs = stmt.executeQuery();

        // Fetch data if available
        if (rs.next()) {
            String studentName = rs.getString("student_name");
            String guardianName = rs.getString("guardian_name");
            String courseName = rs.getString("c.name");
            String hostelName = rs.getString("h.name");
            String startDate = rs.getString("start_date");
            String endDate = rs.getString("end_date");
            String companionName = rs.getString("companion_name") != null ? rs.getString("companion_name") : "अकेली";
            String companionRelation = rs.getString("companion_relation") != null ? rs.getString("companion_relation") : "";

            // Update Leave Request Status with explicit checks
            String updateQuery = "UPDATE LeaveRequests SET gpo_status = 'Accepted', current_stage = 'Complete', final_status = 'Accepted' WHERE leave_id = ? AND student_id = ?";
            ps2 = conn.prepareStatement(updateQuery);
            ps2.setString(1, leaveId);
            ps2.setString(2, studentId);
            int rowsUpdated = ps2.executeUpdate();

            // Only set attributes if update was successful
            if (rowsUpdated > 0) {
                request.setAttribute("leaveId", leaveId);
                request.setAttribute("studentId", studentId);
                request.setAttribute("studentName", studentName);
                request.setAttribute("guardianName", guardianName);
                request.setAttribute("courseName", courseName);
                request.setAttribute("hostelName", hostelName);
                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("companionName", companionName);
                request.setAttribute("companionRelation", companionRelation);
            } else {
                // Log or handle the case where no rows were updated
                System.out.println("No rows updated for leave ID: " + leaveId);
            }
        }
    } else {
        // Handle case where no matching leave request is found
        System.out.println("No leave request found for leave ID: " + leaveId + " and student ID: " + studentId);
    }
} catch (Exception e) {
    e.printStackTrace();
    // Optional: Log error or set an error attribute
    request.setAttribute("errorMessage", "An error occurred while processing the gatepass.");
} finally {
    // Close all database resources
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (ps != null) ps.close();
        if (ps2 != null) ps2.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Gate Pass</title>
    <style>
        body {
            font-family: 'Noto Sans Devanagari', 'Arial', sans-serif;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
        }
        .container {
            margin-top: 150px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .gatepass {
            width: 600px;
            background: white;
            padding: 10px;
            margin-top: 10px;
            border: 2px solid black;
            text-align: center;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            position: relative;
        }
        .header-container {
            display: flex;
            justify-content: space-between;
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 2px;
        }
        .divider {
            border-top: 2px solid black;
            margin: 5px 0;
        }
        .info {
            text-align: left;
            margin-top: 10px;
            position: relative;
        }
        .info p {
            margin: 5px 0;
            display: flex;
            justify-content: space-between;
        }
        .gate-pass-box {
            position: absolute;
            right: 0;
            top: -5px;
            border: 2px solid black;
            padding: 5px 10px;
            font-weight: bold;
        }
        .smart-id {
            position: absolute;
            right: 0;
            top: 30px;
            font-weight: bold;
        }
        .signatures {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
        }
        .signature {
            font-style: italic;
        }
        .course-line {
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .print-button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
            margin-top: 20px;
        }
        .print-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- First Gate Pass -->
        <div class="gatepass">
            <div class="header-container">
                <div>वनस्थली विद्यापीठ</div>
                <div>छात्रा अवकाश स्वीकृति पत्र</div>
            </div>
            <div class="divider"></div>
            <div class="divider"></div>
            <div class="info">
                <div><span>दिनांक:</span> <%= new java.util.Date() %></div>                             
                <div><span>क्रमांक:</span> <%= request.getAttribute("leaveId") %></div>
                <span class="gate-pass-box">मुख्य द्वार प्रति</span>
                <div><span>छात्रा आईडी:</span> <%= request.getAttribute("studentId") %></div> 
                <div><span>छात्रा का नाम:</span> <%= request.getAttribute("studentName") %></div>
                <div><span>पिता का नाम:</span> <%= request.getAttribute("guardianName") %></div>
                <div><span>कोर्स:</span> <%= request.getAttribute("courseName") %></div>
                <div><span>अवकाश अवधि:</span> <%= request.getAttribute("startDate") %> से <%= request.getAttribute("endDate") %> तक</div>
                <div><span>छात्रावास:</span> <%= request.getAttribute("hostelName") %></div>
                <div><span>साथी:</span> <%= request.getAttribute("companionName") %> (<%= request.getAttribute("companionRelation") %>)</div>
            </div>
            <div class="signatures">
                <div class="signature">
                    <p>हस्ताक्षर: _________</p>
                    <p>(जाँचकर्ता हस्ताक्षर)</p>
                </div>
                <div class="signature">
                    <p>हस्ताक्षर: _________</p>
                    <p>(डीन / अधीक्षक)</p>
                </div>
            </div>
        </div>

        <!-- Second Gate Pass (Duplicate) -->
        <div class="gatepass">
            <div class="header-container">
                <div>वनस्थली विद्यापीठ</div>
                <div>छात्रा अवकाश स्वीकृति पत्र</div>
            </div>
            <div class="divider"></div>
            <div class="divider"></div>
            <div class="info">
                <div><span>दिनांक:</span> <%= new java.util.Date() %></div>                             
                <div><span>क्रमांक:</span> <%= request.getAttribute("leaveId") %></div>
                <span class="gate-pass-box">छात्रावास प्रति</span>
                <div><span>छात्रा आईडी:</span> <%= request.getAttribute("studentId") %></div> 
                <div><span>छात्रा का नाम:</span> <%= request.getAttribute("studentName") %></div>
                <div><span>पिता का नाम:</span> <%= request.getAttribute("guardianName") %></div>
                <div><span>कोर्स:</span> <%= request.getAttribute("courseName") %></div>
                <div><span>अवकाश अवधि:</span> <%= request.getAttribute("startDate") %> से <%= request.getAttribute("endDate") %> तक</div>
                <div><span>छात्रावास:</span> <%= request.getAttribute("hostelName") %></div>
                <div><span>साथी:</span> <%= request.getAttribute("companionName") %> (<%= request.getAttribute("companionRelation") %>)</div>
            </div>
            <div class="signatures">
                <div class="signature">
                    <p>हस्ताक्षर: _________</p>
                    <p>(जाँचकर्ता हस्ताक्षर)</p>
                </div>
                <div class="signature">
                    <p>हस्ताक्षर: _________</p>
                    <p>(डीन / अधीक्षक)</p>
                </div>
            </div>
        </div>

        <button class="print-button" onclick="window.print()">Print Gatepass</button>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            let companion = "";  // Fetch from database if available
            let companionRelation = "";  // Fetch from database if available
            
            if (!companion) {
                document.getElementById("companion").innerText = "अकेली";
                document.getElementById("companion_relation").innerText = "";
            } else {
                document.getElementById("companion").innerText = companion;
                document.getElementById("companion_relation").innerText = `(${companionRelation})`;
            }
        });
        document.getElementById("date").addEventListener("focus", function() {
        if (this.innerText.trim() === "DD/MM/YYYY") {
            this.innerText = ""; // Clear placeholder text when clicked
            this.style.color = "black"; // Change text color
        }
    });

    document.getElementById("date").addEventListener("blur", function() {
        if (this.innerText.trim() === "") {
            this.innerText = "DD/MM/YYYY"; // Restore placeholder when empty
            this.style.color = "gray"; // Reset text color
        }
    });
    </script>
</body>
</html>
