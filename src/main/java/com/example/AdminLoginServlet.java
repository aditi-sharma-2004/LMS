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
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String adminId = request.getParameter("adminId");
        String inputPassword = request.getParameter("password");

        // Set content type and obtain writer
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Validate input
        if (adminId == null || adminId.trim().isEmpty() ||
            inputPassword == null || inputPassword.trim().isEmpty()) {
            out.println("<script>alert('Admin ID and Password cannot be empty'); window.location.href='admin.jsp';</script>");
            return;
        }

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC Driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DBConnection.getConnection();

            // Check credentials from the alogin table
            String sql = "SELECT password FROM alogin WHERE admin_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, adminId);
            rs = pst.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                if (storedPassword.equals(inputPassword)) {
                    // Credentials verified; retrieve admin details from the Admin table
                    String adminQuery = "SELECT * FROM admin WHERE admin_id = ?";
                    try (PreparedStatement pst2 = conn.prepareStatement(adminQuery)) {
                        pst2.setString(1, adminId);
                        try (ResultSet rs2 = pst2.executeQuery()) {
                            if (rs2.next()) {
                                // Create session and set attributes to be used in the dashboard
                                HttpSession session = request.getSession();
                                session.setAttribute("adminId", rs2.getString("admin_id"));
                                session.setAttribute("name", rs2.getString("name"));
                                session.setAttribute("email", rs2.getString("email"));
                                session.setAttribute("phone", rs2.getString("phone"));
                                session.setAttribute("image", rs2.getBlob("image"));
                                // Replace the complex authentication logic temporarily with this simple test

                                // Redirect to admin dashboard
                                System.out.println("About to redirect to adminDashboard.jsp");
response.sendRedirect("adminDashboard.jsp");
System.out.println("Redirect sent");
                            } else {
                                out.println("<script>alert('Admin details not found'); window.location.href='admin.jsp';</script>");
                            }
                        }
                    }
                } else {
                    out.println("<script>alert('Invalid Admin ID or Password'); window.location.href='admin.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Admin ID not found'); window.location.href='admin.jsp';</script>");
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            out.println("<script>alert('Something went wrong: " + e.getMessage() + "'); window.location.href='admin.jsp';</script>");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}

