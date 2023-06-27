-- Tetris Day 6

-- Homework
-- No. 1
SELECT DISTINCT mc.nama_cabang, mk.nama_kota 
FROM tr_penjualan tp 
LEFT JOIN ms_cabang mc ON mc.kode_cabang = tp.kode_cabang 
LEFT JOIN ms_kota mk ON mk.kode_kota = mc.kode_kota;

-- cara cepat
WITH transaksi_cabang as(
	SELECT DISTINCT kode_cabang
	FROM tr_penjualan tp 
),
cabang_kota as(
	SELECT DISTINCT kode_cabang, nama_cabang, kode_kota 
	FROM ms_cabang mc
),
kota as (
	SELECT DISTINCT kode_kota, nama_kota 
	FROM ms_kota mk
)

-- SELECT ck.nama_cabang, mk.nama_kota 
-- FROM transaksi_cabang tc
-- LEFT JOIN cabang_kota ck ON tc.kode_cabang = ck.kode_cabang
-- LEFT JOIN kota mk ON ck.kode_kota = mk.kode_kota;

-- No. 2
SELECT ck.nama_cabang, k.nama_kota
FROM cabang_kota ck 
LEFT JOIN kota k ON ck.kode_kota = k.kode_kota
LEFT JOIN transaksi_cabang tc ON tc.kode_cabang = ck.kode_cabang
WHERE tc.kode_cabang IS NULL;

-- No. 3
SELECT 
	k.nama_kota,
	group_concat(nama_cabang ORDER BY ) AS cabang_jualan,
	group_concat(nama_cabang) AS cabang_tdk_jualan
FROM cabang_kota ck 
LEFT JOIN kota k ON ck.kode_kota = k.kode_kota
LEFT JOIN transaksi_cabang tc ON tc.kode_cabang = ck.kode_cabang;

-- No. 4
SELECT count(DISTINCT kode_item) AS barang_terjual  
FROM tr_penjualan tp
WHERE date_format(tgl_transaksi, "%Y-%m-%d")  = '2008-08-08' AND kode_kasir = '039-127';

-- cara cepat
WITH terjual as(
	SELECT DISTINCT kode_item, date_format(tgl_transaksi, "%Y-%m-%d") AS tanggal, kode_kasir 
	FROM tr_penjualan tp 
)

SELECT count(kode_item) AS barang_terjual  
FROM terjual AS t
WHERE tanggal = '2008-08-08' AND t.kode_kasir = '039-127';

-- No. 5
SELECT count(*) jumlah_cabang
FROM ms_cabang mc 
LEFT JOIN ms_kota mk  ON mc.kode_kota = mk.kode_kota 
LEFT JOIN ms_propinsi mp ON mk.kode_propinsi = mp.kode_propinsi 
WHERE mp.nama_propinsi LIKE "%Yogyakarta%";

-- No. 6
-- No. 7

