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

@WebServlet("/UpdateWardenServlet")
@MultipartConfig(maxFileSize = 16177215) // Handle large file uploads
public class UpdateWardenServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Retrieve form data
        String email = request.getParameter("email"); // Email used as identifier
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");

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
                updateSQL = "UPDATE Wardens SET name=?, phone=?, image=? WHERE email=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setBlob(3, inputStream);
                pstmt.setString(4, email);
            } else {
                updateSQL = "UPDATE Wardens SET name=?, phone=? WHERE email=?";
                pstmt = con.prepareStatement(updateSQL);
                pstmt.setString(3, email);
            }

            pstmt.setString(1, name);
            pstmt.setString(2, phone);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("adminDashboard.jsp?message=Warden updated successfully!");
            } else {
                response.sendRedirect("error.jsp?error=Warden not found or no changes made!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.getMessage();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (pstmt != null)
                    pstmt.close();
                if (con != null)
                    con.close();
                if (inputStream != null)
                    inputStream.close();
            } catch (IOException | SQLException e) {
                e.getMessage();
            }
        }
    }
}
