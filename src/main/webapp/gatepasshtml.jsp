<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
Connection conn = null;
PreparedStatement stmt = null;
PreparedStatement updateStmt = null;
ResultSet rs = null;
boolean updateSuccess = false;

// Get student_id from request parameter
String studentId = request.getParameter("student_id");
String leaveId = request.getParameter("leave_id"); // Also get leave_id if available

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

    // SQL query to join tables and retrieve required data
    String sql = "SELECT l.student_id, l.leave_id, l.start_date, l.end_date, l.companion_name, l.companion_relation, " +
                 "s.name AS student_name, g.name AS guardian_name, c.name, h.name " +
                 "FROM leaverequests l " +
                 "JOIN students s ON l.student_id = s.student_id " +
                 "JOIN courses c ON s.course_id = c.course_id " +
                 "JOIN hostels h ON s.hostel_id = h.hostel_id " +
                 "JOIN guardians g ON s.student_id = g.student_id " +
                 "WHERE l.student_id = ?";
    
    if (leaveId != null && !leaveId.isEmpty()) {
        sql += " AND l.leave_id = ?";
    }

    stmt = conn.prepareStatement(sql);
    stmt.setString(1, studentId);
    
    if (leaveId != null && !leaveId.isEmpty()) {
        stmt.setString(2, leaveId);
    }
    
    rs = stmt.executeQuery();

    // Fetch data if available
    if (rs.next()) {
        leaveId = rs.getString("leave_id");
        studentId = rs.getString("student_id");
        String studentName = rs.getString("student_name");
        String guardianName = rs.getString("guardian_name");
        String courseName = rs.getString("c.name");
        String hostelName = rs.getString("h.name");
        String startDate = rs.getString("start_date");
        String endDate = rs.getString("end_date");
        String companionName = (rs.getString("companion_name") == null || rs.getString("companion_name").trim().isEmpty()) ? "अकेली" : rs.getString("companion_name");
        String companionRelation = rs.getString("companion_relation") != null ? rs.getString("companion_relation") : "";

        // Setting attributes to be used in HTML
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
        
        // Update leave status in the database
        String updateQuery = "UPDATE leaverequests SET gpo_status = 'Accepted', current_stage = 'Complete', final_status = 'Accepted' WHERE leave_id = ? AND student_id = ?";
        updateStmt = conn.prepareStatement(updateQuery);
        updateStmt.setString(1, leaveId);
        updateStmt.setString(2, studentId);
        int rowsUpdated = updateStmt.executeUpdate();
        
        if (rowsUpdated > 0) {
            updateSuccess = true;
            System.out.println("Database update successful. Rows updated: " + rowsUpdated);
        } else {
            System.out.println("No rows were updated. Please check leave_id and student_id values.");
        }
    } else {
        System.out.println("No records found for student ID: " + studentId);
    }
} catch (Exception e) {
    System.out.println("Error in database operations:");
    e.printStackTrace();
} finally {
    // Close resources in reverse order of opening
    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (updateStmt != null) updateStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }
        .container {
            margin-top: 230px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 30px;
            width: 100%;
            max-width: 800px;
        }
        .gatepass {
            width: 600px;
            background: white;
            padding: 20px;
            border: 2px solid black;
            text-align: center;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
            position: relative;
            box-sizing: border-box;
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
            flex-wrap: wrap;
            gap: 20px;
            position: relative;
            justify-content: space-between;
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
            margin-top: 2px;
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
        .details {
            flex: 1;
            min-width: 60%;
        }
        .photo-box {
            flex: 0 0 120px; 
            display: flex;
            justify-content: flex-end;
        }
        .photo-box img {
            max-width: 100%;
            max-height: 180px;
            object-fit: contain;
            border: 1px solid #ccc;
            margin-top: -130px;
        }
        .status-message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        @media print {
            .print-button, .status-message {
                display: none;
            }
            .container {
                margin-top: 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <% if (request.getAttribute("studentName") != null) { %>
            <% if (updateSuccess) { %>
                <div class="status-message success">
                    Leave request successfully updated in the database.
                </div>
            <% } %>
            
            <!-- First Gate Pass -->
            <div class="gatepass">
                <div class="header-container">
                    <div>वनस्थली विद्यापीठ</div>
                    <div>छात्रा अवकाश स्वीकृति पत्र</div>
                </div>
                <div class="divider"></div>
                <div class="divider"></div>
                <div class="info">
                    <div class="details">
                        <div><span>दिनांक:</span> <%= new java.util.Date() %></div>                             
                        <div><span>क्रमांक:</span> <%= request.getAttribute("leaveId") %></div>
            
                        <span class="gate-pass-box">मुख्य द्वार प्रति</span>
                        <div><span>छात्रा आईडी:</span> <%= request.getAttribute("studentId") %></div> 
                        <div><span>छात्रा का नाम:</span> <%= request.getAttribute("studentName") %></div>
                        <div><span>पिता का नाम:</span> <%= request.getAttribute("guardianName") %></div>
                        <div><span>कोर्स:</span> <%= request.getAttribute("courseName") %></div>
                        <div><span>अवकाश अवधि:</span> <%= request.getAttribute("startDate") %> से <%= request.getAttribute("endDate") %> तक</div>
                        <div><span>छात्रावास:</span> <%= request.getAttribute("hostelName") %></div>
                        <div><span>साथी:</span> <%= request.getAttribute("companionName") %> <%= request.getAttribute("companionRelation") %></div>
                    </div>
                
                    <!-- Student Photo on Right -->
                    <div class="photo-box">
                        <img src="StudentPhotoServlet?studentId=<%= request.getAttribute("studentId") %>" alt="Student Photo">
                    </div>
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
                    <div class="details">
                        <div><span>दिनांक:</span> <%= new java.util.Date() %></div>                             
                        <div><span>क्रमांक:</span> <%= request.getAttribute("leaveId") %></div>
                        <span class="gate-pass-box">छात्रावास प्रति</span>
                        <div><span>छात्रा आईडी:</span> <%= request.getAttribute("studentId") %></div> 
                        <div><span>छात्रा का नाम:</span> <%= request.getAttribute("studentName") %></div>
                        <div><span>पिता का नाम:</span> <%= request.getAttribute("guardianName") %></div>
                        <div><span>कोर्स:</span> <%= request.getAttribute("courseName") %></div>
                        <div><span>अवकाश अवधि:</span> <%= request.getAttribute("startDate") %> से <%= request.getAttribute("endDate") %> तक</div>
                        <div><span>छात्रावास:</span> <%= request.getAttribute("hostelName") %></div>
                        <div><span>साथी:</span> <%= request.getAttribute("companionName") %> <%= request.getAttribute("companionRelation") %></div>
                    </div>
                
                    <!-- Student Photo on Right -->
                    <div class="photo-box">
                        <img src="StudentPhotoServlet?studentId=<%= request.getAttribute("studentId") %>" alt="Student Photo">
                    </div>
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
        <% } else { %>
            <div class="status-message error">
                No student record found. Please check the student ID and try again.
            </div>
        <% } %>
    </div>

    
</body>
</html>