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

@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String studentId = request.getParameter("studentId");
        String inputPassword = request.getParameter("password");

        // Set content type and obtain writer
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Validate input
        if (studentId == null || studentId.trim().isEmpty() ||
            inputPassword == null || inputPassword.trim().isEmpty()) {
            out.println("<script>alert('Student ID and Password cannot be empty'); window.location.href='student.jsp';</script>");
            return;
        }

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load MySQL JDBC Driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DBConnection.getConnection();

            // Check credentials from the slogin table
            String sql = "SELECT password FROM slogin WHERE student_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, studentId);
            rs = pst.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                if (storedPassword.equals(inputPassword)) {
                    // Credentials verified; retrieve student details from the Students table
                    String studentQuery = "SELECT * FROM Students WHERE student_id = ?";
                    try (PreparedStatement pst2 = conn.prepareStatement(studentQuery)) {
                        pst2.setString(1, studentId);
                        try (ResultSet rs2 = pst2.executeQuery()) {
                            if (rs2.next()) {
                                // Create session and set attributes to be used in the dashboard
                                HttpSession session = request.getSession();
                                session.setAttribute("studentId", rs2.getString("student_id"));
                                session.setAttribute("name", rs2.getString("name"));
                                session.setAttribute("email", rs2.getString("email"));
                                session.setAttribute("course", rs2.getString("course_id")); // assuming course_id is used as course info
                                
                                // Redirect to student dashboard
                                response.sendRedirect("studentDashboard.jsp");
                            } else {
                                out.println("<script>alert('Student details not found'); window.location.href='student.jsp';</script>");
                            }
                        }
                    }
                } else {
                    out.println("<script>alert('Invalid Student ID or Password'); window.location.href='student.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Student ID not found'); window.location.href='student.jsp';</script>");
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.getMessage();
            out.println("<script>alert('Something went wrong: " + e.getMessage() + "'); window.location.href='student.jsp';</script>");
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
