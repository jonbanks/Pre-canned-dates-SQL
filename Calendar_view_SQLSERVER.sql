if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[V_PreCannedDates]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[V_PreCannedDates]
go

CREATE VIEW [dbo].[V_PreCannedDates] AS
SELECT  
[ROWKEY]	= 1, 
[DATEKEY] = (YEAR(DATEADD(d, 0, GETDATE())) * 10000) + (MONTH(DATEADD(d, 0, GETDATE())) * 100) + DAY(DATEADD(d, 0, GETDATE())),
[DATE_PERIOD_KEY] = (YEAR(GETDATE()) * 1000) + MONTH(GETDATE()),
[DATE]	= Convert(DateTime, DATEDIFF(DAY, 0, GETDATE())),
[DATE_DATE] = CONVERT(DATE, GETDATE()),
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Today'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Today'),
[DATE_FROM] = Convert(DateTime, DATEDIFF(DAY, 0, GETDATE())),
[DATE_TO] = Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= YEAR(GETDATE()),
[QUARTER] = floor((month(GETDATE())+2)/3),
[YEAR_AND_QUARTER] = CAST(Year(GETDATE())AS VARCHAR(4))+' Q'+CAST(floor((month(GETDATE())+2)/3) AS VARCHAR(1)), -- Year and quarter
[MONTH_NUMBER] = Month(GETDATE()), -- The month number of the current date
[MONTH_NAME] = DateName(m,GETDATE()), -- the month name of the current month (January, February, etc.)
[MONTH_YEAR] = DateName(m,GETDATE()) + ' ' + CAST(Year(GETDATE()) AS VARCHAR(4)), -- The month and year of the current date
[MONTH_YEAR_ABBREVIATED] = SUBSTRING(DateName(m,GETDATE()),1,3) +' '+SUBSTRING(CAST(Year(GETDATE()) AS VARCHAR(4)),3,2), -- Month and year ABBREVIATED (Jan 09, Jan 10, etc.)
[MONTH_ABBREVIATED] = SUBSTRING(DateName(m,GETDATE()),1,3), -- Month name ABBREVIATED (Jan, Feb, etc.)
[MONTH_NAME_SORTED] = CASE WHEN month(GETDATE()) < 10 THEN '0' ELSE '' END + CAST(month(GETDATE()) AS varchar(2))+' '+DateName(m,GETDATE()), --[MONTH_NAME_SORTED]
[WEEK_NUMBER] = DATEPART(wk, GETDATE()), -- the week number of the current date
[WEEK_STARTING] = CASE WHEN DateName(weekday,GETDATE()) = 'Sunday' THEN datepart(day,(dateadd(week, datediff(week, 0, GETDATE()), -7))) ELSE datepart(day,(dateadd(week, datediff(week, 0, GETDATE()), 0))) END, -- The day of the week that the week starts on
[DAY_NUMBER] = Day(GETDATE()), -- The day number of the current date
[DAY_NAME] = DateName(weekday,GETDATE()), -- The day name of the current date (Monday, Tuesday, etc.)
[DAY_NAME_SORTED] = CASE
	WHEN DateName(weekday,GETDATE()) = 'Monday' THEN '1 Monday'
	WHEN DateName(weekday,GETDATE()) = 'Tuesday' THEN '2 Tuesday'
	WHEN DateName(weekday,GETDATE()) = 'Wednesday' THEN '3 Wednesday'
	WHEN DateName(weekday,GETDATE()) = 'Thursday' THEN '4 Thursday'
	WHEN DateName(weekday,GETDATE()) = 'Friday' THEN '5 Friday'
	WHEN DateName(weekday,GETDATE()) = 'Saturday' THEN '6 Saturday'
	WHEN DateName(weekday,GETDATE()) = 'Sunday' THEN '7 Sunday'
	ELSE ''
