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

@WebServlet("/RemoveAdminServlet")
public class RemoveAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain"); // ✅ Ensure plain text response

        // ✅ Retrieve Admin Email from request
        String adminMail = request.getParameter("adminMail");

        if (adminMail == null || adminMail.trim().isEmpty()) {
            response.getWriter().print("error:Admin email is required!");
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // ✅ Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

            // ✅ Delete Admin using Email
            String deleteSQL = "DELETE FROM admin WHERE email = ?";
            pstmt = con.prepareStatement(deleteSQL);
            pstmt.setString(1, adminMail);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.getWriter().println("success:Admin Removed Successfully!");
            } else {
                response.getWriter().println("error:Admin Not Found!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("error:" + e.getMessage());
        } finally {
            try {
                if (pstmt != null)
                    pstmt.close();
                if (con != null)
                    con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
