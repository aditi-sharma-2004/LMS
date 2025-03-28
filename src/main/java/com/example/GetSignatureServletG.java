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

@WebServlet("/GetSignatureServletG")
public class GetSignatureServletG extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String guardianId = request.getParameter("guardian_id");

        if (guardianId == null || guardianId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing guardian_id parameter");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement("SELECT signature FROM Guardians WHERE guardian_id = ?")) {

            pstmt.setString(1, guardianId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Blob signatureBlob = rs.getBlob("signature");
                    if (signatureBlob != null) {
                        response.setContentType("image/png"); // Change format if needed
                        try (OutputStream out = response.getOutputStream()) {
                            out.write(signatureBlob.getBytes(1, (int) signatureBlob.length()));
                        }
                        return;
                    }
                }
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No guardian signature found");
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
