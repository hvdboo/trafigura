set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2584;
set pagesize 2048;
select  T1.M_LABEL as FutureMaturitySet, T1.M_DESC as Description, 
case 	when (T2.M_LABEL is null) then ' '
		else T2.M_LABEL
		end as Label,
-------
-------
	case when (T2.M_QT_START is null) then ' '
		else to_char(T2.M_QT_START,'DD MON YY')
		end as QuotationStarts,
	case when (T2.M_QT_END is null) then ' '
		else to_char(T2.M_QT_END,'DD MON YY')
		end as QuotationEnds, 
case 	when (T2.M_ST_START is null) then ' '
		else to_char(T2.M_ST_START,'DD MON YY')
		end 	 as DeliveryStarts, 
	case when (T2.M_ST_END is null) then  ' '
		else to_char(T2.M_ST_END,'DD MON YY')
		end 	 as DeliveryEnds,
	case when (T2.M_NT_START is null) then ' '
		else to_char(T2.M_NT_START,'DD MON YY')
		end 	 as NotificationStarts,
	case when (T2.M_NT_END is null) then ' '
		else to_char(T2.M_NT_END,'DD MON YY')
		end 	 as NotificationEnds,
    case when T2.M_FQT_END is null then ' ' else T2.M_FQT_END end as FloatingMaturity,
	case when T2.M_FST_START is null then ' ' else T2.M_FST_START end as FloatingDeliveryStarts,
	case when T2.M_FST_END is null then ' ' else T2.M_FST_END end as FloatingDeliveryEnds,
-------
-------
	case when T2.M_FLT_RUL = 0  then 'None'
		when T2.M_FLT_RUL = 1  then 'Cash Today'
		when T2.M_FLT_RUL = 2  then 'Cash'
		when T2.M_FLT_RUL = 3  then '3M'
		when T2.M_FLT_RUL = 4  then '15M'
		when T2.M_FLT_RUL = 5  then '27M'
		when T2.M_FLT_RUL = 6  then '63M'
		when T2.M_FLT_RUL is null  then ' '
	end as FltRule
-------
-------
from 	CM_FMAT_DBF T1 
left outer join CM_FMAT1_DBF T2 on T1.M_REFERENCE= T2.M_FMAT_ID 
order by T1.M_LABEL,T2.M_LABEL;
-------
quit;
SPOOL OFF;
		