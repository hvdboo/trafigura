set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 700;
set pagesize 2048; 
select CAST(M_LABEL AS VARCHAR2(20)) as ScheduleGenerator,
	case when (M_REL_ABS = 0 ) then 'Simple generator' 
		when (M_REL_ABS = 1 ) then 'Relative generator'
		when (M_REL_ABS = 2 ) then 'Maturity set filter' end as SimpleRelMatSetFilter,
-------
	case when (M_REL_ABS = 0 ) then ' ' else M_LABELTWO end as SchedMaturitySet,
-------
	case when ((M_REL_ABS = 0 ) OR (M_REL_ABS = 1 )) then ' '
		when (M_MATSETCO = 0 )  then 'Maturity'
		when (M_MATSETCO = 1 ) then 'Value Date'
		when (M_MATSETCO = 2 ) then 'First TD'
		when (M_MATSETCO = 3 ) then 'Last TD'
	end as MaturityChoice,	
-------
-------
	case when M_REL_ABS = 2 then ' ' 
		when (M_CALENDAR = 0 ) then 'None' 
		when (M_CALENDAR = 1 ) then 'Week-end'
		when (M_CALENDAR = 2 ) then 'External'
		when (M_CALENDAR = 3 ) then 'Internal'
		when (M_CALENDAR = 4 ) then 'External +'
	end as CalendarCheck, M_STRCALEN as Calendar,
	case	when M_REL_ABS = 2 then ' '
		when ((M_REL_ABS <> 0 and M_NEWMODE = 1) or M_NEWMODE=0 ) and (M_ADJTSTYN= 0) then 'No' 
		when  ((M_REL_ABS <> 0 and M_NEWMODE = 1) or M_NEWMODE=0 ) and ( M_ADJTSTYN= 1) then 'Yes'
		when  ( M_NEWMODE=0 ) and ( M_ADJTSTYN= 2)  then 'Adjust'
		else ' ' end as AdjBefStartShift, 
	CAST(M_ADJTRUST AS VARCHAR2(25)) as AdjBefStartingShifter,
	case	when M_REL_ABS = 2 then ' '
		when (M_IDENTICAL = 0 ) then 'No' 
		when  (M_IDENTICAL = 1 ) then 'Yes'
	end as KeepIdenticalDates, 
	case	when M_REL_ABS = 2 then ' '
		when (M_FOR_BACK = 0) then 'Backward generation'
		when  (M_FOR_BACK = 1) then 'Forward generation'
	end as ForwardBackward,
	case	when M_REL_ABS = 2 then ' '
		when (M_DEF_UNIT = 0 )  then 'Open day'
		when (M_DEF_UNIT = 1 )  then 'Day'
		when (M_DEF_UNIT = 2 )  then 'Week'
		when (M_DEF_UNIT = 3 )  then 'Month'
		when (M_DEF_UNIT = 4 )  then 'Quarter'
	 	when (M_DEF_UNIT = 5 )  then 'Semester'
		when (M_DEF_UNIT = 6 )  then 'Year'
		when (M_DEF_UNIT = 9 )  then 'Intra day'
	end as Unit,
-------
	case	when M_REL_ABS = 2 then ' '
		when (M_REL_ABS <> 1 ) and (M_RECURSIF =0 ) then 'Normal' 
		when (M_REL_ABS <> 1 ) and (M_RECURSIF =1 ) then 'Recursive' else ' '	 
	end as Generation, 
	case when M_REL_ABS = 2 then ' '
		when (M_DEF_UNIT <>  9) then to_char(M_DEF_FREQ) else ' ' end as "Number",
	case	when M_REL_ABS = 2 then ' '
		when (M_ETOEFLAG = 0 and M_DEF_UNIT in (3,4,5,6)) then 'Off' 
		when (M_ETOEFLAG = 1 and M_DEF_UNIT in (3,4,5,6) ) then 'On' 
		when (M_ETOEFLAG = 2 and M_DEF_UNIT in (3,4,5,6) ) then 'On (last open day)'
		else ' ' end as EndToEnd, 
-------
	case when M_REL_ABS = 2 then ' '
		when (M_DEF_UNIT = 0 ) or (M_DEF_UNIT = 9 ) or (M_CALENDAR = 0) then ' '
		when (M_OPENCLOSED = 0 ) then 'Previous'
	 	when (M_OPENCLOSED = 1)  then 'Next'
	 	when (M_OPENCLOSED = 2 ) then 'Modified following'
	 	when (M_OPENCLOSED = 3 ) then 'Indifferent'
	 	when (M_OPENCLOSED = 4 ) then 'Modified preceding'
	end as RollConvention,
	case	when M_REL_ABS = 2 then ' '
		when (M_ADJTCOYN = 0 ) then 'No' 
		when (M_ADJTCOYN= 1 ) then 'Yes'
	end as AdjustmentFlag,
	M_ADJTRUCO as Adjustment,
	case	when M_REL_ABS = 2 then ' '
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and  (M_SCONV = 0) then 'Indifferent'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_SCONV = 1) then 'Roll convention'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_SCONV = 2) then 'Shifter'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_SCONV = 3) then 'Specific Adjustment'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_SCONV = 4) then 'Roll convention + Adjustment'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_SCONV = 5) then 'Shifter + Roll convention'
		else ' '	end as StartConvention,
	M_SSHIFT as StartShift,
	case	when M_REL_ABS = 2 then ' '
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_ECONV = 0) then 'Indifferent'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_ECONV = 1) then 'Roll convention'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_ECONV = 2) then 'Shifter'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_ECONV = 3) then 'Specific Adjustment'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_ECONV = 4) then 'Roll convention + Adjustment'
		when (M_NEWMODE = 1) and (M_REL_ABS = 0 ) and (M_ECONV = 5) then 'Shifter + Roll convention'
		else ' '  end as EndConvention,
	M_ESHIFT as EndShift, 
	case when M_REL_ABS = 2 then ' '
		when (M_ESTUB = 0 and M_NEWMODE = 1 and  M_REL_ABS = 0 and M_ECONV <> 0 and M_ECONV <> 1) then 'UNCHECKED' when (M_ESTUB = 1 and M_NEWMODE = 1 and M_REL_ABS = 0 and M_ECONV <> 0 and M_ECONV <> 1) then 'CHECKED' else ' ' end as AdjustFirst,
	case when M_REL_ABS = 2 then ' '
		when M_REL_ABS in (1,2) then ' ' when(M_NEWMODE = 0) then 'Old Mode' else 'New Mode ' end as NewMode
-------
from  DAT_ECH_DBF
-------
where M_GENERAT = 0
-------
order by M_LABEL;
quit;
SPOOL OFF;