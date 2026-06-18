set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 90;
set pagesize 2048;
select M_RTNG_A as RatingAgency, M_RANK as Rank, M_RTNG as Rating
from RT_RTNG_DBF
order by M_RTNG_A, M_RANK;
quit;
SPOOL OFF;