END,	
[DAY_NUMBER_ORDINAL] = CASE
	WHEN DAY(GETDATE()) IN(1,21,31) then CAST(DAY(GETDATE()) AS VARCHAR(4))+'st'
	WHEN DAY(GETDATE()) IN(2,22) then CAST(DAY(GETDATE()) AS VARCHAR(4))+'nd'
	WHEN DAY(GETDATE()) IN (3,23) then CAST(DAY(GETDATE()) AS VARCHAR(4))+'rd'
	WHEN DAY(GETDATE()) IN(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,24,25,26,27,28,29,30) then CAST(DAY(GETDATE()) AS VARCHAR(4))+'th'
	ELSE CAST(DAY(GETDATE()) AS VARCHAR(4))
END,
[DAY_AND_NAME] = CAST(Day(GETDATE()) AS VARCHAR(2)) +' '+ CAST(DateName(weekday,GETDATE()) AS VARCHAR(10)),
[DAY_AND_NAME_ABBREVATED] = CAST(Day(GETDATE()) AS VARCHAR(2)) +' '+ CAST(SUBSTRING(DateName(weekday,GETDATE()),0,3) AS VARCHAR(4)),
[DD_MMM_YYYY] = CONVERT(VARCHAR(11), GETDATE(),113),
[DD_MMM_YY] = CONVERT(VARCHAR(11),GETDATE(),6),
[MM_DD_YYYY] = CONVERT(VARCHAR(11), GETDATE(),110)
UNION
-- YESTERDAY
SELECT  
[ROWKEY]	= 2, 
[DATEKEY] = (YEAR(DATEADD(d, -1, GETDATE())) * 10000) + (MONTH(DATEADD(d, -1, GETDATE())) * 100) + DAY(DATEADD(d, -1, GETDATE())),
[DATE_PERIOD_KEY] = (YEAR(DATEADD(d,-1,GETDATE())) * 1000) + MONTH(DATEADD(d,-1,GETDATE())),
[DATE]	= DATEADD(d,-1, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_DATE] = CONVERT(DATE, DATEADD(d,-1,GETDATE())),
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Yesterday'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Yesterday'),
[DATE_FROM] = DATEADD(d,-1, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] = Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, 0, GETDATE()))),
[YEAR]	= YEAR(DATEADD(d,-1, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE())))),
[QUARTER] = floor((month(DATEADD(d,-1,GETDATE()))+2)/3),
[YEAR_AND_QUARTER] = CAST(Year(DATEADD(d,-1,GETDATE()))AS VARCHAR(4))+' Q'+CAST(floor((month(DATEADD(d,-1,GETDATE()))+2)/3) AS VARCHAR(1)), -- Year and quarter
[MONTH_NUMBER] = Month(DATEADD(d,-1,GETDATE())), -- The month number of the current date
[MONTH_NAME] = DateName(m,DATEADD(d,-1,GETDATE())), -- the month name of the current month (January, February, etc.)
[MONTH_YEAR] = DateName(m,DATEADD(d,-1,GETDATE())) + ' ' + CAST(Year(DATEADD(d,-1,GETDATE())) AS VARCHAR(4)), -- The month and year of the current date
[MONTH_YEAR_ABBREVIATED] = SUBSTRING(DateName(m,DATEADD(d,-1,GETDATE())),1,3) +' '+SUBSTRING(CAST(Year(DATEADD(d,-1,GETDATE())) AS VARCHAR(4)),3,2), -- Month and year ABBREVIATED (Jan 09, Jan 10, etc.)
[MONTH_ABBRIVEATED] = SUBSTRING(DateName(m,DATEADD(d,-1,GETDATE())),1,3), -- Month name ABBREVIATED (Jan, Feb, etc.)
[MONTH_NAME_SORTED] = CASE WHEN month(DATEADD(d,-1,GETDATE())) < 10 THEN '0' ELSE '' END + CAST(month(DATEADD(d,-1,GETDATE())) AS varchar(2))+' '+DateName(m,DATEADD(d,-1,GETDATE())), --[MONTH_NAME_SORTED]
[WEEK_NUMBER] = DATEPART(wk, DATEADD(d,-1,GETDATE())), -- the week number of the current date
[WEEK_STARTING] = CASE WHEN DateName(weekday,DATEADD(d,-1,GETDATE())) = 'Sunday' THEN datepart(day,(dateadd(week, datediff(week, 0, DATEADD(d,-1,GETDATE())), -7))) ELSE datepart(day,(dateadd(week, datediff(week, 0, DATEADD(d,-1,GETDATE())), 0))) END, -- The day of the week that the week starts on
[DAY_NUMBER] = Day(DATEADD(d,-1,GETDATE())), -- The day number of the current date
[DAY_NAME] = DateName(weekday,DATEADD(d,-1,GETDATE())), -- The day name of the current date (Monday, Tuesday, etc.)
[DAY_NAME_SORTED] = CASE
	WHEN DateName(weekday,DATEADD(d,-1,GETDATE())) = 'Monday' THEN '1 Monday'
	WHEN DateName(weekday,DATEADD(d,-1,GETDATE()))= 'Tuesday' THEN '2 Tuesday'
	WHEN DateName(weekday,DATEADD(d,-1,GETDATE())) = 'Wednesday' THEN '3 Wednesday'
	WHEN DateName(weekday,DATEADD(d,-1,GETDATE())) = 'Thursday' THEN '4 Thursday'
	WHEN DateName(weekday,DATEADD(d,-1,GETDATE())) = 'Friday' THEN '5 Friday'
	WHEN DateName(weekday,DATEADD(d,-1,GETDATE())) = 'Saturday' THEN '6 Saturday'
	WHEN DateName(weekday,DATEADD(d,-1,GETDATE())) = 'Sunday' THEN '7 Sunday'
	ELSE ''
