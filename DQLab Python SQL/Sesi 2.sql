-- SESI 2

use dqlabmartbasic;

select kode_produk, nama_produk from ms_produk_dqlab;

select * from tr_penjualan_dqlab;

select nama_pelanggan, alamat from ms_pelanggan_dqlab;

select nama_produk, harga from ms_produk_dqlab;

-- Prefix
SELECT ms_produk_dqlab.nama_produk, ms_produk_dqlab.kode_produk FROM ms_produk_dqlab;

-- Prefix database
SELECT dqlabmartbasic.ms_produk_dqlab.nama_produk FROM ms_produk_dqlab;

-- ALIAS
SELECT mpd.nama_produk, mpd.kode_produk FROM ms_produk_dqlab mpd;
SELECT mpd.nama_produk AS name_of_product FROM ms_produk_dqlab mpd;

-- case 1
SELECT mpd.nama_pelanggan, mpd.alamat 
FROM ms_pelanggan_dqlab mpd;

-- case 2
SELECT mpd.nama_produk, mpd.harga 
FROM ms_produk_dqlab mpd ;