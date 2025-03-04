<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout</title>
</head>
<body>
    <p>You have been logged out. Redirecting to the login page...</p>
</body>
</html>
<%
    // Invalidate the session
    session.invalidate();

    // Redirect to the login page
    response.sendRedirect("index.jsp");
%>
