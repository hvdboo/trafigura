set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 470;
set pagesize 2048;
select 	M_LABEL as Shifter,
	case when (M_REL_ABS = 0) then 'Simple Shifter'  when (M_REL_ABS = 1) then 'Relative Shifter' end as RelativeAbsolute,
	case when (M_REL_ABS = 0) then ' ' else M_LABELTWO end as RelativeShifter,
	case when (M_CALENDAR = 0) then 'None'  
		when (M_CALENDAR = 1) then 'Week-end'
		when (M_CALENDAR = 2) then 'External'
		when (M_CALENDAR = 3) then 'Internal'
		when (M_CALENDAR = 4) then 'External +'
	end  as CalendarMode,
	M_STRCALEN as Calendar,
	case when (M_ADJTSTYN = 0) then 'No' when (M_ADJTSTYN = 1) then 'Yes' end as AdjustmentBeforeShiftFlag,
	CAST(M_ADJTRUST AS VARCHAR2(25)) as AdjustmentBeforeShift ,
	case when (M_ADJTCOYN = 0) then 'No' when (M_ADJTCOYN = 1) then 'Yes' end as AdjustmentAfterShiftFlag,
	CAST(M_ADJTRUCO AS VARCHAR2(25)) as AdjustmentAfterShift, 
	case when (M_FOR_BACK = 0) then 'Backward' when (M_FOR_BACK = 1) then 'Forward' end as ShiftDefinition,
	case when (M_DEF_UNIT = 0) then 'Business day'
		when (M_DEF_UNIT = 1) then 'Day'
		when (M_DEF_UNIT = 2) then 'Week'
		when (M_DEF_UNIT = 3) then 'Month'
		when (M_DEF_UNIT = 4) then 'Quarter'
		when (M_DEF_UNIT = 5) then 'Semester' 
		when (M_DEF_UNIT = 6) then 'Year' 
	end  as Unit, 
	M_DEF_FREQ as Frequency,
	case when (M_OPENCLOSED =0 ) then 'Previous'
		when (M_OPENCLOSED = 1) then 'Next'
		when (M_OPENCLOSED = 2) then 'Modified following'
		when (M_OPENCLOSED = 3) then 'Indifferent'
	end as RollConvention, 
	case when (M_ETOEFLAG = 0) then 'No' when (M_ETOEFLAG = 1) then 'Yes' end as EndToEnd,
	case when (M_ALGORITHM = 0) then 'Union' when (M_ALGORITHM = 1) then 'Parallel' end as Algorithm,
	case when (M_IDENTICAL = 0 ) then 'No' when  (M_IDENTICAL = 1 ) then 'Yes' end as KeepIdenticalDates
-------
from DAT_ECH_DBF 
where M_GENERAT = 1 
order by M_LABEL;
quit;
SPOOL OFF;
/* we can put more condition to a better display on EndtoEnd (only appears when M_DEF_UNIT >3 ) and RollConvention (M_DEF_UNIT <>0) */