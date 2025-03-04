package com.example;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");

        if (token == null || token.isEmpty()) {
            out.println("<p>Error: Invalid request. Token is missing.</p>");
            return;
        }

        if (newPassword == null || newPassword.isEmpty()) {
            out.println("<p>Error: Password is required.</p>");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DBConnection.getConnection()) {
                
                // Step 1: Get the email using the reset token
                String email = null;
                String getEmailSQL = "SELECT email FROM password_reset WHERE token = ?";
                try (PreparedStatement ps = con.prepareStatement(getEmailSQL)) {
                    ps.setString(1, token);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        email = rs.getString("email");
                    }
                }

                if (email == null) {
                    out.println("<p>Error: Invalid or expired token.</p>");
                    return;
                }

                // Step 2: Find ID where email exists
                String[] userTables = {"students", "guardians", "wardens", "vo", "hod", "admin"};
                String[] loginTables = {"slogin", "glogin", "wlogin", "vologin", "hodlogin", "alogin"};
                String[] loginPages = {"student.jsp", "guardian.jsp", "warden.jsp", "vo.jsp", "hod.jsp", "admin.jsp"};
                String[] idColumns = {"student_id", "guardian_id", "warden_id", "vo_id", "hod_id", "admin_id"};

                boolean updated = false;
                String redirectPage = "login.jsp"; // Default fallback login page

                for (int i = 0; i < userTables.length; i++) {
                    String userTable = userTables[i];
                    String loginTable = loginTables[i];

                    String getIdSQL = "SELECT " + idColumns[i] + " FROM " + userTable + " WHERE email = ?";
                    try (PreparedStatement getIdPs = con.prepareStatement(getIdSQL)) {
                        getIdPs.setString(1, email);
                        ResultSet rs = getIdPs.executeQuery();

                        if (rs.next()) { // If email exists in this table
                            String userId = rs.getString(idColumns[i]); // Use getString()

                            // Step 3: Update password in corresponding login table
                            String updateSQL = "UPDATE " + loginTable + " SET password = ? WHERE " + idColumns[i] + " = ?";
                            try (PreparedStatement updatePs = con.prepareStatement(updateSQL)) {
                                updatePs.setString(1, newPassword);
                                updatePs.setString(2, userId);
                                updatePs.executeUpdate();
                                updated = true;
                                redirectPage = loginPages[i]; // Set the correct login page
                                break; // Stop after updating
                            }
                        }
                    }
                }

                if (updated) {
                    // Step 4: Remove token from password_reset table after successful update
                    String deleteTokenSQL = "DELETE FROM password_reset WHERE email = ?";
                    try (PreparedStatement deletePs = con.prepareStatement(deleteTokenSQL)) {
                        deletePs.setString(1, email);
                        deletePs.executeUpdate();
                    }

                    // Redirect user to the respective login page
                    response.sendRedirect(redirectPage);
                } else {
                    out.println("<p>Error: Unable to update password. Email not found.</p>");
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }
}
