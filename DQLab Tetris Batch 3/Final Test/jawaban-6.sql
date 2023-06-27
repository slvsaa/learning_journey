SELECT 
	node,
	CASE
		WHEN parent IS NULL THEN 'Akar'
		WHEN node IN (SELECT parent FROM nodes) THEN 'Batang'
		ELSE 'Daun'
	END AS position
FROM nodes n
ORDER BY node;