/*
===============================================================================
Author  : Vikas Rana  
Project : SQL Live Laptops EDA + Cleaning + Feature Engineering  
Table   : [dbo].[sql_cx_live_laptops]  
===============================================================================
*/

--------------------------------------------------------------------------------
-- Q1: Show first 10 rows (Head)
--------------------------------------------------------------------------------
SELECT TOP 10 * 
FROM [dbo].[sql_cx_live_laptops];

--------------------------------------------------------------------------------
-- Q2: Show last 10 rows (Tail)  
-- SQL Server doesn’t have direct tail, so we use ORDER BY DESC + TOP
--------------------------------------------------------------------------------
WITH OrderedData AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM [dbo].[sql_cx_live_laptops]
)
SELECT *
FROM OrderedData
WHERE rn > (SELECT COUNT(*)-10 FROM [dbo].[sql_cx_live_laptops])
ORDER BY rn;


-- schecma check
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sql_cx_live_laptops';

--------------------------------------------------------------------------------
-- Q3: Random sample of 10 rows
--------------------------------------------------------------------------------
SELECT TOP 10 * 
FROM [dbo].[sql_cx_live_laptops]
ORDER BY NEWID();

--------------------------------------------------------------------------------
-- Q4: Dataset shape (row count, column count)
--------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_rows
FROM [dbo].[sql_cx_live_laptops];

SELECT 
    COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sql_cx_live_laptops';

--------------------------------------------------------------------------------
-- Q5: Check NULL / missing values in each column
--------------------------------------------------------------------------------
SELECT 
    SUM(CASE WHEN Company IS NULL THEN 1 ELSE 0 END) AS Company_Nulls,
    SUM(CASE WHEN TypeName IS NULL THEN 1 ELSE 0 END) AS TypeName_Nulls,
    SUM(CASE WHEN Inches IS NULL THEN 1 ELSE 0 END) AS Inches_Nulls,
    SUM(CASE WHEN ScreenResolution IS NULL THEN 1 ELSE 0 END) AS ScreenResolution_Nulls,
    SUM(CASE WHEN Cpu IS NULL THEN 1 ELSE 0 END) AS Cpu_Nulls,
    SUM(CASE WHEN Ram IS NULL THEN 1 ELSE 0 END) AS Ram_Nulls,
    SUM(CASE WHEN Memory IS NULL THEN 1 ELSE 0 END) AS Memory_Nulls,
    SUM(CASE WHEN Gpu IS NULL THEN 1 ELSE 0 END) AS Gpu_Nulls,
    SUM(CASE WHEN OpSys IS NULL THEN 1 ELSE 0 END) AS OpSys_Nulls,
    SUM(CASE WHEN Weight IS NULL THEN 1 ELSE 0 END) AS Weight_Nulls,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Price_Nulls,
    SUM(CASE WHEN Resolution_Width IS NULL THEN 1 ELSE 0 END) AS Resolution_Width_Nulls,
    SUM(CASE WHEN Resolution_Height IS NULL THEN 1 ELSE 0 END) AS Resolution_Height_Nulls,
    SUM(CASE WHEN Touchscreen IS NULL THEN 1 ELSE 0 END) AS Touchscreen_Nulls,
    SUM(CASE WHEN Gpu_Brand IS NULL THEN 1 ELSE 0 END) AS Gpu_Brand_Nulls,
    SUM(CASE WHEN Gpu_Name IS NULL THEN 1 ELSE 0 END) AS Gpu_Name_Nulls,
    SUM(CASE WHEN Memory_Cleaned IS NULL THEN 1 ELSE 0 END) AS Memory_Cleaned_Nulls,
    SUM(CASE WHEN Cpu_Brand IS NULL THEN 1 ELSE 0 END) AS Cpu_Brand_Nulls,
    SUM(CASE WHEN Cpu_Model IS NULL THEN 1 ELSE 0 END) AS Cpu_Model_Nulls
FROM [dbo].[sql_cx_live_laptops];

-- (SQL Server needs dynamic SQL for full null check across all columns)

--------------------------------------------------------------------------------
-- Q6: Unique values per column (for categorical overview)
--------------------------------------------------------------------------------
SELECT 'Company' AS ColumnName, COUNT(DISTINCT Company) AS unique_values FROM [dbo].[sql_cx_live_laptops]
UNION ALL
SELECT 'TypeName', COUNT(DISTINCT TypeName) FROM [dbo].[sql_cx_live_laptops]
UNION ALL
SELECT 'ScreenResolution', COUNT(DISTINCT ScreenResolution) FROM [dbo].[sql_cx_live_laptops]
UNION ALL
SELECT 'Cpu', COUNT(DISTINCT Cpu) FROM [dbo].[sql_cx_live_laptops]
UNION ALL
SELECT 'Gpu', COUNT(DISTINCT Gpu) FROM [dbo].[sql_cx_live_laptops];

