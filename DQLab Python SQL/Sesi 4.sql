-- SESI 4
use dqlabmartbasic;

-- Fungsi Order By
select * from tr_penjualan_dqlab tpd 
order by harga; -- default dari KECIL ke BESAR -asc-

select kode_produk, qty, harga 
from tr_penjualan_dqlab tpd 
order by kode_produk ;

select nama_produk,qty  
from tr_penjualan_dqlab tpd 
order by nama_produk ;

-- Order By dengan 2 kolom
select nama_produk, qty, harga 
from tr_penjualan_dqlab tpd 
order by qty, harga ;

select * 
from tr_penjualan_dqlab tpd 
order by qty, tgl_transaksi ;

select * 
from ms_pelanggan_dqlab mpd 
order by nama_pelanggan ;

select * 
from ms_pelanggan_dqlab mpd 
order by alamat ;

-- ASC dan DESC
-- ASC -default- Kecil ke Besar
select nama_produk, harga  from ms_produk_dqlab mpd 
order by harga asc;

-- DESC Besar ke Kecil
select nama_produk, harga  from ms_produk_dqlab mpd 
order by harga desc;

-- Gabungan ASC DESC
select nama_produk, harga, qty from tr_penjualan_dqlab tpd 
order by harga asc, qty desc;

select * from tr_penjualan_dqlab tpd 
order by tgl_transaksi desc, qty;

select * from ms_pelanggan_dqlab mpd 
order by nama_pelanggan desc;

select * from ms_pelanggan_dqlab mpd 
order by alamat desc;

-- Gabungan Where dan Order by 
select * from tr_penjualan_dqlab tpd 
where nama_produk like 'F%'
order by harga, qty ;

-- Fungsi Agregate
select sum(harga) from tr_penjualan_dqlab; 
select max(harga) from tr_penjualan_dqlab;
select min(harga) from tr_penjualan_dqlab; 

select count(distinct kode_pelanggan) from tr_penjualan_dqlab; 
select count(*) from tr_penjualan_dqlab; 

-- Group By tanpa Agregasi
select nama_produk from tr_penjualan_dqlab tpd
group by nama_produk ;

-- Group By dengan Agregasi
select nama_produk, sum(qty) from tr_penjualan_dqlab tpd
group by nama_produk ;

select nama_produk, kode_pelanggan, sum(qty)
from tr_penjualan_dqlab tpd
group by nama_produk, kode_pelanggan ;

select kode_pelanggan, nama_produk, sum(qty)
from tr_penjualan_dqlab tpd
group by kode_pelanggan, nama_produk;

-- HAVING
-- HAVING digunakan untuk filtering data HASIL AGREGASI
select nama_produk, sum(qty)  from tr_penjualan_dqlab
group by nama_produk having sum(qty) > 3; 

select nama_produk, sum(qty)
from tr_penjualan_dqlab
group by nama_produk 
having sum(qty) > 3
order by sum(qty) ; 

