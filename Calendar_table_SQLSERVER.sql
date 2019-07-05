-----------------------------------------
-- Drop database objects if they exist -- 
-----------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[T_CALENDAR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[T_CALENDAR]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnGetBusinessDaysInMonth]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnGetBusinessDaysInMonth]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnGetWorkingHoursInMonth]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnGetWorkingHoursInMonth]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fnResetTimeToMidnight]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fnResetTimeToMidnight]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_CreateCalendarTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_CreateCalendarTable]
GO

------------------------------
-- Create Calendar Objects 	--
------------------------------

------------------------------------------------------------------
-- Reset time to midnight Function                              --
-- Pass in a date and it will reet the time element to midnight --
------------------------------------------------------------------
CREATE FUNCTION [dbo].[fnResetTimeToMidnight](@date DATETIME) 
RETURNS DATETIME 
BEGIN 
  SET @date = DATEADD(HOUR, - DATEPART(HOUR, @date), @date) 
  SET @date = DATEADD(MINUTE, - DATEPART(MINUTE, @date), @date) 
  SET @date = DATEADD(SECOND, - DATEPART(SECOND, @date), @date) 
  SET @date = DATEADD(MILLISECOND, - DATEPART(MILLISECOND, @date), @date) 
  RETURN @date 
END
GO

/* Create a function to get the number of business days in a month */
CREATE function [dbo].[fnGetBusinessDaysInMonth]
(  
    @currentDate datetime  
)  
returns int   
as  
begin  
  
declare @dateRange int  
declare @beginningOfMonthDate datetime, @endOfMonthDate datetime  
  
-- Get the beginning of the month  
set @beginningOfMonthDate = dateadd(month, -1, dateadd(day, -1, dateadd(month, datediff(month, 0, @currentDate) + 1, 1)))  
  
-- Get the the beginning date of the next month  
set @endOfMonthDate = dateadd(day, -1, dateadd(month, datediff(month, 0, @currentDate) + 1, 1))  
  
-- Get the date range between the beginning and the end of the month  
set @dateRange = datediff(day, @beginningOfMonthDate, @endOfMonthDate)  

return  
(  
    -- Get the number of business days by getting the number  
    -- of full weeks * 5 days a week plus the number days remaining  
    -- minus any days from the remaining days that are a weekend day  
    select  @dateRange / 7 * 5 + @dateRange % 7 -    
    (  
        select count(*)  
        from  
            (  
                select 1 as d  
                union  
                select 2  
                union  
                select 3  
                union  
                select 4  
                union  
                select 5  
                union  
                select 6  
                union  
                select 7  
            ) weekdays  
            where   d <= @dateRange % 7  
                and  
            datename(weekday, dateadd(day, -d, @endOfMonthDate)) 
                in ('Saturday', 'Sunday')  
    )  
)  
  
end  
GO

/* Get the number of working hours in a mounth */
CREATE function [dbo].[fnGetWorkingHoursInMonth](  
    @currentDate datetime,  
    @workingHoursInADay int = null  
)  
returns int  
as  
  
begin  
  
if @workingHoursInADay is null  
    set @workingHoursInADay = 8  
  
return dbo.fnGetBusinessDaysInMonth(@currentDate) * @workingHoursInADay  
  
end 
GO 


/* Create a procedure that creates a dates table and fills it with dates */
CREATE PROCEDURE dbo.P_CreateCalendarTable
(
	@StartDate	DATETIME = '20000101', /* This is the start of the dates. If you need more dates in the past; simply adjust this value */
	@EndDate	DATETIME = '21001231'  /* This is the end of the dates. If you need more dates in the future; simply adjust this value */
) AS

