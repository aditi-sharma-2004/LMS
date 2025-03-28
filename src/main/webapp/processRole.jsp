<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = request.getParameter("role");
    String employeeType = request.getParameter("employeeType");

    if ("student".equalsIgnoreCase(role)) {
        response.sendRedirect("student.jsp");
    } else if ("guardian".equalsIgnoreCase(role)) {
        response.sendRedirect("guardian.jsp");
    } else if("admin".equalsIgnoreCase(role)){
        response.sendRedirect("admin.jsp");
    } else if ("employee".equalsIgnoreCase(role)) {
        if ("warden".equalsIgnoreCase(employeeType)) {
            response.sendRedirect("warden.jsp");
        } else if ("hod".equalsIgnoreCase(employeeType)) {
            response.sendRedirect("hod.jsp");
        } else if ("verificationOfficer".equalsIgnoreCase(employeeType)) {
            response.sendRedirect("vo.jsp");
        }else if ("gpo".equalsIgnoreCase(employeeType)) {
            response.sendRedirect("gpo.jsp");
        } else {
            out.println("<h3>Invalid employee type selected!</h3>");
        }
    } else {
        out.println("<h3>Invalid role selected!</h3>");
    }
%>
