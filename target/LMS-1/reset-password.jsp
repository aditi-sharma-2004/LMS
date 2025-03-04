<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .reset-container {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            width: 300px;
        }
        input, button {
            width: 90%;
            margin: 10px 0;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background: #28a745;
            color: white;
            border: none;
        }
        button:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <div class="reset-container">
        <h1>Reset Password</h1>
        <form action="UpdatePasswordServlet" method="POST">
            <input type="hidden" name="token" value="<%= request.getParameter("token") %>">
            <input type="password" name="newPassword" placeholder="Enter new password" required>
            <button type="submit">Reset Password</button>
        </form>
    </div>
</body>
</html>
