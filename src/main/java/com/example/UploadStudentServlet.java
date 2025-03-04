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

@WebServlet("/UploadStudentServlet")
@MultipartConfig(maxFileSize = 16177215) // 16MB max file size
public class UploadStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
           throws ServletException, IOException {
       request.setCharacterEncoding("UTF-8");
       
       // Retrieve form parameters including student_id entered by the user
       String studentId = request.getParameter("student_id").trim();
       String name = request.getParameter("name");
       int rno = Integer.parseInt(request.getParameter("rno"));
       String email = request.getParameter("email");
       String dob = request.getParameter("dob");
       String phone = request.getParameter("phone");
       String address = request.getParameter("address");
       String departmentId = request.getParameter("department_id");
       String courseId = request.getParameter("course_id");
       String hostelId = request.getParameter("hostel_id");
       String year = request.getParameter("year");
       
       Part filePart = request.getPart("image");
       InputStream imageStream = null;
       if (filePart != null && filePart.getSize() > 0) {
           imageStream = filePart.getInputStream();
       }
       
       Connection conn = null;
       PreparedStatement pstmt = null;
       try {
           Class.forName("com.mysql.cj.jdbc.Driver");
           conn = DBConnection.getConnection();
           
           // Insert into Students table with provided student_id
           String insertStudentSQL = "INSERT INTO Students (student_id, name, rno, email, dob, phone, address, department_id, course_id, hostel_id, year, Image) " +
                                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
           pstmt = conn.prepareStatement(insertStudentSQL);
           pstmt.setString(1, studentId);
           pstmt.setString(2, name);
           pstmt.setInt(3, rno);
           pstmt.setString(4, email);
           pstmt.setString(5, dob);
           pstmt.setString(6, phone);
           pstmt.setString(7, address);
           pstmt.setString(8, departmentId);
           pstmt.setString(9, courseId);
           pstmt.setString(10, hostelId);
           pstmt.setString(11, year);
           if (imageStream != null) {
               pstmt.setBlob(12, imageStream);
           } else {
               pstmt.setNull(12, Types.BLOB);
           }
           
           int row = pstmt.executeUpdate();
           if (row == 0) {
               response.getWriter().println("Error: Could not insert student record.");
               return;
           }
           
           // At this point, the student record exists.
           // Generate a random password.
           String randomPassword = generateRandomPassword(8);
           
           // Insert login record into slogin table (using the same student_id)
           String insertLoginSQL = "INSERT INTO slogin (student_id, password) VALUES (?, ?)";
           int row2;
           try (PreparedStatement pstmt2 = conn.prepareStatement(insertLoginSQL)) {
               pstmt2.setString(1, studentId);
               pstmt2.setString(2, randomPassword);
               row2 = pstmt2.executeUpdate();
           }
           if (row2 == 0) {
               response.getWriter().println("Error: Could not insert login record.");
               return;
           }
           
           // Prepare email details and send email with account credentials
           String subject = "Your Student Account Details";
           String body = "Dear " + name + ",\n\n" +
                         "Your student account has been created successfully.\n" +
                         "Student ID: " + studentId + "\n" +
                         "Password: " + randomPassword + "\n\n" +
                         "Regards,\nLeave Management System";
           sendEmail(email, subject, body);
           request.getSession().setAttribute("studentId", studentId);
           // Redirect to a success page (create studentSuccess.jsp as needed)
           response.sendRedirect("addGuardian.jsp");
       } catch (Exception ex) {
           ex.getMessage();
           response.getWriter().println("Error: " + ex.getMessage());
       } finally {
           try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
           try { if (conn != null) conn.close(); } catch (SQLException e) {}
       }
    }
    
    // Utility method to generate a random password of given length
    private String generateRandomPassword(int length) {
       String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
       Random rnd = new Random();
       StringBuilder sb = new StringBuilder(length);
       for (int i = 0; i < length; i++) {
           sb.append(chars.charAt(rnd.nextInt(chars.length())));
       }
       return sb.toString();
    }
    
    // Utility method to send an email using Jakarta Mail (or JavaMail)
    private void sendEmail(String to, String subject, String body) throws Exception {
       Properties props = new Properties();
       props.put("mail.smtp.auth", "true");
       props.put("mail.smtp.starttls.enable", "true");
       props.put("mail.smtp.host", "smtp.gmail.com");
       props.put("mail.smtp.port", "587");
       
       // Replace with your valid email credentials
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
