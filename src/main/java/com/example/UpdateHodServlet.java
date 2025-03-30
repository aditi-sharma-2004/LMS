package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateHodServlet")
@MultipartConfig(maxFileSize = 16177215) // Allows large file uploads
public class UpdateHodServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Get form data (email is the unique identifier, so it should not change)
        String email = request.getParameter("email"); // HOD Email as unique identifier
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String departmentName = request.getParameter("department_name");

        Part filePart = request.getPart("image");
        InputStream inputStream = null;
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream(); // Read new image if provided
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

            // ✅ Step 1: Get `department_id` from `Departments` table based on department name
            String getDeptIdQuery = "SELECT department_id FROM Departments WHERE name=?";
            PreparedStatement deptStmt = con.prepareStatement(getDeptIdQuery);
            deptStmt.setString(1, departmentName);
            rs = deptStmt.executeQuery();
            String departmentId = null;

            if (rs.next()) {
                departmentId = rs.getString("department_id");
            }
            deptStmt.close();

            // ✅ Step 2: Construct SQL query for updating HOD details
            String updateSQL;
            if (inputStream != null) {
                // If a new image is provided
                updateSQL = "UPDATE hod SET name=?, phone=?, department_id=?, image=? WHERE email=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setBlob(4, inputStream);
                pstmt.setString(5, email);
            } else {
                // If no new image is provided
                updateSQL = "UPDATE hod SET name=?, phone=?, department_id=? WHERE email=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setString(4, email);
            }

            pstmt.setString(1, name);
            pstmt.setString(2, phone);
            pstmt.setString(3, departmentId);

            // ✅ Step 3: Execute update query
            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("dashboard.jsp?message=HOD details updated successfully!");
            } else {
                response.sendRedirect("error.jsp?error=HOD not found or no changes made!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            // ✅ Step 4: Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
                if (inputStream != null) inputStream.close();
            } catch (IOException | SQLException e) {
                e.printStackTrace();
        }}
    }
}
