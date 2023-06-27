SELECT nama_pegawai, count(DISTINCT ts.no_so) AS jumlah_so, target, IF(count(DISTINCT no_so)<target, "ya", "tidak") AS kurang_dari_target
FROM tr_so ts 
INNER JOIN 	ms_pegawai mp 
ON ts.kode_sales  = mp.kode_pegawai
WHERE MONTH(tgl_so) = 1
GROUP BY 1,3
ORDER BY nama_pegawai;

