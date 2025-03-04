package com.example;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GuardianPhotoServlet")
public class GuardianPhotoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database connection settings
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String guardianId = request.getParameter("guardianId");
        if(guardianId == null || guardianId.trim().isEmpty()){
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing guardianId parameter");
            return;
        }
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JDBC Driver not found");
            return;
        }
        
        try (Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement("SELECT Image FROM Guardians WHERE guardian_id = ?")) {
            
            pstmt.setString(1, guardianId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()){
                    Blob imageBlob = rs.getBlob("Image");
                    if(imageBlob != null){
                        response.setContentType("image/jpeg"); // adjust if needed
                        try(OutputStream out = response.getOutputStream()){
                            out.write(imageBlob.getBytes(1, (int) imageBlob.length()));
                        }
                        return;
                    }
                }
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found for guardian");
        } catch(SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
