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

@WebServlet("/StudentRegistration")
@MultipartConfig(maxFileSize = 16177215)  // Max photo size ~16MB
public class StudentRegistration extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");
        Part filePart = request.getPart("photo");

        InputStream inputStream = null; 
        if (filePart != null) {
            inputStream = filePart.getInputStream();
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        String sql = "INSERT INTO students (name, email, course, photo) VALUES (?, ?, ?, ?)";
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, course);
            if (inputStream != null) {
                stmt.setBlob(4, inputStream);
            }
            
            int row = stmt.executeUpdate();
            if (row > 0) {
                response.getWriter().println("<h3>Student Registered Successfully!</h3>");
            } else {
                response.getWriter().println("<h3>Registration Failed!</h3>");
            }
        } catch (IOException | SQLException ex) {
            ex.getMessage();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.getMessage();
            }
        }
    }
}
