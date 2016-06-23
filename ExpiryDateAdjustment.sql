/* Purpose of this file is to track changes in pack expiry date.
Standard purchase histroy is held separately from adjustments. 
Matching adjustment with packs is problematic because commont fields are only customer ID and pack ID. 
This means that if customer purchased same pack for the second time - date the adjustment was made becomes crucial in identifying which subscription was modified
This is done by selecting max (AdjustmentDate) separately for each pack StartDate
*/

-- create some purchase history data for practice

IF OBJECT_ID('tempdb..##KrzGod_MasloMaslane') IS NOT NULL
DROP TABLE ##KrzGod_MasloMaslane
GO

CREATE TABLE ##KrzGod_MasloMaslane  (
    [StartDate] datetime NOT NULL
    , [EndDate] datetime NOT NULL
	, [CustomerNumber] int NOT NULL
	, [PackNumber] int NOT NULL
)

INSERT INTO ##KrzGod_MasloMaslane VALUES
  ('2016-01-01','2016-02-01','1234', '10')
, ('2016-01-10','2016-02-10','1234', '20')
, ('2016-02-01','2016-03-01','1234', '10')
, ('2016-02-10','2016-03-10','1234', '20')
, ('2016-01-01','2016-02-01','4321', '10')
, ('2016-01-10','2016-02-10','4321', '20')
, ('2016-02-01','2016-03-01','4321', '10')
, ('2016-02-10','2016-03-10','4321', '20')

GO

--create some pack expiry date adjustments

IF OBJECT_ID('tempdb..##KrzGod_ZmianyMasla') IS NOT NULL
DROP TABLE ##KrzGod_ZmianyMasla
GO

CREATE TABLE ##KrzGod_ZmianyMasla  (
    [DataZmiany] datetime NOT NULL
    , [NowyStart] datetime NOT NULL
	, [NowyEnd] datetime NOT NULL
	, [CustomerNumber] int NOT NULL
	, [PackNumber] int NOT NULL
)

INSERT INTO ##KrzGod_ZmianyMasla VALUES
  ('2016-01-20','2016-01-05', '2016-02-05', '1234', '10')
  , ('2016-01-22','2016-01-15', '2016-02-15', '1234', '10')
  , ('2016-01-22','2016-01-17', '2016-02-17', '1234', '20')
  , ('2016-02-26','2016-02-20', '2016-03-20', '1234', '20')
  , ('2016-03-01','2016-02-05', '2016-03-05', '1234', '20')
  , ('2016-01-22','2016-01-15', '2016-02-15', '4321', '10')
  , ('2016-01-22','2016-01-17', '2016-02-17', '4321', '20')


GO

-- */


--quick pick at both tables
SELECT * FROM ##KrzGod_MasloMaslane
SELECT * FROM ##KrzGod_ZmianyMasla



SELECT mm.CustomerNumber  --Unique customer ID
	, mm.PackNumber     -- subscription ID
	, mm.StartDate    -- Oryginal subscription start date
	, mm.EndDate    --Oryginal subscription End Date
	, zm.NowyEnd    -- End Date after adjustment

FROM ##KrzGod_MasloMaslane mm

LEFT JOIN
-- following table looks up the most recent adjustment date for each customer, each pack type and each subscription cycle separately
	(SELECT zm.CustomerNumber
		, zm.PackNumber
		, mm.StartDate
		, max (zm.DataZmiany) as LastAdjustment
	FROM ##KrzGod_ZmianyMasla zm
		LEFT JOIN ##KrzGod_MasloMaslane mm
		ON zm.CustomerNumber = mm.CustomerNumber
		AND zm.PackNumber = mm.PackNumber
		AND zm.DataZmiany BETWEEN mm.StartDate AND mm.EndDate
	GROUP BY zm.CustomerNumber
		, zm.PackNumber
		, mm.StartDate
		) NewDates

	ON mm.CustomerNumber =  NewDates.CustomerNumber
	AND mm.PackNumber = NewDates.PackNumber
	AND mm.StartDate = NewDates.StartDate

-- find correct expiry date by looking up Cst ID, pack ID and date when most recent adjustment was made
	LEFT JOIN ##KrzGod_ZmianyMasla zm
	ON zm.CustomerNumber = NewDates.CustomerNumber
	AND zm.PackNumber = NewDates.PackNumber
	AND zm.DataZmiany = NewDates.LastAdjustment
