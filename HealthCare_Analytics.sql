

---- Healthcare Analytics Queries:
USE HealthcareDB;


 -- Patient Demographics: Retrieve the number of patients grouped by gender and calculate the average age of patients.

SELECT `Gender`, 
    COUNT(*) AS NumberOfPatients,
    AVG(`Age`) AS Average_Age 
FROM `Patients`
GROUP BY `Gender`;


 -- Hospital Utilization: Identify hospitals with the highest number of admissions.

SELECT 
    h.HospitalID, h.HospitalName,
    COUNT(a.AdmissionID) AS Number_of_Admissions
FROM `Hospitals` h
JOIN `Admissions` a
    ON h.HospitalID = a.HospitalID
GROUP BY 
    h.HospitalID,
    h.HospitalName
ORDER BY 
    Number_of_Admissions DESC;


-- Treatment Costs: Calculate the total cost of treatments provided at each hospital.

SELECT h.`HospitalID`, h.`HospitalName`, SUM(t.`Cost`) From `Hospitals` h
JOIN `Admissions` a
ON h.`HospitalID` = a.`HospitalID`
JOIN `Treatments` t
ON a.`AdmissionID` = t.`AdmissionID`
GROUP BY h.`HospitalID`,h.`HospitalName`;

-- Length of Stay Analysis: Extract the average length of stay for patients grouped by hospital.

SELECT 
   h.`HospitalID`, h.`HospitalName`,
   AVG(DATEDIFF(a.`DischargeDate`, a.`AdmissionDate`)) AS Average_Length_of_Stay
FROM `Hospitals` h
JOIN `Admissions` a
ON h.`HospitalID` = a.`HospitalID`
GROUP BY 
    h.`HospitalID`,
    h.`HospitalName`;


-- Advanced Filtering:

 -- List all patients who stayed longer than 7 days in any hospital.

SELECT 
   p.`PatientID`, p.`FullName`,
   a.`AdmissionID`, a.`HospitalID`, a.`AdmissionDate`, a.`DischargeDate`,
   DATEDIFF(a.`DischargeDate`, a.`AdmissionDate`) AS Length_of_Stay
   from `Patients` p
   JOIN `Admissions` a
   On p.`PatientID`=a.`PatientID`
   WHERE DATEDIFF(a.`DischargeDate`, a.`AdmissionDate`) > 7;
    

-- Identify treatments that have been performed more than 5 times across all hospitals.

SELECT 
    t.`ProcedureName`,
    COUNT(t.`TreatmentID`) AS NumberofTimes
FROM `Admissions` a
JOIN `Treatments` t
    ON a.`AdmissionID` = t.`AdmissionID`
GROUP BY t.`ProcedureName`
HAVING COUNT(t.`TreatmentID`) > 5;


-- Combining Data:

  -- Combine admission and treatment data to display complete patient histories.

SELECT 
  p.`PatientID`, p.`FullName`, p.`Gender`, p.`Age`, p.`Address`,
  a.`AdmissionID`, a.`HospitalID`, a.`AdmissionDate`, a.`DischargeDate`, a.`ReasonForAdmission`,
  t.`TreatmentID`, t.`Cost`, t.`ProcedureName`, t.`Outcome`  
  FROM `Patients` p
  JOIN `Admissions` a 
  ON p.`PatientID` = a.`PatientID`
  JOIN `Treatments` t
  ON a.`AdmissionID`= t.`AdmissionID`

  -- Combine lists of patients admitted for different reasons (e.g., surgery and therapy).
SELECT 
    p.`PatientID`,
    p.`FullName`,
    a.`AdmissionID`,
    a.`ReasonForAdmission`
FROM `Patients` p
JOIN `Admissions` a 
    ON p.`PatientID` = a.`PatientID`
WHERE a.`ReasonForAdmission` IN ('Surgery', 'Therapy');
  

-- Subqueries and Views:

  --Use a subquery to find the hospital with the highest average treatment cost.
SELECT *
FROM (
    SELECT 
        h.`HospitalID`,
        h.`HospitalName`,
        AVG(t.`Cost`) AS Average_Treatment_Cost
    FROM `Hospitals` h
    JOIN `Admissions` a
        ON h.`HospitalID` = a.`HospitalID`
    JOIN `Treatments` t
        ON a.`AdmissionID` = t.`AdmissionID`
    GROUP BY 
        h.`HospitalID`,
        h.`HospitalName`
    ORDER BY 
        Average_Treatment_Cost DESC
    LIMIT 1
) AS HospitalAverage;


-- Create a view named HospitalPerformance to display the total number of admissions, average length of stay, and total revenue generated for each hospital.

CREATE VIEW HospitalPerformance AS
SELECT
    h.`HospitalID`,
    h.`HospitalName`,
    COUNT(DISTINCT a.`AdmissionID`) AS Total_Admissions,
    AVG(DATEDIFF(a.`DischargeDate`, a.`AdmissionDate`)) AS Average_Length_of_Stay,
    SUM(t.`Cost`) AS Total_Revenue
FROM `Hospitals` h
LEFT JOIN `Admissions` a
    ON h.`HospitalID` = a.`HospitalID`
LEFT JOIN `Treatments` t
    ON a.`AdmissionID` = t.`AdmissionID`
GROUP BY
    h.`HospitalID`,
    h.`HospitalName`;

SELECT * FROM hospitalperformance;


-- Window Functions:

  --Use the RANK function to rank hospitals based on their total revenue.
    SELECT
    h.HospitalID,
    h.HospitalName,
    SUM(t.Cost) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(t.Cost) DESC) AS Revenue_Rank
FROM Hospitals h
JOIN Admissions a
    ON h.HospitalID = a.HospitalID
JOIN Treatments t
    ON a.AdmissionID = t.AdmissionID
GROUP BY h.HospitalID, h.HospitalName
ORDER BY Revenue_Rank;


 -- Use DENSE_RANK to rank treatments based on their frequency.

  SELECT
    t.ProcedureName,
    COUNT(t.TreatmentID) AS Frequency,
    DENSE_RANK() OVER (
        ORDER BY COUNT(t.TreatmentID) DESC
    ) AS Treatment_Rank
FROM Treatments t
GROUP BY t.ProcedureName
ORDER BY Treatment_Rank;



