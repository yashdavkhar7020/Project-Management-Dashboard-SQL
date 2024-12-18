Database Schema

-- Create the database
CREATE DATABASE project_management_dashboard;

-- Use the database
USE project_management_dashboard;

-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(255) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50)
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeName VARCHAR(255) NOT NULL,
    Role VARCHAR(50),
    Availability VARCHAR(50)
);

-- Create Tasks table
CREATE TABLE Tasks (
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT,
    TaskName VARCHAR(255) NOT NULL,
    AssignedTo INT,
    HoursWorked FLOAT,
    Status VARCHAR(50),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (AssignedTo) REFERENCES Employees(EmployeeID)
);

-- Create TimeLogs table
CREATE TABLE TimeLogs (
    TimeLogID INT AUTO_INCREMENT PRIMARY KEY,
    TaskID INT,
    EmployeeID INT,
    HoursWorked FLOAT,
    Date DATE,
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
Sample Data Insertion

-- Insert sample data into Projects table
INSERT INTO Projects (ProjectName, StartDate, EndDate, Status) VALUES
('Project Alpha', '2024-01-01', '2024-06-01', 'In Progress'),
('Project Beta', '2024-02-01', '2024-07-01', 'Completed');

-- Insert sample data into Employees table
INSERT INTO Employees (EmployeeName, Role, Availability) VALUES
('Alice Johnson', 'Developer', 'Available'),
('Bob Smith', 'Designer', 'Available'),
('Carol White', 'Project Manager', 'Busy');

-- Insert sample data into Tasks table
INSERT INTO Tasks (ProjectID, TaskName, AssignedTo, HoursWorked, Status) VALUES
(1, 'Task 1', 1, 10, 'In Progress'),
(1, 'Task 2', 2, 5, 'Completed'),
(2, 'Task 3', 1, 20, 'Completed'),
(2, 'Task 4', 3, 15, 'In Progress');

-- Insert sample data into TimeLogs table
INSERT INTO TimeLogs (TaskID, EmployeeID, HoursWorked, Date) VALUES
(1, 1, 5, '2024-03-01'),
(1, 1, 5, '2024-03-02'),
(2, 2, 5, '2024-03-01'),
(3, 1, 10, '2024-04-01'),
(3, 1, 10, '2024-04-02'),
(4, 3, 15, '2024-05-01');

SELECT ProjectID, 
       ProjectName, 
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedTasks,
       COUNT(TaskID) AS TotalTasks,
       (SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) / COUNT(TaskID)) * 100 AS CompletionRate
FROM Tasks
GROUP BY ProjectID, ProjectName;

SELECT EmployeeID, 
       EmployeeName, 
       COUNT(TaskID) AS AssignedTasks,
       SUM(HoursWorked) AS TotalHours
FROM Tasks
JOIN Employees ON Tasks.AssignedTo = Employees.EmployeeID
GROUP BY EmployeeID, EmployeeName;
Automated Alerts (Trigger)

CREATE TRIGGER ProjectStatusUpdate
AFTER UPDATE ON Tasks
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Completed' THEN
    UPDATE Projects
    SET Status = 'In Progress'
    WHERE ProjectID = NEW.ProjectID
    AND NOT EXISTS (SELECT 1 FROM Tasks WHERE ProjectID = NEW.ProjectID AND Status <> 'Completed');
  END IF;
END;
