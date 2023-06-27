-- Sesi 3

-- select literal

select 37;

select 37 as number;

select 37 as number, 89 as number1;

select 73 as num, true as benarsalah, 'pakalongan' as kota;

select null as kosong;
-- beberapa treatment jika ditemukan nilai null
-- 1. NULL karena HUMAN ERROR, isi dengan MODUS -nilai yg sering muncul- ketika tipe data KATEGORIKAL
-- 2. NULL karena HUMAN ERROR, isi dengan MEDIAN/MEAN ketika tipe data NON-KATEGORIKAL
-- 3. NULL karena ACTIVITY KOSONG, isi dengan LAST DATA yg dimiliki

-- Penggunaan operator matematika
select 2+2 as penjumlahan, 10/3 as pembagian, 10 div 3 as pembagian_div, 2-(-2) as pengurangan, 10 % 3 as modulo;
-- DIV adalah pembagian dengan PEMBULATAN KE BAWAH

select 4*2 as soal1, (4*8)%7 as soal2, (4*8) mod 7 as soal3;

use dqlabmartbasic;

select qty*harga as revenue from tr_penjualan_dqlab;
-- membuat view
create view view_revenue as select *, qty*harga as revenue from tr_penjualan_dqlab;

-- OPERATOR PERBANDINGAN
select nama_produk, qty, qty<4 as qty_below_4, harga, harga != 92000 from tr_penjualan_dqlab;


-- PRAKTIK FUNCTION
select round(2.11) as ROUND, round(2.11, 1) as ROUND_1,
ceiling (2.11) as ceiling1, floor(2.11) as FLOOR1, now() as DATE_NOW;  

select round(harga) as round, round(harga, 2) as round_1,
ceiling(harga/qty) as ceiling1, floor(harga/qty) as floor1,
year(tgl_transaksi) as year1, month(tgl_transaksi) as month1
from tr_penjualan_dqlab tpd ;

select now() as saat_ini, year('2022-05-03') as tahun, 
datediff('2022-07-22', '2022-05-03') as selisih, day('2022-05-03') as hari;

select kode_pelanggan, tgl_transaksi, datediff(now(),tgl_transaksi)  from tr_penjualan_dqlab tpd ;

select monthname(now()); 

-- WHERE
select * from tr_penjualan_dqlab tpd where harga > 100000;

select * from tr_penjualan_dqlab tpd where harga > 100000 and qty = 5;

select * from tr_penjualan_dqlab tpd where harga > 100000 or qty = 5;

select * from tr_penjualan_dqlab tpd 
where harga > 100000 or nama_produk = 'Kotak Pensil DQLab';

-- LIKE -untuk string-
select * from tr_penjualan_dqlab tpd 
where nama_produk like 'f%';

select * from tr_penjualan_dqlab tpd 
where nama_produk like '%f%';

