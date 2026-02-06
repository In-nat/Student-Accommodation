-- ============================================================
-- University Accommodation Service - Query Development
-- Scenario 11: Student Housing Management System
-- ============================================================
-- This file contains queries organized into four categories:
--   1. Basic and Conditional Retrieval
--   2. Aggregated Reports
--   3. Data Manipulation (INSERT, UPDATE, DELETE)
--   4. Complex Queries (JOINs, Subqueries, Advanced SQL)
-- ============================================================

USE UniversityAccommodation;


-- ************************************************************
-- SECTION 1: BASIC AND CONDITIONAL RETRIEVAL
-- Queries that fetch data from single or multiple tables
-- based on specific conditions.
-- ************************************************************

-- 1.1 Retrieve all students
SELECT * FROM Students;

-- 1.2 Retrieve all female students
SELECT StudentID, FullName, Department, YearOfStudy
FROM Students
WHERE Gender = 'Female';

-- 1.3 Retrieve students with the highest priority (PriorityLevel = 1)
SELECT StudentID, FullName, Department, PriorityLevel
FROM Students
WHERE PriorityLevel = 1;

-- 1.4 Retrieve students in their 1st year of study
SELECT StudentID, FullName, Department, Phone
FROM Students
WHERE YearOfStudy = 1;

-- 1.5 Retrieve all available rooms
SELECT RoomID, RoomNumber, Floor, Status
FROM Rooms
WHERE Status = 'Available';

-- 1.6 Retrieve all occupied rooms
SELECT RoomID, RoomNumber, Floor, Status
FROM Rooms
WHERE Status = 'Occupied';

-- 1.7 Retrieve housing options with a monthly fee less than 4000
SELECT HousingID, HousingType, Location, MonthlyFee
FROM HousingOptions
WHERE MonthlyFee < 4000;

-- 1.8 Retrieve housing options sorted by monthly fee (ascending)
SELECT HousingID, HousingType, Capacity, Location, MonthlyFee
FROM HousingOptions
ORDER BY MonthlyFee ASC;

-- 1.9 Retrieve all pending maintenance requests
SELECT RequestID, RoomID, StudentID, IssueDescription, RequestDate
FROM MaintenanceRequests
WHERE Status = 'Pending';

-- 1.10 Retrieve maintenance requests filed in March 2025
SELECT RequestID, RoomID, IssueDescription, RequestDate, Status
FROM MaintenanceRequests
WHERE RequestDate BETWEEN '2025-03-01' AND '2025-03-31';

-- 1.11 Retrieve all payments that are still pending
SELECT PaymentID, StudentID, Amount, PaymentDate, PaymentMethod
FROM Payments
WHERE Status = 'Pending';

-- 1.12 Retrieve payments made via UPI
SELECT PaymentID, StudentID, Amount, PaymentDate, Status
FROM Payments
WHERE PaymentMethod = 'UPI';

-- 1.13 Retrieve students from the Computer Science or Physics department
SELECT StudentID, FullName, Department, YearOfStudy
FROM Students
WHERE Department IN ('Computer Science', 'Physics');

-- 1.14 Retrieve room allocations that are currently active (EndDate in the future)
SELECT AllocationID, StudentID, RoomID, AllocationDate, EndDate
FROM RoomAllocations
WHERE EndDate >= CURDATE();

-- 1.15 Retrieve students whose name starts with 'A'
SELECT StudentID, FullName, Department
FROM Students
WHERE FullName LIKE 'A%';

-- 1.16 Retrieve rooms on the 1st floor
SELECT RoomID, RoomNumber, HousingID, Status
FROM Rooms
WHERE Floor = 1;

-- 1.17 Retrieve housing options with capacity greater than 50 and fee under 4000
SELECT HousingID, HousingType, Capacity, MonthlyFee
FROM HousingOptions
WHERE Capacity > 50 AND MonthlyFee < 4000;

-- 1.18 Retrieve distinct departments from the Students table
SELECT DISTINCT Department
FROM Students;

