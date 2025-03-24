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

@WebServlet("/GuardianChangePasswordServlet")
public class GuardianChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/lms";
    private static final String DB_USER = "lms";
    private static final String DB_PASSWORD = "lms";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String guardianId = (String) session.getAttribute("guardianId");

        if (guardianId == null) {
            response.sendRedirect("guardian.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("message", "All fields are required!");
            request.getRequestDispatcher("guardian_change_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "New password and confirm password do not match!");
            request.getRequestDispatcher("guardian_change_password.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String checkPasswordSQL = "SELECT password FROM glogin WHERE guardian_id = ?";
            pst = conn.prepareStatement(checkPasswordSQL);
            pst.setString(1, guardianId);
            rs = pst.executeQuery();

            if (rs.next() && rs.getString("password").equals(oldPassword)) {
                String updateSQL = "UPDATE glogin SET password = ? WHERE guardian_id = ?";
                pst = conn.prepareStatement(updateSQL);
                pst.setString(1, newPassword);
                pst.setString(2, guardianId);

                if (pst.executeUpdate() > 0) {
                    response.setContentType("text/html");
                    response.getWriter().println("<script>alert('Password Changed Successfully'); window.location='guardianDashboard.jsp';</script>");
                } else {
                    request.setAttribute("message", "Failed to update password!");
                    request.getRequestDispatcher("guardian_change_password.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("message", "Old password is incorrect!");
                request.getRequestDispatcher("guardian_change_password.jsp").forward(request, response);
            }
        } catch (ClassNotFoundException | SQLException e) {
            request.setAttribute("message", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("guardian_change_password.jsp").forward(request, response);
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
