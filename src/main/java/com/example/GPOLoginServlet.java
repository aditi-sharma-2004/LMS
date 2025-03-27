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

@WebServlet("/GPOLoginServlet")
public class GPOLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String gpoId = request.getParameter("gpoId");
        String inputPassword = request.getParameter("password");

        // Set content type and obtain writer
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Validate input
        if (gpoId == null || gpoId.trim().isEmpty() ||
            inputPassword == null || inputPassword.trim().isEmpty()) {
            out.println("<script>alert('GPO ID and Password cannot be empty'); window.location.href='gpo.jsp';</script>");
            return;
        }

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC Driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DBConnection.getConnection();

            // Check credentials from the gpologin table
            String sql = "SELECT password FROM gpologin WHERE gpo_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, gpoId);
            rs = pst.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                if (storedPassword.equals(inputPassword)) {
                    // Credentials verified; retrieve GPO details from the gpo table
                    String gpoQuery = "SELECT * FROM gpo WHERE gpo_id = ?";
                    try (PreparedStatement pst2 = conn.prepareStatement(gpoQuery)) {
                        pst2.setString(1, gpoId);
                        try (ResultSet rs2 = pst2.executeQuery()) {
                            if (rs2.next()) {
                                // Create session and set attributes to be used in the dashboard
                                HttpSession session = request.getSession();
                                session.setAttribute("hodId", rs2.getString("gpo_id"));
                                session.setAttribute("name", rs2.getString("name"));
                                session.setAttribute("email", rs2.getString("email"));
                                response.sendRedirect("pendingLeavesGpo.jsp");
                            } else {
                                out.println("<script>alert('GPO details not found'); window.location.href='gpo.jsp';</script>");
                            }
                        }
                    }
                } else {
                    out.println("<script>alert('Invalid GPO ID or Password'); window.location.href='gpo.jsp';</script>");
                }
            } else {
                out.println("<script>alert('GPO ID not found'); window.location.href='gpo.jsp';</script>");
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            out.println("<script>alert('Something went wrong: " + e.getMessage() + "'); window.location.href='gpo.jsp';</script>");
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
