-- Tetris Day 2

-- query 1 SELECT ALL 
SELECT  *
FROM  tr_penjualan AS tp
LIMIT 5;

-- query 2 SELECT mutiple columns
SELECT 
	kode_cabang,
	kode_transaksi
FROM tr_penjualan tp 
LIMIT 5;

-- query 3 distinct
SELECT DISTINCT 
	kode_cabang
FROM tr_penjualan tp ;

-- query 4 alias
SELECT DISTINCT 
	kode_cabang AS cabang
FROM tr_penjualan tp;

## contoh komen 1
-- Contoh komen 2
/* Contoh komen 3 */
-- shortcut komen ctrl + /
/* shortcut ctrl + shft + / */

-- LATIHAN PART 1
SELECT DISTINCT 
	tgl_transaksi AS trx_date,
	kode_cabang AS branch
FROM tr_penjualan AS sales
LIMIT 5;

-- query where
SELECT *
FROM ms_kota mk 
WHERE kode_propinsi = 'P30';

SELECT *
FROM ms_harga_harian mhh  
WHERE tgl_berlaku >= '2008-12-31';

-- where AND 
SELECT 
	kode_produk,
	tgl_berlaku,
	kode_cabang 
FROM ms_harga_harian mhh 
WHERE 
	kode_cabang = 'CABANG-047' 
	AND tgl_berlaku >= '2008-12-31';
	
-- where OR 
SELECT 
	kode_produk,
	tgl_berlaku,
	kode_cabang 
FROM ms_harga_harian mhh 
WHERE 
	kode_cabang = 'CABANG-047' 
	OR tgl_berlaku >= '2008-12-31';
	
-- where OR AND (perhatikan tanda kurung)
SELECT 
	kode_produk, 
	tgl_berlaku , 
	kode_cabang
FROM ms_harga_harian 
WHERE 
	(tgl_berlaku >= '2008-12-31'  AND kode_cabang = 'CABANG-047')
	OR (tgl_berlaku <= '2008-12-31'  AND kode_cabang = 'CABANG-039') ;

-- where IN 
SELECT DISTINCT 
	kode_produk, 
	tgl_berlaku, 
	kode_cabang
FROM ms_harga_harian 
WHERE 
	kode_cabang IN ('CABANG-039', 'CABANG-047');
	
-- where NOT IN 
SELECT DISTINCT 
	kode_cabang 
FROM ms_harga_harian 
WHERE 
	kode_cabang NOT IN ('CABANG-039', 'CABANG-047');
	
-- where IS NULL dan IS NOT NULL
SELECT
	count(*) AS Total
FROM ms_produk mp 
WHERE nama_produk IS NULL;

SELECT
	count(*) AS Total
FROM ms_produk mp 
WHERE nama_produk IS NOT NULL;

-- where LIKE and NOT LIKE 
SELECT 
	kode_propinsi, nama_propinsi 
FROM ms_propinsi mp 
WHERE nama_propinsi LIKE '%Yogyakarta';

SELECT 
	kode_propinsi, nama_propinsi 
FROM ms_propinsi mp 
WHERE nama_propinsi NOT LIKE 'Jawa%';


