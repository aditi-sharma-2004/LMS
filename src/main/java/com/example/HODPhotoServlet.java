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

@WebServlet("/HODPhotoServlet")
public class HODPhotoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String hodId = request.getParameter("hodId");
        if(hodId == null || hodId.trim().isEmpty()){
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing hodId parameter");
            return;
        }
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "JDBC Driver not found");
            return;
        }
        
        try (Connection con = DBConnection.getConnection();
            PreparedStatement pstmt = con.prepareStatement("SELECT Image FROM hod WHERE hod_id = ?")) {
            
            pstmt.setString(1, hodId);
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
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found for HOD");
        } catch(SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
