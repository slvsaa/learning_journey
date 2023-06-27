SELECT
	mp.nama_product,
	sum(IF(ts.satuan = 'krat', ts.qty*24, IF(ts.satuan = 'dus', ts.qty*30, ts.qty))) AS qty
FROM tr_so ts 
JOIN ms_product mp 
ON ts.kode_barang = mp.kode_produk
GROUP BY 1
ORDER BY qty DESC, mp.nama_product
LIMIT 3;