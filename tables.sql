create database lms;
use lms;


CREATE TABLE Departments (
    department_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Courses (
    course_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    department_id VARCHAR(50) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);
CREATE TABLE Hostels (
    hostel_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE wardens (
    warden_id VARCHAR(50) PRIMARY KEY, -- ID with custom prefix
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    Image LONGBLOB,
    hostel_id VARCHAR(50) DEFAULT NULL, 
    FOREIGN KEY (hostel_id) REFERENCES Hostels(hostel_id) ON DELETE SET NULL
); 

CREATE TABLE vo (
    vo_id VARCHAR(50) PRIMARY KEY, -- ID with custom prefix
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    Image LONGBLOB,
    department_id VARCHAR(50) DEFAULT NULL, 
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
); 

CREATE TABLE hod (
    hod_id VARCHAR(50) PRIMARY KEY, -- ID with custom prefix
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    Image LONGBLOB,
    department_id VARCHAR(50) DEFAULT NULL, 
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
); 
CREATE TABLE Students (
    student_id VARCHAR(50) PRIMARY KEY,      -- Unique Smart Card ID
    name VARCHAR(255) NOT NULL,               -- Student's full name
    rno INT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,       -- Student's email
    dob DATE NOT NULL,                        -- Date of birth
    phone VARCHAR(15) NOT NULL,               -- 10-digit phone number
    address TEXT NOT NULL,                    -- Address
    department_id VARCHAR(50) NOT NULL,               -- Foreign key for department
    course_id VARCHAR(50) NOT NULL,                   -- Foreign key for course
    hostel_id VARCHAR(50) DEFAULT NULL,               -- Foreign key for hostel (optional)
    year ENUM('1st', '2nd', '3rd', '4th') NOT NULL, -- Year of study
    Image LONGBLOB,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (hostel_id) REFERENCES Hostels(hostel_id) ON DELETE SET NULL
); 
CREATE TABLE Guardians (
    guardian_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,               -- Student's full name
    email VARCHAR(255) NOT NULL UNIQUE,       -- Student's email
    phone VARCHAR(10) NOT NULL,               -- 10-digit phone number
    address TEXT NOT NULL,                    -- Address
    Image LONGBLOB,
    student_id VARCHAR(50) NOT NULL UNIQUE,-- Unique Smart Card ID
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
); 

CREATE TABLE admin (
    admin_id VARCHAR(10) PRIMARY KEY, -- ID with custom prefix
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
); 



CREATE TABLE slogin (
    student_id VARCHAR(50) PRIMARY KEY, -- Foreign key to the `student` table
    password VARCHAR(255) NOT NULL,   -- Password column
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);
CREATE TABLE glogin (
    guardian_id VARCHAR(50) PRIMARY KEY, -- Foreign key to the `guardian` table
    password VARCHAR(255) NOT NULL,   -- Password column
    FOREIGN KEY (guardian_id) REFERENCES guardians(guardian_id) ON DELETE CASCADE
);

CREATE TABLE wlogin (
    warden_id VARCHAR(50) PRIMARY KEY, -- Foreign key to the `warden` table
    password VARCHAR(255) NOT NULL,   -- Password column
    FOREIGN KEY (warden_id) REFERENCES wardens(warden_id) ON DELETE CASCADE
); 


CREATE TABLE vologin (
    vo_id VARCHAR(50) PRIMARY KEY, -- Foreign key to the `vo` table
    password VARCHAR(255) NOT NULL,   -- Password column
    FOREIGN KEY (vo_id) REFERENCES vo(vo_id) ON DELETE CASCADE
); 

CREATE TABLE hodlogin (
    hod_id VARCHAR(50) PRIMARY KEY, -- Foreign key to the `hod` table
    password VARCHAR(255) NOT NULL,   -- Password column
    FOREIGN KEY (hod_id) REFERENCES hod(hod_id) ON DELETE CASCADE
);

CREATE TABLE alogin (
    admin_id VARCHAR(10) PRIMARY KEY, -- Foreign key to the `admin` table
    password VARCHAR(255) NOT NULL,   -- Password column
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id) ON DELETE CASCADE
); 


/* TRIGGER CODE TO AUTO-INCREMENT ID*/

DELIMITER ;;

CREATE TRIGGER before_insert_guardian_id
BEFORE INSERT ON Guardians
FOR EACH ROW
BEGIN
    DECLARE new_id INT;
    
    -- Get the latest numerical ID from existing guardian_id
    SELECT COALESCE(MAX(CAST(SUBSTRING(guardian_id, 6) AS UNSIGNED)), 100) + 1 
    INTO new_id 
    FROM Guardians;
    
    -- Assign new guardian_id
    SET NEW.guardian_id = CONCAT('GUARD', new_id);
END ;;

DELIMITER ;