-- 1.19 Retrieve students ordered by PriorityLevel (highest priority first)
SELECT StudentID, FullName, Department, PriorityLevel
FROM Students
ORDER BY PriorityLevel ASC;

-- 1.20 Retrieve the top 5 most expensive housing options
SELECT HousingType, Location, MonthlyFee
FROM HousingOptions
ORDER BY MonthlyFee DESC
LIMIT 5;


-- ************************************************************
-- SECTION 2: AGGREGATED REPORTS
-- Using SQL aggregate functions (COUNT, SUM, AVG, MIN, MAX)
-- with GROUP BY and HAVING to generate summary reports.
-- ************************************************************

-- 2.1 Count the total number of students
SELECT COUNT(*) AS TotalStudents
FROM Students;

-- 2.2 Count students by gender
SELECT Gender, COUNT(*) AS StudentCount
FROM Students
GROUP BY Gender;

-- 2.3 Count students by department
SELECT Department, COUNT(*) AS StudentCount
FROM Students
GROUP BY Department
ORDER BY StudentCount DESC;

-- 2.4 Count students by year of study
SELECT YearOfStudy, COUNT(*) AS StudentCount
FROM Students
GROUP BY YearOfStudy
ORDER BY YearOfStudy;

-- 2.5 Count rooms by status (Available vs Occupied)
SELECT Status, COUNT(*) AS RoomCount
FROM Rooms
GROUP BY Status;

-- 2.6 Total, average, minimum, and maximum monthly fees across all housing options
SELECT
    COUNT(*) AS TotalHousingOptions,
    SUM(MonthlyFee) AS TotalFees,
    AVG(MonthlyFee) AS AverageFee,
    MIN(MonthlyFee) AS MinimumFee,
    MAX(MonthlyFee) AS MaximumFee
FROM HousingOptions;

-- 2.7 Total capacity per housing type
SELECT HousingType, Capacity
FROM HousingOptions
ORDER BY Capacity DESC;

-- 2.8 Count maintenance requests by status
SELECT Status, COUNT(*) AS RequestCount
FROM MaintenanceRequests
GROUP BY Status
ORDER BY RequestCount DESC;

-- 2.9 Count maintenance requests per room
SELECT RoomID, COUNT(*) AS RequestCount
FROM MaintenanceRequests
GROUP BY RoomID
HAVING RequestCount > 1;

-- 2.10 Total payments collected (only 'Paid' status)
SELECT
    COUNT(*) AS TotalPaidPayments,
    SUM(Amount) AS TotalAmountCollected
FROM Payments
WHERE Status = 'Paid';

-- 2.11 Total pending payment amount
SELECT
    COUNT(*) AS PendingPayments,
    SUM(Amount) AS TotalPendingAmount
FROM Payments
WHERE Status = 'Pending';

-- 2.12 Total payments by payment method
SELECT PaymentMethod, COUNT(*) AS PaymentCount, SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY PaymentMethod
ORDER BY TotalAmount DESC;

-- 2.13 Average payment amount per student
SELECT StudentID, AVG(Amount) AS AvgPayment
FROM Payments
GROUP BY StudentID;

-- 2.14 Number of allocations per room
SELECT RoomID, COUNT(*) AS AllocationCount
FROM RoomAllocations
GROUP BY RoomID
ORDER BY AllocationCount DESC;

-- 2.15 Monthly payment summary (payments grouped by month)
SELECT
    DATE_FORMAT(PaymentDate, '%Y-%m') AS PaymentMonth,
    COUNT(*) AS NumberOfPayments,
    SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY DATE_FORMAT(PaymentDate, '%Y-%m')
ORDER BY PaymentMonth;

-- 2.16 Count of students per priority level
SELECT PriorityLevel, COUNT(*) AS StudentCount
FROM Students
GROUP BY PriorityLevel
ORDER BY PriorityLevel;

-- 2.17 Housing options where average room floor is above 1
SELECT h.HousingType, AVG(r.Floor) AS AvgFloor
FROM HousingOptions h
JOIN Rooms r ON h.HousingID = r.HousingID
GROUP BY h.HousingType
HAVING AvgFloor > 1;

