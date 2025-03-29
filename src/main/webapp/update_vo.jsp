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
    gap: 20px;
    margin-top: 80px; /* Moves the container below the navbar */
}

.photo-container {
    flex-shrink: 0;
    align-self: flex-start;
    margin-top: 50px;
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
    color: #6a5acd;
}

.navbar ul li {
    list-style: none;
    display: inline-block;
    margin: 0 20px;
    position: relative;
}

.navbar ul li a {
    text-decoration: none;
    color: #fff;
}

.navbar ul li::after {
    content: '';
    height: 3px;
    width: 0;
    background: #6386a6;
    position: absolute;
    left: 0;
    bottom: -10px;
    transition: 0.5s;
}

.navbar ul li:hover::after {
    width: 100%;
}

.navbar .nav-button {
    background-color: #6a5acd;
    color: white;
    text-decoration: none;
    padding: 10px 15px;
    border-radius: 5px;
    font-size: 14px;
    transition: background-color 0.3s;
}

.navbar .nav-button:hover {
    background-color: #6a5acd;
}

.quick-links {
    position: relative;
}

.quick-links .dropdown {
    display: none;
    position: absolute;
    background-color: white;
    min-width: 150px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
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
    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
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
        
        <a href="resetPassword.jsp" >Change Password</a>
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
  <div class="container">
    <div class="photo-container">
        <img src="VOPhotoServlet?studentId=<%= rs.getString("student_id") %>" alt="Student Photo">
    </div>
  <div class="details-container">
    <form id="vo-form" action="UpdateVOServlet" method="post" enctype="multipart/form-data">
  

    <!-- Name -->
    <div class="details-grid">
    <div class="full-width">
      <label>Name:</label>
      <input type="text" name="name" value="<%= rs.getString("name") %>">
    </div>

    <!-- Email (Read-only) -->
    <div class="full-width">
      <label>Email:</label>
      <input type="text" name="email" value="<%= rs.getString("email") %>" readonly>
    </div>

    <!-- Phone -->
    <div class="full-width">
      <label>Phone:</label>
      <input type="text" name="phone" value="<%= rs.getString("phone") %>">
    </div>

    <!-- Department Name (Read-only) -->
    <div class="full-width">
      <label>Department Name:</label>
      <input type="text" value="<%= departmentName %>" readonly>
    </div>

    <!-- Upload Image -->
    <div class="full-width">
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
</div>
</body>
</html>
