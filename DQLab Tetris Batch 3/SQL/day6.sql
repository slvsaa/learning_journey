-- Tetris Day 6

-- memfilter alamat yang ada angka 26
select *
from ms_people 
where address regexp '26';

-- memfilter email diawali huruf aa (case insensitive)
select *
from ms_people 
where email regexp '^Aa';

-- memfilter people yang emailnya diawali Aa (case sensitive)
select *
from ms_people 
where regexp_like (email, '^Aa', 'c');

-- Mengganti semua angka di alamat menjadi XX
select address, regexp_replace(address, '[0-9]+','XX') 
from ms_people 
limit 10;

-- Mengambil angka dari alamat
select address, regexp_substr(address, '[0-9]+') 
from ms_people 
limit 10;

select email, regexp_replace(email, '.*@(.*)', '$1') domain
from ms_people mp 
limit 10;

select email, regexp_substr(email, '(@.+)') 
from ms_people mp 
limit 10;

select email, SUBSTR(email , INSTR(email, '@') + 1) as new
from ms_people mp 
limit 5;

select email,
	substr(regexp_substr(email, '@.+'),2)
from ms_people mp;