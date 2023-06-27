-- Tetris Day 4

-- Pembahasan Homework
-- No. 1
SELECT 
	DISTINCT nama_depan,
	nama_belakang
FROM ms_karyawan mk 
WHERE nama_depan LIKE 'A%' AND nama_belakang LIKE '%a';

-- No. 2
SELECT count(DISTINCT kode_kasir) AS jumlah_kasir
FROM tr_penjualan tp 
WHERE jumlah_pembelian > 15;

-- MATERI
-- UNION ALL
SELECT 2019 AS tahun, 'Januari' AS bulan
UNION ALL
SELECT 2019 AS tahun, 'Januari' AS bulan;

-- UNION
SELECT 2019 AS tahun, 'Januari' AS bulan
UNION
SELECT 2019 AS tahun, 'Januari' AS bulan;


-- SUBQUERY
-- Scalar
SELECT 
	date_format(tgl_transaksi, '%M %Y') AS month_date,
	count(DISTINCT kode_produk) AS unique_produk_terjual,
	(SELECT count(*) FROM ms_produk mp) AS jumlah_produk
FROM tr_penjualan tp
GROUP BY 1;

-- Column
SELECT *
FROM tr_penjualan tp 
WHERE 
	jumlah_pembelian IN (
		SELECT max(jumlah_pembelian) 
		FROM tr_penjualan tp2 
	);

-- Table
SELECT *
FROM ms_harga_harian mhh 
WHERE (kode_cabang, harga_berlaku_cabang) IN (
	SELECT 
		kode_cabang,
		max(harga_berlaku_cabang) 
	FROM ms_harga_harian mhh2 
	GROUP BY 1
);

-- Derived Table
SELECT 
	avg(tp.jumlah_transaksi) AS avg_jumlah_transaksi
FROM (
	SELECT 
		kode_cabang,
		count(*) AS jumlah_transaksi 
	FROM tr_penjualan tp
	GROUP BY kode_cabang
) AS tp;

-- CTE /  WITH QUERY
WITH penjualan AS (
	SELECT 
		kode_cabang,
		count(*) AS jumlah_transaksi 
	FROM tr_penjualan tp
	GROUP BY kode_cabang
)
SELECT 
	avg(jumlah_transaksi) AS avg_jumlah_transaksi
FROM penjualan;

-- WINDOW FUNCTION
-- Seperti AGREGASI tp tdk ada pengurangan jumlah ROW
-- No. 1
SELECT 
	kode_kota,
	kode_cabang,
	count(kode_cabang) OVER (PARTITION BY kode_kota) AS jumlah_cabang
FROM ms_cabang mc 
WHERE 
	kode_kota IN ('KOTA-001','KOTA-002','KOTA-003','KOTA-004','KOTA-005')
GROUP BY 1,2;

-- No. 2
WITH total_per_cabang AS (
	SELECT kode_cabang, count(*) AS jumlah_transaksi 
	FROM tr_penjualan tp 
	GROUP BY 1
)
SELECT *, AVG(jumlah_transaksi) OVER () AS avg_transaksi
FROM total_per_cabang;

-- No. 3 penggunaan ROW
WITH total_per_cabang as(
	SELECT 
		MONTH(tgl_transaksi) AS bulan,
		count(*) AS jumlah_transaksi 
	FROM tr_penjualan tp 
	GROUP BY 1
)
SELECT *, ROW_NUMBER () OVER(ORDER BY jumlah_transaksi DESC) AS rank_transaksi
FROM total_per_cabang;

-- No. 4 penggunaan RANK
WITH ms_cabang_cte as(
	SELECT 
		kode_kota ,
		count(kode_cabang) AS jumlah_cabang
	FROM ms_cabang 
	WHERE kode_kota IN ('KOTA-001','KOTA-002','KOTA-003','KOTA-004','KOTA-005')
	GROUP BY 1
)
SELECT 
	*, 
	ROW_NUMBER () OVER(ORDER BY jumlah_cabang DESC) AS used_row,
	RANK () over(ORDER BY jumlah_cabang DESC) AS used_rank
FROM ms_cabang_cte;

-- No. 5 Penggunaan LAG
WITH total_per_cabang as(
	SELECT 
		MONTH(tgl_transaksi) AS bulan,
		kode_cabang,
		count(*) AS jumlah_transaksi 
	FROM tr_penjualan tp 
	GROUP BY 1,2
)
SELECT 
	*, 
	LAG(jumlah_transaksi,1) OVER (PARTITION BY kode_cabang ORDER BY bulan) AS trxs
FROM total_per_cabang;

-- VIEW
CREATE VIEW per_kasir AS 
	SELECT 
		kode_cabang,
		kode_kasir,
		count(*) total_transaksi_kasir
	FROM tr_penjualan tp 
	GROUP BY 1,2;
	
SELECT 
	*,
	sum(total_transaksi_kasir) over (PARTITION BY kode_cabang) AS total_transaksi_cabang 
FROM per_kasir pk;

-- drop view (menghapus view)
DROP view per_kasir;

-- STORED PROCEDURE
CALL per_kasir_cabang("cabang-039");
CALL per_kasir_cabang("cabang-039", '2008-01-01');

SHOW CREATE PROCEDURE per_kasir_cabang;

SELECT *
FROM information_schema.parameters
WHERE SPECIFIC_NAME = "per_kasir_cabang";