END,	
[DAY_NUMBER_ORDINAL] = CASE
	WHEN DAY(DATEADD(d,-1,GETDATE())) IN(1,21,31) then CAST(DAY(DATEADD(d,-1,GETDATE())) AS VARCHAR(4))+'st'
	WHEN DAY(DATEADD(d,-1,GETDATE())) IN(2,22) then CAST(DAY(DATEADD(d,-1,GETDATE())) AS VARCHAR(4))+'nd'
	WHEN DAY(DATEADD(d,-1,GETDATE())) IN (3,23) then CAST(DAY(DATEADD(d,-1,GETDATE())) AS VARCHAR(4))+'rd'
	WHEN DAY(GETDATE()) IN(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,24,25,26,27,28,29,30) then CAST(DAY(DATEADD(d,-1,GETDATE())) AS VARCHAR(4))+'th'
	ELSE CAST(DAY(DATEADD(d,-1,GETDATE())) AS VARCHAR(4))
END,
[DAY_AND_NAME] = CAST(Day(DATEADD(d,-1,GETDATE())) AS VARCHAR(2)) +' '+ CAST(DateName(weekday,DATEADD(d,-1,GETDATE())) AS VARCHAR(10)),
[DAY_AND_NAME_ABBREVIATED] = CAST(Day(DATEADD(d,-1,GETDATE())) AS VARCHAR(2)) +' '+ CAST(SUBSTRING(DateName(weekday,DATEADD(d,-1,GETDATE())),0,3) AS VARCHAR(4)),
[DD_MMM_YYYY] = CONVERT(VARCHAR(11), DATEADD(d,-1,GETDATE()),113),
[DD_MMM_YY] = CONVERT(VARCHAR(11),DATEADD(d,-1,GETDATE()),6),
[MM_DD_YYYY] = CONVERT(VARCHAR(11), DATEADD(d,-1,GETDATE()),110)
UNION
--Last Working Day
SELECT  
[ROWKEY]	= 3, 
[DATEKEY] = (YEAR(DATEADD(d, 0, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))) * 10000) 
+ (MONTH(DATEADD(d, 0, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))) * 100) + DAY(DATEADD(d, 0, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))),
[DATE_PERIOD_KEY] = (YEAR(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) * 1000) + MONTH(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))),
[DATE]	= Convert(DateTime, DATEDIFF(DAY, 0, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))),
[DATE_DATE] = CONVERT(DATE, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))),
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last Working Day'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last Working Day'),
[DATE_FROM] = Convert(DateTime, DATEDIFF(DAY, 0, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))),
[DATE_TO] = Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))))),
[YEAR]	= YEAR(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))),
[QUARTER] = floor((month(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))+2)/3),
[YEAR_AND_QUARTER] = CAST(Year(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))AS VARCHAR(4))+' Q'+CAST(floor((month(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())))+2)/3) AS VARCHAR(1)), -- Year and quarter
[MONTH_NUMBER] = Month(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), -- The month number of the current date
[MONTH_NAME] = DateName(m,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), -- the month name of the current month (January, February, etc.)
[MONTH_YEAR] = DateName(m,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) + ' ' + CAST(Year(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(4)), -- The month and year of the current date
[MONTH_YEAR_ABBREVIATED] = SUBSTRING(DateName(m,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))),1,3) +' '+SUBSTRING(CAST(Year(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(4)),3,2), -- Month and year ABBREVIATED (Jan 09, Jan 10, etc.)
[MONTH_ABBREVIATED] = SUBSTRING(DateName(m,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))),1,3), -- Month name ABBREVIATED (Jan, Feb, etc.)
[MONTH_NAME_SORTED] = CASE WHEN month(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) < 10 THEN '0' ELSE '' END + CAST(month(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS varchar(2))+' '+DateName(m,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), --[MONTH_NAME_SORTED]
[WEEK_NUMBER] = DATEPART(wk, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), -- the week number of the current date
[WEEK_STARTING] = CASE WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Sunday' THEN datepart(day,(dateadd(week, datediff(week, 0, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), -7))) ELSE datepart(day,(dateadd(week, datediff(week, 0, DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), 0))) END, -- The day of the week that the week starts on
[DAY_NUMBER] = Day(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), -- The day number of the current date
[DAY_NAME] = DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))), -- The day name of the current date (Monday, Tuesday, etc.)
[DAY_NAME_SORTED] = CASE
	WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Monday' THEN '1 Monday'
	WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Tuesday' THEN '2 Tuesday'
	WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Wednesday' THEN '3 Wednesday'
	WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Thursday' THEN '4 Thursday'
	WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Friday' THEN '5 Friday'
	WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Saturday' THEN '6 Saturday'
	WHEN DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) = 'Sunday' THEN '7 Sunday'
	ELSE ''
