<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Verification Officer</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }
    .container { width: 50%; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px gray; }
    .row { margin-bottom: 10px; }
    .row label { font-weight: bold; display: block; margin-bottom: 5px; }
    .row input, .row select { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 5px; }
    .update-btn { background-color: green; color: white; padding: 10px; border: none; cursor: pointer; width: 100%; }
  </style>
</head>
<body>

<div class="container">
  <h2>Update Verification Officer Details</h2>

  <%
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String base64Image = "default-profile.jpg";
    String email = request.getParameter("email");
    String departmentName = "Not Assigned";

    if (email != null && !email.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

            // Fetch VO details using email
            String query = "SELECT v.*, d.name AS department_name FROM vo v " +
            "LEFT JOIN Departments d ON v.department_id = d.department_id " +
            "WHERE v.email = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                byte[] imgData = rs.getBytes("image");
                if (imgData != null && imgData.length > 0) {
                    base64Image = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imgData);
                }
                departmentName = rs.getString("department_name") != null ? rs.getString("department_name") : "Not Assigned";
  %>

  <form action="UpdateVOServlet" method="post" enctype="multipart/form-data">
    
    <!-- Profile Picture -->
    <div class="row">
      <img src="<%= base64Image %>" alt="VO Photo" style="width: 150px; height: 150px; border-radius: 50%;">
    </div>

    <!-- Name -->
    <div class="row">
      <label>Name:</label>
      <input type="text" name="name" value="<%= rs.getString("name") %>">
    </div>

    <!-- Email (Read-only) -->
    <div class="row">
      <label>Email:</label>
      <input type="text" name="email" value="<%= rs.getString("email") %>" readonly>
    </div>

    <!-- Phone -->
    <div class="row">
      <label>Phone:</label>
      <input type="text" name="phone" value="<%= rs.getString("phone") %>">
    </div>

    <!-- Department Name (Read-only) -->
    <div class="row">
      <label>Department Name:</label>
      <input type="text" value="<%= departmentName %>" readonly>
    </div>

    <!-- Upload Image -->
    <div class="row">
      <label>Upload New Image:</label>
      <input type="file" name="image" accept="image/*">
    </div>

    <button type="submit" class="update-btn">Update</button>
  </form>

  <%
            } else {
                out.println("<p style='color: red;'>No Verification Officer found with this email!</p>");
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

</body>
</html>
