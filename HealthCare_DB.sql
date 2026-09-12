-- Database Creation
CREATE DATABASE HealthcareDB;

Use HealthcareDB;

-- Patients Table --

CREATE TABLE Patients(
PatientID INT PRIMARY KEY AUTO_INCREMENT,
FullName VARCHAR(100),
Age INT,
Gender VARCHAR(10),
Address VARCHAR(200)
);

-- Hospital Table --

CREATE TABLE Hospitals(
HospitalID INT PRIMARY KEY AUTO_INCREMENT,
HospitalName VARCHAR(100),
Location VARCHAR(200),
Capacity INT
);

-- Admissions Table

CREATE TABLE Admissions(
AdmissionID INT Primary Key AUTO_INCREMENT,
PatientID  INT,
Foreign Key (PatientID) REFERENCES Patients(PatientID),
HospitalID INT,
Foreign Key (HospitalID) REFERENCES Hospitals(HospitalID),
AdmissionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
DischargeDate DATE,
ReasonForAdmission VARCHAR(200)
);

ALTER TABLE Admissions
MODIFY COLUMN AdmissionDate DATE NOT NULL;

-- Treatments Table

CREATE TABLE Treatments(
TreatmentID INT Primary Key AUTO_INCREMENT,
AdmissionID INT,
FOREIGN KEY (AdmissionID) REFERENCES Admissions(AdmissionID),
ProcedureName VARCHAR(100),
Cost DECIMAL,
Outcome VARCHAR(100)
);


-- Insert data into Patients table

INSERT INTO Patients (FullName, Age, Gender, Address) VALUES
('John Doe', 45, 'Male', '123 Elm Street'),
('Jane Smith', 34, 'Female', '456 Oak Avenue'),
('Sam Brown', 29, 'Male', '789 Pine Road'),
('Lisa White', 52, 'Female', '321 Maple Lane'),
('Tom Green', 67, 'Male', '654 Birch Blvd'),
('Alice Johnson', 40, 'Female', '987 Willow Court'),
('Robert Black', 60, 'Male', '564 Cypress Road'),
('Emily Davis', 25, 'Female', '321 Cedar Avenue'),
('Michael Scott', 50, 'Male', '742 Birch Lane'),
('Sarah Taylor', 33, 'Female', '159 Spruce Drive');

-- Insert data into Hospitals table
INSERT INTO Hospitals (HospitalName, Location, Capacity) VALUES
('General Hospital', 'New York', 500),
('City Clinic', 'Los Angeles', 200),
('Central Medical Center', 'Chicago', 300),
('Regional Health Facility', 'Houston', 150),
('Sunrise Hospital', 'Phoenix', 400);

-- Insert data into Admissions table
INSERT INTO Admissions (PatientID, HospitalID, AdmissionDate, DischargeDate, ReasonForAdmission) VALUES
(1, 1, '2024-11-01', '2024-11-05', 'Surgery'),
(2, 2, '2024-11-03', '2024-11-08', 'Therapy'),
(3, 3, '2024-11-10', '2024-11-15', 'Accident'),
(4, 4, '2024-11-12', '2024-11-19', 'Routine Checkup'),
(5, 5, '2024-12-01', '2024-12-08', 'Infection'),
(6, 1, '2024-12-01', NULL, 'Surgery'),
(7, 2, '2024-12-02', '2024-12-05', 'Fracture Repair'),
(8, 3, '2024-12-03', NULL, 'Chronic Illness'),
(9, 4, '2024-12-03', '2024-12-18', 'Therapy'),
(10, 5, '2024-12-04', '2024-12-18', 'Infection');

-- Insert data into Treatments table
INSERT INTO Treatments (AdmissionID, ProcedureName, Cost, Outcome) VALUES
(1, 'Appendectomy', 1500.00, 'Successful'),
(2, 'Physical Therapy', 800.00, 'Ongoing'),
(3, 'Fracture Repair', 3000.00, 'Successful'),
(4, 'Blood Test', 200.00, 'Pending'),
(5, 'Antibiotics', 500.00, 'Improved'),
(6, 'Gallbladder Surgery', 4000.00, 'Successful'),
(7, 'X-Ray', 300.00, 'Successful'),
(8, 'Chemotherapy', 5000.00, 'Ongoing'),
(9, 'MRI Scan', 1200.00, 'Pending'),
(10, 'Diabetes Treatment', 700.00, 'Improved');