END,	
[DAY_NUMBER_ORDINAL] = CASE
	WHEN DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) IN(1,21,31) then CAST(DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(4))+'st'
	WHEN DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) IN(2,22) then CAST(DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(4))+'nd'
	WHEN DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) IN (3,23) then CAST(DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(4))+'rd'
	WHEN DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) IN(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,24,25,26,27,28,29,30) then CAST(DAY(GETDATE()) AS VARCHAR(4))+'th'
	ELSE CAST(DAY(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(4))
END,
[DAY_AND_NAME] = CAST(Day(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(2)) +' '+ CAST(DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(10)),
[DAY_AND_NAME_ABBREVATED] = CAST(Day(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))) AS VARCHAR(2)) +' '+ CAST(SUBSTRING(DateName(weekday,DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))),0,3) AS VARCHAR(4)),
[DD_MMM_YYYY] = CONVERT(VARCHAR(11), DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())),113),
[DD_MMM_YY] = CONVERT(VARCHAR(11),DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())),6),
[MM_DD_YYYY] = CONVERT(VARCHAR(11), DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) WHEN 'Sunday' THEN -2 WHEN 'Monday' THEN -3 ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())),110)
UNION
-- Last 7 days
SELECT  
[ROWKEY]	= 4, 
[DATEKEY] = NULL, 
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 7 Days'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 7 Days ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(d, -6, GETDATE())), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(d, -6, GETDATE())), 3) + ' '
                             + DATENAME(YY, DATEADD(d, -6, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, GETDATE()), 2) + ' ' 
                             + LEFT(DATENAME(MM, GETDATE()), 3) + ' '
                             + DATENAME(YY, GETDATE())
                             + ')'
                             ),
[DATE_FROM] = DATEADD(d,-6, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] =  Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last 14 days
SELECT  
[ROWKEY]	= 5, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 14 Days'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 14 Days ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(d, -13, GETDATE())), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(d, -13, GETDATE())), 3) + ' '
                             + DATENAME(YY, DATEADD(d, -13, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, GETDATE()), 2) + ' ' 
                             + LEFT(DATENAME(MM, GETDATE()), 3) + ' '
                             + DATENAME(YY, GETDATE())
                             + ')'
                             ),
