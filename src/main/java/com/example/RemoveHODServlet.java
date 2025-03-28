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

@WebServlet("/RemoveHODServlet")
public class RemoveHODServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain"); // ✅ Ensure plain text response

        // ✅ Retrieve HOD Email from request
        String hodMail = request.getParameter("hodMail");

        if (hodMail == null || hodMail.trim().isEmpty()) {
            response.getWriter().print("error:HOD email is required!");
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // ✅ Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

            // ✅ Delete HOD using Email
            String deleteSQL = "DELETE FROM hod WHERE email = ?";
            pstmt = con.prepareStatement(deleteSQL);
            pstmt.setString(1, hodMail);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.getWriter().println("success:HOD Removed Successfully!");
            } else {
                response.getWriter().println("error:HOD Not Found!");
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
