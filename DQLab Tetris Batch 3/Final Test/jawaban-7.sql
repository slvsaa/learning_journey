SELECT satu.x AS X, dua.y AS Y
FROM xy satu
JOIN xy dua 
ON satu.x = dua.x
WHERE satu.x < dua.y
ORDER BY satu.x, dua.y;