[DATE_FROM] = DATEADD(d,-13, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] =  Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last 30 days
SELECT  
[ROWKEY]	= 6, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 30 Days'),
[LONG_DATE_NAME] =  CONVERT(VARCHAR(50), 'Last 30 Days ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(d, -29, GETDATE())), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(d, -29, GETDATE())), 3) + ' '
                             + DATENAME(YY, DATEADD(d, -29, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, GETDATE()), 2) + ' ' 
                             + LEFT(DATENAME(MM, GETDATE()), 3) + ' '
                             + DATENAME(YY, GETDATE())
                             + ')'
                             ),
[DATE_FROM] = DATEADD(d,-29, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] =  Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last 60 days
SELECT  
[ROWKEY]	= 7, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 60 Days'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 60 Days ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(d, -59, GETDATE())), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(d, -59, GETDATE())), 3) + ' '
                             + DATENAME(YY, DATEADD(d, -59, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, GETDATE()), 2) + ' ' 
                             + LEFT(DATENAME(MM, GETDATE()), 3) + ' '
                             + DATENAME(YY, GETDATE())
                             + ')'
                             ),
[DATE_FROM] = DATEADD(d,-59, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] =  Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last 90 days
SELECT  
[ROWKEY]	= 8, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 90 Days'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 90 Days ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(d, -89, GETDATE())), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(d, -89, GETDATE())), 3) + ' '
                             + DATENAME(YY, DATEADD(d, -89, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, GETDATE()), 2) + ' ' 
                             + LEFT(DATENAME(MM, GETDATE()), 3) + ' '
                             + DATENAME(YY, GETDATE())
                             + ')'
                             ),
[DATE_FROM] = DATEADD(d,-89, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] =  Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last Calendar Month
SELECT  
[ROWKEY]	= 9, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last Calendar Month'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last Calendar Month ('
                             + RIGHT('0' + DATENAME(DD,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) ), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) ), 3) + ' '
                             + DATENAME(YY, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) )
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)), 3) + ' '
                             + DATENAME(YY, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))
                             + ')'
                             ),
[DATE_FROM] = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0),
[DATE_TO] =   DATEADD(ms,-2,DATEDIFF(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = MONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)), 
[MONTH_NAME] = DATENAME(mm,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)), 
[MONTH_YEAR] = DATENAME(mm,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0))+' '+ CAST(YEAR(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)) AS VARCHAR(4)),
[MONTH_YEAR_ABBREVIATED] = SUBSTRING(DateName(mm,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)),1,3) +' '+SUBSTRING(CAST(Year(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)) AS VARCHAR(4)),3,2), -- Month and year ABBREVIATED (Jan 09, Jan 10, etc.),
[MONTH_ABBREVIATED] = SUBSTRING(DateName(m,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)),1,3),
[MONTH_NAME_SORTED] = CASE WHEN month(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)) < 10 THEN '0' ELSE '' END + CAST(month(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)) AS varchar(2))+' '+DateName(m,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0)), --[MONTH_NAME_SORTED],
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last 3 Calendar Month
SELECT  
[ROWKEY]	= 10, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 3 Calendar Months'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(70), 'Last 3 Calendar Months ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-4, 0)), 2) + ' ' 
                             + LEFT(DATENAME(MM,  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-4, 0)), 3) + ' '
                             + DATENAME(YY,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-4, 0))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)), 3) + ' '
                             + DATENAME(YY, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))
                             + ')'
                             ),
[DATE_FROM] = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-4, 0),
[DATE_TO] =  DATEADD(ms,-2,DATEDIFF(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last 6 calendar months
SELECT  
[ROWKEY]	= 11, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 6 Calendar Months'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last 6 Calendar Months ('
                             + RIGHT('0' + DATENAME(DD,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()) -7, 0)), 2) + ' ' 
                             + LEFT(DATENAME(MM,  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()) -7, 0)), 3) + ' '
                             + DATENAME(YY,DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()) -7, 0))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)), 3) + ' '
                             + DATENAME(YY, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))
                             + ')'
                             ),
