package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    // Login tables for all roles
    private static final String[] TABLES = { "slogin", "glogin", "wlogin", "hodlogin", "vologin", "alogin" };

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");

        if (token == null || newPassword == null || newPassword.trim().isEmpty()) {
            response.getWriter().println("Invalid request.");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            for (String table : TABLES) {
                String userId = getUserIdByToken(conn, table, token);
                if (userId != null) {
                    if (updatePassword(conn, table, userId, newPassword)) {
                        response.getWriter().println("Password reset successfully.");
                    } else {
                        response.getWriter().println("Error updating password.");
                    }
                    return;
                }
            }
            response.getWriter().println("Invalid or expired token.");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private String getUserIdByToken(Connection conn, String table, String token) throws SQLException {
        String query = "SELECT * FROM " + table + " WHERE reset_token = ? AND token_expiry > NOW()";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, token);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1); // Primary key is always in the first column
            }
        }
        return null;
    }

    private boolean updatePassword(Connection conn, String table, String userId, String newPassword) throws SQLException {
        // Correctly determine the primary key column name
        String primaryKeyColumn = "";
        
        switch (table) {
            case "slogin": primaryKeyColumn = "student_id"; break;
            case "glogin": primaryKeyColumn = "guardian_id"; break;
            case "wlogin": primaryKeyColumn = "warden_id"; break;
            case "hodlogin": primaryKeyColumn = "hod_id"; break;
            case "vologin": primaryKeyColumn = "vo_id"; break;
            case "alogin": primaryKeyColumn = "admin_id"; break;
            default: throw new SQLException("Invalid table name: " + table);
        }
    
        String query = "UPDATE " + table + " SET password = ?, reset_token = NULL, token_expiry = NULL WHERE " + primaryKeyColumn + " = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, newPassword);
            pstmt.setString(2, userId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    
}

