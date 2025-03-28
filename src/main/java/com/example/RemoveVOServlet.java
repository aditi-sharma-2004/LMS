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

@WebServlet("/RemoveVOServlet")
public class RemoveVOServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain"); // ✅ Ensure plain text response

        // ✅ Retrieve VO Email from request
        String voMail = request.getParameter("voMail");

        if (voMail == null || voMail.trim().isEmpty()) {
            response.getWriter().print("error:VO email is required!");
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            // ✅ Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "lms", "lms");

            // ✅ Delete VO using Email
            String deleteSQL = "DELETE FROM vo WHERE email = ?";
            pstmt = con.prepareStatement(deleteSQL);
            pstmt.setString(1, voMail);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.getWriter().println("success:VO Removed Successfully!");
            } else {
                response.getWriter().println("error:VO Not Found!");
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