[DATE_FROM] = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()) -7, 0),
[DATE_TO] =  DATEADD(ms,-2,DATEDIFF(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- Last calendar year
SELECT  
[ROWKEY]	= 12, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Last Year'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Last Year ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)), 3) + ' '
                             + DATENAME(YY, DATEADD(YY, -1, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-8, -1)), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(ms,-2,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) - 0, 0))), 3) + ' '
                             + DATENAME(YY, DATEADD(ms,-2,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) - 0, 0)))
                             + ')'
                             ),
[DATE_FROM] = DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) - 1, 0),
[DATE_TO] = DATEADD(ms,-2,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) - 0, 0)),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 
UNION
-- This Month
SELECT  
[ROWKEY]	= 13, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL,
[DATE_DATE] = NULL,
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'This Month'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'This Month (' 
					+ RIGHT(Convert(Date, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),2)+' '+
					+ LEFT(DATENAME(mm,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),3)+' '+
					+ DATENAME(yy, DATEADD(month, DATEDIFF(month, 0, GETDATE()),0))+' '+
					+' - '+
					RIGHT(Convert(Date,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))),2)+' '+
					+ LEFT(DATENAME(mm,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),3)+' '+
					+ DATENAME(yy, DATEADD(month, DATEDIFF(month, 0, GETDATE()),0))+' '+
					+')'
					),
[DATE_FROM] = Convert(DateTime, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),
[DATE_TO] = Convert(DateTime,DATEADD(ms,-2,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))),
[YEAR]	= NULL,
[QUARTER] = NULL,
[YEAR_AND_QUARTER] = NULL, -- Year and quarter
[MONTH_NUMBER] = Month(GETDATE()), -- The month number of the current date
[MONTH_NAME] = DateName(m,GETDATE()), -- the month name of the current month (January, February, etc.)
[MONTH_YEAR] = DateName(m,GETDATE()) + ' ' + CAST(Year(GETDATE()) AS VARCHAR(4)), -- The month and year of the current date
[MONTH_YEAR_ABBREVIATED] = SUBSTRING(DateName(m,GETDATE()),1,3) +' '+SUBSTRING(CAST(Year(GETDATE()) AS VARCHAR(4)),3,2), -- Month and year ABBREVIATED (Jan 09, Jan 10, etc.)
[MONTH_ABBREVIATED] = SUBSTRING(DateName(m,GETDATE()),1,3), -- Month name ABBREVIATED (Jan, Feb, etc.)
[MONTH_NAME_SORTED] = CASE WHEN month(GETDATE()) < 10 THEN '0' ELSE '' END + CAST(month(GETDATE()) AS varchar(2))+' '+DateName(m,GETDATE()), --[MONTH_NAME_SORTED]
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL,
[DAY_NAME_SORTED] = NULL,	
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL,
[DD_MMM_YY] = NULL,
[MM_DD_YYYY] = NULL
UNION
-- This Year
SELECT  
[ROWKEY]	= 14, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL,
[DATE_DATE] = NULL,
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'This Year'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'This Year (' 
					+ RIGHT(Convert(Date, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),2)+' '+
					+ LEFT(DATENAME(MM, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)), 3)+' '+
					+ DATENAME(yy, GETDATE())+' '+
					+' - '+
					RIGHT(Convert(Date,Convert(Date,DATEADD(ms,-2,DATEADD(year, DATEDIFF(year, -1, GETDATE()), 0)))),2)+' '+
					+ LEFT(DATENAME(mm,Convert(Date,DATEADD(ms,-2,DATEADD(year, DATEDIFF(year, -1, GETDATE()), 0)))),3)+' '+
					+ DATENAME(yy, DATEADD(month, DATEDIFF(month, 0, GETDATE()),0))+' '+
					+')'
					),
