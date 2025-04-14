package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Random;

import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UploadGPOServlet")
public class UploadGPOServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String phone = request.getParameter("contact");
        String email = request.getParameter("email");

        Connection conn = null;
        PreparedStatement stmt = null;

        // Generate unique GPO ID
        String gpoId = generateGpoId();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DBConnection.getConnection();

            String sql = "INSERT INTO gpo (gpo_id, name, phone, email) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, gpoId);
            stmt.setString(2, name);
            stmt.setString(3, phone);
            stmt.setString(4, email);

            int row = stmt.executeUpdate();

            if (row == 0) {
                response.getWriter().println("Error: Could not insert GPO record.");
                return;
            }

            // Generate random password
            String randomPassword = generateRandomPassword(8);

            // Store GPO login credentials
            String insertLoginSQL = "INSERT INTO gpologin (gpo_id, password) VALUES (?, ?)";
            int row2;
            try (PreparedStatement pstmt2 = conn.prepareStatement(insertLoginSQL)) {
                pstmt2.setString(1, gpoId);
                pstmt2.setString(2, randomPassword);
                row2 = pstmt2.executeUpdate();
            }

            if (row2 == 0) {
                response.getWriter().println("Error: Could not insert login record.");
                return;
            }

            // Send email with credentials
            String subject = "Your GPO Account Details";
            String body = "Dear " + name + ",\n\n" +
                    "Your GPO account has been created successfully.\n" +
                    "GPO ID: " + gpoId + "\n" +
                    "Password: " + randomPassword + "\n\n" +
                    "Regards,\nLeave Management System";
            sendEmail(email, subject, body);

            response.setContentType("text/html");
            response.getWriter().println("<html><head><title>Registration Successful</title>");
            response.getWriter().println("<script>");
            response.getWriter().println("setTimeout(function() { window.history.back(); }, 3000);");
            response.getWriter().println("</script></head><body>");
            response.getWriter().println("<h2 style='text-align: center;'>GPO Registered Successfully!</h2>");
            response.getWriter().println("<p style='text-align: center;'>You will be redirected to the previous page in 3 seconds...</p>");
            response.getWriter().println("</body></html>");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
            }
        }
    }

    private String generateGpoId() {
        Random rnd = new Random();
        int num = 100000 + rnd.nextInt(900000); // Generates a 6-digit number
        return "GPO" + num; // Example: GPO123456
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
