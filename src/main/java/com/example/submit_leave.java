package com.example;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/submit_leave")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)  // 5MB max file size
public class submit_leave extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentId = request.getParameter("student_id");
        String guardianId = request.getParameter("guardian_id");
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
                String sql = "INSERT INTO leaverequests (student_id, guardian_id, reason, start_date, end_date, leave_type, " +
                        "leaving_alone, companion_name, companion_relation, companion_address, companion_phone, leaving_address, signature) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, studentId);
                    stmt.setString(2, guardianId);
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
                    
                    System.out.println("Student ID: " + studentId);
                    System.out.println("Guardian ID: " + guardianId);
                    System.out.println("Reason: " + reason);
                    System.out.println("Start Date: " + startDate);
                    System.out.println("End Date: " + endDate);
                    System.out.println("Leave Type: " + leaveType);
                    System.out.println("Leaving Alone: " + leavingAlone);
                    System.out.println("Companion Name: " + companionName);
                    System.out.println("Companion Relation: " + companionRelation);
                    System.out.println("Companion Address: " + companionAddress);
                    System.out.println("Companion Phone: " + companionPhone);
                    System.out.println("Leaving Address: " + leavingAddress);
                    
                    // Handling file upload
                    if (signaturePart != null && signaturePart.getSize() > 0) {
                        InputStream inputStream = signaturePart.getInputStream();
                        stmt.setBlob(13, inputStream);
                    } else {
                        stmt.setNull(13, java.sql.Types.BLOB);
                    }
                    
                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                        response.sendRedirect("guardianDashboard.jsp");  // Redirect to success page
                    } else {
                        response.getWriter().println("Error: Leave request submission failed.");
                    }
                }
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.getMessage();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}