[DATE_FROM] = Convert(DateTime,  DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)),
[DATE_TO] = Convert(DateTime,DATEADD(ms,-2,DATEADD(year, DATEDIFF(year, -1, GETDATE()), 0))),
[YEAR]	= NULL,
[QUARTER] = NULL,
[YEAR_AND_QUARTER] = NULL, 
[MONTH_NUMBER] = NULL,
[MONTH_NAME] = NULL,
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL,
[DAY_NAME_SORTED] = NULL,	
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL,
[DD_MMM_YY] = NULL,
[MM_DD_YYYY] = NULL
UNION
-- This Week

SELECT  
[ROWKEY]	= 15, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL,
[DATE_DATE] = NULL,
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'This Week'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'This Week (' 
					+ RIGHT(Convert(Date, DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0)),2)+' '+
					+ LEFT(DATENAME(MM, DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0)), 3)+' '+
					+ DATENAME(yy,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))+' '+
					+' - '+
					RIGHT(Convert(Date,DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 7))),2)+' '+
					+ LEFT(DATENAME(mm,DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 5))),3)+' '+
					+ DATENAME(yy, DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 5)))+' '+
					+')'
					),
[DATE_FROM] = Convert(DateTime, DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0)),
[DATE_TO] = Convert(DateTime,DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 7))),
[YEAR]	= NULL,
[QUARTER] = NULL,
[YEAR_AND_QUARTER] = NULL, 
[MONTH_NUMBER] = NULL,
[MONTH_NAME] = NULL,
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL,
[DAY_NAME_SORTED] = NULL,	
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL,
[DD_MMM_YY] = NULL,
[MM_DD_YYYY] = NULL
UNION
-- This Month Last Year
SELECT  
[ROWKEY]	= 16, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL,
[DATE_DATE] = NULL,
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'This Month Last Year'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'This Month Last Year (' 
					+ RIGHT(Convert(Date, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),2)+' '+
					+ LEFT(DATENAME(MM, Convert(DateTime, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))), 3)+' '+
					+ DATENAME(yy, DATEADD(yy,-1,Convert(DateTime, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))))+' '+
					+' - '+
					RIGHT(Convert(Date,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))),2)+' '+
					+ LEFT(DATENAME(mm,Convert(DateTime, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))),3)+' '+
					+ DATENAME(yy, DATEADD(yy,-1,Convert(DateTime, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))))+' '+
					+')'
					),
[DATE_FROM] = Convert(DateTime, DATEADD(yy,-1,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))),
[DATE_TO] = Convert(DateTime,DATEADD(ms,-2,DATEADD(yy,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)))),
[YEAR]	= NULL,
[QUARTER] = NULL,
[YEAR_AND_QUARTER] = NULL, -- Year and quarter
[MONTH_NUMBER] = MONTH(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),
[MONTH_NAME] = DATENAME(mm,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),
[MONTH_YEAR] = DATENAME(mm,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))+' '+CAST(YEAR(DATEADD(yy,-1,Convert(DateTime, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)))) AS VARCHAR(4)),
[MONTH_YEAR_ABBREVIATED] = SUBSTRING(DateName(m,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),1,3) +' '+SUBSTRING(CAST(Year(DATEADD(yy,-1,Convert(DateTime, DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)))) AS VARCHAR(4)),3,2), -- Month and year ABBREVIATED (Jan 09, Jan 10, etc.),
[MONTH_ABBREVIATED] = SUBSTRING(DateName(m,DATEADD(yy,-1,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))),1,3), -- Month name ABBREVIATED (Jan, Feb, etc.)
[MONTH_NAME_SORTED] = CASE WHEN month(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) < 10 THEN '0' ELSE '' END + CAST(month(DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS varchar(2))+' '+DateName(m,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)), --[MONTH_NAME_SORTED]
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL,
[DAY_NAME_SORTED] = NULL,	
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL,
[DD_MMM_YY] = NULL,
[MM_DD_YYYY] = NULL
UNION
-- ‘This Week Last Year’ (tricky ; week numbers ? . Yeuch).
SELECT  
[ROWKEY]	= 17, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL,
[DATE_DATE] = NULL,
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'This Week Last Year'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'This Week Last Year (' 
					+ RIGHT(Convert(Date, DATEADD(wk,-52,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))),2)+' '+
					+ LEFT(DATENAME(MM, DATEADD(wk,-52,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))), 3)+' '+
					+ DATENAME(yy, DATEADD(wk,-52,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0)))+' '+
					+' - '+
					RIGHT(Convert(Date, DATEADD(wk,-52,DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 7)))),2)+' '+
					+ LEFT(DATENAME(mm, DATEADD(wk,-52,DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 7)))),3)+' '+
					+ DATENAME(yy, DATEADD(wk,-52,DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 7))))+' '+
					+')'
					),
