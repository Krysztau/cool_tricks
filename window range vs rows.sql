-- window using rows counts rows before/after current row
-- window using range compares values and pick ones within set boundaries.

-- e.g. using rows in col1='c' will look one row back
-- but using range will compare value of col2, and for rows where col2 IN (5,9) it will not include preceeding column because it's value is more than 1 smaller, and 1 is lower boundary

WITH data_tbl AS
(SELECT 'a' as col1, 1 as col2, 1 as col3
UNION ALL SELECT 'a', 2, 1
UNION ALL SELECT 'a', 3, 0
UNION ALL SELECT 'a', 4, 3
UNION ALL SELECT 'b', 2, 2
UNION ALL SELECT 'b', 3, 0
UNION ALL SELECT 'b', 4, 0
UNION ALL SELECT 'c', 1, 0
UNION ALL SELECT 'c', 2, 5
UNION ALL SELECT 'c', 3, 2
UNION ALL SELECT 'c', 5, 4
UNION ALL SELECT 'c', 6, 0
UNION ALL SELECT 'c', 9, 1
)
select
col1, col2, col3
-- , sum (col3) OVER (PARTITION BY col1 order by col2 ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as running_ttl
-- , sum (col3) OVER (PARTITION BY col1 order by col2 ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) as prev_running_ttl
-- , count (col3) OVER (PARTITION BY col1 order by col2 ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) as records_left
-- , LAG (col3) OVER (PARTITION BY col1 order by col2 ASC) prev_col3
, array_agg(col3) OVER (PARTITION BY col1 order by col2 ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) as array_based_on_rows
, array_agg(col3) OVER (PARTITION BY col1 order by col2 RANGE BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) as array_based_on_VALUE
, CASE WHEN LAG (col3) OVER (PARTITION BY col1 order by col2 ASC) IS NULL  -- TRUE if this is the first record ever (ordered by date)
            THEN running_ttl  -- for the first record ever the current FTS is also delta from previous day (where FTS was zero)
            ELSE running_ttl - sum (col3) OVER (PARTITION BY col1 order by col2 ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING)
            END AS DAILY_DELTA  -- FTS minus same FTS calculation conducted for yesterday
    
from data_tbl
