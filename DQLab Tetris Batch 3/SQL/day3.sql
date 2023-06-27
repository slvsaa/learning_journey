-- Tetris Day 3

-- Homework dr Day 2
-- No. 1
SELECT *
FROM ms_kota mk 
WHERE nama_kota LIKE '%Jakarta%';

-- No. 2
SELECT *
FROM ms_kota mk 
WHERE kode_propinsi IN ('P30','P31', 'P32');

-- END HOMEWORK

-- Fungsi Agregasi
-- Count(), MAX(), MIN(), AVG(), SUM()

SELECT count(DISTINCT kode_propinsi) AS UNIQUE_code
FROM ms_kota mk;

-- Group By
-- Kalau ada AGREGASI harus ada GROUP BY, kalo TIDAK nanti ERROR
SELECT 
	kode_propinsi,
	count(DISTINCT kode_kota) AS UNIQUE_kota
FROM ms_kota mk
GROUP BY kode_propinsi ;

-- HAVING
-- FILTER untuk AGREGASI adalah HAVING, TIDAK bisa pakai WHERE 
SELECT 
	kode_propinsi,
	count(DISTINCT nama_kota) AS UNIQUE_kota
FROM ms_kota mk
GROUP BY kode_propinsi
HAVING UNIQUE_kota > 2;

-- ORDER BY
SELECT 
	kode_cabang,
	jenis_kelamin,
	count(*) AS total
FROM ms_karyawan
GROUP BY kode_cabang, jenis_kelamin 
ORDER BY kode_cabang;

SELECT 
	kode_cabang,
	jenis_kelamin
FROM ms_karyawan
ORDER BY kode_cabang, jenis_kelamin DESC ;

-- FUNGSI STRING
-- left, right, lower, upper, lenght, replace, substr, trim

SELECT 
	nama_kota,
	REPLACE (nama_kota, "Jakarta", "JKT") AS Replacement
FROM ms_kota mk 
WHERE nama_kota LIKE "%Jakarta%";

SELECT 
	LENGTH ("Tetris Program") AS LengthOfString,
	LEFT ("Tetris Program", 3) AS LeftOfString,
	RIGHT ("Tetris Program", 4) AS RightOfString,
	lower("Tetris Program") AS LowerOfString,
	upper("Tetris Program") AS UpperOfString,
	REPLACE ("Tetris Program", "Tetris", "Batch 3") AS RepleceOfString,
	substr("Tetris Program",5,4) AS ExtractOfString, 
	trim("    Tetris Program    ") AS trimmedOfStrin;

-- FUNGSI NUMERIC
-- abs, ceil, floor, round

SELECT 
	abs(-234.5) AS AbsoluteNumber,
	CEIL(25.75) AS CeilNumber,
	floor(25.75) AS FloorNumber,
	round(135.375, 2) AS RoundNumber; 
	
-- FUNGSI TIMESTAMP
-- EXTRACT
-- year, quarter, month, week, day, hour, minute, second, microseconds
SELECT
	kode_cabang,
	EXTRACT(MONTH FROM tgl_transaksi)
FROM tr_penjualan tp;

-- DATEDIFF(date1, date2)
-- CURRENT_DATE()
SELECT current_date(); 

-- CURRENT_TIMESTAMP()
SELECT current_timestamp(); 

-- DATE_FORMAT(date, format)
SELECT date_format(current_date(), '%Y');

-- LATIHAN PART 3
SELECT 
	kode_cabang, 
	kode_produk, 
	max(jumlah_pembelian) AS jumlah_pembelian 
FROM tr_penjualan 
GROUP BY 1,2
HAVING max(jumlah_pembelian) > 10
ORDER BY 3; 

-- LATIHAN PART 4
-- No. 1
SELECT 
	lower(nama_propinsi) AS lowercase_propinsi 
FROM ms_propinsi mp;

-- No. 2
SELECT 
	jumlah_pembelian + 100 AS add_100
FROM tr_penjualan tp;

-- No. 3
SELECT 
	datediff(current_date(), tgl_transaksi) AS perbedaan_waktu
FROM tr_penjualan tp;

-- CAST (merubah tipe data)
-- CAST(value AS datatype)
SELECT 
	tgl_transaksi,
	CAST(tgl_transaksi AS date) AS date_transaksi,
	CAST(tgl_transaksi AS TIME) AS time_transaksi
FROM tr_penjualan tp;

-- IF(condition, value_if_TRUE, value_if_FALSE)
SELECT if(500 < 100, "Benar", "Salah") AS cobacoba;

-- CASE WHEN
SELECT 
	CASE 
		WHEN jumlah_pembelian > 10 THEN 'lebih dari 10'
		WHEN jumlah_pembelian > 5 THEN 'lebih dari 5'
		ELSE 'kurang atau sama dengan 5'
	END AS Kelompok,
	count(*) AS jumlah 
FROM tr_penjualan tp 
GROUP BY 1;

-- IFUNULL(exspresion, alt_value)
SELECT ifnull(NULL, "tetris program") AS coba1; 

-- COALESCE
SELECT 
	COALESCE(NULL, "Tetris Program") AS get_one,
	COALESCE(NULL, NULL, 1, 2) AS get_two,
	COALESCE(NULL, NULL, NULL, 2) AS get_three;

-- LATIHAN PART 5
-- No. 1
SELECT 
	CASE 
		WHEN nama_propinsi LIKE '%jawa%' THEN 'Pulau Jawa'
		WHEN nama_propinsi LIKE '%Kalimantan%' THEN 'Pulau Kalimantan'
		WHEN nama_propinsi LIKE '%Sulawesi%' THEN 'Pulau Sulawesi'
		WHEN nama_propinsi LIKE '%Sumatera%' THEN 'Pulau Sumatera'
		ELSE 'Lainnya'
	END AS pulau_grouping,
	nama_propinsi 
FROM ms_propinsi mp
ORDER BY 1; 

-- No. 2
SELECT 
	DISTINCT kode_produk,
	IF(harga_berlaku_cabang > (modal_cabang+100), "Sudah sesuai", "Checking")
FROM ms_harga_harian mhh;

