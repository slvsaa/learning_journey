-- Sesi 5
use dqlabmartbasic;

-- JOIN
select tpd.kode_transaksi, tpd.tgl_transaksi, tpd.nama_produk, mpd.nama_pelanggan
from tr_penjualan_dqlab tpd join ms_pelanggan_dqlab mpd 
on tpd.kode_pelanggan = mpd.kode_pelanggan;

select tpd.kode_transaksi, tpd.tgl_transaksi, mpd.nama_produk, mpd.kategori_produk 
from tr_penjualan_dqlab tpd join ms_produk_dqlab mpd
on tpd.kode_produk = mpd.kode_produk;

-- CROSS JOIN -On True-
select tpd.kode_transaksi, tpd.tgl_transaksi, mpd.nama_produk, mpd.kategori_produk 
from tr_penjualan_dqlab tpd join ms_produk_dqlab mpd
on true;

-- INNER JOIN -sama kayak join biasa
select tpd.kode_transaksi, tpd.tgl_transaksi, mpd.nama_produk, mpd.kategori_produk 
from tr_penjualan_dqlab tpd inner join ms_produk_dqlab mpd
on tpd.kode_produk = mpd.kode_produk;

-- LEFT OUTER JOIN
select tpd.kode_transaksi, tpd.tgl_transaksi, mpd.nama_produk, mpd.kategori_produk 
from tr_penjualan_dqlab tpd left outer join ms_produk_dqlab mpd
on tpd.kode_produk = mpd.kode_produk;

-- RIGHT OUTER JOIN
select tpd.kode_transaksi, tpd.tgl_transaksi, mpd.nama_produk, mpd.kategori_produk 
from tr_penjualan_dqlab tpd right outer join ms_produk_dqlab mpd
on tpd.kode_produk = mpd.kode_produk;


select tpd.kode_transaksi, tpd.kode_produk, tpd.tgl_transaksi, tpd.nama_produk, mpd.nama_produk, mpd2.nama_pelanggan
from ms_produk_dqlab mpd 
join tr_penjualan_dqlab tpd 
on mpd.kode_produk = tpd.kode_produk
join ms_pelanggan_dqlab mpd2 
on mpd2.kode_pelanggan = tpd.kode_pelanggan;

select tpd.kode_transaksi, tpd.kode_produk, tpd.tgl_transaksi, mpd.nama_produk, mpd2.nama_pelanggan, mpd.harga, mpd2.alamat 
from ms_produk_dqlab mpd 
join tr_penjualan_dqlab tpd 
on mpd.kode_produk = tpd.kode_produk
join ms_pelanggan_dqlab mpd2 
on mpd2.kode_pelanggan = tpd.kode_pelanggan
order by tpd.harga desc;

select tpd.kode_transaksi, tpd.kode_produk, tpd.harga, tpd.nama_produk, mpd.kategori_produk, mpd2.alamat 
from ms_produk_dqlab mpd 
join tr_penjualan_dqlab tpd 
on mpd.kode_produk = tpd.kode_produk
join ms_pelanggan_dqlab mpd2 
on mpd2.kode_pelanggan = tpd.kode_pelanggan
group by kode_transaksi, kode_produk, harga, nama_produk, kategori_produk, alamat
order by tpd.harga desc;

-- UNION -menggabungkan table secara vertikal dengan syarat jumlah kolom sama
select nama_pelanggan from ms_pelanggan_dqlab 
union
select harga from ms_produk_dqlab;

select 'nama' as kategori_nama, nama_produk from ms_produk_dqlab mpd 
union
select 'harga' as kategori_harga, harga from tr_penjualan_dqlab tpd;

-- Jika ada data double, UNION hanya mengambil data UNIQUE
select nama_produk from ms_produk_dqlab mpd 
union
select nama_produk from ms_produk_dqlab mpd;

-- UNION ALL menampilakan data apa adanya
select nama_produk from ms_produk_dqlab mpd 
union all
select nama_produk from ms_produk_dqlab mpd;


-- LIMIT
select nama_produk from ms_produk_dqlab mpd 
union all
select nama_produk from ms_produk_dqlab mpd
limit 5;

select tpd.kode_transaksi, tpd.kode_produk, tpd.harga, tpd.nama_produk, mpd.kategori_produk, mpd2.alamat 
from ms_produk_dqlab mpd 
join tr_penjualan_dqlab tpd 
on mpd.kode_produk = tpd.kode_produk
join ms_pelanggan_dqlab mpd2 
on mpd2.kode_pelanggan = tpd.kode_pelanggan
group by kode_transaksi, kode_produk, harga, nama_produk, kategori_produk, alamat
order by tpd.harga desc
limit 5;

