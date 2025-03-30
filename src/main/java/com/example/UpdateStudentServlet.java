package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateStudentServlet")
@MultipartConfig(maxFileSize = 16177215) // Handle large file uploads
public class UpdateStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form data
        String studentId = request.getParameter("student_id");
        String name = request.getParameter("name");
        String rollNumber = request.getParameter("rno");
        String email = request.getParameter("email");
        String dob = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String departmentId = request.getParameter("department_id");
        String courseId = request.getParameter("course_id");
        String hostelId = request.getParameter("hostel_id");

        Part filePart = request.getPart("image");
        InputStream inputStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        String updateSQL;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DBConnection.getConnection();
            if (inputStream != null) {
                updateSQL = "UPDATE Students SET name=?, rno=?, email=?, dob=?, phone=?, address=?, department_id=?, course_id=?, hostel_id=?, image=? WHERE student_id=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setBlob(10, inputStream);
                pstmt.setString(11, studentId);
            } else {
                updateSQL = "UPDATE Students SET name=?, rno=?, email=?, dob=?, phone=?, address=?, department_id=?, course_id=?, hostel_id=? WHERE student_id=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setString(10, studentId);
            }

            pstmt.setString(1, name);
            pstmt.setString(2, rollNumber);
            pstmt.setString(3, email);
            pstmt.setString(4, dob);
            pstmt.setString(5, phone);
            pstmt.setString(6, address);
            pstmt.setString(7, departmentId);
            pstmt.setString(8, courseId);
            pstmt.setString(9, hostelId);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.getWriter().println("<script>"
    + "alert('Student updated successfully!');"
    + "window.history.back(-2);"
    + "</script>");

            } else {
                response.sendRedirect("error.jsp?error=Student not found or no changes made!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.getMessage();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
                if (inputStream != null) inputStream.close();
            } catch (IOException | SQLException e) {
                e.getMessage();
            }
        }
    }
}

