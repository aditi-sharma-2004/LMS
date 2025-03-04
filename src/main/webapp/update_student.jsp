<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Student Dashboard - Leave Management System</title>
  <style>
    body { 
      font-family: Arial, sans-serif; 
      background-color: #f4f4f4; 
      margin: 0; 
      padding: 0; 
    }
    .navbar { 
      background-color: #333; 
      color: white; 
      padding: 15px 20px; 
      display: flex; 
      justify-content: space-between; 
      align-items: center; 
      height: 70px; 
    }
    .logo img { 
      width: 50px; 
      height: 50px; 
      border-radius: 50%; 
      margin-right: 10px; 
    }
    .nav-links a { 
      color: white; 
      margin: 0 15px; 
      text-decoration: none; 
      font-size: 16px; 
      transition: color 0.3s ease; 
    }
    .nav-links a:hover { 
      color: #f4b400; 
    }
    .content { 
      width: 60%; 
      margin: auto; 
      background: white; 
      padding: 20px; 
      border-radius: 10px; 
      box-shadow: 0px 0px 10px gray; 
    }
    .profile-container { 
      display: flex; 
      flex-direction: column; 
      align-items: center; 
    }
    .photo-container img { 
      width: 150px; 
      height: 150px; 
      border-radius: 50%; 
    }
    .update-btn { 
      background-color: green; 
      color: white; 
      padding: 10px; 
      border: none; 
      cursor: pointer; 
    }
    .details-container {
      width: 100%;
      display: flex;
      flex-direction: column;
    }
    .row {
      margin-bottom: 10px;
    }
    .row label {
      font-weight: bold;
      display: block;
      margin-bottom: 5px;
    }
  </style>
</head>
<body>

  <div class="navbar">
    <div class="logo">
      <img src="Logoos.jpg" alt="Logo">
    </div>
    <div class="nav-links">
      <a href="contact.jsp">Contact Us</a>
      <button type="submit" class="update-btn" form="student-form">Update</button>
      <a href="logout.jsp" class="logout">Logout</a>
    </div>
  </div>

  <div class="content">
    <div class="profile-container">

      <%
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String base64Image = "default-profile.jpg"; // Default image
        String studentID = request.getParameter("student_id");

        String departmentId = "";
        String courseId = "";
        String hostelId = "";

        if (studentID != null && !studentID.trim().isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

                // Fetch student details
                String query = "SELECT * FROM Students WHERE student_id = ?";
                pstmt = con.prepareStatement(query);
                pstmt.setString(1, studentID);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    byte[] imgData = rs.getBytes("image");
                    if (imgData != null && imgData.length > 0) {
                        base64Image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imgData);
                    }
                    departmentId = rs.getString("department_id");
                    courseId = rs.getString("course_id");
                    hostelId = rs.getString("hostel_id");
      %>

      <div class="photo-container">
        <img src="<%= base64Image %>" alt="Student Photo" id="student-photo">
      </div>

      <div class="details-container">
        <form id="student-form" action="UpdateStudentServlet" method="post" enctype="multipart/form-data">
          
          <!-- Student ID -->
          <div class="row">
            <label>Student ID:</label>
            <input type="text" name="student_id" value="<%= rs.getString("student_id") %>" readonly>
          </div>

          <!-- Name -->
          <div class="row">
            <label>Name:</label>
            <input type="text" name="name" value="<%= rs.getString("name") %>">
          </div>


          <!-- rno-->
          <div class="row">
            <label>Roll Number:</label>
            <input type="text" name="rno" value="<%= rs.getString("rno") %>">
          </div>

          <!-- Email -->
          <div class="row">
            <label>Email:</label>
            <input type="text" name="email" value="<%= rs.getString("email") %>">
          </div>

          <!-- Date of Birth -->
          <div class="row">
            <label>Date of Birth:</label>
            <input type="date" name="dob" value="<%= rs.getString("dob") %>">
          </div>

          <!-- Phone -->
          <div class="row">
            <label>Phone:</label>
            <input type="text" name="phone" value="<%= rs.getString("phone") %>">
          </div>

          <!-- Address -->
          <div class="row">
            <label>Address:</label>
            <input type="text" name="address" value="<%= rs.getString("address") %>">
          </div>

          <!-- Department -->
          <div class="row">
            <label>Department:</label>
            <select name="department_id">
              <%
                ResultSet deptRs = con.createStatement().executeQuery("SELECT * FROM Departments");
                while (deptRs.next()) {
                  String id = deptRs.getString("department_id");
                  String name = deptRs.getString("name");
              %>
                <option value="<%= id %>" <%= id.equals(departmentId) ? "selected" : "" %>><%= name %></option>
              <% } %>
            </select>
          </div>

          <!-- Course -->
          <div class="row">
            <label>Course:</label>
            <select name="course_id">
              <%
                ResultSet courseRs = con.createStatement().executeQuery("SELECT * FROM Courses");
                while (courseRs.next()) {
                  String id = courseRs.getString("course_id");
                  String name = courseRs.getString("name");
              %>
                <option value="<%= id %>" <%= id.equals(courseId) ? "selected" : "" %>><%= name %></option>
              <% } %>
            </select>
          </div>

          <!-- Hostel -->
          <div class="row">
            <label>Hostel:</label>
            <select name="hostel_id">
              <%
                ResultSet hostelRs = con.createStatement().executeQuery("SELECT * FROM Hostels");
                while (hostelRs.next()) {
                  String id = hostelRs.getString("hostel_id");
                  String name = hostelRs.getString("name");
              %>
                <option value="<%= id %>" <%= id.equals(hostelId) ? "selected" : "" %>><%= name %></option>
              <% } %>
            </select>
          </div>

          <!-- Upload Image -->
          <div class="row">
            <label>Upload New Image:</label>
            <input type="file" name="image" accept="image/*">
          </div>

        </form>
      </div>

      <% 
                } else {
                    out.println("<p style='color: red;'>No student found with this ID!</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>Error fetching data: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            }
        }
      %>

    </div>
  </div>
</body>
</html>