[DATE_FROM] =  Convert(DateTime, DATEADD(wk,-52,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))),
[DATE_TO] = Convert(DateTime, DATEADD(wk,-52,DATEADD(ms,-2,DATEADD(week, DATEDIFF(day, 0, getdate())/7, 7)))),
[YEAR]	= NULL,
[QUARTER] = NULL,
[YEAR_AND_QUARTER] = NULL, -- Year and quarter
[MONTH_NUMBER] = NULL,
[MONTH_NAME] = NULL,
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = DATEPART(wk,  DATEADD(wk,-52,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))), 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL,
[DAY_NAME_SORTED] = NULL,	
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL,
[DD_MMM_YY] = NULL,
[MM_DD_YYYY] = NULL

UNION
-- ‘Rolling 12 months’
SELECT  
[ROWKEY]	= 18, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Rolling 12 months'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Rolling 12 months ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(year, -1, GETDATE())), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(year, -1, GETDATE())), 3) + ' '
                             + DATENAME(YY, DATEADD(year, -1, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, GETDATE()), 2) + ' ' 
                             + LEFT(DATENAME(MM, GETDATE()), 3) + ' '
                             + DATENAME(YY, GETDATE())
                             + ')'
                             ),
[DATE_FROM] = DATEADD(YEAR,-1, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] =  Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 

UNION
-- ‘Rolling 6 months’
SELECT  
[ROWKEY]	= 17, 
[DATEKEY] = NULL,
[DATE_PERIOD_KEY] = NULL,
[DATE]	= NULL, 
[DATE_DATE] = NULL, 
[SHORT_DATE_NAME] = CONVERT(VARCHAR(50), 'Rolling 6 months'),
[LONG_DATE_NAME] = CONVERT(VARCHAR(50), 'Rolling 6 months ('
                             + RIGHT('0' + DATENAME(DD, DATEADD(month, -6, GETDATE())), 2) + ' ' 
                             + LEFT(DATENAME(MM, DATEADD(month, -6, GETDATE())), 3) + ' '
                             + DATENAME(YY, DATEADD(month, -6, GETDATE()))
                             + ' - '
                             + RIGHT('0' + DATENAME(DD, GETDATE()), 2) + ' ' 
                             + LEFT(DATENAME(MM, GETDATE()), 3) + ' '
                             + DATENAME(YY, GETDATE())
                             + ')'
                             ),
[DATE_FROM] = DATEADD(month,-6, Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()))),
[DATE_TO] =  Convert(DateTime, DATEADD(ms,-2,DATEDIFF(DAY, -1, GETDATE()))),
[YEAR]	= NULL, 
[QUARTER] = NULL, 
[YEAR_AND_QUARTER] = NULL,
[MONTH_NUMBER] = NULL, 
[MONTH_NAME] = NULL, 
[MONTH_YEAR] = NULL,
[MONTH_YEAR_ABBREVIATED] = NULL,
[MONTH_ABBREVIATED] = NULL,
[MONTH_NAME_SORTED] = NULL,
[WEEK_NUMBER] = NULL, 
[WEEK_STARTING] = NULL,
[DAY_NUMBER] = NULL,
[DAY_NAME] = NULL, 
[DAY_NAME_SORTED] = NULL, 
[DAY_NUMBER_ORDINAL] = NULL,
[DAY_AND_NAME] = NULL,
[DAY_AND_NAME_ABBREVIATED] = NULL,
[DD_MMM_YYYY] = NULL, 
[DD_MMM_YY] = NULL, 
[MM_DD_YYYY] = NULL 


GO