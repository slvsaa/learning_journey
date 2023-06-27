SELECT
	p1.nama, 
	p2.nama, 
	abs(DATE_FORMAT(FROM_DAYS(DATEDIFF(p1.tanggal_registrasi ,p1.tanggal_lahir)), '%Y') + 0 - 
	DATE_FORMAT(FROM_DAYS(DATEDIFF(p2.tanggal_registrasi ,p2.tanggal_lahir)), '%Y') + 0) AS selisih_umur
FROM people p1
JOIN people p2 ON p1.nama <> p2.nama
ORDER BY selisih_umur ASC
LIMIT 1
;
