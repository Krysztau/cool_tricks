/*
purpose of this query is to translate dates between retail and normal calendar.
Retail calendar starts weeks on sunday and keeps all month to be of length 4 or 5 weeks exactly.
This results in some months starting after 1st day of calendar month and others starting before the first
(e.g. on 30th of the previous month)
additionally - months are counted from April i.e. month 1 = April, month 10=January
finally years are named like so 1516, 1617, 1718, 1819 and so on.

This query takes an actual date - finds it in calendar table, returns proper month number (e.g. 4 for April) 
and proper year number. For example if JAnuary 2019 starts on 30/12/2018, than any date from 30/12 onwardsm,
that falls in retail month 10 will return 2019-01-01
*/


SELECT cal.date_dashed 
    -- equivalent calendar month converted from fiscal. E.g. 1=April, 11=February
    , strright(concat('0' , cast( ((cal.fiscal_month+2)%12)+1 AS string)),2) equivalent_month
    -- get the last 2 digits of retail year equivalent, e.g. 18 for months 1-9 and 18+1 for 10-12
    , strleft(cast(cal.fiscal_year+100*floor(cal.fiscal_month/10) as string),2) equivalent_year

    , concat ('20'
            , strleft(cast(1819+100*floor(cal.fiscal_month/10) as string),2)
            , '-'
            , strright(concat('0' , cast( ((cal.fiscal_month+2)%12)+1 AS string)),2)-- equivalent calendar month converted from fiscal. E.g. 1=April, 11=February
            ,'-01'  --first day of the month
            ) AS equivalent_of_first_of_that_month
    
FROM  calendar cal
WHERE  cal.date_dashed IN ('2018-04-01' ,'2018-12-29' , '2018-12-30' , '2018-12-31' , '2019-01-01' , '2019-01-31' , '2019-02-02', '2019-02-03')
;



/*
below is a sample from this table:
fiscal_month,calendar_year,fiscal_year,date_dashed
10,2018,1819,2018-12-30
*/
