<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %> <!-- Import JDBC classes -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        form {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        label {
            font-weight: bold;
        }
        input, select, textarea {
            width: 100%;
            padding: 8px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<h2>Student Registration Form</h2>

<form action="studentDatabase.jsp" method="post">
    <!-- Student Information -->
    <h3>Student Information</h3>
    <label for="name">Full Name:</label>
    <input type="text" id="name" name="name" placeholder="Enter your full name" required>

    <label for="rollno">Roll No.:</label>
    <input type="text" id="rollno" placeholder="Enter Roll Number" name="rollno" required>

    

    <label for="dob">Date of Birth:</label>
    <input type="date" id="dob" name="dob" required>


    <label for="smart_card_id">Smart Card ID:</label>
    <input type="text" id="smart_card_id" name="smart_card_id" placeholder="Enter your smart card ID" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" placeholder="Enter your email" required>

    <label for="phone">Phone Number:</label>
    <input type="tel" id="phone" name="phone" placeholder="Enter your phone number" maxlength="10" required>

    <label for="address">Address:</label>
    <textarea id="address" name="address" rows="3" placeholder="Enter your address" required></textarea>

    <label for="course">Course:</label>
    <select id="course" name="course" required>
        <option value="">Select Course</option>
        <%
            // Establish JDBC connection and populate courses
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                // Load MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Get connection to the database
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms","lms","lms");
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT course_id, course_name FROM Courses");

                // Populate options dynamically
                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("course_id") %>"><%= rs.getString("course_name") %></option>
        <%
                }
            } catch (Exception e) {
                out.println("<option disabled>Error loading courses</option>");
            } finally {
                // Clean up resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException se) {
                    out.println("Error closing resources: " + se.getMessage());
                }
            }
        %>
    </select>

    <label for="department">Department:</label>
    <select id="department" name="department" required>
        <option value="">Select Department</option>
        <%
            // Fetch departments
            try {
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms","lms");
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT department_id, department_name FROM Departments");

                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("department_id") %>"><%= rs.getString("department_name") %></option>
        <%
                }
            } catch (Exception e) {
                out.println("<option disabled>Error loading departments</option>");
            } finally {
                // Clean up resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException se) {
                    out.println("Error closing resources: " + se.getMessage());
                }
            }
        %>
    </select>

    <label for="year">Year of Study:</label>
    <select id="year" name="year" required>
        <option value="">Select Year</option>
        <option value="1st">1st Year</option>
        <option value="2nd">2nd Year</option>
        <option value="3rd">3rd Year</option>
        <option value="4th">4th Year</option>
    </select>

    <label for="hostel">Hostel Name:</label>
    <select id="hostel" name="hostel">
        <option value="">Select Hostel (optional)</option>
        <%
            // Fetch hostels
            try {
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms","lms");
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT hostel_id, hostel_name FROM Hostels");

                while (rs.next()) {
        %>
                    <option value="<%= rs.getInt("hostel_id") %>"><%= rs.getString("hostel_name") %></option>
        <%
                }
            } catch (Exception e) {
                out.println("<option disabled>Error loading hostels</option>");
            } finally {
                // Clean up resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException se) {
                    out.println("Error closing resources: " + se.getMessage());
                }
            }
        %>
    </select>

    <!-- Guardian Information -->
    <h3>Guardian Information</h3>
    <label for="guardian_name">Guardian Name:</label>
    <input type="text" id="guardian_name" name="guardian_name" placeholder="Enter guardian's name" required>

    <label for="guardian_phone">Guardian Phone Number:</label>
    <input type="tel" id="guardian_phone" name="guardian_phone" placeholder="Enter guardian's phone number" maxlength="10" required>

    <label for="guardian_email">Guardian Email:</label>
    <input type="email" id="guardian_email" name="guardian_email" placeholder="Enter guardian's email">

    <label for="guardian_address">Guardian Address:</label>
    <textarea id="guardian_address" name="guardian_address" rows="3" placeholder="Enter guardian's address" required></textarea>

    <label for="emergency_contact">Emergency Contact:</label>
    <input type="tel" id="emergency_contact" name="emergency_contact" placeholder="Enter emergency contact number" maxlength="10" required>

    <button type="submit">Register</button>
</form>

</body>
</html>
