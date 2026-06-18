set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 100;
set pagesize 2048;
select M_CATEGORY0 as Category,
case when(M_CAT_A = 0 ) then 'Sector'
	when(M_CAT_A = 1 ) then 'Seniority'
	when(M_CAT_A = 2 ) then 'Rating'
end as Abscissa,
case when(M_CAT_O = 0 ) then 'Sector'
	when(M_CAT_O = 1 ) then 'Seniority'
	when(M_CAT_O = 2 ) then 'Rating'
end as Ordinate
from	CR_CAT_DBF
order by M_CATEGORY0;
quit;
SPOOL OFF;