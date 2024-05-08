WITH sample AS
(SELECT 
"a" col1
, 1 col2
, 10 col3
, 100 number1
UNION ALL SELECT "a", 1, 20, 101
UNION ALL SELECT "a", 1, 30, 102
UNION ALL SELECT "b", 4, 40, 103
UNION ALL SELECT "b", 4, 50, 104
UNION ALL SELECT "a", 2, 60, 105
UNION ALL SELECT "a", 2, 70, 106
)

, 
interim_tbl AS
(
SELECT
sam.col1, sam.col2
, ARRAY_AGG(STRUCT(sam.col3, sam.number1)) arr1  -- ORDER BY sample.col1)[SAFE_OFFSET(0)] AS moj_array
FROM sample sam

GROUP BY sam.col1, sam.col2
)

, interim_tbl_latest_data AS
(
SELECT interim_tbl.col1
, ARRAY_AGG(STRUCT (interim_tbl.col2, interim_tbl.arr1) ORDER BY interim_tbl.col2 DESC)[SAFE_OFFSET(0)] arr2   --- move this to FROM section?
FROM
 interim_tbl
GROUP BY col1
)

SELECT
col1
, arr2.col2
, MAX(nest1.col3) AS max_c3
, AVG(nest1.number1) AS avg_num1
FROM interim_tbl_latest_data itld
, UNNEST (arr2.arr1) as nest1
GROUP BY 1,2
