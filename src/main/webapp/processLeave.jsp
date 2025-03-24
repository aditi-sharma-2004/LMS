<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Leave Application - Process</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f9;
        }
        h1 {
            color: #333;
        }
        .form-container {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: auto;
        }
        .form-container label {
            display: block;
            margin-bottom: 8px;
        }
        .form-container input {
            width: 100%;
            padding: 8px;
            margin-bottom: 16px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .form-container input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .form-container input[type="submit"]:hover {
            background-color: #45a049;
        }
        .details {
            margin-top: 20px;
        }
        .details p {
            font-size: 16px;
            line-height: 1.6;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>

    <h1>Student Leave Application</h1>

    <div class="form-container">
        <form action="processLeave.jsp" method="post">
            <label for="smartCardId">Enter Smart Card ID:</label>
            <input type="text" id="smartCardId" name="smartCardId" required>

            <input type="submit" name="fetchDetails" value="Fetch Details">
        </form>
    </div>

    <div class="details">
        <%
            String smartCardId = request.getParameter("smartCardId");
            String rollNumber = "";
            String name = "";
            String studentClass = "";
            String hostelName = "";
            String guardianName = "";

            if (smartCardId != null && request.getParameter("fetchDetails") != null) {
                try {
                    // Database connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String jdbcURL = "jdbc:mysql://localhost:3306/lms";
                    String dbUser = "lms";
                    String dbPassword = "lms"; // Fixed extra quotation mark
                    Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                    // Query to fetch student and guardian details
                    String query = "SELECT s.roll_NO, s.name, c.course_Name, h.hostel_Name, g.guardian_Name " +
                    "FROM student s " +
                    "JOIN guardians g ON s.smart_card_ID = g.smart_card_id " +
                    "JOIN hostels h ON s.hostel_Id = h.hostel_Id " +
                    "JOIN courses c ON s.course_Id = c.course_Id " +
                    "WHERE s.smart_Card_Id = ?";

                    PreparedStatement statement = connection.prepareStatement(query);
                    statement.setString(1, smartCardId);
                    ResultSet resultSet = statement.executeQuery();

                    if (resultSet.next()) {
                        rollNumber = resultSet.getString("roll_NO");
                        name = resultSet.getString("name");
                        studentClass = resultSet.getString("course_Name");
                        hostelName = resultSet.getString("hostel_Name");
                        guardianName = resultSet.getString("guardian_Name");
                    } else {
                        out.println("<p class='error'>No details found for the provided Smart Card ID.</p>");
                    }

                    connection.close();
                } catch (Exception e) {
                    out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
                }
            }

            if (!rollNumber.isEmpty()) {
                out.println("<h3>Student Details:</h3>");
                out.println("<p><strong>Roll Number:</strong> " + rollNumber + "</p>");
                out.println("<p><strong>Name:</strong> " + name + "</p>");
                out.println("<p><strong>Course:</strong> " + studentClass + "</p>");
                out.println("<p><strong>Hostel Name:</strong> " + hostelName + "</p>");
                out.println("<p><strong>Guardian Name:</strong> " + guardianName + "</p>");
            }
        %>
    </div>

</body>
</html>