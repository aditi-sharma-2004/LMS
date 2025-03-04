
INSERT INTO Departments (name) VALUES 
('Computer Science'), 
('Electronics'), 
('Mathematics'), 
('Management');

-- Insert into Courses
INSERT INTO Courses (name, department_id) VALUES 
('B.Tech CSE', 1), 
('B.Tech ECE', 2), 
('B.Sc Mathematics', 3), 
('MBA', 4);

-- Insert into Hostels
INSERT INTO Hostels (name) VALUES 
('Aprajita'), 
('Meera'), 
('Gargi'), 
('Saraswati');

-- Insert into Wardens
INSERT INTO wardens (warden_id, name, phone, email, hostel_id, image) VALUES 
('W001', 'Dr. Anjali Sharma', '9876543210', 'anjali.sharma@banasthali.in', 1, NULL), 
('W002', 'Dr. Poonam Verma', '9876543211', 'poonam.verma@banasthali.in', 2, NULL);

-- Insert into VO (Vice Officers)
INSERT INTO vo (vo_id, name, phone, email, department_id, image) VALUES 
('VO001', 'Dr. Rakesh Mehta', '9876543220', 'rakesh.mehta@banasthali.in', 1, NULL), 
('VO002', 'Dr. Sunita Gupta', '9876543221', 'sunita.gupta@banasthali.in',2,NULL);
INSERT INTO hod (hod_id, name, phone, email, department_id, image) VALUES 
('HOD001', 'Dr. Anurag Singh', '9876543230', 'anurag.singh@banasthali.in', 1, NULL), 
('HOD002', 'Dr. Neha Pandey', '9876543231', 'neha.pandey@banasthali.in', 2, NULL);
INSERT INTO Students (student_id, name, rno, email, dob, phone, address, department_id, course_id, hostel_id, year, image) VALUES 
('BTP001', 'Aditi Sharma', 101, 'aditi.sharma@banasthali.in', '2003-05-12', '9876543240', 'Jaipur, Rajasthan', 1, 1, 1, '2nd', NULL), 
('BTP002', 'Ridhi Golchha', 102, 'ridhi.golchha@banasthali.in', '2004-07-23', '9876543241', 'Delhi', 2, 2, 2, '3rd', NULL);
INSERT INTO Guardians (name, email, phone, address, student_id, image) VALUES 
('Mahesh Sharma', 'mahesh.sharma@example.com', '9876543250', 'Jaipur, Rajasthan', 'BTP001', NULL), 
('Seema Golchha', 'seema.golchha@example.com', '9876543251', 'Delhi', 'BTP002', NULL);
-- Student Login
INSERT INTO slogin (student_id, password) VALUES 
('BTP001', 'password'), 
('BTP002', 'password');

-- Guardian Login
INSERT INTO glogin (guardian_id, password) VALUES 
(1, 'password'), 
(2, 'password');

-- Warden Login
INSERT INTO wlogin (warden_id, password) VALUES 
('W001', 'password'), 
('W002', 'password');

-- VO Login
INSERT INTO vologin (vo_id, password) VALUES 
('VO001', 'password'), 
('VO002', 'password');

-- HOD Login
INSERT INTO hodlogin (hod_id, password) VALUES 
('HOD001', 'password'), 
('HOD002', 'password');

