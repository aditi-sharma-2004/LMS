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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/submit_leave")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)  // 5MB max file size
public class submit_leave extends HttpServlet {
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // 🛑 Get guardian ID from session (assuming guardian is logged in)
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("guardian_id") == null) {
        response.getWriter().println("Error: You must be logged in as a guardian.");
        return;
    }

    String loggedInGuardianId = session.getAttribute("guardian_id").toString();  // 🛑 Guardian ID from session
    String studentId = request.getParameter("student_id");

    // Trim and validate input
    if (studentId == null || studentId.trim().isEmpty()) {
        response.getWriter().println("Error: Student ID is required.");
        return;
    }

    studentId = studentId.trim();

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

            // 🚀 Fetch guardian_id from DB for the given student_id
            String guardianIdFromDB = null;
            String fetchGuardianQuery = "SELECT guardian_id FROM Guardians WHERE student_id = ?";
            try (PreparedStatement fetchGuardianStmt = conn.prepareStatement(fetchGuardianQuery)) {
                fetchGuardianStmt.setString(1, studentId);
                ResultSet rs = fetchGuardianStmt.executeQuery();
                if (rs.next()) {
                    guardianIdFromDB = rs.getString("guardian_id");
                }
            }

            // 🛑 Validation: Ensure the logged-in guardian is the correct one
            if (guardianIdFromDB == null || !guardianIdFromDB.equals(loggedInGuardianId)) {
                response.getWriter().println("Error: You can only submit leave requests for your own ward.");
                return;
            }

            // 📝 Insert leave request
            String sql = "INSERT INTO leaverequests (student_id, guardian_id, reason, start_date, end_date, leave_type, " +
                    "leaving_alone, companion_name, companion_relation, companion_address, companion_phone, leaving_address, signature) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, studentId);
                stmt.setString(2, loggedInGuardianId);  // 🔥 Using logged-in guardian ID
                stmt.setString(3, reason);
                stmt.setString(4, startDate);
                stmt.setString(5, endDate);
                stmt.setString(6, leaveType);
                stmt.setString(7, leavingAlone);
                stmt.setString(8, companionName);
                stmt.setString(9, companionRelation);
                stmt.setString(10, companionAddress);
                stmt.setString(11, companionPhone);
                stmt.setString(12, leavingAddress);

                // 🔍 Handling file upload
                if (signaturePart != null && signaturePart.getSize() > 0) {
                    InputStream inputStream = signaturePart.getInputStream();
                    stmt.setBlob(13, inputStream);
                } else {
                    stmt.setNull(13, java.sql.Types.BLOB);
                }

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
        e.printStackTrace();
    }
}

}
