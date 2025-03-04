<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Leave Management System</title>
    <style>
        /* General Styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            box-sizing: border-box;
        }
    
        /* Top Navigation Bar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #333;
            color: white;
            padding: 10px 20px;
            position: fixed;
            top: 0;
            width: 100%; /* Changed width to 100% for consistency */
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            height: 80px; /* Ensure the height is fixed */
            flex-wrap: wrap; /* Ensures content wraps instead of overflowing */
            box-sizing: border-box;
        }
    
        .navbar .logo {
            display: flex;
            align-items: center;
        }
    
        .navbar .logo img {
            width: 180px;
            height: auto;
            margin-right: 20px;
        }
    
        .navbar .logo h1 {
            font-size: 20px;
            margin: 0;
            font-weight: 500;
        }
    
        .navbar .nav-links {
            display: flex;
            gap: 15px; /* Adjusted spacing for better layout */
            align-items: center;
            flex-shrink: 0; /* Prevents shrinking of links */
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
    
        /* Main Content */
        .content {
            margin-top: 60px; /* This ensures content starts below the navbar */
            padding: 20px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            box-sizing: border-box;
        }
    
        /* Table Sections */
        .section {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
    
        .section h2 {
            color: #333;
            margin-bottom: 15px;
        }
    
        .section table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 14px;
        }

        .section table th {
            background-color: #000;
            color: white;
            font-weight: 500;
            padding: 10px;
        }

        .section table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .section table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .details-container {
      background-color: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      display: flex;
      align-items: flex-start;
      gap: 30px;
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
            border-color: #4CAF50;
            outline: none;
            background-color: #fff;
        }
        /* Photo Styling */
    .photo-container {
      flex-shrink: 0;
    }
    
    .photo-container img {
      max-width: 200px;
      border-radius: 10px;
    }

        /* Footer */
        .footer {
            text-align: center;
            padding: 15px 0;
            background-color: #333;
            color: white;
            font-size: 14px;
            margin-top: 30px;
        }
    </style>
</head>
<body>
  <!-- Top Navigation Bar -->
  <div class="navbar">
    <div class="logo">
      <img src="Logoos.jpg" alt="Logo">
    </div>
    <div class="nav-links">
      <a href="contact.jsp">Contact Us</a>
      <a href="logout.jsp" class="logout">Logout</a>
    </div>
  </div>

  <!-- Main Content -->
  <div class="content">
    <!-- Student Details Section -->
    <div class="details-container">
      <%
          // Use the implicit session object. Ensure that your login servlet sets "studentId"
          String studentId = (String) session.getAttribute("studentId");
          if(studentId == null) {
              response.sendRedirect("slogin.jsp");
              return;
          }
      %>
      <!-- Photo Section -->
      <div class="photo-container">
          <img src="StudentPhotoServlet?studentId=<%= studentId %>" alt="Student Photo">
      </div>
      <!-- Details Section -->
      <div class="details-grid">
          <%
              Connection con = null;
              PreparedStatement pstmt = null;
              ResultSet rs = null;
              try {
                  Class.forName("com.mysql.cj.jdbc.Driver");
                  con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");
                  String query = "SELECT s.student_id, s.name AS student_name, s.email, s.dob, s.phone, s.address, " +
                                 "d.name AS department_name, c.name AS course_name, h.name AS hostel_name, s.year " +
                                 "FROM Students s " +
                                 "LEFT JOIN Departments d ON s.department_id = d.department_id " +
                                 "LEFT JOIN Courses c ON s.course_id = c.course_id " +
                                 "LEFT JOIN Hostels h ON s.hostel_id = h.hostel_id " +
                                 "WHERE s.student_id = ?";
                  pstmt = con.prepareStatement(query);
                  pstmt.setString(1, studentId);
                  rs = pstmt.executeQuery();
                  if(rs.next()){
          %>
          <label>Student ID:</label>
          <input type="text" value="<%= rs.getString("student_id") %>" readonly>
          
          <label>Name:</label>
          <input type="text" value="<%= rs.getString("student_name") %>" readonly>
          
          <label>Email:</label>
          <input type="text" value="<%= rs.getString("email") %>" readonly>
          
          <label>Date of Birth:</label>
          <input type="text" value="<%= rs.getDate("dob") %>" readonly>
          
          <label>Phone:</label>
          <input type="text" value="<%= (rs.getString("phone") != null ? rs.getString("phone") : "N/A") %>" readonly>
          
          <label>Address:</label>
          <input type="text" value="<%= rs.getString("address") %>" readonly>
          
          <label>Department:</label>
          <input type="text" value="<%= rs.getString("department_name") %>" readonly>
          
          <label>Course:</label>
          <input type="text" value="<%= rs.getString("course_name") %>" readonly>
          
          <label>Hostel:</label>
          <input type="text" value="<%= (rs.getString("hostel_name") != null ? rs.getString("hostel_name") : "N/A") %>" readonly>
          
          <label>Year:</label>
          <input type="text" value="<%= rs.getString("year") %>" readonly>
          <%
                  } else {
                      out.println("<p style='color: red;'>No student found with the provided ID.</p>");
                  }
              } catch(Exception e) {
                  out.println("<p style='color: red;'>Error fetching data: " + e.getMessage() + "</p>");
              } finally {
                  if(rs != null) try { rs.close(); } catch(Exception e) {}
                  if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                  if(con != null) try { con.close(); } catch(Exception e) {}
              }
          %>
      </div>
    </div>
        <!-- Current Applications Section -->
        <div class="section">
            <h2>Track Current Application</h2>
            <table>
                <thead>
                    <tr>
                        <th>Application ID</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>12345</td>
                        <td>2025-01-10</td>
                        <td>2025-01-12</td>
                        <td>Pending</td>
                    </tr>
                    <tr>
                        <td>12346</td>
                        <td>2025-01-01</td>
                        <td>2025-01-03</td>
                        <td>Approved</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Previous Applications Section -->
        <div class="section">
            <h2>Record of Previous Applications</h2>
            <table>
                <thead>
                    <tr>
                        <th>Application ID</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                        <th>Remarks</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>12234</td>
                        <td>2024-12-10</td>
                        <td>2024-12-12</td>
                        <td>Approved</td>
                        <td>Enjoy your leave!</td>
                    </tr>
                    <tr>
                        <td>12235</td>
                        <td>2024-11-20</td>
                        <td>2024-11-22</td>
                        <td>Rejected</td>
                        <td>Insufficient reason</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 Leave Management System - Banasthali Vidyapeeth</p>
    </div>
</body>
</html>