-- 2.18 Departments with more than 1 student
SELECT Department, COUNT(*) AS StudentCount
FROM Students
GROUP BY Department
HAVING StudentCount > 1;

-- 2.19 Payment methods used by more than 2 students
SELECT PaymentMethod, COUNT(DISTINCT StudentID) AS UniqueStudents
FROM Payments
GROUP BY PaymentMethod
HAVING UniqueStudents >= 2;

-- 2.20 Total revenue per housing type from payments
SELECT h.HousingType, SUM(p.Amount) AS TotalRevenue
FROM Payments p
JOIN Students s ON p.StudentID = s.StudentID
JOIN RoomAllocations ra ON s.StudentID = ra.StudentID
JOIN Rooms r ON ra.RoomID = r.RoomID
JOIN HousingOptions h ON r.HousingID = h.HousingID
GROUP BY h.HousingType
ORDER BY TotalRevenue DESC;


-- ************************************************************
-- SECTION 3: DATA MANIPULATION
-- Demonstrating INSERT, UPDATE, and DELETE operations.
-- ************************************************************

-- ----- INSERT Operations -----

-- 3.1 Insert a new student
INSERT INTO Students (FullName, Gender, Department, YearOfStudy, PriorityLevel, Phone)
VALUES ('Vikram Patel', 'Male', 'Architecture', 2, 2, '9876543220');

-- 3.2 Insert a new housing option
INSERT INTO HousingOptions (HousingType, Capacity, Location, MonthlyFee)
VALUES ('Eco-Friendly Hostel', 50, 'Green Zone', 3800);

-- 3.3 Insert a new room into the newly created housing option
INSERT INTO Rooms (HousingID, RoomNumber, Floor, Status)
VALUES (11, 'ECO101', 1, 'Available');

-- 3.4 Insert a new room allocation for the new student
INSERT INTO RoomAllocations (StudentID, RoomID, AllocationDate, EndDate)
VALUES (11, 11, '2025-04-01', '2025-12-31');

-- 3.5 Insert a new maintenance request
INSERT INTO MaintenanceRequests (RoomID, StudentID, IssueDescription, RequestDate, Status)
VALUES (11, 11, 'Ceiling fan making noise', '2025-04-05', 'Pending');

-- 3.6 Insert a new payment record
INSERT INTO Payments (StudentID, Amount, PaymentDate, PaymentMethod, Status)
VALUES (11, 3800, '2025-04-02', 'UPI', 'Paid');

-- 3.7 Insert multiple students at once (batch insert)
INSERT INTO Students (FullName, Gender, Department, YearOfStudy, PriorityLevel, Phone) VALUES
('Meera Joshi', 'Female', 'Economics', 1, 3, '9876543221'),
('Ravi Kumar', 'Male', 'History', 3, 4, '9876543222');


-- ----- UPDATE Operations -----

-- 3.8 Update the status of a maintenance request from 'Pending' to 'In Progress'
UPDATE MaintenanceRequests
SET Status = 'In Progress'
WHERE RequestID = 1;

-- 3.9 Update a student's phone number
UPDATE Students
SET Phone = '9999999999'
WHERE StudentID = 1;

-- 3.10 Mark a payment as 'Paid'
UPDATE Payments
SET Status = 'Paid'
WHERE PaymentID = 5;

-- 3.11 Update room status from 'Available' to 'Occupied'
UPDATE Rooms
SET Status = 'Occupied'
WHERE RoomID = 11;

-- 3.12 Increase the monthly fee by 10% for all PG Accommodation
UPDATE HousingOptions
SET MonthlyFee = MonthlyFee * 1.10
WHERE HousingType = 'PG Accommodation';

-- 3.13 Update the end date for a specific room allocation
UPDATE RoomAllocations
SET EndDate = '2026-06-30'
WHERE AllocationID = 1;

-- 3.14 Update department for a student who changed majors
UPDATE Students
SET Department = 'Data Science'
WHERE StudentID = 6;

