set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 550;
set pagesize 2048;
select T1.M_LABEL as LocationLabel,T1.M_DESC as Description,
case when T2.M_LABEL is null then ' ' else T2.M_LABEL end as Type,
-------
-------
case when T3. M_LABEL  is null then ' ' else T3. M_LABEL  end as TimeZone,
case when T7.M_LABEL is null then ' ' else T7.M_LABEL end as Area,
case when T8.M_LABEL is null then ' ' else T8.M_LABEL end as GeographyFrom, 
case when T9.M_LABEL is null then ' ' else T9.M_LABEL end as GeographyTo,
case when T5.M_DSP_LABEL is null then ' ' else T5.M_DSP_LABEL end as Owner, 
case when T6.M_DSP_LABEL is null then ' ' else T6.M_DSP_LABEL end as Operator,
-------
T1.M_CALENDAR as Calendar,
case when T10.M_LABEL is null then ' ' else T10.M_LABEL end as NominationUnit,
T1.M_SHIFTER as DeliveryShifter, T1.M_GRANULAR as DeliveryGranularity,
case when T12.M_LABEL is null then ' ' else T12.M_LABEL end as Registration
-------
from CM_LOCAT_DBF T1 
	left join DAT_TZONE_DBF T3 on T3.M_REFERENCE=T1.M_TIME_ZONE 
	left join CM_LTYPE_DBF T2 on T2.M_REFERENCE=T1.M_TYPE 
	left join TRN_CPDF_DBF T5 on T1.M_OWNER=T5.M_ID 
	left join TRN_CPDF_DBF T6 on T1.M_HOLDER=T6.M_ID
	left join  CM_LOCAT_DBF T7 on T7.M_REFERENCE = T1.M_AREA
	left join  CM_LOCAT_DBF T8 on T8.M_REFERENCE = T1.M_FROM
	left join  CM_LOCAT_DBF T9 on T9.M_REFERENCE = T1.M_TO
	left join CM_UNIT_DBF  T10 on T10.M_REFERENCE = T1.M_UNIT
	left join  CM_REGMAP_LOC_DBF T11 on T1.M_REFERENCE = T11.M_LOC_REF
	left join CM_REG_DBF T12 on T11.M_REG_REF = T12.M_REFERENCE
-------
order by T1.M_LABEL;
quit;
SPOOL OFF;