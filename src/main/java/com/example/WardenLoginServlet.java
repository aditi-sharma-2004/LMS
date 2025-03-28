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

@WebServlet("/WardenLoginServlet")
public class WardenLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String wardenId = request.getParameter("wardenId");
        String inputPassword = request.getParameter("password");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (wardenId == null || wardenId.trim().isEmpty() || inputPassword == null || inputPassword.trim().isEmpty()) {
            out.println("<script>alert('Warden ID and Password cannot be empty'); window.location.href='warden.jsp';</script>");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement("SELECT password FROM wlogin WHERE warden_id = ?")) {

            pst.setString(1, wardenId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");

                    if (storedPassword.equals(inputPassword)) { // Consider hashing for security
                        // Retrieve warden details
                        String wardenQuery = "SELECT warden_id, name, email, hostel_id FROM wardens WHERE warden_id = ?";
                        try (PreparedStatement pst2 = conn.prepareStatement(wardenQuery)) {
                            pst2.setString(1, wardenId);
                            try (ResultSet rs2 = pst2.executeQuery()) {
                                if (rs2.next()) {
                                    HttpSession session = request.getSession();
                                    session.setAttribute("wardenId", rs2.getString("warden_id"));
                                    session.setAttribute("name", rs2.getString("name"));
                                    session.setAttribute("email", rs2.getString("email"));
                                    session.setAttribute("hostel", rs2.getInt("hostel_id")); // Store as integer

                                    response.sendRedirect("wardenDashboard.jsp");
                                    return;
                                }
                            }
                        }
                        out.println("<script>alert('Warden details not found'); window.location.href='warden.jsp';</script>");
                    } else {
                        out.println("<script>alert('Invalid Warden ID or Password'); window.location.href='warden.jsp';</script>");
                    }
                } else {
                    out.println("<script>alert('Warden ID not found'); window.location.href='warden.jsp';</script>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('Something went wrong. Please try again later.'); window.location.href='warden.jsp';</script>");
        }
    }
}
