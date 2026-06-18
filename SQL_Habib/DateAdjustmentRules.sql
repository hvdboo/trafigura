set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 500;
set pagesize 2048;
select	M_LABEL as Adjustment, 
case when (M_LEVEL0 = 0) then 'Day'
when (M_LEVEL0 = 1) then 'Week day'
when (M_LEVEL0 = 2) then 'Monthday'
when (M_LEVEL0 = 3) then 'Month'
when (M_LEVEL0 = 4) then 'Quarter'
when (M_LEVEL0 = 5) then 'Semester'
end as FirstLevel1,
case when (M_LEVEL0 = 2) and (M_LEVEL1 = 3) then 'The'
when (M_INDEX0 = -7) then 'First'
when (M_INDEX0 = -6) then 'Previous'
when (M_INDEX0 = -5) then 'Current'
when (M_INDEX0 = -4) then 'Next'
when (M_INDEX0 = -1) then 'Last'
when (M_INDEX0 = -3) then 'A-Penult'
when (M_INDEX0 = -2) then 'Bef.last'
else to_char (M_INDEX0)
end as FirstLevel2,
	case	when (M_LEVEL0 = 0) and (M_NUMBER0 = -5) then 'Day'
when (M_LEVEL0 = 1) and (M_NUMBER0 = 0) then 'Sunday'
when (M_LEVEL0 = 1) and (M_NUMBER0 = 1) then 'Monday'
when (M_LEVEL0 = 1) and (M_NUMBER0 = 2) then 'Tuesday'
when (M_LEVEL0 = 1) and (M_NUMBER0 = 3) then 'Wednesday'
when (M_LEVEL0 = 1) and (M_NUMBER0 = 4) then 'Thursday'
when (M_LEVEL0 = 1) and (M_NUMBER0 = 5) then 'Friday'
when (M_LEVEL0 = 1) and (M_NUMBER0 = 6) then 'Saturday'
when (M_LEVEL0 = 2) and (M_NUMBER0 = 1) then 'First'
when (M_LEVEL0 = 2) and (M_NUMBER0 = -3) then 'A-Penult'
when (M_LEVEL0 = 2) and (M_NUMBER0 = -2) then 'Bef. last'
when (M_LEVEL0 = 2) and (M_NUMBER0 = -1) then 'Last'
when (M_LEVEL0 = 3) and (M_NUMBER0 = -5) then 'Month'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 0) then 'January'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 1) then 'February'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 2) then 'March'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 3) then 'April'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 4) then 'May'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 5) then 'June'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 6) then 'July'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 7) then 'August'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 8) then 'September'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 9) then 'October'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 10) then 'November'
when (M_LEVEL0 = 3) and (M_NUMBER0 = 11) then 'December'
when (M_LEVEL0 = 4) and (M_NUMBER0 = -5) then 'Quarter'
when (M_LEVEL0 = 5) and (M_NUMBER0 = -5) then 'Semester'
else to_char (M_NUMBER0)
end as FirstLevel3, 
case when (M_LEVEL1 = 3) then 'Month'
when (M_LEVEL1 = 4) then 'Quarter'
when (M_LEVEL1 = 5) then 'Semester'
when (M_LEVEL1 = 6) then 'Year'
end as SecondLevel1,
case when (M_INDEX1 = -7) then 'First'
when (M_INDEX1 = -6) then 'Previous'
when (M_INDEX1 = -5) then 'Current'
when (M_INDEX1 = -4) then 'Next'
when (M_INDEX1 = -3) then 'A-Penult'
when (M_INDEX1 = -2) then 'Bef. last'
when (M_INDEX1 = -1) then 'Last'
else to_char (M_INDEX1)
end as SecondLevel2,
case
when (M_LEVEL1 = 3) and (M_NUMBER1 = -5) then 'Month'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 0) then 'January'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 1) then 'February'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 2) then 'March'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 3) then 'April'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 4) then 'May'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 5) then 'June'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 6) then 'July'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 7) then 'August'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 8) then 'September'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 9) then 'October'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 10) then 'November'
when (M_LEVEL1 = 3) and (M_NUMBER1 = 11) then 'December'
when (M_LEVEL1 = 4) then 'Quarter'
when (M_LEVEL1 = 5) then 'Semester'
when (M_LEVEL1 = 6) then 'Year'
end  as SecondLevel3,
case when (M_LEVEL2 = 4) then 'Quarter'
when (M_LEVEL2 = 5) then 'Semester'
when (M_LEVEL2 = 6) then 'Year'
when (M_LEVEL2 = 20) then ' '
end as ThirdLevel1,
case when (M_INDEX2 = -7) then 'First'
when (M_INDEX2 = -6) then 'Previous'
when (M_INDEX2 = -5) then 'Current'
when (M_INDEX2 = -4) then 'Next'
when (M_INDEX2 = -1) then 'Last'
when (M_LEVEL2 = 20) then ' '
else to_char (M_INDEX2)
end as ThirdLevel2, 
case when (M_LEVEL2 = 4) then 'Quarter'
when (M_LEVEL2 = 5) then 'Semester'
when (M_LEVEL2 = 6) then 'Year'
when (M_LEVEL2 = 20) then ' '
end  as ThirdLevel3,
case when (M_LEVEL3 = 4) then 'Quarter'
when (M_LEVEL3 = 5) then 'Semester'
when (M_LEVEL3 = 6) then 'Year'
when (M_LEVEL3 = 20) then ' '
end as FourthLevel1 ,
case when (M_INDEX3 = -7) then 'First'
when (M_INDEX3 = -6) then 'Previous'
when (M_INDEX3 = -5) then 'Current'
when (M_INDEX3 = -4) then 'Next'
when (M_INDEX3 = -1) then 'Last'
when (M_LEVEL3 = 20) then ' '
else to_char (M_INDEX2)
end as FourthLevel2,
case when (M_LEVEL3 = 6) then 'Year' 
when (M_LEVEL3 = 20) then ' '
end  as FourthLevel3,
case when (M_NUMBER4 =0) then 'Previous'
when (M_NUMBER4 =1) then 'Next'
when (M_NUMBER4 =2) then 'Modified Following'
when (M_NUMBER4 =3) then 'Indifferent'
when (M_LEVEL3 = 20) then ' '
end as IfNonBusinessDay
from	DAT_ADJT_DBF
where	M_TYPE=3
order by M_LABEL;
quit;
SPOOL OFF;