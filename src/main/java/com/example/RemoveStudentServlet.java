package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RemoveStudentServlet")
public class RemoveStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain"); // Send plain text response

        // Retrieve Student ID from the form
        String studentId = request.getParameter("student_id");

        if (studentId == null || studentId.trim().isEmpty()) {
            response.getWriter().print("error:Student ID is required!");
            return;
        }


        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

            // SQL Query to Delete Student
            String deleteSQL = "DELETE FROM Students WHERE student_id = ?";
            pstmt = con.prepareStatement(deleteSQL);
            pstmt.setString(1, studentId);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.getWriter().println("success:Student removed successfully!");
            } else {
                response.getWriter().println("Error: Student not found!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        } finally {
            // Close resources properly
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
