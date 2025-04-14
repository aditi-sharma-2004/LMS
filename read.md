 Leave Management System (LMS)
A web-based Leave Management System designed for academic institutions, allowing guardians to apply for leave on behalf of students and enabling a multi-level approval flow through Warden, Verification Officer(VO), Head of the Department(HOD), and Gate pass officer(GPO). Admins have full authority over the system.

 Features
●	The Guardian can submit a leave request form.

●	Multi-level approval workflow:
 Warden → VO → HOD → GPO

●	GPO can print the gate pass after final approval.

●	Admin functionalities:

○	Add/Remove/Update/View all users

○	Override leave requests at any stage (approve/reject)

●	Role-specific dashboards for:

○	Guardians

○	Wardens

○	VO

○	HOD

○	GPO

○	Admin

 Tech Stack
●	Frontend: HTML, CSS, JavaScript, JSP

●	Backend: Java (Servlets)

●	Database: MySQL

●	Server: Apache Tomcat

Folder Structure Overview

This project is a Leave Management System with multi-role functionality (Admin, Warden, Guardian, HOD, VO, Student). The backend is written in Java (Servlets), and the frontend uses JSP pages.
The main directories include:
●	java/com/example/: Backend logic and controllers

●	webapps/: JSP pages for user interfaces

●	WEB-INF/: Deployment descriptors

●	insert.sql and tables.sql: SQL setup scripts

Installation and Setup Instructions

1.	Clone the github repository

git clone https://github.com/aditi-sharma-2004/LMS.git
cd Leave-Management-System

2.	Setup MySQL Database

●	Create a MySQL database named lms.
●	Sample schema structure:
CREATE DATABASE lms;
USE lms;
●	Execute the SQL script to create required tables- provided in insert.sql and tables.sql

●	Update database credentials in DBConnection.java

String url="jdbc:mysql://localhost:3306/lms";
String username = "lms";
String password = "lms";

3.	Deploy on Apache Tomcat

●	Copy project folder to webapps/ directory of Apache Tomcat

●	Start Tomcat server

●	Access the application in your browser:
http://localhost:8080/LMS-1/

Execution Flow
1. Guardian Submits Leave Form
●	Enter student name, reason, dates, etc.

●	Request is saved with Pending status and current_stage = 'Warden'

2. Warden Reviews
●	Views leave requests at Warden level

●	Approves → moves to VO

●	Rejects → request closed

3. VO Reviews
●	Approves → moves to HOD

●	Rejects → request closed

4. HOD Reviews
●	Approves → moves to GPO

●	Rejects → request closed

5. GPO Final Approval
●	Gatepass generated for printing

6. Admin Panel
●	Full access to all requests and user data

●	Can approve/reject leave at any stage

●	Add, remove, update user records


Developed By

B.Tech (CSE) 3rd year students(2022-2026), Banasthali Vidyapith
●	Aditi Sharma
●	Nupur Kushwaha
●	Priyanshi Seth
●	Radhika Paliwal
●	Shanica Pandey 


License

This project is licensed under the MIT License.




