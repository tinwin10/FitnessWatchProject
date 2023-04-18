/* 
 
Bellabeat Project Exploratory Data Analysis

Skills Used: Data Transposition, Union Alls, 
Case Statements, Aggregate Functions, 
Multiple CTEs, Subqueries, Substrings, Joins

 */

-- Daily Minutes by Intensity Type √

WITH IntensityMinute AS(
SELECT 
	Id, ActivityDate, "VeryActiveMinutes" AS Intensity, VeryActiveMinutes AS Minutes
FROM
	Bellabeat.DailyActivity
UNION ALL
SELECT 
	Id, ActivityDate, "FairlyActiveMinutes" AS Intensity, FairlyActiveMinutes AS Minutes
FROM
	Bellabeat.DailyActivity
UNION ALL
SELECT 
	Id, ActivityDate, "LightlyActiveMinutes" AS Intensity, LightlyActiveMinutes AS Minutes
FROM
	Bellabeat.DailyActivity
UNION ALL	
SELECT 
	Id, ActivityDate, "SedentaryMinutes" AS Intensity, SedentaryMinutes AS Minutes
FROM
	Bellabeat.DailyActivity
)

SELECT
	CASE
		WHEN Intensity = "VeryActiveMinutes" THEN "Very Active"
		WHEN Intensity = "FairlyActiveMinutes" THEN "Moderately Active"
		WHEN Intensity = "LightlyActiveMinutes" THEN "Lightly Active"
		ELSE "Sedentary"
	END AS IntensityType,
	AVG(Minutes) AS AverageDailyMinutes
FROM NewIntensityMinutes
GROUP BY
	Intensity
ORDER BY 
	AverageDailyMinutes DESC
	
-- Percentage of Each Intensity Minutes √

WITH Total AS(
	SELECT
		SUM(Minutes) AS TotalMinutes
	FROM
		Bellabeat.NewIntensityMinutes
)
	
SELECT
	CASE
		WHEN Intensity = "VeryActiveMinutes" THEN "Very Active"
		WHEN Intensity = "FairlyActiveMinutes" THEN "Moderately Active"
		WHEN Intensity = "LightlyActiveMinutes" THEN "Lightly Active"
		ELSE "Sedentary"
	END AS IntensityType,
	(SUM(Minutes) / (SELECT TotalMinutes FROM Total)) * 100 AS Percentage
FROM
	Bellabeat.IntensityMinutes
GROUP BY
	IntensityType
ORDER BY 
	Percentage DESC

-- Intensity by Weekdays √

SELECT
	CASE
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 1 THEN "Sunday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 2 THEN "Monday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 3 THEN "Tuesday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 4 THEN "Wednesday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 5 THEN "Thursday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 6 THEN "Friday"
	ELSE "Saturday"
	END AS DayoftheWeek,
	CASE
		WHEN LEFT(Intensity, char_length(Intensity) -7) = "VeryActive" THEN "Very Active"
		WHEN LEFT(Intensity, char_length(Intensity) -7) = "FairlyActive" THEN "Fairly Active"
		WHEN LEFT(Intensity, char_length(Intensity) -7) = "LightlyActive" THEN "Lightly Active"
		ELSE "Sedentary"
	END AS IntensityType,
	AVG(Minutes) AS Minutes
FROM
	Bellabeat.NewIntensityMinutes
GROUP BY
	DayoftheWeek,
	Intensity
ORDER BY
	CASE 
		WHEN DayoftheWeek = "Sunday" THEN 1
		WHEN DayoftheWeek = "Monday" THEN 2
		WHEN DayoftheWeek = "Tuesday" THEN 3
		WHEN DayoftheWeek = "Wednesday" THEN 4
		WHEN DayoftheWeek = "Thursday" THEN 5
		WHEN DayoftheWeek = "Friday" THEN 6
		ELSE 7
	END

-- Steps, Calories, METs, Total Minutes Asleep, Total Time, Time to Sleep in Bed by Weekdays √

