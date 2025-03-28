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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/UploadGuardianServlet")
@MultipartConfig(maxFileSize = 16177215) // 16MB max file size
public class UploadGuardianServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        String studentId = (String) session.getAttribute("studentId");

        // Retrieving the Image (Guardian's Photo)
        InputStream imageStream = null;
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            imageStream = imagePart.getInputStream();
        }

        // Retrieving the Signature Image
        InputStream signatureStream = null;
        Part signaturePart = request.getPart("signature");
        if (signaturePart != null && signaturePart.getSize() > 0) {
            signatureStream = signaturePart.getInputStream();
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        // Generate unique guardian_id
        String guardianId = generateGuardianId();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DBConnection.getConnection();

            // Updated query to insert both image and signature
            String sql = "INSERT INTO Guardians (guardian_id, name, email, phone, address, Image, signature, student_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, guardianId);
            stmt.setString(2, name);
            stmt.setString(3, email);
            stmt.setString(4, phone);
            stmt.setString(5, address);

            if (imageStream != null) {
                stmt.setBlob(6, imageStream);
            } else {
                stmt.setNull(6, Types.BLOB);
            }

            if (signatureStream != null) {
                stmt.setBlob(7, signatureStream);
            } else {
                stmt.setNull(7, Types.BLOB);
            }

            stmt.setString(8, studentId);

            int row = stmt.executeUpdate();
            if (row == 0) {
                response.getWriter().println("Error: Could not insert guardian record.");
                return;
            }

            // Generate and insert guardian login credentials
            String randomPassword = generateRandomPassword(8);
            String insertLoginSQL = "INSERT INTO glogin (guardian_id, password) VALUES (?, ?)";
            int row2;
            try (PreparedStatement pstmt2 = conn.prepareStatement(insertLoginSQL)) {
                pstmt2.setString(1, guardianId);
                pstmt2.setString(2, randomPassword);
                row2 = pstmt2.executeUpdate();
            }

            if (row2 == 0) {
                response.getWriter().println("Error: Could not insert login record.");
                return;
            }

            // Send email with credentials
            String subject = "Your Guardian Account Details";
            String body = "Dear " + name + ",\n\n" +
                    "Your guardian account has been created successfully.\n" +
                    "Guardian ID: " + guardianId + "\n" +
                    "Password: " + randomPassword + "\n\n" +
                    "Regards,\nLeave Management System";
            sendEmail(email, subject, body);

            response.sendRedirect("guardianSuccess.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
            }
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
            }
        }
    }

    private String generateGuardianId() {
        Random rnd = new Random();
        int num = 100000 + rnd.nextInt(900000); // Generates a 6-digit number
        return "G" + num; // Example format: G123456
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
