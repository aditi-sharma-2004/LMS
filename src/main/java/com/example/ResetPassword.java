package com.example;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.UUID;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ResetPassword")
public class ResetPassword extends HttpServlet {

    private static final String SMTP_HOST = "smtp.gmail.com";  
    private static final String SMTP_USER = "aditisharma7782@gmail.com";
    private static final String SMTP_PASS = "oaal rxza rkru mvut";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");

        if (email == null || email.isEmpty()) {
            out.println("<p>Error: Email field is required.</p>");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DBConnection.getConnection()) {
                String[] tables = {"students", "guardians", "wardens", "vo", "hod", "admin"};
                boolean userExists = false;
                
                for (String table : tables) {
                    String sql = "SELECT * FROM " + table + " WHERE email = ?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, email);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            userExists = true;
                            break;
                        }
                    }
                }
                
                if (userExists) {
                    String token = UUID.randomUUID().toString();
                    
                    // Update reset token instead of inserting
                    String updateSql = "UPDATE password_reset SET token = ?, created_at = NOW() WHERE email = ?";
                    try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                        updatePs.setString(1, token);
                        updatePs.setString(2, email);
                        int rowsUpdated = updatePs.executeUpdate();
                        
                        // If no existing entry, insert a new row
                        if (rowsUpdated == 0) {
                            String insertSql = "INSERT INTO password_reset (email, token, created_at) VALUES (?, ?, NOW())";
                            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                                insertPs.setString(1, email);
                                insertPs.setString(2, token);
                                insertPs.executeUpdate();
                            }
                        }
                    }
                    
                    String resetLink = "http://localhost:8080/LMS-1/reset-password.jsp?token=" + token;
                    boolean emailSent = sendEmail(email, resetLink);
                    
                    if (emailSent) {
                        out.println("<p>Reset link has been sent to your email.</p>");
                    } else {
                        out.println("<p>Error sending reset email. Please try again.</p>");
                    }
                } else {
                    out.println("<p>Error: Email not registered.</p>");
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }

    private boolean sendEmail(String recipientEmail, String resetLink) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Password Reset Request");
            message.setText("Click the link below to reset your password:\n" + resetLink);

            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            return false;
        }
    }
}
