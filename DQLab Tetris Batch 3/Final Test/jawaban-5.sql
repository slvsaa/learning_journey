SELECT 
	vendor,
	sum(IF(ts.satuan = 'krat', mp.harga_satuan*(ts.qty*24), IF(ts.satuan = 'dus', mp.harga_satuan*(ts.qty*30), mp.harga_satuan*ts.qty))) AS amount
FROM tr_inv ti 
JOIN tr_do td 
ON ti.no_entry_do = td.no_entry_do
JOIN tr_so ts 
ON td.no_entry_so = ts.no_entry_so 
JOIN ms_product mp 
ON ts.kode_barang = mp.kode_produk 
JOIN ms_vendor mv 
ON mp.kode_vendor = mv.kode_vendor 
GROUP BY 1
ORDER BY amount DESC, vendor 
LIMIT 3
;