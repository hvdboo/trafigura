set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2650;
set pagesize 2048;
select  T1.M_IND_LAB as InterestRateIndex,
	case when (T5.M_DLABEL is null) then ' '  
		when T1.M_CONTANGO = 1 then ' ' 
		else  T5.M_DLABEL 
	end as RateCurve,
        case    when (T1.M_CONTANGO = 1) then T5.M_DLABEL else ' ' end as NumRateCurve,
        case     when (T1.M_CONTANGO = 1) then T6.M_DLABEL else ' ' end as DenRateCurve
-------	
from  RT_GROUP_DBF T2 , RT_INDEX_DBF T1
-------
left outer join RT_CT_DBF T5 on T1.M_RT_CRV=T5.M_LABEL
left outer join RT_CT_DBF T6 on T1.M_RT_DCRV=T6.M_LABEL 
-------
-------
where		T1.M_CATEGORY=0
and 		T1.M_HISFILE=T2.M_HISFILE
and 		T1.M_CREAT_MODE = 0
order by T1.M_IND_LAB;
quit;
SPOOL OFF;