set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 755;
set pagesize 2048;
select  T1.M_LABEL as OptionMaturitySet, T1.M_DESC as Description,  
case when T3.M_LABEL is null then ' ' else T3.M_LABEL end as OptionMaturity,
	case when T3.M_QT_START is null then ' ' else to_char(T3.M_QT_START,'DD MON YY') end as QuotationStartsDate,
	case when T3.M_MATURITY is null then ' ' else to_char(T3.M_MATURITY,'DD MON YY') end as QuotationEndsDate,
	case when T4.M_LABEL is null then ' ' else T4.M_LABEL end as Future,
	case when T4.M_QT_END is null then ' ' else to_char(T4.M_QT_END,'DD MON YY') end as FutureQuotationEndsDate,
	case when T4.M_ST_START is null then ' ' else to_char(T4.M_ST_START,'DD MON YY') end as DeliveryStartsDate,
	case when T4.M_ST_END is null then ' ' else to_char(T4.M_ST_END,'DD MON YY') end as DeliveryEndsDate
-------
from 	CM_OMAT_DBF T1 
-------
left outer join CM_OMAT1_DBF T3 on T1.M_REFERENCE=T3.M_OMAT_ID 
left outer join CM_FMAT1_DBF T4 on T3.M_UND_REF = T4.M_REFERENCE
order by T1.M_LABEL,T3.M_LABEL;
quit;
SPOOL OFF;	