-- Summing up the amount produced
SELECT SUM(Amount_Produced) AS Total_Production FROM Production;

-- Summing up the theoretical production
SELECT SUM("Theoretical Production") AS Production_Planned FROM Production;

-- Summing up the amount rejected
SELECT SUM(Amount_Rejected) AS Total_Rejected FROM Production;

-- Summing up the total hours
SELECT SUM("Total Hours") AS Total_Hours FROM Production;

-- Calculating productive hours (excluding rows with an event number)
SELECT SUM("Total Hours") AS Uptime FROM Production WHERE Event_Number IS NULL;

-- Calculating downtime
SELECT SUM("Total Hours") - (SELECT SUM("Total Hours")FROM Production WHERE Event_Number IS NULL) AS Downtime FROM Production;

-- Calculating availability
SELECT
    (Productive_Hours / Total_Hours)*100 AS Availability
FROM (
    SELECT(SELECT SUM("Total Hours") FROM Production WHERE Event_Number IS NULL) AS Productive_Hours, 
	SUM("Total Hours") AS Total_Hours FROM Production) AS Subquery;

-- Calculating performance
SELECT (SUM(Amount_Produced) / SUM("Theoretical Production")*100) AS Performance FROM Production;

-- Calculating quality
SELECT
    (Total_Produced) / (Total_Produced + Total_Rejected)*100 AS Quality
FROM (
    SELECT SUM(Amount_Produced) AS Total_Produced, SUM(Amount_Rejected) AS Total_Rejected FROM Production) AS Subquery;

-- Calculating Overall Equipment Effectiveness (OEE)
SELECT
    Availability * Performance * Quality * 100 AS Overall_Equipment_Effectiveness
FROM (
    SELECT
        Productive_Hours  / Total_Hours AS Availability,
        Total_Produced  / Total_Theoretical_Produced AS Performance,
        Total_Produced / (Total_Produced + Total_Rejected) AS Quality
    FROM (
        SELECT
            (SELECT SUM("Total Hours") FROM Production WHERE Event_Number IS NULL) AS Productive_Hours,
            SUM("Total Hours") AS Total_Hours,
            SUM(Amount_Produced) AS Total_Produced,
            SUM("Theoretical Production") AS Total_Theoretical_Produced,
            SUM(Amount_Rejected) AS Total_Rejected
        FROM Production
    ) AS SubQuery
) AS OEE_SubQuery;
