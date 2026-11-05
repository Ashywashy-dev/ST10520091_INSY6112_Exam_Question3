CREATE SCHEMA IF NOT EXISTS university_advising_db;

USE university_advising_db;

-- Question 1

CREATE TABLE Student (
StudentID INT PRIMARY KEY,
StudentName VARCHAR(100) NOT NULL,
StudentNumber VARCHAR(20) NOT NULL
);

-- Question 2

CREATE TABLE Advisor (
AdvisorID INT PRIMARY KEY,
AdvisorName VARCHAR(100) NOT NULL
);

-- Question 3

CREATE TABLE Advising (
AdvisingID INT PRIMARY KEY,
StudentID INT NOT NULL,
AdvisorID INT NOT NULL,
AdvisingDate DATE NOT NULL,
AdvisingTime TIME NOT NULL,
AdvisingDuration INT NOT NULL,
FOREIGN KEY (StudentID) 
REFERENCES Student(StudentID),
FOREIGN KEY (AdvisorID) 
REFERENCES Advisor(AdvisorID)
);

-- Question 4

INSERT INTO Student (StudentID, StudentName, StudentNumber)
VALUES
(1, 'Debbie Theart', '123456'),
(2, 'Thomas Ducan', '654321');

INSERT INTO Advisor (AdvisorID, AdvisorName)
VALUES
(1, 'Zintle Nukani'),
(2, 'Ravi Maharaj');

INSERT INTO Advising (AdvisingID, AdvisingDate, AdvisingTime, AdvisingDuration, AdvisorID, StudentID)
VALUES
(1, '2026-01-15', '09:00:00', 180, 2, 1),
(2, '2026-01-18', '15:00:00', 240, 2, 2),
(3, '2026-01-20', '10:00:00', 180, 1, 1),
(4, '2026-01-21', '11:00:00', 180, 2, 1);

-- Question 5

SELECT *
FROM Advising
WHERE AdvisingDate 
BETWEEN '2026-01-16' AND '2026-01-20';

-- Question 6

SELECT
SUBSTRING_INDEX(s.StudentName, ' ', 1) AS StudentFirstName,
SUBSTRING_INDEX(s.StudentName, ' ', -1) AS StudentSurname,
COUNT(a.AdvisingID) AS TotalAdvisings
FROM Student s
LEFT JOIN Advising a ON s.StudentID = a.StudentID
GROUP BY s.StudentID, s.StudentName
ORDER BY TotalAdvisings DESC;

-- Question 7

SELECT a.AdvisingDate, a.AdvisingTime,
SUBSTRING_INDEX(ad.AdvisorName, ' ', 1) AS AdvisorFirstName,
SUBSTRING_INDEX(ad.AdvisorName, ' ', -1) AS AdvisorSurname,
SUBSTRING_INDEX(s.StudentName, ' ', 1) AS StudentFirstName,
SUBSTRING_INDEX(s.StudentName, ' ', -1) AS StudentSurname
FROM Advising a
INNER JOIN Advisor ad ON a.AdvisorID = ad.AdvisorID
INNER JOIN Student s ON a.StudentID = s.StudentID
ORDER BY a.AdvisingDate DESC;

-- Question 8

CREATE OR REPLACE VIEW Advisor2Students AS
SELECT DISTINCT
SUBSTRING_INDEX(s.StudentName, ' ', 1) AS StudentFirstName,
SUBSTRING_INDEX(s.StudentName, ' ', -1) AS StudentSurname
FROM Student s
INNER JOIN Advising a ON s.StudentID = a.StudentID
WHERE a.AdvisorID = 2
ORDER BY StudentSurname ASC;

SELECT *
FROM Advisor2Students
ORDER BY StudentSurname ASC;

-- Question 9

DELIMITER //
CREATE PROCEDURE GetAdvisings(IN p_date DATE)
BEGIN
SELECT
a.AdvisingTime,
a.AdvisingDuration,
SUBSTRING_INDEX(ad.AdvisorName, ' ', 1) AS AdvisorFirstName,
SUBSTRING_INDEX(ad.AdvisorName, ' ', -1) AS AdvisorSurname,
SUBSTRING_INDEX(s.StudentName, ' ', 1) AS StudentFirstName,
SUBSTRING_INDEX(s.StudentName, ' ', -1) AS StudentSurname
FROM Advising a
INNER JOIN Advisor ad ON a.AdvisorID = ad.AdvisorID
INNER JOIN Student s ON a.StudentID = s.StudentID
WHERE a.AdvisingDate = p_date
ORDER BY a.AdvisingTime ASC;
END //
DELIMITER ;

CALL GetAdvisings('2026-01-20');