WITH StepsCaloriesData AS(
SELECT
	CASE
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 1 THEN "Sunday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 2 THEN "Monday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 3 THEN "Tuesday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 4 THEN "Wednesday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 5 THEN "Thursday"
		WHEN DAYOFWEEK(STR_TO_DATE(ActivityDate, '%m/%d/%Y')) = 6 THEN "Friday"
	ELSE "Saturday"
	END AS DayoftheWeek,
	AVG(TotalSteps) AS AverageSteps,
	AVG(Calories) AS AverageCaloriesBurned
FROM
	Bellabeat.DailyActivity
GROUP BY
	DayoftheWeek
),

METsData AS(
SELECT
	CASE
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(ActivityMinute, 1, 9)), '%m/%d/%Y')) = 1 THEN "Sunday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(ActivityMinute, 1, 9)), '%m/%d/%Y')) = 2 THEN "Monday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(ActivityMinute, 1, 9)), '%m/%d/%Y')) = 3 THEN "Tuesday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(ActivityMinute, 1, 9)), '%m/%d/%Y')) = 4 THEN "Wednesday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(ActivityMinute, 1, 9)), '%m/%d/%Y')) = 5 THEN "Thursday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(ActivityMinute, 1, 9)), '%m/%d/%Y')) = 6 THEN "Friday"
		ELSE "Saturday"
	END AS DayoftheWeek,
	AVG(METs) AS AverageMETs
FROM 
	Bellabeat.MinuteMETsNarrow
GROUP BY
	DayoftheWeek
),
	
SleepData AS(
SELECT
	CASE
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(SleepDay, 1, 9)), '%m/%d/%Y')) = 1 THEN "Sunday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(SleepDay, 1, 9)), '%m/%d/%Y')) = 2 THEN "Monday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(SleepDay, 1, 9)), '%m/%d/%Y')) = 3 THEN "Tuesday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(SleepDay, 1, 9)), '%m/%d/%Y')) = 4 THEN "Wednesday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(SleepDay, 1, 9)), '%m/%d/%Y')) = 5 THEN "Thursday"
		WHEN DAYOFWEEK(STR_TO_DATE(RTRIM(SUBSTRING(SleepDay, 1, 9)), '%m/%d/%Y')) = 6 THEN "Friday"
		ELSE "Saturday"
	END AS DayoftheWeek,
	AVG(TotalMinutesAsleep) AS AverageMinutesAsleep,
	AVG(TotalTimeinBed) AS AverageTimeinBed,
	AVG(TotalTimeinBed - TotalMinutesAsleep) AS AverageTimetoSleep
FROM
	Bellabeat.SleepDay
GROUP BY
	DayoftheWeek
)
	
SELECT
	StepsCaloriesData.DayoftheWeek,
	AverageSteps,
	AverageCaloriesBurned,
	AverageMETs,
	AverageMinutesAsleep,
	AverageTimeinBed,
	AverageTimetoSleep
FROM 
	StepsCaloriesData
LEFT JOIN
	METsData
ON
	StepsCaloriesData.DayoftheWeek = METsData.DayoftheWeek
LEFT JOIN 
	SleepData
ON
	StepsCaloriesData.DayoftheWeek = SleepData.DayoftheWeek
ORDER BY
	CASE 
		WHEN StepsCaloriesData.DayoftheWeek = "Sunday" THEN 1
		WHEN StepsCaloriesData.DayoftheWeek = "Monday" THEN 2
		WHEN StepsCaloriesData.DayoftheWeek = "Tuesday" THEN 3
		WHEN StepsCaloriesData.DayoftheWeek = "Wednesday" THEN 4
		WHEN StepsCaloriesData.DayoftheWeek = "Thursday" THEN 5
		WHEN StepsCaloriesData.DayoftheWeek = "Friday" THEN 6
		ELSE 7
	END

-- Steps, Calories, METs, Total Minutes Asleep, Total Time in Bed, Time to Sleep by Weekdays (Standardized) √	

WITH NewTable AS(	
SELECT 
	*,
	(AverageTimeinBed - AverageMinutesAsleep) AS AverageTimetoSleep
FROM Bellabeat.WeeklyTrend
),	
	
