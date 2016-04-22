    --Prepare Table for excercise
create table managerowie
	( name int, boss int )
GO
    --insert some entries
insert managerowie values 
	(1, 2),	(2, 3), (3, NULL), (4, NULL), (5, 6), (6, NULL), (7, 8), (8, 9), (9, 10), (10, NULL)	
GO


  --query top manager and level for each employee in the company:

with SubTable (TopBoss, name, level) AS

(SELECT   --level 1: top bosses
  NULL, managerowie.name, 1
FROM managerowie
WHERE managerowie.boss is NULL

Union all

Select  
  Case When TopBoss IS NULL Then managerowie.boss Else TopBoss END    --copy your boss' name or name your boss copied
	, managerowie.name, 1+level
FROM SubTable
JOIN managerowie
ON managerowie.boss = SubTable.name)

  --check the result
SELECT * FROM SubTable		
