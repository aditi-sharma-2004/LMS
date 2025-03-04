package com.example;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.Properties;
import java.util.Random;

import jakarta.mail.Authenticator;
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

@WebServlet("/GuardianRegistrationServlet")
@MultipartConfig(maxFileSize = 16177215) // ~16MB
public class GuardianRegistrationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String guardianName = request.getParameter("guardian_name");
        String guardianPhone = request.getParameter("guardian_phone");
        String guardianEmail = request.getParameter("guardian_email");
        String guardianRelation = request.getParameter("guardian_relation");
        String guardianAddress = request.getParameter("guardian_address");
        String studentId = request.getParameter("student_id");

        Part photoPart = request.getPart("image");
        InputStream photoStream = (photoPart != null && photoPart.getSize() > 0) ? photoPart.getInputStream() : null;

        try (Connection conn = DBConnection.getConnection()) {
            // Step 1: Check if student_id exists
            String checkStudentQuery = "SELECT COUNT(*) FROM students WHERE student_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkStudentQuery)) {
                checkStmt.setString(1, studentId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    // Student ID does not exist
                    response.getWriter().println("<html><body><h2 style='color: red; text-align: center;'>Error: Student ID does not exist.</h2>");
                    response.getWriter().println("<div style='text-align: center;'><a href='admin.jsp'><button style='padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;'>Go to Admin Page</button></a></div>");
                    response.getWriter().println("</body></html>");
                    return;
                }
            }

            // Step 2: Insert Guardian Details
            String sql = "INSERT INTO Guardians (name, phone, email, address, relation, student_id, Image) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, guardianName);
                ps.setString(2, guardianPhone);
                ps.setString(3, guardianEmail);
                ps.setString(4, guardianAddress);
                ps.setString(5, guardianRelation);
                ps.setString(6, studentId);
                if (photoStream != null) {
                    ps.setBlob(7, photoStream);
                } else {
                    ps.setNull(7, Types.BLOB);
                }

                int rowsInserted = ps.executeUpdate();
                if (rowsInserted > 0) {
                    ResultSet generatedKeys = ps.getGeneratedKeys();
                    String guardianId = generatedKeys.next() ? generatedKeys.getString(1) : guardianEmail;

                    String randomPassword = generateRandomPassword(8);
                    try (PreparedStatement stmt2 = conn.prepareStatement("INSERT INTO glogin (guardian_id, password) VALUES (?, ?)")) {
                        stmt2.setString(1, guardianId);
                        stmt2.setString(2, randomPassword);
                        stmt2.executeUpdate();
                    }

                    sendEmail(guardianEmail, "Your Guardian Account Details",
                            "Dear " + guardianName + ",\n\n" +
                                    "Your guardian account has been created successfully.\n" +
                                    "Guardian ID: " + guardianId + "\n" +
                                    "Password: " + randomPassword + "\n\n" +
                                    "Regards,\nLeave Management System");

                    response.setContentType("text/html");
                    response.getWriter().println("<html><head><title>Registration Successful</title></head><body>");
                    response.getWriter().println("<h2 style='color: green; text-align: center;'>Guardian Registration Complete!</h2>");
                    response.getWriter().println("<div style='text-align: center;'><a href='admin.jsp'><button style='padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer;'>Go to Admin Page</button></a></div>");
                    response.getWriter().println("</body></html>");
                } else {
                    response.getWriter().println("Error: Unable to add guardian.");
                }
            }
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
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

        final String from = "your-email@gmail.com";
        final String password = "your-email-password";

        Session session = Session.getInstance(props, new Authenticator() {
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
    }
}
