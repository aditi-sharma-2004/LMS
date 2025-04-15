# Leave Management System (LMS) 🚪📄

A **web-based Leave Management System** tailored for academic institutions. It enables **guardians** to submit leave requests on behalf of students and incorporates a **multi-level approval workflow** involving Wardens, Verification Officers (VO), Heads of Department (HOD), and Gate Pass Officers (GPO). **Admins** have full control over user management and request overrides.

---

## 🚀 Features

- **Guardian Leave Submission**
  - Guardians can submit leave forms for students.

- **Multi-Level Approval Workflow**
  - Warden → VO → HOD → GPO
  - Each role gets a dedicated dashboard for request handling.

- **Gate Pass Generation**
  - GPO can generate and print gate passes post final approval.

- **Admin Controls**
  - Add, remove, update, or view any user.
  - Override or intervene in leave requests at any stage.

- **Role-Specific Dashboards**
  - Guardian  
  - Warden  
  - VO (Verification Officer)  
  - HOD (Head of Department)  
  - GPO (Gate Pass Officer)  
  - Admin

---

## 🧰 Tech Stack

| Layer        | Technology               |
|--------------|--------------------------|
| Frontend     | HTML, CSS, JavaScript, JSP |
| Backend      | Java (Servlets)           |
| Database     | MySQL                     |
| Server       | Apache Tomcat             |

---

## 📁 Folder Structure

This project has a structured organization with clear separation of backend and frontend components:

- **java/com/example/**: Backend logic and controllers
- **webapps/**: JSP pages for user interfaces
- **WEB-INF/**: Deployment descriptors
- **insert.sql and tables.sql**: SQL setup scripts

---

## 📥 Installation and Setup Instructions

### 1. Clone the GitHub Repository
```bash
git clone https://github.com/aditi-sharma-2004/LMS.git
cd Leave-Management-System
```

### 2. Setup MySQL Database
- Create a MySQL database named `lms`:
```sql
CREATE DATABASE lms;
USE lms;
```
- Execute the SQL scripts provided in `insert.sql` and `tables.sql`
- Update database credentials in `DBConnection.java`:
```java
String url="jdbc:mysql://localhost:3306/lms";
String username = "lms";
String password = "lms";
```

### 3. Deploy on Apache Tomcat
- Copy project folder to the `webapps/` directory of Apache Tomcat
- Start Tomcat server
- Access the application in your browser: `http://localhost:8080/LMS-1/`

---

## 🔄 Execution Flow

### 1. Guardian Submits Leave Form
- Enter student name, reason, dates, etc.
- Request is saved with `Pending` status and `current_stage = 'Warden'`

### 2. Warden Reviews
- Views leave requests at Warden level
- Approves → moves to VO
- Rejects → request closed

### 3. VO Reviews
- Approves → moves to HOD
- Rejects → request closed

### 4. HOD Reviews
- Approves → moves to GPO
- Rejects → request closed

### 5. GPO Final Approval
- Gatepass generated for printing

### 6. Admin Panel
- Full access to all requests and user data
- Can approve/reject leave at any stage
- Add, remove, update user records

---

## 👥 Developed By

B.Tech (CSE) 3rd year students (2022-2026), Banasthali Vidyapith:
- Aditi Sharma
- Nupur Kushwaha
- Priyanshi Seth
- Radhika Paliwal
- Shanica Pandey 

---

## 📝 License

This project is licensed under the MIT License.
