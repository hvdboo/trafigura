set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 400;
set pagesize 10000;
set feedback off;
-------
select  CAST(M_SETNAME AS CHAR(13)) as MaturitySet, 
	case	when (M_TYPE =1) then 'Future'
		when (M_TYPE =2) then 'Option on Future'
		when (M_TYPE =3) then 'Option on Equity or Equity Index' 
               	end as MaturitySetType,
	CAST(M_LABEL AS VARCHAR2(15)) as MaturityLabel,
	case 	when (M_MAT is null) then ' ' else to_char(M_MAT,'DD MON YY')
	end as MaturityDate,
	case	when (M_VMAT is null) then ' ' else to_char(M_VMAT,'DD MON YY') end as ValueDate,
	case	when (M_TEDATE is null) then ' ' else to_char(M_TEDATE,'DD MON YY') end as LastTradingDate,
	CAST(M_UNDLAB AS VARCHAR2(25)) as UnderlyingMaturityLabel
from OM_MAT_DBF
where M_DELETED=0
and M_MAT >= '20081215'
and (M_TYPE != 0 )
order by 1,2,M_MAT;
quit;
SPOOL OFF;