WITH CTE_Interpretation AS (SELECT * 
FROM [geochron].[TBL_Interpretation_HIS_Interpretation_History]
UNION
SELECT * FROM 
[geochron].[TBL_Interpretation_HIS_Interpretation]), 

	CTE_AGE AS (SELECT 
		AGE.AgeID AS [AgeID], 
		'Age' AS [Column], 
		CASE WHEN CTE_Interpretation.InterpretationID = LAG(CTE_Interpretation.InterpretationID) over (ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) 
			THEN LAG(Age) OVER(ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) END AS [FROM], 
		Age AS [TO], 
		CTE_Interpretation.ModifiedBy, 
		CTE_Interpretation.ModifiedDate,
		CTE_Interpretation.ValidFrom, 
		CTE_Interpretation.ValidTo
	FROM CTE_Interpretation
	LEFT JOIN [geochron].[TBL_Age_HIS_Age] AGE ON AGE.InterpretationID = CTE_Interpretation.InterpretationID),

	CTE_ERRORPLUS AS (SELECT
		AGE.AgeID AS [AgeID], 
		'Error+' as [Column], 
		CASE WHEN CTE_Interpretation.InterpretationID = LAG(CTE_Interpretation.InterpretationID) OVER (ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) 
			THEN LAG(ErrorPlus) OVER(ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) END AS [FROM],
		[ErrorPlus] AS [TO], 
		CTE_Interpretation.ModifiedBy, 
		CTE_Interpretation.ModifiedDate,
		CTE_Interpretation.ValidFrom, 
		CTE_Interpretation.ValidTo
		FROM CTE_Interpretation
		LEFT JOIN [geochron].[TBL_Age_HIS_Age] AGE ON AGE.InterpretationID = CTE_Interpretation.InterpretationID), 

	CTE_ERRORMINUS AS (SELECT
		AGE.AgeID AS [AgeID], 
		'Error-' as [Column], 
		CASE WHEN CTE_Interpretation.InterpretationID = LAG(CTE_Interpretation.InterpretationID) OVER (ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) 
			THEN LAG(ErrorMinus) OVER(ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) END AS [FROM],
		[ErrorMinus] AS [TO], 
		CTE_Interpretation.ModifiedBy, 
		CTE_Interpretation.ModifiedDate,
		CTE_Interpretation.ValidFrom, 
		CTE_Interpretation.ValidTo
		FROM CTE_Interpretation
		LEFT JOIN [geochron].[TBL_Age_HIS_Age] AGE ON AGE.InterpretationID = CTE_Interpretation.InterpretationID), 

	CTE_ProbFit AS (SELECT
		AGE.AgeID AS [AgeID], 
		'ProbFit' as [Column], 
		CASE WHEN CTE_Interpretation.InterpretationID = LAG(CTE_Interpretation.InterpretationID) OVER (ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) 
			THEN LAG(ProbabilityOfFit) OVER(ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) END AS [FROM],
		[ProbabilityOfFit] AS [TO], 
		CTE_Interpretation.ModifiedBy, 
		CTE_Interpretation.ModifiedDate,
		CTE_Interpretation.ValidFrom, 
		CTE_Interpretation.ValidTo
		FROM CTE_Interpretation
		LEFT JOIN [geochron].[TBL_Age_HIS_Age] AGE ON AGE.InterpretationID = CTE_Interpretation.InterpretationID), 

	CTE_MSWD AS (SELECT
		AGE.AgeID AS [AgeID], 
		'MSWD' as [Column], 
		CASE WHEN CTE_Interpretation.InterpretationID = LAG(CTE_Interpretation.InterpretationID) OVER (ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) 
			THEN LAG([MSWD]) OVER(ORDER BY CTE_Interpretation.InterpretationID, CTE_Interpretation.ModifiedDate) END AS [FROM],
		[MSWD] AS [TO], 
		CTE_Interpretation.ModifiedBy, 
		CTE_Interpretation.ModifiedDate,
		CTE_Interpretation.ValidFrom, 
		CTE_Interpretation.ValidTo
		FROM CTE_Interpretation
		LEFT JOIN [geochron].[TBL_Age_HIS_Age] AGE ON AGE.InterpretationID = CTE_Interpretation.InterpretationID)


--SELECT * FROM CTE_AGE WHERE [FROM] IS NOT NULL AND [FROM] != [TO] UNION
--SELECT * FROM CTE_ERRORPLUS WHERE [FROM] IS NOT NULL AND [FROM] != [TO] UNION
--SELECT * FROM CTE_ERRORMINUS WHERE [FROM] IS NOT NULL --AND [FROM] != [TO] UNION
SELECT * FROM CTE_ProbFit WHERE [FROM] IS NOT NULL AND [FROM] != [TO] UNION
SELECT * FROM CTE_MSWD WHERE [FROM] IS NOT NULL AND [FROM] != [TO]
ORDER BY AgeID



	
