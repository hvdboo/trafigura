set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 320;
set pagesize 2048;
select 	T1.M_LABEL as Unit, T1.M_DESC as Description,
case when T1.M__TYPE_=1 then 'Volume'
	when T1.M__TYPE_ =2 then 'Weight'
	when T1.M__TYPE_=4 then 'Energy'
	when T1.M__TYPE_=8 then 'Power'
	when T1.M__TYPE_=16 then 'Time'
	when T1.M__TYPE_=32 then 'Volume Flow'
	when T1.M__TYPE_=64 then 'Temperature'
	when T1.M__TYPE_=128 then 'Weight Flow'
	when T1.M__TYPE_=16777216 then 'Other'
end as UnitType,
case when T2.M_LABEL is null then ' ' 
	else T2.M_LABEL
end as StockUnit,
case when T3.M_LABEL is null then ' ' 
	else T3.M_LABEL
end as TimeUnit,
case when T1.M__TYPE_=16777216 then ' ' else to_char(T1.M_CNV_FCT) end as IsEqualTo,
case when T1.M__TYPE_=16777216 then ' '
	when T1.M_CNV_MLT=4 then 'Fraction'
	when T1.M_CNV_MLT =1 then 'Multiple'
	when T1.M_CNV_MLT=2 then 'Linear'
end as OperationType,
case when T1.M__TYPE_=16777216 then ' '
	when T1.M_CNV_MLT=2 then to_char(T1.M_CNV_OFST) 
	else ' ' 
end as ConventionOffset,
case when T1.M__TYPE_=16777216 then ' ' 
	when T1.M__TYPE_=1 then 'M3'
	when T1.M__TYPE_ =2 then 'MT'
	when T1.M__TYPE_=4 then 'GJ'
	when T1.M__TYPE_=8 then 'MW'
	when T1.M__TYPE_=16 then 'S'
	when T1.M__TYPE_=32 then 'M3/S'
	when T1.M__TYPE_=64 then 'K'
	when T1.M__TYPE_=128 then 'MT/S'	
end as UnitShort,

------
from 	CM_UNIT_DBF T1
left outer join CM_UNIT_DBF T2 on T1.M_STK_REF=T2.M_REFERENCE
left outer join CM_UNIT_DBF T3 on T1.M_TIME_REF=T3.M_REFERENCE
order by T1.M_LABEL;
quit; 
SPOOL OFF;