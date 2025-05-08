<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%
    String adminId = request.getParameter("adminId");
    String inputPassword = request.getParameter("password");

    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "lms";
    String dbPassword = "lms"; // Database password

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        // Validate input
        if (adminId == null || adminId.trim().isEmpty() || inputPassword == null || inputPassword.trim().isEmpty()) {
            out.println("<script>alert('adminId and Password cannot be empty');</script>");
            request.getRequestDispatcher("admin.jsp").include(request, response);
            return;
        }

        

        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        String admin_id = request.getParameter("adminId");
        
        String sql = "SELECT password FROM alogin WHERE admin_id = ?";
        pst = conn.prepareStatement(sql);
        pst.setString(1, adminId);
        rs = pst.executeQuery();

        if (rs.next()) {
            String password = rs.getString("password");
            
            
            if (inputPassword.equals(password)) {
                
                response.sendRedirect("adminDashboard.jsp");
                //HttpSession session = request.getSession();
                session.setAttribute("adminId", admin_id);
            } else {
                out.println("<script>alert('Invalid admin ID or Password');</script>");
                request.getRequestDispatcher("admin.jsp").include(request, response);
            }
        } else {
            out.println("<script>alert('admin ID not found');</script>");
            request.getRequestDispatcher("admin.jsp").include(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Something went wrong: " + e.getMessage() + "');</script>");
        request.getRequestDispatcher("index.jsp").include(request, response);
    } finally {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>