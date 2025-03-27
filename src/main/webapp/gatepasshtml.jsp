<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    Connection con = null;
    PreparedStatement ps = null;
    PreparedStatement ps2 = null;
    ResultSet rts = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL Driver
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

        String updateQuery = "UPDATE LeaveRequests SET gpo_status = 'Accepted' WHERE leave_id = ?";
        ps = con.prepareStatement(updateQuery);
        
        int leaveId = Integer.parseInt(request.getParameter("leaveId")); // Ensure leaveId is properly retrieved
        ps.setInt(1, leaveId);
        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            String updateStageQuery = "UPDATE LeaveRequests SET current_stage = 'Complete' WHERE leave_id = ?";
            ps2 = con.prepareStatement(updateStageQuery);
            ps2.setInt(1, leaveId);
            ps2.executeUpdate();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (ps != null) ps.close();
        if (ps2 != null) ps2.close();
        if (con != null) con.close();
    }
%>
<%

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String studentId = request.getParameter("student_id"); // Assume student_id is passed as a parameter

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms","lms");

    // SQL query to join tables and retrieve required data
    String sql = "SELECT l.leave_id, l.start_date, l.end_date, l.companion_name, l.companion_relation, " +
                 "s.name AS student_name, g.name AS guardian_name, c.name, h.name " +
                 "FROM leaverequests l " +
                 "JOIN students s ON l.student_id = s.student_id " +
                 "JOIN courses c ON s.course_id = c.course_id " +
                 "JOIN hostels h ON s.hostel_id = h.hostel_id " +
                 "JOIN guardians g ON s.student_id = g.student_id " +
                 "WHERE l.student_id = ?";
    String updateQuery = "UPDATE LeaveRequests SET gpo_status = 'Accepted' WHERE leave_id = ?";
    stmt = con.prepareStatement(updateQuery);

    stmt = conn.prepareStatement(sql);
    stmt.setString(1, studentId);
    rs = stmt.executeQuery();

    // Fetch data if available
    if (rs.next()) {
        String leaveId = rs.getString("leave_id");
        String studentName = rs.getString("student_name");
        String guardianName = rs.getString("guardian_name");
        String courseName = rs.getString("c.name");
        String hostelName = rs.getString("h.name");
        String startDate = rs.getString("start_date");
        String endDate = rs.getString("end_date");
        String companionName = rs.getString("companion_name") != null ? rs.getString("companion_name") : "अकेली";
        String companionRelation = rs.getString("companion_relation") != null ? rs.getString("companion_relation") : "";

        // Setting attributes to be used in HTML
        request.setAttribute("leaveId", leaveId);
        request.setAttribute("studentName", studentName);
        request.setAttribute("guardianName", guardianName);
        request.setAttribute("courseName", courseName);
        request.setAttribute("hostelName", hostelName);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("companionName", companionName);
        request.setAttribute("companionRelation", companionRelation);
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
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
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .gatepass {
            width: 600px;
            background: white;
            padding: 20px;
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
            margin-bottom: 10px;
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
            margin-top: 20px;
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
