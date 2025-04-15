package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

// (No changes in the package and import section)

@WebServlet("/submit_leave")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)  // 5MB max file size
public class submit_leave extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentId = request.getParameter("student_id");
        String reason = request.getParameter("reason");
        String startDate = request.getParameter("start_date");
        String endDate = request.getParameter("end_date");
        String leaveType = request.getParameter("leave_type");
        String leavingAlone = request.getParameter("leaving_alone");
        String companionName = request.getParameter("companion_name");
        String companionRelation = request.getParameter("companion_relation");
        String companionAddress = request.getParameter("companion_address");
        String companionPhone = request.getParameter("companion_phone");
        String leavingAddress = request.getParameter("leaving_address");

        Part signaturePart = request.getPart("signature");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/LMS", "lms", "lms")) {

                // Check total leave days already taken
                String totalDaysQuery = "SELECT SUM(DATEDIFF(end_date, start_date) + 1) AS total_days FROM leaverequests WHERE student_id = ?";
                int totalTaken = 0;
                try (PreparedStatement totalDaysStmt = conn.prepareStatement(totalDaysQuery)) {
                    totalDaysStmt.setString(1, studentId);
                    ResultSet rs = totalDaysStmt.executeQuery();
                    if (rs.next()) {
                        totalTaken = rs.getInt("total_days"); // returns 0 if NULL
                    }
                }

                // Calculate new leave duration
                java.sql.Date sDate = java.sql.Date.valueOf(startDate);
                java.sql.Date eDate = java.sql.Date.valueOf(endDate);
                long millisDiff = eDate.getTime() - sDate.getTime();
                int numDaysRequested = (int)(millisDiff / (1000 * 60 * 60 * 24)) + 1;

                if (totalTaken + numDaysRequested > 10) {
                    response.getWriter().println("Error: Leave limit exceeded. Only " + (10 - totalTaken) + " day(s) remaining.");
                    return;
                }

                // Fetch guardian_id and address
                String guardianId;
                String guardianAddress;
                String fetchGuardianQuery = "SELECT guardian_id, address FROM guardians WHERE student_id = ?";
                try (PreparedStatement fetchGuardianStmt = conn.prepareStatement(fetchGuardianQuery)) {
                    fetchGuardianStmt.setString(1, studentId);
                    ResultSet rs = fetchGuardianStmt.executeQuery();
                    if (rs.next()) {
                        guardianId = rs.getString("guardian_id");
                        guardianAddress = rs.getString("address");
                    } else {
                        response.getWriter().println("Error: Student ID not found.");
                        return;
                    }
                }

                String sql = "INSERT INTO leaverequests (student_id, guardian_id, guardian_address, reason, start_date, end_date, leave_type, " +
                        "leaving_alone, companion_name, companion_relation, companion_address, companion_phone, leaving_address, signature, current_stage) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    String currentStage = "Warden";
                    stmt.setString(1, studentId);
                    stmt.setString(2, guardianId);
                    stmt.setString(3, guardianAddress);
                    stmt.setString(4, reason);
                    stmt.setString(5, startDate);
                    stmt.setString(6, endDate);
                    stmt.setString(7, leaveType);
                    stmt.setString(8, leavingAlone);
                    stmt.setString(9, companionName);
                    stmt.setString(10, companionRelation);
                    stmt.setString(11, companionAddress);
                    stmt.setString(12, companionPhone);
                    stmt.setString(13, leavingAddress);

                    if (signaturePart != null && signaturePart.getSize() > 0) {
                        InputStream inputStream = signaturePart.getInputStream();
                        stmt.setBlob(14, inputStream);
                    } else {
                        stmt.setNull(14, java.sql.Types.BLOB);
                    }

                    stmt.setString(15, currentStage);

                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                        response.sendRedirect("guardianDashboard.jsp");
                    } else {
                        response.getWriter().println("Error: Leave request submission failed.");
                    }
                }
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
