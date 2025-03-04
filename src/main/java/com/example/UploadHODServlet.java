package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Properties;
import java.util.Random;

import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UploadHodServlet")
@MultipartConfig(maxFileSize = 16177215) // 16MB max file size
public class UploadHODServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String phone = request.getParameter("contact");
        String email = request.getParameter("email");
        String departmentId = request.getParameter("department_id"); // Fetch selected department_id

        InputStream inputStream = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        // Generate unique HOD ID
        String hodId = generateHodId();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DBConnection.getConnection();

            String sql = "INSERT INTO hod (hod_id, name, email, phone, Image, department_id) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, hodId);
            stmt.setString(2, name);
            stmt.setString(3, email);
            stmt.setString(4, phone);
            if (inputStream != null) {
                stmt.setBlob(5, inputStream);
            } else {
                stmt.setNull(5, Types.BLOB);
            }
            stmt.setString(6, departmentId);

            int row = stmt.executeUpdate();
            
            if (row == 0) {
                response.getWriter().println("Error: Could not insert HOD record.");
                return;
            }

            // Generate random password
            String randomPassword = generateRandomPassword(8);

            // Store HOD login credentials
            String insertLoginSQL = "INSERT INTO hodlogin (hod_id, password) VALUES (?, ?)";
            int row2;
            try (PreparedStatement pstmt2 = conn.prepareStatement(insertLoginSQL)) {
                pstmt2.setString(1, hodId);
                pstmt2.setString(2, randomPassword);
                row2 = pstmt2.executeUpdate();
            }

            if (row2 == 0) {
                response.getWriter().println("Error: Could not insert login record.");
                return;
            }
            
            // Send email with credentials
            String subject = "Your HOD Account Details";
            String body = "Dear " + name + ",\n\n" +
                        "Your HOD account has been created successfully.\n" +
                        "HOD ID: " + hodId + "\n" +
                        "Password: " + randomPassword + "\n\n" +
                        "Regards,\nLeave Management System";
            sendEmail(email, subject, body);

            response.setContentType("text/html");
            response.getWriter().println("<html><head><title>Registration Successful</title></head><body>");
            response.getWriter().println("<h2 style='color: green; text-align: center;'>HOD Registered Successfully!</h2>");
            response.getWriter().println("<div style='text-align: center;'><a href='adminDashboard.jsp'><button style='padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;'>Go to Admin Page</button></a></div>");
            response.getWriter().println("</body></html>");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    private String generateHodId() {
        Random rnd = new Random();
        int num = 100000 + rnd.nextInt(900000); // Generates a 6-digit number
        return "H" + num; // Example format: H123456
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }

    private void sendEmail(String to, String subject, String body) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        final String from = "nupurk930@gmail.com";
        final String password = "ahgc gdrj mgla uezt";

        Session session = Session.getInstance(props,
                new jakarta.mail.Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setText(body);
        Transport.send(message);
        System.out.println("Email sent successfully to: " + to);
    }
}
