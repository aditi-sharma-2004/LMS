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

@WebServlet("/RemoveWardenServlet")
public class RemoveWardenServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain"); // ✅ Ensure plain text response

        // ✅ Retrieve Warden Email from request
        String wardenMail = request.getParameter("wardenMail");

        if (wardenMail == null || wardenMail.trim().isEmpty()) {
            response.getWriter().print("error:Warden email is required!");
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // ✅ Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

            // ✅ Check if warden exists before deleting
            String checkSQL = "SELECT COUNT(*) FROM wardens WHERE email = ?";
            pstmt = con.prepareStatement(checkSQL);
            pstmt.setString(1, wardenMail);
            var rs = pstmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count == 0) {
                response.getWriter().println("error:Warden not found!");
                return;
            }

            // ✅ Delete Warden using Email
            String deleteSQL = "DELETE FROM wardens WHERE email = ?";
            pstmt = con.prepareStatement(deleteSQL);
            pstmt.setString(1, wardenMail);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.getWriter().println("success:✔ Warden removed successfully!");
            } else {
                response.getWriter().println("error:Warden removal failed!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("error:Database error: " + e.getMessage());
        } finally {
            // ✅ Close resources properly
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
