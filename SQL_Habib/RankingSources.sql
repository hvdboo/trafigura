set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 50;
set pagesize 2048;
select M_LABEL as RankingSource, M_RANK as Rank
from RNK_SRC_DBF
order by M_LABEL;
quit;
SPOOL OFF;