Descriptives AS(
SELECT
	AVG(AverageSteps) AS MeanSteps,
	STD(AverageSteps) AS STDSteps,
	AVG(AverageCaloriesBurned) AS MeanCalories,
	STD(AverageCaloriesBurned) AS STDCalories,
	AVG(AverageMETs) AS MeanMETs,
	STD(AverageMETs) AS STDMETs,
	AVG(AverageMinutesAsleep) AS MeanMinutesAsleep,
	STD(AverageMinutesAsleep) AS STDMinutesAsleep,
	AVG(AverageTimeinBed) AS MeanTimeinBed,
	STD(AverageTimeinBed) AS STDTimeinBed,
	AVG(AverageTimetoSleep) AS MeanTimetoSleep,
	STD(AverageTimetoSleep) AS STDTimetoSleep
FROM 
	NewTable
)

SELECT
	DayoftheWeek,
	(AverageSteps - (SELECT MeanSteps FROM Descriptives)) / (SELECT STDSteps FROM Descriptives) AS StepsZScore,
	(AverageCaloriesBurned - (SELECT MeanCalories FROM Descriptives)) / (SELECT STDCalories FROM Descriptives) AS CaloriesZScore,
	(AverageMETs - (SELECT MeanMETs FROM Descriptives)) / (SELECT STDMETs FROM Descriptives) AS METsZScore,
	(AverageMinutesAsleep - (SELECT MeanMinutesAsleep FROM Descriptives)) / (SELECT STDMinutesAsleep FROM Descriptives) AS MinutesAsleepZScore,
	(AverageTimeinBed - (SELECT MeanTimeinBed FROM Descriptives)) / (SELECT STDTimeinBed FROM Descriptives) AS TimeinBedZScore,
	(AverageTimetoSleep- (SELECT MeanTimetoSleep FROM Descriptives)) / (SELECT STDTimetoSleep FROM Descriptives) AS TimetoSleepZScore
FROM
	NewTable
	
-- Correlation Between Intensity Distance and Minutes √

SELECT
	Id,
	"Very Active" AS IntensityType,
	AVG(VeryActiveDistance) AS AverageDistance,
	AVG(VeryActiveMinutes) AS AverageMinutes
FROM 
	Bellabeat.DailyActivity
GROUP BY
	Id
UNION ALL
SELECT
	Id,
	"Moderately Active" AS IntensityType,
	AVG(ModeratelyActiveDistance) AS AverageDistance,
	AVG(FairlyActiveMinutes) AS AverageMinutes
FROM 
	Bellabeat.DailyActivity
GROUP BY
	Id
UNION ALL
SELECT
	Id,
	"Lightly Active" AS IntensityType,
	AVG(LightActiveDistance) AS AverageDistance,
	AVG(LightlyActiveMinutes) AS AverageMinutes
FROM 
	Bellabeat.DailyActivity
GROUP BY 
	Id

-- Correlation Between Steps, Calories, Intensity Minutes, Heartrate, METs, Sleep Records, Total Minutes Asleep, Total Time in Bed by ID √ **

WITH MergedData AS(
SELECT
	DailyActivity.Id,
	TotalSteps,
	VeryActiveMinutes,
	FairlyActiveMinutes,
	LightlyActiveMinutes,
	SedentaryMinutes,
	VeryActiveDistance,
	ModeratelyActiveDistance,
	LightActiveDistance,
	Calories,
	TotalSleepRecords,
	TotalMinutesAsleep,
	TotalTimeinBed
FROM
	Bellabeat.DailyActivity AS DailyActivity
LEFT JOIN 	
	Bellabeat.SleepDay AS SleepDay
ON
	DailyActivity.Id = SleepDay.Id
),