-- 3.15 Update all 'Pending' maintenance requests older than 30 days to 'Overdue'
UPDATE MaintenanceRequests
SET Status = 'Overdue'
WHERE Status = 'Pending' AND RequestDate < DATE_SUB(CURDATE(), INTERVAL 30 DAY);


-- ----- DELETE Operations -----

-- 3.16 Delete a specific payment record
DELETE FROM Payments
WHERE PaymentID = 11;

-- 3.17 Delete the maintenance request for the new student
DELETE FROM MaintenanceRequests
WHERE RequestID = 11;

-- 3.18 Delete a room allocation record
DELETE FROM RoomAllocations
WHERE AllocationID = 11;

-- 3.19 Delete a room
DELETE FROM Rooms
WHERE RoomID = 11;

-- 3.20 Delete the newly added housing option
DELETE FROM HousingOptions
WHERE HousingID = 11;

-- 3.21 Delete the batch-inserted students (clean up)
DELETE FROM Students
WHERE StudentID IN (11, 12, 13);


-- ************************************************************
-- SECTION 4: COMPLEX QUERIES
-- Queries involving JOINs, subqueries, and other advanced
-- SQL features to address complex information needs.
-- ************************************************************

-- ----- JOIN Queries -----

-- 4.1 INNER JOIN: Get student names with their allocated room numbers and housing type
SELECT
    s.FullName,
    r.RoomNumber,
    h.HousingType,
    h.Location,
    ra.AllocationDate,
    ra.EndDate
FROM Students s
INNER JOIN RoomAllocations ra ON s.StudentID = ra.StudentID
INNER JOIN Rooms r ON ra.RoomID = r.RoomID
INNER JOIN HousingOptions h ON r.HousingID = h.HousingID;

-- 4.2 LEFT JOIN: List all students and their payments (including students with no payments)
SELECT
    s.StudentID,
    s.FullName,
    p.Amount,
    p.PaymentDate,
    p.PaymentMethod,
    p.Status AS PaymentStatus
FROM Students s
LEFT JOIN Payments p ON s.StudentID = p.StudentID;

-- 4.3 LEFT JOIN: List all rooms and their maintenance requests (including rooms with no requests)
SELECT
    r.RoomID,
    r.RoomNumber,
    h.HousingType,
    m.IssueDescription,
    m.RequestDate,
    m.Status AS MaintenanceStatus
FROM Rooms r
LEFT JOIN MaintenanceRequests m ON r.RoomID = m.RoomID
LEFT JOIN HousingOptions h ON r.HousingID = h.HousingID;

-- 4.4 JOIN: Full details of maintenance requests with student and room info
SELECT
    m.RequestID,
    s.FullName AS StudentName,
    r.RoomNumber,
    h.HousingType,
    m.IssueDescription,
    m.RequestDate,
    m.Status
FROM MaintenanceRequests m
JOIN Students s ON m.StudentID = s.StudentID
JOIN Rooms r ON m.RoomID = r.RoomID
JOIN HousingOptions h ON r.HousingID = h.HousingID
ORDER BY m.RequestDate DESC;

-- 4.5 JOIN: Show each student's payment alongside their housing fee for comparison
SELECT
    s.FullName,
    h.HousingType,
    h.MonthlyFee AS ExpectedFee,
    p.Amount AS PaidAmount,
    (h.MonthlyFee - p.Amount) AS Difference,
    p.Status AS PaymentStatus
FROM Students s
JOIN RoomAllocations ra ON s.StudentID = ra.StudentID
JOIN Rooms r ON ra.RoomID = r.RoomID
JOIN HousingOptions h ON r.HousingID = h.HousingID
JOIN Payments p ON s.StudentID = p.StudentID;


-- ----- Subquery Queries -----

-- 4.6 Subquery: Find students who have NOT made any payment
SELECT StudentID, FullName, Department
FROM Students
WHERE StudentID NOT IN (
    SELECT DISTINCT StudentID
    FROM Payments
);

