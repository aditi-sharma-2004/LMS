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

@WebServlet("/VORegistrationServlet")
@MultipartConfig(maxFileSize = 16177215)  // ~16MB for image upload
public class VORegistrationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form data
        String voName = request.getParameter("voName");
        String phone = request.getParameter("contact");
        String email = request.getParameter("email");
        String departmentId = request.getParameter("department"); // Fetch selected department_id

        // Get image file
        Part photoPart = request.getPart("image");
        InputStream photoStream = null;
        if (photoPart != null && photoPart.getSize() > 0) {
            photoStream = photoPart.getInputStream();
        }

        Connection con = null;
        PreparedStatement ps = null;

        // SQL query to insert data into `verification_officer` table
        String sql = "INSERT INTO vo (name, phone, email, Image, department_id) VALUES (?, ?, ?, ?, ?)";

        try {
            // Obtain database connection
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, voName);
            ps.setString(2, phone);
            ps.setString(3, email);

            // Set image as BLOB if available
            if (photoStream != null) {
                ps.setBlob(4, photoStream);
            } else {
                ps.setNull(4, java.sql.Types.BLOB);
            }

            ps.setString(5, departmentId);

            // Execute update
            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                // Show success message with button
                response.setContentType("text/html");
                response.getWriter().println("<html><head><title>Registration Successful</title></head><body>");
                response.getWriter().println("<h2 style='color: green; text-align: center;'>VO Registered Successfully!</h2>");
                response.getWriter().println("<div style='text-align: center;'><a href='adminReplace.jsp'><button style='padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;'>Go to Admin Page</button></a></div>");
                response.getWriter().println("</body></html>");
            } else {
                response.getWriter().println("<h3>Error: Verification Officer registration failed.</h3>");
            }
        } catch (SQLException | IOException e) {
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.getMessage();
            }
        }
    }
}