--------------------------------------------------------------------------------
-- Q7: Descriptive statistics of numerical column (Price_euros)
--------------------------------------------------------------------------------
SELECT 
    MIN(Price) AS min_price,
    MAX(Price) AS max_price,
    AVG(Price) AS avg_price,
    STDEV(Price) AS stddev_price,
    COUNT(*) AS total_count
FROM [dbo].[sql_cx_live_laptops];





--------------------------------------------------------------------------------
-- Q8: Outlier detection (IQR method for Price)
--------------------------------------------------------------------------------
WITH stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER() AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER() AS Q3
    FROM [dbo].[sql_cx_live_laptops]
)
SELECT s.Q1, s.Q3, (s.Q3-s.Q1) AS IQR,
       (s.Q1 - 1.5*(s.Q3-s.Q1)) AS lower_bound,
       (s.Q3 + 1.5*(s.Q3-s.Q1)) AS upper_bound
FROM stats s;

--------------------------------------------------------------------------------
-- Q9: Bucketizing Price into ranges
--------------------------------------------------------------------------------
SELECT 
    Price,
    CASE 
        WHEN Price < 500 THEN 'Low (<500)'
        WHEN Price BETWEEN 500 AND 1000 THEN 'Medium (500-1000)'
        WHEN Price BETWEEN 1000 AND 1500 THEN 'High (1000-1500)'
        ELSE 'Premium (>1500)'
    END AS price_bucket
FROM [dbo].[sql_cx_live_laptops];

--------------------------------------------------------------------------------
-- Q10: Cleaning - OS Standardization
--------------------------------------------------------------------------------
SELECT DISTINCT OpSys FROM [dbo].[sql_cx_live_laptops];

UPDATE [dbo].[sql_cx_live_laptops]
SET OpSys = CASE
    WHEN OpSys LIKE '%mac%' THEN 'macOS'
    WHEN OpSys LIKE '%windows%' THEN 'Windows'
    WHEN OpSys LIKE '%linux%' THEN 'Linux'
    ELSE 'Other'
END;

--------------------------------------------------------------------------------
-- Q11: CPU Feature Engineering
--------------------------------------------------------------------------------
ALTER TABLE [dbo].[sql_cx_live_laptops]
ADD Cpu_Brand NVARCHAR(50), Cpu_Model NVARCHAR(100);

UPDATE [dbo].[sql_cx_live_laptops]
SET Cpu_Brand = LEFT(Cpu, CHARINDEX(' ', Cpu)-1),
    Cpu_Model = SUBSTRING(Cpu, CHARINDEX(' ', Cpu)+1, LEN(Cpu));

--------------------------------------------------------------------------------
-- Q12: GPU Feature Engineering
--------------------------------------------------------------------------------
ALTER TABLE [dbo].[sql_cx_live_laptops]
ADD Gpu_Model NVARCHAR(100);

UPDATE [dbo].[sql_cx_live_laptops]
SET Gpu_Brand = LEFT(Gpu, CHARINDEX(' ', Gpu)-1),
    Gpu_Model = SUBSTRING(Gpu, CHARINDEX(' ', Gpu)+1, LEN(Gpu));

--------------------------------------------------------------------------------
-- Q13: Memory Feature Engineering (simplified: keep only GB size + type)
--------------------------------------------------------------------------------
ALTER TABLE [dbo].[sql_cx_live_laptops]
ADD Memory_Cleaned NVARCHAR(50);

SELECT DISTINCT Memory
FROM [dbo].[sql_cx_live_laptops]
WHERE ISNUMERIC(REPLACE(REPLACE(REPLACE(Memory,'TB',''),'GB',''),' ',''))
      = 0;


UPDATE [dbo].[sql_cx_live_laptops]
SET Memory_Cleaned = 
    CASE 
        WHEN Memory LIKE '%TB%' 
             AND ISNUMERIC(REPLACE(REPLACE(Memory,'TB',''),' ',''))
        = 1
        THEN CAST(REPLACE(REPLACE(Memory,'TB',''),' ','') AS FLOAT) * 1024

        WHEN Memory LIKE '%GB%'
             AND ISNUMERIC(REPLACE(REPLACE(Memory,'GB',''),' ',''))
        = 1
        THEN CAST(REPLACE(REPLACE(Memory,'GB',''),' ','') AS FLOAT)

        ELSE NULL
    END;


--------------------------------------------------------------------------------
-- Q14: One-hot Encoding for categorical vars (example: Company)
--------------------------------------------------------------------------------
SELECT *,
    CASE WHEN Company = 'Dell' THEN 1 ELSE 0 END AS is_Dell,
    CASE WHEN Company = 'HP' THEN 1 ELSE 0 END AS is_HP,
    CASE WHEN Company = 'Lenovo' THEN 1 ELSE 0 END AS is_Lenovo
FROM [dbo].[sql_cx_live_laptops];

--------------------------------------------------------------------------------
-- Q15: Final Check - Clean dataset preview
--------------------------------------------------------------------------------
SELECT TOP 20 * 
FROM [dbo].[sql_cx_live_laptops];