-- 4.7 Subquery: Find students living in the most expensive housing option
SELECT s.FullName, s.Department, h.HousingType, h.MonthlyFee
FROM Students s
JOIN RoomAllocations ra ON s.StudentID = ra.StudentID
JOIN Rooms r ON ra.RoomID = r.RoomID
JOIN HousingOptions h ON r.HousingID = h.HousingID
WHERE h.MonthlyFee = (
    SELECT MAX(MonthlyFee)
    FROM HousingOptions
);

-- 4.8 Subquery: Find rooms that have had more maintenance requests than the average
SELECT r.RoomID, r.RoomNumber, COUNT(m.RequestID) AS RequestCount
FROM Rooms r
JOIN MaintenanceRequests m ON r.RoomID = m.RoomID
GROUP BY r.RoomID, r.RoomNumber
HAVING RequestCount > (
    SELECT AVG(req_count)
    FROM (
        SELECT COUNT(*) AS req_count
        FROM MaintenanceRequests
        GROUP BY RoomID
    ) AS avg_table
);

-- 4.9 Subquery: Find students who paid more than the average payment amount
SELECT s.FullName, p.Amount, p.PaymentDate
FROM Students s
JOIN Payments p ON s.StudentID = p.StudentID
WHERE p.Amount > (
    SELECT AVG(Amount)
    FROM Payments
);

-- 4.10 Subquery: Find housing options that have no available rooms
SELECT HousingID, HousingType, Location
FROM HousingOptions
WHERE HousingID NOT IN (
    SELECT DISTINCT HousingID
    FROM Rooms
    WHERE Status = 'Available'
);


-- ----- Advanced / Combined Queries -----

-- 4.11 View: Create a view for a student accommodation dashboard
CREATE OR REPLACE VIEW StudentAccommodationDashboard AS
SELECT
    s.StudentID,
    s.FullName,
    s.Department,
    s.YearOfStudy,
    s.PriorityLevel,
    r.RoomNumber,
    h.HousingType,
    h.MonthlyFee,
    ra.AllocationDate,
    ra.EndDate
FROM Students s
LEFT JOIN RoomAllocations ra ON s.StudentID = ra.StudentID
LEFT JOIN Rooms r ON ra.RoomID = r.RoomID
LEFT JOIN HousingOptions h ON r.HousingID = h.HousingID;

-- Query the dashboard view
SELECT * FROM StudentAccommodationDashboard;

-- 4.12 CASE statement: Categorize students by priority level description
SELECT
    StudentID,
    FullName,
    PriorityLevel,
    CASE
        WHEN PriorityLevel = 1 THEN 'Highest Priority'
        WHEN PriorityLevel = 2 THEN 'High Priority'
        WHEN PriorityLevel = 3 THEN 'Medium Priority'
        WHEN PriorityLevel = 4 THEN 'Low Priority'
        WHEN PriorityLevel = 5 THEN 'Lowest Priority'
        ELSE 'Unclassified'
    END AS PriorityDescription
FROM Students
ORDER BY PriorityLevel;

-- 4.13 CASE statement: Classify housing by affordability
SELECT
    HousingType,
    MonthlyFee,
    CASE
        WHEN MonthlyFee <= 3000 THEN 'Budget'
        WHEN MonthlyFee <= 4000 THEN 'Standard'
        WHEN MonthlyFee <= 5500 THEN 'Premium'
        ELSE 'Luxury'
    END AS AffordabilityCategory
FROM HousingOptions
ORDER BY MonthlyFee;

-- 4.14 EXISTS: Find students who have at least one pending maintenance request
SELECT s.StudentID, s.FullName, s.Department
FROM Students s
WHERE EXISTS (
    SELECT 1
    FROM MaintenanceRequests m
    WHERE m.StudentID = s.StudentID
    AND m.Status = 'Pending'
);

-- 4.15 Correlated subquery: For each student, find their most recent payment date
SELECT
    s.StudentID,
    s.FullName,
    (SELECT MAX(p.PaymentDate)
     FROM Payments p
     WHERE p.StudentID = s.StudentID) AS MostRecentPayment,
    (SELECT SUM(p.Amount)
     FROM Payments p
     WHERE p.StudentID = s.StudentID) AS TotalPaid
