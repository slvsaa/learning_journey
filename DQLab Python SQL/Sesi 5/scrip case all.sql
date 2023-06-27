/* day 4*/
use dqlabmartbasic;

select * from ms_pelanggan_dqlab;

#1#
select distinct(nama_pelanggan), kode_pelanggan, alamat from ms_pelanggan_dqlab;

#2#
select distinct(nama_produk), harga from ms_produk_dqlab

#3#

select * from ms_produk_dqlab  where nama_produk ='Flashdisk DQLab 32 GB' AND harga >15000;

#4#
select * from ms_produk_dqlab 
where nama_produk ='Gantungan Kunci DQLab'
OR nama_produk = 'Tas Travel Organizer DigiSkills.id' 
OR nama_produk = 'Flashdisk DQLab 84 GB';

#5#

select * from ms_produk_dqlab mpd  WHERE harga < 50000;

#6#
select kode_pelanggan, 
nama_produk,
qty,
harga, 
qty*harga AS total 
from tr_penjualan_dqlab 
having qty*harga >=200000  order by total DESC;

#7#

select kode_pelanggan,
sum(qty) as total_qty,
sum(harga) as total_harga, 
MOD(qty,3) as sisa_quantity 
from tr_penjualan_dqlab 
group by kode_pelanggan

#8#

SELECT kode_transaksi ,
tgl_transaksi ,
no_urut ,
nama_produk , 
CONCAT(kode_produk, nama_produk) as kode_produk_namaproduk 
from tr_penjualan_dqlab tpd where qty =5;

#9#

SELECT nama_pelanggan, 
SUBSTRING_INDEX(nama_pelanggan, ',', 1) as nama_tanpa_gelar,
SUBSTRING_INDEX(nama_pelanggan, ' ', 1) nama_panggilan 
from ms_pelanggan_dqlab mpd where kode_pelanggan ='dqlabcust01' ;

#10#

SELECT nama_pelanggan, 
SUBSTR(nama_pelanggan, 2, 3) as Initial from ms_pelanggan_dqlab mpd ;

#11#

SELECT nama_pelanggan, 
SUBSTR(nama_pelanggan, 2, 3) as Initial,
LENGTH(nama_pelanggan) as Total_Char  from ms_pelanggan_dqlab mpd ;

#12#

SELECT nama_pelanggan,
REPLACE(nama_pelanggan, 'Pelanggan Non Member', 'Not member') as new_revisi_pelanggan, 
SUBSTR(nama_pelanggan, 2, 3) as Initial,LENGTH(nama_pelanggan) as Total_Char  
from ms_pelanggan_dqlab mpd ;

#13#

SELECT nama_pelanggan,
UPPER(nama_pelanggan) as UPPER_NAMA_PELANGGAN,
LOWER(nama_pelanggan) as lower_nama_pelanggan, 
REPLACE(nama_pelanggan, 'Pelanggan Non Member', 'Not member') as new_revisi_pelanggan, 
SUBSTR(nama_pelanggan, 2, 3) as Initial,
LENGTH(nama_pelanggan) as Total_Char  from ms_pelanggan_dqlab mpd ;

#14#

SELECT kode_pelanggan, 
count(kode_transaksi) as total_order, 
sum(qty),
sum(harga*qty) as  revenue 
from tr_penjualan_dqlab tpd  group by kode_transaksi;

#15#

SELECT kode_pelanggan, 
count(kode_transaksi) as total_order, 
sum(qty),sum(harga*qty) as  revenue,
CASE
When SUM(harga*qty) >= 900000 THEN 'Target Achieved'
WHEN SUM(harga*qty) <= 850000 THEN 'Less performed'
ELSE 'Follow Up'
END remark
FROM tr_penjualan_dqlab   
group by kode_pelanggan;

/*Day 5
#16#

select 
tr_penjualan.kode_transaksi,
tr_penjualan.kode_pelanggan,
tr_penjualan.kode_produk,
ms_produk.nama_produk, 
ms_produk.harga, 
tr_penjualan.qty, 
ms_produk.harga*tr_penjualan.qty as total 
from tr_penjualan_dqlab as tr_penjualan 
inner join ms_produk_dqlab as ms_produk 
on 
tr_penjualan.kode_produk=ms_produk.kode_produk where qty =3
order by harga desc;

#17#

select 
nama_produk , 
no_urut from tr_penjualan_dqlab tpd 
union all
select nama_produk , no_urut from tr_penjualan_dqlab tpd2

#18#
select 
nama_produk,
no_urut from tr_penjualan_dqlab tpd 
union 
select nama_produk , 
no_urut from tr_penjualan_dqlab tpd2

#19#

select distinct ms_pelanggan.kode_pelanggan, 
ms_pelanggan.nama_pelanggan,
ms_pelanggan.alamat,nama_produk
from ms_pelanggan_dqlab as ms_pelanggan
inner join 
tr_penjualan_dqlab as tr_penjualan
ON ms_pelanggan.kode_pelanggan=tr_penjualan.kode_pelanggan
WHERE 
tr_penjualan.nama_produk = 'Kotak Pensil DQLab' 
OR tr_penjualan.nama_produk='Flashdisk DQLab 32 GB'
OR tr_penjualan.nama_produk = 'Sticky Notes DQLab 500 sheets' */

#20#

select nama_produk, 
tgl_transaksi,
DATEDIFF(curdate() , tgl_transaksi) AS days_aging #Date diff fimulai dengan currdate/now
FROM tr_penjualan_dqlab tpd ;

#21#
select nama_produk, 
tgl_transaksi,
month(tgl_transaksi) as month_date,
year(tgl_transaksi) as year_date, 
day(tgl_transaksi) as day_date,
DATEDIFF(curdate() , tgl_transaksi) AS days_aging
FROM tr_penjualan_dqlab tpd ;

#22#

select nama_produk, 
tgl_transaksi,
monthname(tgl_transaksi) as month_date,
year(tgl_transaksi) as year_date, 
day(tgl_transaksi) as day_date,
DATEDIFF(curdate() , tgl_transaksi) AS days_aging
FROM tr_penjualan_dqlab tpd ;

#23#

select nama_produk, 
tgl_transaksi,
month(tgl_transaksi) as month_date,
year(tgl_transaksi) as year_date, 
day(tgl_transaksi) as day_date,
TIMESTAMPDIFF(year,  tgl_transaksi,curdate()) AS year_aging,
TIMESTAMPDIFF(month,  tgl_transaksi,curdate()) AS month_aging,
TIMESTAMPDIFF(day , tgl_transaksi,curdate()) AS days_aging 
FROM tr_penjualan_dqlab tpd ;

set sql_mode='ONLY_FULL_GROUP_BY'