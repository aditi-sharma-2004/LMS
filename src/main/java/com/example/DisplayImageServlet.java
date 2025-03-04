package com.example;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/DisplayImageServlet")
public class DisplayImageServlet extends HttpServlet {
        @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("id"));
try {
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs ;

        
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DBConnection.getConnection();
            String sql = "SELECT photo FROM Students WHERE student_id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, studentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                byte[] imgData = rs.getBytes("photo");
                response.setContentType("image/jpeg");
                OutputStream os = response.getOutputStream();
                os.write(imgData);
                os.flush();
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.getMessage();
        }
    }
}
