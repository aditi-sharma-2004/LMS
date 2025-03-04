<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('back.jpg'); /* Ensure the correct path */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
        }
        .reset-container {
            margin: 100px auto;
            background: #fff;
            padding: 20px;
            width: 300px;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0,0,0,0.1);
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
        <form action="ResetPassword" method="POST">
            <input type="email" name="email" placeholder="Registered Email" required>
            <button type="submit">Send Reset Link</button>
        </form>
        <p>Remembered your password? <a href="guardian.jsp">Go back to Login</a></p>
    </div>
</body>
</html>