MergedQuery AS(
SELECT 
	Id,
	AVG(TotalSteps) AS AverageSteps,
	AVG(Calories) AS AverageCaloriesBurned,
	AVG(VeryActiveMinutes) AS AverageVeryActiveMinutes,
	AVG(FairlyActiveMinutes) AS AverageModeratelyActiveMinutes,
	AVG(LightlyActiveMinutes) AS AverageLightlyActiveMinutes,
	AVG(SedentaryMinutes) AS AverageSedentaryMinutes,
	AVG(VeryActiveDistance) AS AverageVeryActiveDistance,
	AVG(ModeratelyActiveDistance) AS AverageModeratelyActiveDistance,
	AVG(LightActiveDistance) AS AverageLightlyActiveDistance,
	CASE 
		WHEN AVG(TotalSleepRecords) > 1 THEN "> 1"
		ELSE 1
	END AS AverageSleepRecords,
	AVG(TotalMinutesAsleep) AS AverageMinutesAsleep,
	AVG(TotalTimeinBed) AS AverageTimeinBed,
	AVG(TotalTimeinBed - TotalMinutesAsleep) AS AverageTimetoSleep
FROM
	MergedData
GROUP BY
	Id
),

GroupedHeartrate AS(
SELECT 
	Id, 
	AVG(Value) AS AverageHeartrate
FROM
	Bellabeat.HeartrateSeconds
GROUP BY
	Id
),

GroupedMETs AS(
SELECT 
	Id, 
	AVG(METs / 10) AS AverageMETs
FROM
	Bellabeat.MinuteMETsNarrow
GROUP BY
	Id
)

SELECT 
	MergedQuery.Id,
	AverageSteps,
	AverageCaloriesBurned,
	AverageVeryActiveMinutes,
	AverageModeratelyActiveMinutes,
	AverageLightlyActiveMinutes,
	AverageSedentaryMinutes,
	AverageVeryActiveDistance,
	AverageModeratelyActiveDistance,
	AverageLightlyActiveDistance,
	AverageHeartrate,
	AverageMETs,
	AverageSleepRecords,
	AverageMinutesAsleep,
	AverageTimeinBed,
	AverageTimetoSleep
FROM
	MergedQuery
LEFT JOIN
	GroupedHeartrate
ON
	MergedQuery.Id = GroupedHeartrate.Id
LEFT JOIN
	GroupedMETs
ON
	MergedQuery.Id = GroupedMETs.Id
	
-- Hourly Trends in Steps, Calories, Heartrate, METs √

WITH FirstData AS(
SELECT
	HourlySteps.Id,
	HourlySteps.ActivityHour,
	StepTotal,
	Calories
FROM 
	Bellabeat.HourlySteps AS HourlySteps
INNER JOIN
	Bellabeat.HourlyCalories AS HourlyCalories
ON
	HourlySteps.Id = HourlyCalories.Id AND
	HourlySteps.ActivityHour = HourlyCalories.ActivityHour
),

FirstQuery AS(
SELECT
	LTRIM(SUBSTRING(ActivityHour, 10, 21)) AS TimeofDay,
	AVG(StepTotal) AS AverageSteps,
	AVG(Calories) AS AverageCalories
FROM FirstData
GROUP BY
	TimeofDay
),	

SecondData AS(
SELECT 
	HeartrateSeconds.Id,
	HeartrateSeconds.Time,
	HeartrateSeconds.Value AS Heartrate,
	METs
FROM 	
	Bellabeat.HeartrateSeconds AS HeartrateSeconds
INNER JOIN
	Bellabeat.MinuteMETsNarrow AS MinuteMETs
ON
	HeartrateSeconds.Id = MinuteMETs.Id AND
	HeartrateSeconds.Time = ActivityMinute
),

