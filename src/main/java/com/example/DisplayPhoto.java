package com.example;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DisplayPhoto")
public class DisplayPhoto extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT photo FROM students WHERE id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                byte[] imgData = rs.getBytes("photo");
                response.setContentType("image/jpeg");
                try (OutputStream os = response.getOutputStream()) {
                    os.write(imgData);
                    os.flush();
                }
            }
        } catch (IOException | SQLException e) {
            e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } 
            catch (SQLException ex) { ex.getMessage(); }
        }
    }
}
