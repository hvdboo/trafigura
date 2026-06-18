set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 150;
set pagesize 2048;
select M_CR_CITY as City, M_CR_C_CODE as CityCode  
from CR_CITY_DBF order by M_CR_CITY;
quit;
SPOOL OFF;