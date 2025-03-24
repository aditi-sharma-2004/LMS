package com.example;

// TrackLeaveServlet.java (Handles Leave Tracking using Jakarta EE)
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/TrackLeaveServlet")
public class TrackLeaveServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<Map<String, String>> leaveRecords = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT leave_id, reason, start_date, end_date, status, warden_status, hod_status, verification_status, gpo_status, final_status FROM LeaveRequests WHERE student_id = ?")) {
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> record = new HashMap<>();
                record.put("leave_id", rs.getString("leave_id"));
                record.put("reason", rs.getString("reason"));
                record.put("start_date", rs.getString("start_date"));
                record.put("end_date", rs.getString("end_date"));
                record.put("status", rs.getString("status"));
                record.put("warden_status", rs.getString("warden_status"));
                record.put("hod_status", rs.getString("hod_status"));
                record.put("verification_status", rs.getString("verification_status"));
                record.put("gpo_status", rs.getString("gpo_status"));
                record.put("final_status", rs.getString("final_status"));
                leaveRecords.add(record);
            }
        } catch (SQLException e) {
            e.getMessage();
        }
        
        request.setAttribute("leaveRecords", leaveRecords);
        request.getRequestDispatcher("track_leave.jsp").forward(request, response);
    }
}