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

@WebServlet("/HODLoginServlet")
public class HODLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String hodId = request.getParameter("hodId");
        String inputPassword = request.getParameter("password");

        // Set content type
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Validate input fields
        if (hodId == null || hodId.trim().isEmpty() || inputPassword == null || inputPassword.trim().isEmpty()) {
            out.println("<script>alert('HOD ID and Password cannot be empty'); window.location.href='hod.jsp';</script>");
            return;
        }

        // Database connection and prepared statements
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement("SELECT password FROM hodlogin WHERE hod_id = ?")) {

            pst.setString(1, hodId);
            try (ResultSet rs = pst.executeQuery()) {

                if (rs.next()) {
                    String storedPassword = rs.getString("password");

                    // Secure password comparison
                    if (storedPassword != null && storedPassword.equals(inputPassword)) {
                        // Credentials verified; retrieve HOD details
                        String hodQuery = "SELECT * FROM hod WHERE hod_id = ?";
                        try (PreparedStatement pst2 = conn.prepareStatement(hodQuery)) {
                            pst2.setString(1, hodId);
                            try (ResultSet rs2 = pst2.executeQuery()) {
                                if (rs2.next()) {
                                    // Create session and set attributes
                                    HttpSession session = request.getSession();
                                    session.setAttribute("hodId", rs2.getString("hod_id"));
                                    session.setAttribute("name", rs2.getString("name"));
                                    session.setAttribute("email", rs2.getString("email"));
                                    session.setAttribute("hodDepartmentId", rs2.getString("department_id"));

                                    // Redirect to dashboard
                                    response.sendRedirect("hodDashboard.jsp");
                                } else {
                                    out.println("<script>alert('HOD details not found'); window.location.href='hod.jsp';</script>");
                                }
                            }
                        }
                    } else {
                        out.println("<script>alert('Invalid HOD ID or Password'); window.location.href='hod.jsp';</script>");
                    }
                } else {
                    out.println("<script>alert('HOD ID not found'); window.location.href='hod.jsp';</script>");
                }
            }
        } catch (IOException | SQLException e) {
            e.printStackTrace(); // Log error for debugging
            out.println("<script>alert('Something went wrong. Please try again later.'); window.location.href='hod.jsp';</script>");
        }
    }
}
