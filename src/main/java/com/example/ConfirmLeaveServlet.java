package com.example;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

import jakarta.mail.Authenticator;
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

@WebServlet("/ConfirmLeaveServlet")
public class ConfirmLeaveServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String leaveId = request.getParameter("leave_id");

        try (Connection conn = DBConnection.getConnection()) {
            String studentEmail = "";
            String studentName = "";

            // Fetch student email and name
            String selectQuery = "SELECT s.email, s.name FROM students s JOIN LeaveRequests l ON s.student_id = l.student_id WHERE l.leave_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(selectQuery)) {
                ps.setString(1, leaveId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    studentEmail = rs.getString("s.email");
                    studentName = rs.getString("s.name");
                }
            }

            // Send email notification if student email exists
            if (!studentEmail.isEmpty()) {
                try {
                    sendEmail(studentEmail, "Leave Request Approved",
                            "Dear " + studentName + ",\n\n" +
                                    "Your leave request (ID: " + leaveId + ") has been approved.\n" +
                                    "Collect your GatePass from Vani Mandir Room No. 102.\n\n" +
                                    "Regards,\nLeave Management System");
                } catch (Exception e) {
                    e.getMessage(); // Log error but don’t stop execution
                }
            }

            response.sendRedirect("pendingLeavesHod.jsp");
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private void sendEmail(String to, String subject, String body) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        final String from = "nupurk930@gmail.com";
        final String password = "ahgc gdrj mgla uezt";

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
