--HealthCare_Dataset Break Down

SELECT *
FROM dbo.healthcare_dataset

--Patient information

SELECT Name, Age, Gender, [Blood Type], [Medical Condition]
FROM dbo.healthcare_dataset

--Distinct Medical Conditions

SELECT DISTINCT [Medical Condition]
FROM dbo.healthcare_dataset

----The Number of patient in each distinct Medical Condtition

SELECT Distinct [Medical Condition], COUNT(*) as Condition_count
FROM dbo.healthcare_dataset
Group By [Medical Condition]

--Total Billing Amount For Each Hospital
--Round of to two decimals

SELECT Hospital, Round(SUM([Billing Amount]),2) AS Total_billing_amount
FROM dbo.healthcare_dataset
Group by Hospital

--TOP 200 Patients with High Billing Amount

SELECT TOP 200 Name, ROUND([Billing Amount],2) AS Highest_billing_amount
FROM dbo.healthcare_dataset
WHERE [Billing Amount]> 20000
Order by [Billing Amount] DESC

--Number of patients for each Blood Type

SELECT DISTINCT [Blood Type], COUNT(*) AS Total_Patients_Blood_Type
FROM dbo.healthcare_dataset
GROUP BY [Blood Type]

--Average Age of Male and Female Patients

SELECT Gender, Round(AVG(Age),2) as Avg_age
FROM dbo.healthcare_dataset
GROUP BY Gender

---Latest Admission Date for Each Patient

SELECT Name, Max([Date of Admission]) AS Latest_Admission_Date
FROM dbo.healthcare_dataset
Group By Name, [Date of Admission]
ORDER BY [Date of Admission] Desc

---Top 5 Medical Conditions by Frequency

SELECT TOP 5 [Medical Condition], Count(*) AS Count_Condition 
FROM dbo.healthcare_dataset
Group By [Medical Condition]
Order by Count_Condition desc

---Patients with no Insurance Providers
 
SELECT Name, [Insurance Provider]
FROM dbo.healthcare_dataset
where [Insurance Provider] is Null

---Average Billing Amount for each Admission Type

SELECT [Admission Type], Round(AVG([Billing Amount]),2) as Avg_billing_amount
FROM dbo.healthcare_dataset
GROUP BY [Admission Type]
ORDER BY [Admission Type] DESC

---Common Table Expression
---Ranking of patients based on billing amount within each hospital

With RankedPatient as (
	SELECT TOP 100 Name, [Billing Amount], Hospital,
	RANK() OVER(Partition By Hospital ORDER BY [Billing Amount] Desc) As Billing_rank
	FROM dbo.healthcare_dataset
	)
SELECT Name, [Billing Amount], Hospital, Billing_rank
FROM RankedPatient
WHERE Billing_rank = 1;

--Case Statement
--How many patients are universal donor and above 40 years

SELECT DISTINCT [Blood Type], COUNT(*) AS Total_Patients_Blood_Type,
	CASE
		WHEN [Blood Type] = 'O+' THEN 'Universal Donor'
		when [Blood Type] = 'O-' THEN 'Universal Donor'
		ELSE null
	END AS Universal_donors
FROM dbo.healthcare_dataset
Where Age > 40 
Group by [Blood type]

--Patient using Medicare Insurance Provider with urgent admission type

SELECT Name, [Insurance Provider], [Admission Type]
FROM dbo.healthcare_dataset
Where [Insurance Provider] = 'Medicare' AND [Admission Type] = 'Urgent'

--- Using Wildcats to Search Bryan Moyer Details

SELECT *
FROM dbo.healthcare_dataset
Where Name like '%Bryan Moyer%'

--Percentage of Patients based on Medical Condition  

SELECT [Medical Condition], Count(*) as total_condition, COUNT(*) * 100/ (SELECT COUNT (*) FROM dbo.healthcare_dataset) AS Percentage
FROM dbo.healthcare_dataset
GROUP BY [Medical Condition];

SELECT *
FROM dbo.healthcare_dataset