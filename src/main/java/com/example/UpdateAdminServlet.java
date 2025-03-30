package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateAdminServlet")
@MultipartConfig(maxFileSize = 16177215) // Allows large file uploads (16MB max)
public class UpdateAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form data
        String email = request.getParameter("email"); // Email used as identifier (CANNOT BE EDITED)
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");

        Part filePart = request.getPart("image");
        InputStream inputStream = null;

        // Check if an image was uploaded
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // Load MySQL driver and establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "priyanshi", "2004@seth");

            String updateSQL;

            // If a new image is uploaded, update all fields including the image
            if (inputStream != null) {
                updateSQL = "UPDATE admin SET name=?, phone=?, image=? WHERE email=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setString(1, name);
                pstmt.setString(2, phone);
                pstmt.setBlob(3, inputStream);
                pstmt.setString(4, email);
            } else { 
                // If no new image is uploaded, update only text fields
                updateSQL = "UPDATE admin SET name=?, phone=? WHERE email=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setString(1, name);
                pstmt.setString(2, phone);
                pstmt.setString(3, email);
            }

            // Execute update query
            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("dashboard.jsp?message=Admin profile updated successfully!");
            } else {
                response.sendRedirect("error.jsp?error=Admin not found or no changes made!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<h3 style='color: red;'>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
                if (inputStream != null) inputStream.close();
            } catch (IOException | SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
