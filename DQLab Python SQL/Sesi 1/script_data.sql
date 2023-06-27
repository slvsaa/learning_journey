-- Gunakan dqlabmartbasic databse
use dqlabmartbasic ;

-- Menghapus tabel ms_pelanggan_dqlab jika sudah ada
DROP TABLE IF EXISTS ms_pelanggan_dqlab;

-- Membuat tabel ms_pelanggan_dqlab
CREATE TABLE ms_pelanggan_dqlab (
kode_pelanggan varchar(15) DEFAULT NULL,
no_urut int(11) DEFAULT NULL,
nama_pelanggan varchar(100) DEFAULT NULL,
alamat varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Mengunci tabel ms_pelanggan_dqlab untuk menulis
LOCK TABLES ms_pelanggan_dqlab WRITE;

-- Menambahkan data ke tabel ms_pelanggan_dqlab
INSERT INTO ms_pelanggan_dqlab VALUES
('dqlabcust00',0,'Pelanggan Non Member',NULL),
('dqlabcust01',1,'Eva Novianti, S.H.','Vila Sempilan, No. 67 - Kota B'),
('dqlabcust02',2,'Heidi Goh','Vila Sempilan, No. 11 - Kota B'),
('dqlabcust03',3,'Unang Handoko','Vila Sempilan, No. 1 - Kota B'),
('dqlabcust04',4,'Jokolono Sukarman','Vila Permata Intan Berkilau, Blok C5-7'),
('dqlabcust05',5,'Tommy Sinaga','Vila Permata Intan Berkilau, Blok A1/2'),
('dqlabcust06',6,'Irwan Setianto','Vila Gunung Seribu, Blok O1 - No. 1 - Kota C'),
('dqlabcust07',7,'Agus Cahyono','Vila Gunung Seribu, Blok F4 - No. 8'),
('dqlabcust08',8,'Maria Sirait','Vila Bukit Sagitarius, Gang. Sawit No. 3'),
('dqlabcust09',9,'Ir. Ita Nugraha','Vila Bukit Sagitarius, Gang Kelapa No. 6'),
('dqlabcust10',10,'Djoko Wardoyo, Drs.','Vila Bukit Sagitarius, Blok A1 No. 1');

-- Membuka kunci tabel ms_pelanggan_dqlab
UNLOCK TABLES;

-- Menghapus tabel ms_produk_dqlab jika sudah ada
DROP TABLE IF EXISTS ms_produk_dqlab;

-- Membuat tabel ms_produk_dqlab
CREATE TABLE ms_produk_dqlab (
kode_produk varchar(15) DEFAULT NULL,
no_urut int(11) DEFAULT NULL,
kategori_produk varchar(100) DEFAULT NULL,
nama_produk varchar(100) DEFAULT NULL,
harga double DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Mengunci tabel ms_produk_dqlab untuk menulis
LOCK TABLES ms_produk_dqlab WRITE;

-- Menambahkan data ke tabel ms_produk_dqlab
INSERT INTO ms_produk_dqlab VALUES
('prod-01',1,'Alat Tulis Kantor','Kotak Pensil DQLab',62500),
('prod-02',2,'Aksesoris Komputer','Flashdisk DQLab 64 GB',55000),
('prod-03',3,'Gift & Voucher','Gift Voucher DQLab 100rb',100000),
('prod-04',4,'Aksesoris Komputer','Flashdisk DQLab 32 GB',40000),('prod-05',5,'Gift & Voucher','Gift Voucher DQLab 250rb',250000),('prod-06',6,'Alat Tulis Kantor','Pulpen Multifunction + Laser DQLab',92500),('prod-07',7,'Gift & Voucher','Tas Travel Organizer DigiSkills.id',48000),('prod-08',8,'Gift & Voucher','Gantungan Kunci DQLab',15800),('prod-09',9,'Alat Tulis Kantor','Buku Planner Agenda DQLab',92000),('prod-10',10,'Alat Tulis Kantor','Sticky Notes DQLab 500 sheets',55000);

-- Membuka Kunci 
UNLOCK TABLES;


-- Menghapus tabel tr_penjualan_dqlab jika sudah ada
DROP TABLE IF EXISTS `tr_penjualan_dqlab`;

-- Membuat tabel
CREATE TABLE `tr_penjualan_dqlab` (
  `kode_urut_transaksi` varchar(10) DEFAULT NULL,
  `kode_transaksi` varchar(10) DEFAULT NULL,
  `kode_pelanggan` varchar(15) DEFAULT NULL,
  `tgl_transaksi` datetime DEFAULT NULL,
  `no_urut` int(11) DEFAULT NULL,
  `kode_produk` varchar(15) DEFAULT NULL,
  `nama_produk` varchar(100) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `harga` double DEFAULT NULL,
  `diskon_persen` double DEFAULT NULL CHECK (`diskon_persen` >= 0 and `diskon_persen` <= 100)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;





-- Mengunci tabel
LOCK TABLES `tr_penjualan_dqlab` WRITE;


-- Memasukan Value
INSERT INTO `tr_penjualan_dqlab` VALUES ('1','tr-001','dqlabcust07','2020-05-01 00:00:00',1,'prod-01','Kotak Pensil DQLab',5,62500,0),('2','tr-001','dqlabcust07','2020-05-01 00:00:00',2,'prod-03','Flash disk DQLab 32 GB',1,100000,25),('3','tr-001','dqlabcust07','2020-05-01 00:00:00',3,'prod-09','Buku Planner Agenda DQSQuad',3,92000,0),('4','tr-001','dqlabcust07','2020-05-01 00:00:00',4,'prod-04','Flashdisk DQLab 32 GB',3,40000,0),('5','tr-002','dqlabcust00','2020-05-01 00:00:00',1,'prod-03','Gift Voucher DQLab 100rb',2,100000,0),('6','tr-002','dqlabcust00','2020-05-01 00:00:00',2,'prod-10','Sticky Notes DQLab 500 sheets',4,55000,0),('7','tr-002','dqlabcust00','2020-05-01 00:00:00',3,'prod-07','Tas Travel Organizer DQLab',1,48000,0),('8','tr-003','dqlabcust03','2020-05-03 00:00:00',1,'prod-02','Flashdisk DQLab 64 GB',2,55000,12.5),('9','tr-004','dqlabcust03','2020-05-03 00:00:00',1,'prod-10','Sticky Notes DQLab 500 sheets',5,55000,0),('10','tr-004','dqlabcust03','2020-05-03 00:00:00',2,'prod-04','Flashdisk DQLab 32 GB',4,40000,0),('11','tr-005','dqlabcust00','2020-06-12 00:00:00',1,'prod-09','Buku Planner Agenda DQSQuad',3,92000,0),('12','tr-005','dqlabcust00','2020-06-12 00:00:00',2,'prod-01','Kotak Pensil DQLab',1,62500,5),('13','tr-005','dqlabcust00','2020-06-12 00:00:00',3,'prod-04','Flashdisk DQLab 32 GB',2,40000,0),('14','tr-006','dqlabcust02','2020-06-19 00:00:00',1,'prod-05','Gift Voucher DQLab 250rb',4,250000,0),('15','tr-006','dqlabcust02','2020-06-19 00:00:00',2,'prod-08','Gantungan Kunci DQLab',2,15800,0);

-- Membuka kunci
UNLOCK TABLES;