BEGIN 
	-- Check if the table exists
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[T_CALENDAR]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE [dbo].[T_CALENDAR]
END

	SET NOCOUNT ON
 	-- first create the table of dates
	CREATE TABLE dbo.T_CALENDAR
	(
		[ROWKEY]					INT PRIMARY KEY,
		[DATEKEY]					INT,
		[DATE_PERIOD_KEY]			INT,
		[DATE]						DATETIME,
		[DATE_DATE]					DATE,
		[SHORT_DATE_NAME]			VARCHAR(255),
		[LONG_DATE_NAME]			VARCHAR(255),
		[DATE_FROM]					DATETIME,
		[DATE_TO]					DATETIME,
		[YEAR]						INT,
		[QUARTER]					INT,
		[YEAR_AND_QUARTER]			VARCHAR(7),
		[MONTH_NUMBER]				INT,
		[MONTH_NAME]				VARCHAR(10),
		[MONTH_YEAR]				VARCHAR(16),
		[MONTH_YEAR_ABBRIVIATED] 	VARCHAR(10),
		[MONTH_ABBRIVIATED] 		VARCHAR(3),
		[MONTH_NAME_SORTED]			VARCHAR(20),
		[WEEK_NUMBER]				INT,
		[WEEK_STARTING]				INT,
		[DAY_NUMBER]			    INT,
		[DAY_NAME]					VARCHAR(10),
		[DAY_NAME_SORTED]			VARCHAR(20),
		[DAY_NUMBER_ORDINAL]		VARCHAR(10),
		[DAY_AND_NAME]				VARCHAR(20),
		[DAY_AND_NAME_ABBRIVATED]	VARCHAR(7),
		[DD_MMM_YYYY]				VARCHAR(11),
		[DD_MMM_YY]					VARCHAR(11),
		[MM_DD_YYYY]				VARCHAR(11)
	)
	 
	-- Declare local variables
	DECLARE @i INT 
	DECLARE @curdate DATETIME 
	
	-- Set the value of the variables
	SET @i 			= 12
	SET @curdate 	= @StartDate
	
	-- now add one date at a time
	WHILE @curdate <= @EndDate
	BEGIN
	 
	-- add a record for this date (could use FORMAT
	-- function if SQL Server 2012 or later)
	INSERT INTO dbo.T_CALENDAR 
	(
		[ROWKEY],
		[DATEKEY],
		[DATE_PERIOD_KEY],
		[DATE],
		[DATE_DATE],
		[SHORT_DATE_NAME],
		[LONG_DATE_NAME],
		[DATE_FROM],
		[DATE_TO],
		[YEAR],
		[QUARTER],
		[YEAR_AND_QUARTER],
		[MONTH_NUMBER],
		[MONTH_NAME],
		[MONTH_YEAR],
		[MONTH_YEAR_ABBRIVIATED],
		[MONTH_ABBRIVIATED],
		[MONTH_NAME_SORTED],
		[WEEK_NUMBER],
		[WEEK_STARTING],
		[DAY_NUMBER], 
		[DAY_NAME], 
		[DAY_NAME_SORTED],
		[DAY_NUMBER_ORDINAL],
		[DAY_AND_NAME],
		[DAY_AND_NAME_ABBRIVATED],
		[DD_MMM_YYYY],
		[DD_MMM_YY], 
		[MM_DD_YYYY]
	) 

	VALUES 
	( 
		@i, --RowKey
		(YEAR(DATEADD(d, 0, @curdate)) * 10000) + (MONTH(DATEADD(d, 0, @curdate)) * 100) + DAY(DATEADD(d, 0, @curdate)),-- DateKey
		(YEAR(@curdate) * 1000) + MONTH(@curdate), -- DatePeriodKey
		@curdate, -- Date
		CONVERT(DATE, @curdate), -- Date only
		RIGHT('0'+DATENAME(DD, DATEADD(d, 0,  @curdate)), 2)+' '+LEFT(DATENAME(MM, DATEADD(d, 0,  @curdate)), 3)+' '+DATENAME(YY, DATEADD(d, 0,  @curdate)),
		RIGHT('0'+DATENAME(DD, DATEADD(d, 0,  @curdate)), 2)+' '+DATENAME(MM, DATEADD(d, 0,  @curdate)) + ' '+ DATENAME(YY, DATEADD(d, 0,  @curdate)), 
	    dbo.fnResetTimeToMidnight(@curdate),
		dbo.fnResetTimeToMidnight(@curdate),
		Year(@curdate), -- Year
		floor((month(@curdate)+2)/3), -- Quarter
		CAST(Year(@curdate)AS VARCHAR(4))+' Q'+CAST(floor((month(@curdate)+2)/3) AS VARCHAR(1)), -- Year and quarter
		Month(@curdate), -- The month number of the current date
		DateName(m,@curdate), -- the month name of the current month (January, February, etc.)
		DateName(m,@curdate) + ' ' + CAST(Year(@curdate) AS VARCHAR(4)), -- The month and year of the current date
		SUBSTRING(DateName(m,@curdate),1,3) +' '+SUBSTRING(CAST(Year(@curdate) AS VARCHAR(4)),3,2), -- Month and year abbriviated (Jan 09, Jan 10, etc.)
		SUBSTRING(DateName(m,@curdate),1,3), -- Month name abbriviated (Jan, Feb, etc.)
		-- get month name as "01 January" or "11 November"
		CASE
			WHEN month(@curdate) < 10 THEN '0'
			ELSE ''
		END +
			CAST(month(@curdate) AS varchar(2))+' '+DateName(m,@curdate),
		DATEPART( wk, @curdate), -- the week number of the current date
		CASE
			WHEN DateName(weekday,@curdate) = 'Sunday' THEN datepart(day,(dateadd(week, datediff(week, 0, @curdate), -7)))
			ELSE datepart(day,(dateadd(week, datediff(week, 0, @curdate), 0)))
		END, -- The day of the week that the week starts on
		Day(@curdate), -- The day number of the current date
		DateName(weekday,@curdate), -- The day name of the current date (Monday, Tuesday, etc.)			
		CASE
			WHEN DateName(weekday,@curdate) = 'Monday' THEN '1 Monday'
			WHEN DateName(weekday,@curdate) = 'Tuesday' THEN '2 Tuesday'
			WHEN DateName(weekday,@curdate) = 'Wednesday' THEN '3 Wednesday'
			WHEN DateName(weekday,@curdate) = 'Thursday' THEN '4 Thursday'
			WHEN DateName(weekday,@curdate) = 'Friday' THEN '5 Friday'
			WHEN DateName(weekday,@curdate) = 'Saturday' THEN '6 Saturday'
			WHEN DateName(weekday,@curdate) = 'Sunday' THEN '7 Sunday'
		ELSE ''
		END, -- Day number sorted
		-- The day number with the ordinal on the end (1st, 2nd, 3rd, etc.)
		CASE
			WHEN DAY(@curdate) IN(1,21,31) then CAST(DAY(@curdate) AS VARCHAR(4))+'st'
			WHEN DAY(@curdate) IN(2,22) then CAST(DAY(@curdate) AS VARCHAR(4))+'nd'
			WHEN DAY(@curdate) IN (3,23) then CAST(DAY(@curdate) AS VARCHAR(4))+'rd'
			WHEN DAY(@curdate) IN(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,24,25,26,27,28,29,30) then CAST(DAY(@curdate) AS VARCHAR(4))+'th'
			ELSE CAST(DAY(@curdate) AS VARCHAR(4))
		END,
		CAST(Day(@curdate) AS VARCHAR(2)) +' '+ CAST(DateName(weekday,@curdate) AS VARCHAR(10)),
		CAST(Day(@curdate) AS VARCHAR(2)) +' '+ CAST(SUBSTRING(DateName(weekday,@curdate),0,3) AS VARCHAR(4)),
		CONVERT(VARCHAR(11), @curdate,113),
		CONVERT(VARCHAR(11),@curdate,6),
		CONVERT(VARCHAR(11), @curdate,110)
	)
	-- increase iteration count and current date
	SET @i = @i+ 1
	SET @curdate = DateAdd(day,1,@curdate)
	 
	-- quick check we haven't got a ridiculous loop
	IF @i > 36600
	BEGIN
		SELECT 'More than 100 years!'
		RETURN
	END
END
GO

/* Run the procedure now to fill the calendar table with data */
EXEC dbo.P_CreateCalendarTable
GO