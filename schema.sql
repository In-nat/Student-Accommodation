-- ============================================================
-- University Accommodation Service - Database Schema
-- Scenario 11: Student Housing Management System
-- ============================================================

CREATE DATABASE IF NOT EXISTS UniversityAccommodation;
USE UniversityAccommodation;

-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Gender VARCHAR(10),
    Department VARCHAR(50),
    YearOfStudy INT,
    PriorityLevel INT,
    Phone VARCHAR(15)
);

CREATE TABLE HousingOptions (
    HousingID INT PRIMARY KEY AUTO_INCREMENT,
    HousingType VARCHAR(50),
    Capacity INT,
    Location VARCHAR(100),
    MonthlyFee DECIMAL(8,2)
);

CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    HousingID INT,
    RoomNumber VARCHAR(10),
    Floor INT,
    Status VARCHAR(20),
    FOREIGN KEY (HousingID) REFERENCES HousingOptions(HousingID)
);

CREATE TABLE RoomAllocations (
    AllocationID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    RoomID INT,
    AllocationDate DATE,
    EndDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

CREATE TABLE MaintenanceRequests (
    RequestID INT PRIMARY KEY AUTO_INCREMENT,
    RoomID INT,
    StudentID INT,
    IssueDescription VARCHAR(255),
    RequestDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    Amount DECIMAL(8,2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(20),
    Status VARCHAR(20),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- ============================================================
-- SAMPLE DATA INSERTION
-- ============================================================

INSERT INTO Students (FullName, Gender, Department, YearOfStudy, PriorityLevel, Phone) VALUES
('Rahul Sharma','Male','Computer Science',2,1,'9876543210'),
('Ananya Das','Female','Biotechnology',1,3,'9876543211'),
('Arjun Singh','Male','Mechanical',3,2,'9876543212'),
('Priya Roy','Female','Commerce',2,1,'9876543213'),
('Neha Kapoor','Female','Physics',4,4,'9876543214'),
('Amit Verma','Male','Mathematics',1,3,'9876543215'),
('Sneha Sen','Female','English',3,2,'9876543216'),
('Rohan Ghosh','Male','Civil',2,2,'9876543217'),
('Karan Mehta','Male','Electronics',4,5,'9876543218'),
('Pooja Iyer','Female','Chemistry',1,1,'9876543219');

INSERT INTO HousingOptions (HousingType, Capacity, Location, MonthlyFee) VALUES
('Boys Hostel',200,'Block A',3000),
('Girls Hostel',180,'Block B',3200),
('PG Accommodation',100,'Near Campus',4500),
('Apartment',60,'City Center',7000),
('Research Scholars Hostel',80,'Block C',3500),
('International Hostel',50,'Block D',5000),
('Faculty Guest House',30,'Campus West',6500),
('Sports Hostel',40,'Stadium Area',2800),
('Medical Hostel',70,'Hospital Road',3400),
('Law Hostel',90,'Block E',3100);

INSERT INTO Rooms (HousingID, RoomNumber, Floor, Status) VALUES
(1,'A101',1,'Available'),
(1,'A102',1,'Occupied'),
(2,'B101',1,'Available'),
(2,'B102',2,'Occupied'),
(3,'PG201',2,'Available'),
(4,'APT301',3,'Occupied'),
(5,'C101',1,'Available'),
(6,'D101',1,'Occupied'),
(7,'FGH01',1,'Available'),
(8,'SP101',1,'Occupied');

INSERT INTO RoomAllocations (StudentID, RoomID, AllocationDate, EndDate) VALUES
(1,2,'2025-01-01','2025-12-31'),
(2,4,'2025-02-01','2025-12-31'),
(3,6,'2025-03-01','2025-12-31'),
(4,10,'2025-01-15','2025-12-31'),
(5,8,'2025-02-10','2025-12-31'),
(6,2,'2025-04-01','2025-12-31'),
(7,4,'2025-05-01','2025-12-31'),
(8,6,'2025-06-01','2025-12-31'),
(9,8,'2025-07-01','2025-12-31'),
(10,10,'2025-08-01','2025-12-31');

INSERT INTO MaintenanceRequests (RoomID, StudentID, IssueDescription, RequestDate, Status) VALUES
(2,1,'Fan not working','2025-02-10','Pending'),
(4,2,'Water leakage','2025-02-11','Completed'),
(6,3,'Broken window','2025-02-15','Pending'),
(10,4,'AC malfunction','2025-03-01','In Progress'),
(8,5,'Light not working','2025-03-05','Completed'),
(2,6,'Door lock issue','2025-03-10','Pending'),
(4,7,'Bed damaged','2025-03-15','In Progress'),
(6,8,'Internet issue','2025-03-20','Completed'),
(8,9,'Pipe leakage','2025-03-25','Pending'),
(10,10,'Electrical short circuit','2025-03-30','In Progress');

INSERT INTO Payments (StudentID, Amount, PaymentDate, PaymentMethod, Status) VALUES
(1,3000,'2025-01-05','UPI','Paid'),
(2,3200,'2025-01-06','Card','Paid'),
(3,7000,'2025-01-07','Cash','Paid'),
(4,2800,'2025-01-08','UPI','Paid'),
(5,5000,'2025-01-09','Card','Pending'),
(6,3000,'2025-02-05','UPI','Paid'),
(7,3200,'2025-02-06','Cash','Paid'),
(8,7000,'2025-02-07','Card','Pending'),
(9,5000,'2025-02-08','UPI','Paid'),
(10,2800,'2025-02-09','Cash','Paid');