FROM Students s;

-- 4.16 UNION: Combined list of all pending maintenance and pending payments
SELECT
    'Maintenance' AS RequestType,
    s.FullName,
    m.IssueDescription AS Details,
    m.RequestDate AS Date,
    m.Status
FROM MaintenanceRequests m
JOIN Students s ON m.StudentID = s.StudentID
WHERE m.Status = 'Pending'
UNION ALL
SELECT
    'Payment' AS RequestType,
    s.FullName,
    CONCAT('Amount: ', p.Amount) AS Details,
    p.PaymentDate AS Date,
    p.Status
FROM Payments p
JOIN Students s ON p.StudentID = s.StudentID
WHERE p.Status = 'Pending';

-- 4.17 Multi-table JOIN with aggregation: Room occupancy report per housing type
SELECT
    h.HousingType,
    h.Capacity AS TotalCapacity,
    COUNT(CASE WHEN r.Status = 'Occupied' THEN 1 END) AS OccupiedRooms,
    COUNT(CASE WHEN r.Status = 'Available' THEN 1 END) AS AvailableRooms,
    COUNT(r.RoomID) AS TotalRooms
FROM HousingOptions h
LEFT JOIN Rooms r ON h.HousingID = r.HousingID
GROUP BY h.HousingID, h.HousingType, h.Capacity
ORDER BY h.HousingType;

-- 4.18 Window function (RANK): Rank students by priority within their department
SELECT
    FullName,
    Department,
    PriorityLevel,
    RANK() OVER (PARTITION BY Department ORDER BY PriorityLevel ASC) AS PriorityRank
FROM Students;

-- 4.19 Window function (ROW_NUMBER): Number all maintenance requests chronologically per room
SELECT
    r.RoomNumber,
    m.IssueDescription,
    m.RequestDate,
    m.Status,
    ROW_NUMBER() OVER (PARTITION BY m.RoomID ORDER BY m.RequestDate) AS RequestSequence
FROM MaintenanceRequests m
JOIN Rooms r ON m.RoomID = r.RoomID;

-- 4.20 Comprehensive student report: Complete student profile with accommodation and financial summary
SELECT
    s.StudentID,
    s.FullName,
    s.Gender,
    s.Department,
    s.YearOfStudy,
    s.PriorityLevel,
    r.RoomNumber,
    h.HousingType,
    h.Location,
    h.MonthlyFee,
    ra.AllocationDate,
    ra.EndDate,
    COALESCE(pay_summary.TotalPaid, 0) AS TotalPaid,
    COALESCE(pay_summary.PaymentCount, 0) AS PaymentCount,
    COALESCE(maint_summary.MaintenanceRequests, 0) AS MaintenanceRequests,
    COALESCE(maint_summary.PendingRequests, 0) AS PendingRequests
FROM Students s
LEFT JOIN RoomAllocations ra ON s.StudentID = ra.StudentID
LEFT JOIN Rooms r ON ra.RoomID = r.RoomID
LEFT JOIN HousingOptions h ON r.HousingID = h.HousingID
LEFT JOIN (
    SELECT
        StudentID,
        SUM(Amount) AS TotalPaid,
        COUNT(*) AS PaymentCount
    FROM Payments
    WHERE Status = 'Paid'
    GROUP BY StudentID
) AS pay_summary ON s.StudentID = pay_summary.StudentID
LEFT JOIN (
    SELECT
        StudentID,
        COUNT(*) AS MaintenanceRequests,
        SUM(CASE WHEN Status = 'Pending' THEN 1 ELSE 0 END) AS PendingRequests
    FROM MaintenanceRequests
    GROUP BY StudentID
) AS maint_summary ON s.StudentID = maint_summary.StudentID
ORDER BY s.PriorityLevel ASC, s.FullName;

-- ============================================================
-- END OF QUERY DEVELOPMENT
-- ============================================================
