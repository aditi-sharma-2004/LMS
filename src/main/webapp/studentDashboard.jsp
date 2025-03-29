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
    background-image: url('img.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed; /* Keeps the background fixed */
    margin: 0;
    padding: 0;
    overflow-x: hidden; /* Prevent horizontal scroll */
}
  
    /* Top Navigation Bar */
    .navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #333;
    color: white;
    padding: 3px 8px;
    position: fixed; /* Fix the navbar */
    left: 0;
    top: 0;
    width: 100%; /* Make sure it stretches fully */
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
    color: white;
    text-decoration: none;
    padding: 10px 15px;
    border-radius: 5px;
    font-size: 14px;
    transition: background-color 0.3s;
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

    /* Main Content */
    .content {
    margin-top: 60px; /* Push content below navbar */
    padding: 20px;
    max-width: 1200px;
    margin-left: auto;
    margin-right: auto;
    box-sizing: border-box;
}
    
    /* Student Details Section */
    .details-container {
    background-color: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    display: flex;
    align-items: flex-start;
    gap: 30px;
    flex-wrap: wrap; /* Ensures responsiveness */
}
    
    /* Photo Styling */
    .photo-container {
      flex-shrink: 0;
    }
    
    .photo-container img {
      max-width: 200px;
      border-radius: 10px;
    }
    
    /* Details Grid Styling */
    .details-grid {
      display: grid;
      grid-template-columns: 1fr 2fr;
      gap: 10px 20px;
    }
    
    .details-grid label {
      font-weight: bold;
      color: #555;
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
      border-color: #4CAF50;
      outline: none;
      background-color: #fff;
    }
    .section {
    background-color: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    margin-top: 20px;
}
      .section h2 {
        margin-bottom: 20px;
        color: #333;
        border-bottom: 2px solid #4CAF50;
        padding-bottom: 10px;
      }
      
      table {
        width: 100%;
        border-collapse: collapse;
      }
      
      table th, table td {
        border: 1px solid #ddd;
        padding: 12px;
        text-align: left;
      }
      
      table th {
        background-color: #f2f2f2;
        color: #333;
        font-weight: bold;
      }
      
      .status-pending {
        color: #FF9800;
        font-weight: bold;
      }
      
      .status-approved {
        color: #4CAF50;
        font-weight: bold;
      }
      
      .status-rejected {
        color: #F44336;
        font-weight: bold;
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
            
            <a href="student_change_password.jsp" >Change Password</a>
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

  <!-- Main Content -->
  <div class="content">
    <!-- Student Details Section -->
    <div class="details-container">
      <%
          // Use the implicit session object. Ensure that your login servlet sets "studentId"
          String studentId = (String) session.getAttribute("studentId");
          if(studentId == null) {
              response.sendRedirect("login.jsp");
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
        <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Student Dashboard - Leave Management System</title>
          <style>
            /* Previous styles remain the same */
            .section {
              background-color: white;
              padding: 30px;
              border-radius: 10px;
              box-shadow: 0 4px 8px rgba(0,0,0,0.1);
              margin-top: 20px;
            }
            
            .section h2 {
              margin-bottom: 20px;
              color: #333;
              border-bottom: 2px solid #4CAF50;
              padding-bottom: 10px;
            }
            
            table {
              width: 100%;
              border-collapse: collapse;
            }
            
            table th, table td {
              border: 1px solid #ddd;
              padding: 12px;
              text-align: left;
            }
            
            table th {
              background-color: #f2f2f2;
              color: #333;
              font-weight: bold;
            }
            
            .status-pending {
              color: #FF9800;
              font-weight: bold;
            }
            
            .status-approved {
              color: #4CAF50;
              font-weight: bold;
            }
            
            .status-rejected {
              color: #F44336;
              font-weight: bold;
            }
          </style>
        </head>
        <body>
          <!-- Previous navbar and student details sections remain the same -->
    <!-- Current Applications Section -->
    <div class="section">
        <h2>Track Current Applications</h2>
        <table>
          <thead>
            <tr>
              <th>Application ID</th>
              <th>Leave Type</th>
              <th>Start Date</th>
              <th>End Date</th>
              <th>Days</th>
              <th>Current Stage</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <%
              // Database connection and current applications retrieval
              Connection currentCon = null;
              PreparedStatement currentPstmt = null;
              ResultSet currentRs = null;
              
              try {
                // Reuse the student_id from the previous section
                Class.forName("com.mysql.cj.jdbc.Driver");
                currentCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");
                
                String currentQuery = "SELECT leave_id, leave_type, start_date, end_date, num_days, " +
                               "current_stage, final_status " +
                               "FROM LeaveRequests " +
                               "WHERE student_id = ? AND (final_status = 'Pending' OR final_status = 'In Progress')";
                
                currentPstmt = currentCon.prepareStatement(currentQuery);
                currentPstmt.setString(1, studentId);
                currentRs = currentPstmt.executeQuery();
                
                boolean hasCurrentApplications = false;
                while (currentRs.next()) {
                  hasCurrentApplications = true;
                  String leaveId = currentRs.getString("leave_id");
                  String leaveType = currentRs.getString("leave_type");
                  Date startDate = currentRs.getDate("start_date");
                  Date endDate = currentRs.getDate("end_date");
                  int numDays = currentRs.getInt("num_days");
                  String currentStage = currentRs.getString("current_stage");
                  String verificationStatus = currentRs.getString("final_status");
            %>
            <tr>
              <td><%= leaveId %></td>
              <td><%= leaveType %></td>
              <td><%= startDate %></td>
              <td><%= endDate %></td>
              <td><%= numDays %></td>
              <td><%= currentStage %></td>
              <td class="<%= 
                verificationStatus.equals("Pending") ? "status-pending" : 
                verificationStatus.equals("Accepted") ? "status-approved" : 
                "status-rejected" 
              %>">
                <%= verificationStatus %>
              </td>
            </tr>
            <% 
                }
                
                if (!hasCurrentApplications) {
            %>
            <tr>
              <td colspan="7" style="text-align: center;">No current leave applications</td>
            </tr>
            <% 
                }
              } catch(Exception e) {
                out.println("<tr><td colspan='7' style='color: red;'>Error fetching current applications: " + e.getMessage() + "</td></tr>");
              } finally {
                if(currentRs != null) try { currentRs.close(); } catch(Exception e) {}
                if(currentPstmt != null) try { currentPstmt.close(); } catch(Exception e) {}
                if(currentCon != null) try { currentCon.close(); } catch(Exception e) {}
              }
            %>
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
              <th>Leave Type</th>
              <th>Start Date</th>
              <th>End Date</th>
              <th>Days</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <%
            // Database connection and previous applications retrieval
            Connection prevCon = null;
            PreparedStatement prevPstmt = null;
            ResultSet prevRs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                prevCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");
                
                String prevQuery = "SELECT leave_id, leave_type, start_date, end_date, num_days, " +
                                "final_status " +
                                "FROM LeaveRequests " +
                                "WHERE student_id = ? AND (final_status = 'Accepted' OR final_status = 'Rejected')";
                
                prevPstmt = prevCon.prepareStatement(prevQuery);
                prevPstmt.setString(1, studentId);
                prevRs = prevPstmt.executeQuery();
                
                boolean hasPreviousApplications = false;
                while (prevRs.next()) {
                    hasPreviousApplications = true;
                    String leaveId = prevRs.getString("leave_id");
                    String leaveType = prevRs.getString("leave_type");
                    Date startDate = prevRs.getDate("start_date");
                    Date endDate = prevRs.getDate("end_date");
                    int numDays = prevRs.getInt("num_days");
                    String verificationStatus = prevRs.getString("final_status");
        %>
                    <tr>
                        <td><%= leaveId %></td>
                        <td><%= leaveType %></td>
                        <td><%= startDate %></td>
                        <td><%= endDate %></td>
                        <td><%= numDays %></td>
                        <td class="<%=
                            verificationStatus.equals("Pending") ? "status-pending" :
                            verificationStatus.equals("Accepted") ? "status-approved" :
                            "status-rejected"
                        %>">
                            <%= verificationStatus %>
                        </td>
                    </tr>
        <%
                }
                
                if (!hasPreviousApplications) {
        %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No previous leave applications</td>
                    </tr>
        <%
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='6' style='color: red;'>Error fetching previous applications: " + e.getMessage() + "</td></tr>");
            } finally {
                if(prevRs != null) try { prevRs.close(); } catch(Exception e) {}
                if(prevPstmt != null) try { prevPstmt.close(); } catch(Exception e) {}
                if(prevCon != null) try { prevCon.close(); } catch(Exception e) {}
            }
        %>
          </tbody>
        </table>
      </div>
    </div>

  </body>
  </html>