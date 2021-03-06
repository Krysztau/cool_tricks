, CONVERT (varchar(10)
       , DATEADD(day, 1 - datepart(weekday, dateadd(day, -1, dateWithSlashes)), dateWithSlashes) 
       , 120 
       ) as weekStart
, CONVERT (varchar(10)
       , DATEADD(day, 7 - datepart(weekday, dateadd(day, -1, dateWithSlashes)), dateWithSlashes) 
       , 120 
       ) as weekEnd
, CONVERT (varchar(10)
       , DATEADD (day, 1 - datepart(day,  dateWithSlashes), dateWithSlashes) 
       , 120
       ) as Monthstart
, CONVERT (varchar(10)
       , DATEADD (day, - datepart(day,  DATEADD (month, 1, '2016-01-20 00:00:00.000')) , DATEADD (month, 1, '2016-01-20 00:00:00.000')) 
       , 120
       ) as Monthend
, DATEPART(day
		, DATEADD (day, - datepart(day,  DATEADD (month, 1, '2016-03-30 00:00:00.000')) , DATEADD (month, 1, '2016-03-30 00:00:00.000'))
		) as MonthLength
,  CONVERT (varchar(10)
       , DATEADD (day, 1 - datepart(dayofyear,'2016-01-20 00:00:00.000'),'2016-01-20 00:00:00.000') 
       , 120
       ) as YearStart
  
--corrected weeknum (speedtest) - first week = 1st to 7th January and so on...
    , datepart(week,[DATE_LOCAL]) + 
		(sign(datepart(weekday,[DATE_LOCAL])- datepart(weekday,  DATEADD (day, 1 - datepart(dayofyear,[DATE_LOCAL]),[DATE_LOCAL])+1/2))     -1)/2 as SpecialWeekNum

  FROM [DB1].[dbo].[CALENDAR]

--corrected weeknum (maybe slightly slower)
  	, datepart(week,[SESSION_STARTDATE_TIME]) + 
		case when datepart(weekday,[SESSION_STARTDATE_TIME]) < datepart(weekday,(DATEADD (day, 1 - datepart(dayofyear,[SESSION_STARTDATE_TIME]),[SESSION_STARTDATE_TIME])))
		THEN -1
		ELSE 0
		END AS SpecWeekNumOPTION2
	  FROM [DB1].[dbo].[CALENDAR]
