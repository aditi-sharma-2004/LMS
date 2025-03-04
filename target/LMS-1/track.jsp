<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Applications - Leave Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }

        .content {
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 14px;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        table th {
            background-color: #f4f4f4;
            font-weight: 500;
        }

        table tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>

    <div class="content">
        <h2>Track Applications</h2>

        <!-- Current Applications Section -->
        <h3>Current Applications</h3>
        <table>
            <thead>
                <tr>
                    <th>Application ID</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>12345</td>
                    <td>2025-01-10</td>
                    <td>2025-01-12</td>
                    <td>Pending</td>
                </tr>
            </tbody>
        </table>

        <!-- Previous Applications Section -->
        <h3>Previous Applications</h3>
        <table>
            <thead>
                <tr>
                    <th>Application ID</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                    <th>Remarks</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>12234</td>
                    <td>2024-12-10</td>
                    <td>2024-12-12</td>
                    <td>Approved</td>
                    <td>Enjoy your leave!</td>
                </tr>
            </tbody>
        </table>
    </div>

</body>
</html>
