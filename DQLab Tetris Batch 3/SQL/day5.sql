-- Tetris Day 5

-- DDL
-- CREATE, ALTER , DROP 

-- CREATE 
-- Membuat table baru
CREATE table ms_propinsi2(
	kode_proponsi int,
	nama_propinsi varchar(100)
);

-- Membuat table baru berdasarkan table lama (isinya mengambil table lama)
CREATE table tbl_per_kasir AS 
	SELECT 
		kode_cabang,
		kode_kasir,
		count(*) total_transaksi_kasir
	FROM 
		tr_penjualan tp 
	GROUP BY 1,2;


-- DML
-- INSERT , UPDATE, DELETE, CALL, EXPLAIN PLAN 

-- INSERT 
INSERT INTO ms_propinsi2 (kode_proponsi, nama_propinsi) 
VALUES (61, 'Kalimantan Barat');

INSERT INTO ms_propinsi2
VALUES (62, 'Kalimantan Selatan'), (63, 'Kalimantan Timur');

-- UPDATE 
UPDATE tbl_per_kasir 
SET total_transaksi_kasir = 0,
	kode_kasir = ''
WHERE kode_cabang = 'CABANG-039';

-- update dengan join
UPDATE tbl_per_kasir 
JOIN ms_cabang mc ON tbl_per_kasir.kode_cabang = mc.kode_cabang
SET total_transaksi_kasir = 0
WHERE mc.nama_cabang = 'PHI Mini Market - Surabaya 01';

-- DELETE 
DELETE FROM ms_propinsi2 WHERE kode_proponsi = 61;

-- DCL
-- GRANT, REVOKE

-- CONSTRAINT
CREATE TABLE `ms_pelanggan2` (
  `no_urut` int(11) NOT NULL AUTO_INCREMENT, 
  `kode_pelanggan` varchar(15) DEFAULT NULL,
  `nama_customer` varchar(100) UNIQUE,
  `alamat` varchar(255) DEFAULT NULL,
  `status` ENUM('menikah', 'belum menikah') ,
  `umur` int CHECK(`umur` >= 12 and `umur` <= 140),
   PRIMARY KEY (`no_urut`)
);

CREATE TABLE `tr_penjualan2` (
  `no_penjualan` int, 
   `no_urut` int(11) NOT NULL,
   FOREIGN KEY (`no_urut`)
      REFERENCES `ms_pelanggan`(`no_urut`)
);

-- INDEX
-- Optimasi Database
