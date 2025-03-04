package com.example;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/GuardianLoginServlet")
public class GuardianLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database connection settings
    private static final String DB_URL = "jdbc:mysql://localhost:3306/lms";
    private static final String DB_USER = "lms";
    private static final String DB_PASSWORD = "lms";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String guardianId = request.getParameter("guardianId");
        String inputPassword = request.getParameter("password");

        // Set content type and obtain writer
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Validate input
        if (guardianId == null || guardianId.trim().isEmpty() ||
            inputPassword == null || inputPassword.trim().isEmpty()) {
            out.println("<script>alert('Guardian ID and Password cannot be empty'); window.location.href='guardian.jsp';</script>");
            return;
        }

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC Driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Check credentials from the glogin table
            String sql = "SELECT password FROM glogin WHERE guardian_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, guardianId);
            rs = pst.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                if (storedPassword.equals(inputPassword)) {
                    // Credentials verified; retrieve guardian details from the Guardians table
                    String guardianQuery = "SELECT * FROM Guardians WHERE guardian_id = ?";
                    try (PreparedStatement pst2 = conn.prepareStatement(guardianQuery)) {
                        pst2.setString(1, guardianId);
                        try (ResultSet rs2 = pst2.executeQuery()) {
                            if (rs2.next()) {
                                // Create session and set attributes to be used in the dashboard
                                HttpSession session = request.getSession();
                                session.setAttribute("guardianId", rs2.getString("guardian_id"));
                                session.setAttribute("name", rs2.getString("name"));
                                session.setAttribute("email", rs2.getString("email"));
                                session.setAttribute("studentId", rs2.getString("student_id"));
                                
                                // Redirect to guardian dashboard
                                response.sendRedirect("guardianDashboard.jsp");
                            } else {
                                out.println("<script>alert('Guardian details not found'); window.location.href='guardian.jsp';</script>");
                            }
                        }
                    }
                } else {
                    out.println("<script>alert('Invalid Guardian ID or Password'); window.location.href='guardian.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Guardian ID not found'); window.location.href='guardian.jsp';</script>");
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.getMessage();
            out.println("<script>alert('Something went wrong: " + e.getMessage() + "'); window.location.href='guardian.jsp';</script>");
        } finally {
            // Close resources
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
