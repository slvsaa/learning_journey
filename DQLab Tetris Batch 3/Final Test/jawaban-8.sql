SELECT 
	CAST(IF(tanggal LIKE 'Tanggal%', 
        SUBSTRING_INDEX(SUBSTRING_INDEX(tanggal, 'Tanggal ', -1), ' terjual', 1), tanggal) AS date) AS tanggal,
    CASE 
    	WHEN qty LIKE '%lusin' THEN CAST(SUBSTRING(qty, 1, POSITION(' ' IN qty))*12 AS UNSIGNED)
    	ELSE CAST(SUBSTRING(qty, 1, POSITION(' ' IN qty)) AS UNSIGNED)
    END AS qty,
    CASE 
    	WHEN qty LIKE '%lusin' THEN CAST(total/(SUBSTRING(qty, 1, POSITION(' ' IN qty))*12)AS UNSIGNED)
    	ELSE CAST(total/SUBSTRING(qty, 1, POSITION(' ' IN qty))AS UNSIGNED)
    END AS harga_satuan,
    CAST(total AS UNSIGNED) AS total
FROM (
    SELECT 
    	trim(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(strdata, 'telah', 1), 'tanggal', -1), ' ', 2)) AS tanggal,
    	trim(SUBSTRING_INDEX(SUBSTRING_INDEX(strdata, 'terjual', -1), ' ', 3)) AS qty,
    	SUBSTRING_INDEX(SUBSTRING_INDEX(strdata, 'seharga', -1), ' ', -1) AS total
    FROM strdata
) AS subquery
ORDER BY tanggal;