SecondQuery AS(
SELECT 
	CASE 
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '12:%AM' THEN "12:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '1:%AM' THEN "1:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '2:%AM' THEN "2:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '3:%AM' THEN "3:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '4:%AM' THEN "4:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '5:%AM' THEN "5:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '6:%AM' THEN "6:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '7:%AM' THEN "7:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '8:%AM' THEN "8:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '9:%AM' THEN "9:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '10:%AM' THEN "10:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '11:%AM' THEN "11:00:00 AM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '12:%PM' THEN "12:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '1:%PM' THEN "1:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '2:%PM' THEN "2:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '3:%PM' THEN "3:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '4:%PM' THEN "4:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '5:%PM' THEN "5:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '6:%PM' THEN "6:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '7:%PM' THEN "7:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '8:%PM' THEN "8:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '9:%PM' THEN "9:00:00 PM"
		WHEN LTRIM(SUBSTRING(Time, 10, 21)) LIKE '10:%PM' THEN "10:00:00 PM"
		ELSE "11:00:00 PM"
	END AS TimeofDay,
	AVG(Heartrate) AS AverageHeartrate,
	AVG(METs / 10) AS AverageMETs
FROM
	SecondData
GROUP BY
	TimeofDay
ORDER BY 
	CASE 
		WHEN TimeofDay = "12:00:00 AM" THEN 1
		WHEN TimeofDay = "1:00:00 AM" THEN 2
		WHEN TimeofDay = "2:00:00 AM" THEN 3
		WHEN TimeofDay = "3:00:00 AM" THEN 4
		WHEN TimeofDay = "4:00:00 AM" THEN 5
		WHEN TimeofDay = "5:00:00 AM" THEN 6
		WHEN TimeofDay = "6:00:00 AM" THEN 7
		WHEN TimeofDay = "7:00:00 AM" THEN 8
		WHEN TimeofDay = "8:00:00 AM" THEN 9
		WHEN TimeofDay = "9:00:00 AM" THEN 10
		WHEN TimeofDay = "10:00:00 AM" THEN 11
		WHEN TimeofDay = "11:00:00 AM" THEN 12
		WHEN TimeofDay = "12:00:00 PM" THEN 13
		WHEN TimeofDay = "1:00:00 PM" THEN 14
		WHEN TimeofDay = "2:00:00 PM" THEN 15
		WHEN TimeofDay = "3:00:00 PM" THEN 16
		WHEN TimeofDay = "4:00:00 PM" THEN 17
		WHEN TimeofDay = "5:00:00 PM" THEN 18
		WHEN TimeofDay = "6:00:00 PM" THEN 19
		WHEN TimeofDay = "7:00:00 PM" THEN 20
		WHEN TimeofDay = "8:00:00 PM" THEN 21
		WHEN TimeofDay = "9:00:00 PM" THEN 22
		WHEN TimeofDay = "10:00:00 PM" THEN 23
		ELSE 24
	END
)

SELECT
	FirstQuery.TimeofDay,
	AverageSteps,
	AverageCalories,
	AverageHeartrate,
	AverageMETs
FROM 
	FirstQuery
INNER JOIN
	SecondQuery
ON
	FirstQuery.TimeofDay = SecondQuery.TimeofDay

-- Hourly Trends Steps, Calories, Heartrate, METs (Standardized) √
	
WITH Descriptives AS(
SELECT
	AVG(AverageSteps) AS MeanSteps,
	STD(AverageSteps) AS STDSteps,
	AVG(AverageCalories) AS MeanCalories,
	STD(AverageCalories) AS STDCalories,
	AVG(AverageHeartrate) AS MeanHeartrate,
	STD(AverageHeartrate) AS STDHeartrate,
	AVG(AverageMETs) AS MeanMETs,
	STD(AverageMETs) AS STDMETs
FROM 
	Bellabeat.HourlyTrend
)

SELECT
	TimeofDay,
	(AverageSteps - (SELECT MeanSteps FROM Descriptives)) / (SELECT STDSteps FROM Descriptives) AS StepsZScore,
	(AverageCalories - (SELECT MeanCalories FROM Descriptives)) / (SELECT STDCalories FROM Descriptives) AS CaloriesZScore,
	(AverageHeartrate - (SELECT MeanHeartrate FROM Descriptives)) / (SELECT STDHeartrate FROM Descriptives) AS HeartrateZScore,
	(AverageMETs - (SELECT MeanMETs FROM Descriptives)) / (SELECT STDMETs FROM Descriptives) AS METsZScore
FROM
	Bellabeat.HourlyTrend
