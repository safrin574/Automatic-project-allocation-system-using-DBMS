CREATE DATABASE student2;
USE student2;

-- Students Table
CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(100)
);

-- Advisors Table
CREATE TABLE Advisors (
    AdvisorID INT PRIMARY KEY,
    AdvisorName VARCHAR(100),
    Department VARCHAR(100)
);


-- Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectTitle VARCHAR(200),
    MaxStudents INT,
    AdvisorID INT,
    FOREIGN KEY (AdvisorID) REFERENCES Advisors(AdvisorID)
);

-- Project Allocations Table
CREATE TABLE ProjectAllocations (
    AllocationID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    ProjectID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

DELIMITER //

CREATE PROCEDURE Students(
    IN p_StudentName VARCHAR(100)
)
BEGIN
    DECLARE v_StudentID INT;
    DECLARE v_ProjectID INT;

    -- Step 1: Add student
    INSERT INTO Students (StudentName) VALUES (p_StudentName);
    SET v_StudentID = LAST_INSERT_ID();

    -- Step 2: Pick a random available project
    SELECT ProjectID INTO v_ProjectID
    FROM Projects p
    WHERE (
        SELECT COUNT(*) FROM ProjectAllocations pa WHERE pa.ProjectID = p.ProjectID
    ) < p.MaxStudents
    ORDER BY RAND()
    LIMIT 1;

    -- Step 3: Allocate only if project available
    IF v_ProjectID IS NOT NULL THEN
        INSERT INTO ProjectAllocations (StudentID, ProjectID)
        VALUES (v_StudentID, v_ProjectID);
    END IF;
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_BeforeInsertAllocation
BEFORE INSERT ON ProjectAllocations
FOR EACH ROW
BEGIN
    DECLARE currentCount INT;
    DECLARE maxAllowed INT;

    SELECT COUNT(*) INTO currentCount
    FROM ProjectAllocations
    WHERE ProjectID = NEW.ProjectID;

    SELECT MaxStudents INTO maxAllowed
    FROM Projects
    WHERE ProjectID = NEW.ProjectID;

    IF currentCount >= maxAllowed THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot allocate: Project is full';
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE AddAdvisor (
    IN p_AdvisorID INT,
    IN p_AdvisorName VARCHAR(100),
    IN p_Department VARCHAR(100)
)
BEGIN
    INSERT INTO Advisors (AdvisorID, AdvisorName, Department)
    VALUES (p_AdvisorID, p_AdvisorName, p_Department);
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AddProject (
    IN p_ProjectID INT,
    IN p_ProjectTitle VARCHAR(200),
    IN p_MaxStudents INT,
    IN p_AdvisorID INT
)
BEGIN
    INSERT INTO Projects (ProjectID, ProjectTitle, MaxStudents, AdvisorID)
    VALUES (p_ProjectID, p_ProjectTitle, p_MaxStudents, p_AdvisorID);
END;
//

DELIMITER ;

CREATE VIEW StudentProjectDashboard AS
SELECT 
    s.StudentID,
    s.StudentName,
    p.ProjectID,
    p.ProjectTitle,
    a.AdvisorID,
    a.AdvisorName,
    a.Department
FROM 
    Students s
JOIN 
    ProjectAllocations pa ON s.StudentID = pa.StudentID
JOIN 
    Projects p ON pa.ProjectID = p.ProjectID
JOIN 
    Advisors a ON p.AdvisorID = a.AdvisorID;

-- Advisors
INSERT INTO Advisors VALUES
(1, 'Dr. Senthil Kumar', 'AI&DS'),
(2, 'Dr. Johnson', 'Data Science'),
(3, 'Ms. Nishanandhini', 'CSE'),
(4, 'Dr. Sathish Kumar', 'AI&DS'),
(5, 'Dr. Jeevitha', 'CSE'),
(6, 'Dr. Johny Sebastine', 'AI&DS'),
(7, 'Ms.Radhika', 'CSE'),
(8, 'Ms.SubhaLakshmi', 'AI&DS'),
(9, 'Dr.Periyasamy', 'Data Science'),
(10, 'Ms.Pavithra', 'AI&DS');

-- Projects
CALL AddProject(101, 'AI Chatbot', 3, 1);
CALL AddProject(102, 'Data Mining', 3, 2);
CALL AddProject(103, 'Online Ticket Booking System', 3, 3);
CALL AddProject(104, 'Hostel Management System', 3, 4);
CALL AddProject(105, 'Online Food Delivery System', 3, 5);
CALL AddProject(106, 'Online Course Registration System', 3, 6);
CALL AddProject(107, ' Bloodbank Management System',3, 7);
CALL AddProject(108, 'Bookstore Management System', 3, 9);
CALL AddProject(109, ' Employee Attendence System', 3, 8);
CALL AddProject(110, 'AI Image Recognition  System', 3, 10);


-- Add students using automated procedure
CALL Students('Vimali Vincy M');
CALL Students('Safrin M');
CALL Students('Bhuvaneshwari N');
CALL Students('Ragavi S');
CALL Students('Priyadharshini');
CALL Students('Mathumitha CS');
CALL Students('Narkis M');
CALL Students('Prisilla thras');
CALL Students('Valarmathi G');
CALL Students('Sabitha S');
CALL Students('Pavithra');
CALL Students('Ashitha');


-- Check live dashboard
SELECT * FROM StudentProjectDashboard; 
