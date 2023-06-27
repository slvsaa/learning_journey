SELECT
	td.no_do,
	mc.nama_customer,
	td.tgl_do,
	'2018-02-01' AS date_measurement,
	abs(datediff(td.tgl_do, '2018-02-01')) AS aging
FROM tr_inv ti 
RIGHT JOIN tr_do td 
ON ti.no_entry_do = td.no_entry_do
JOIN tr_so ts 
ON td.no_entry_so = ts.no_entry_so 
JOIN ms_customer mc 
ON ts.kode_customer = mc.kode_customer 
WHERE ti.no_entry_do IS NULL
ORDER BY aging DESC, no_do;