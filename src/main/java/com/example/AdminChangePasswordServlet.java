package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminChangePasswordServlet")
public class AdminChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/lms";
    private static final String DB_USER = "lms";
    private static final String DB_PASSWORD = "lms";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String adminId = (String) session.getAttribute("adminId");

        if (adminId == null) {
            response.sendRedirect("admin.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("message", "All fields are required!");
            request.getRequestDispatcher("admin_change_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "New password and confirm password do not match!");
            request.getRequestDispatcher("admin_change_password.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Step 1: Verify the old password
            String checkPasswordSQL = "SELECT password FROM alogin WHERE admin_id = ?";
            pst = conn.prepareStatement(checkPasswordSQL);
            pst.setString(1, adminId);
            rs = pst.executeQuery();

            if (rs.next() && rs.getString("password").equals(oldPassword)) {
                rs.close();
                pst.close();

                // Step 2: Update the password
                String updateSQL = "UPDATE alogin SET password = ? WHERE admin_id = ?";
                pst = conn.prepareStatement(updateSQL);
                pst.setString(1, newPassword);
                pst.setString(2, adminId);

                int updatedRows = pst.executeUpdate();
                pst.close();

                if (updatedRows > 0) {
                    request.setAttribute("message", "Password changed successfully!");
                } else {
                    request.setAttribute("message", "Failed to update password!");
                }
            } else {
                request.setAttribute("message", "Old password is incorrect!");
            }
            
            request.getRequestDispatcher("admin_change_password.jsp").forward(request, response);
        } catch (ClassNotFoundException | SQLException e) {
            request.setAttribute("message", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("admin_change_password.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.getMessage();
            }
        }
    }
}
