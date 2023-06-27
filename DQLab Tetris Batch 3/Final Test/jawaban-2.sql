SELECT
	td.no_do, 
	ts.kode_customer, 
	td.tgl_do,
	IF(ts.satuan = 'krat', ts.qty*24, IF(ts.satuan = 'dus', ts.qty*30, ts.qty)) AS qty,
	IF(ts.satuan = 'krat', mp.harga_satuan*(ts.qty*24), IF(ts.satuan = 'dus', mp.harga_satuan*(ts.qty*30), mp.harga_satuan*ts.qty)) + 
		(IF(ts.satuan = 'krat', mp.harga_satuan*(ts.qty*24), IF(ts.satuan = 'dus', mp.harga_satuan*(ts.qty*30), mp.harga_satuan*ts.qty)))
		*0.10 + mc.ongkos_kirim AS amount
FROM tr_do td 
INNER JOIN 	tr_so ts 
ON ts.no_entry_so  = td.no_entry_so
INNER JOIN 	ms_product mp  
ON mp.kode_produk = ts.kode_barang 
INNER JOIN ms_customer mc 
ON ts.kode_customer = mc.kode_customer
ORDER BY no_do;