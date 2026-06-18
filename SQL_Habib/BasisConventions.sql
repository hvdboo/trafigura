set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 650;
set pagesize 2048;
select M_BASIS as BasisConvention, M_DESC as Description,
case		when (M_NUM_CONV = 0 ) then 'ACT' 
		when (M_NUM_CONV = 1 ) then '30' 
		when (M_NUM_CONV = 2 ) then '30E' 
		when (M_NUM_CONV = 9 ) then '30E+' 
		when (M_NUM_CONV = 11 ) then 'NL' 
		when (M_NUM_CONV = 13 ) then '30U'
                when (M_NUM_CONV = 15 ) then '30A'
----
end as NumeratorConvention,
case		when (M_NUM_CONV = 2 ) and (M_NUM_METHOD= 0 ) then 'AFB' 
		when (M_NUM_CONV = 2 ) and  (M_NUM_METHOD = 1 ) then 'ISDA' 
                when (M_NUM_CONV = 2 ) and  (M_NUM_METHOD = 2 ) then 'German'
		else ' '
end as NumeratorMethod, 
case		when (M_DEN_CONV = 0 ) then 'ACT' 
when (M_DEN_CONV = 1 ) then '30' 
when (M_DEN_CONV = 2 ) then '30E' 
when (M_DEN_CONV = 3 ) then '360' 
when (M_DEN_CONV = 4 ) then '365' 
when (M_DEN_CONV = 5 ) then '366' 
when (M_DEN_CONV = 6 ) then '365.25' 
when (M_DEN_CONV = 7 ) then '366(1)' 
when (M_DEN_CONV = 8 ) then '366(2)' 
when (M_DEN_CONV = 9 ) then '30E+' 
when (M_DEN_CONV = 10 ) then '364' 
when (M_DEN_CONV = 11 ) then 'NL' 
when (M_DEN_CONV = 12 ) then '252' 
when (M_DEN_CONV = 14 ) then '366(3)' 
end as DenominatorConvention ,
case		when (M_UNIT = 0 ) then 'Days' 
when (M_UNIT = 1 ) then 'Months' 
when (M_UNIT = 2 ) then 'Quarters' 
when (M_UNIT = 3 ) then 'Semesters' 
when (M_UNIT = 4 ) then 'Days exclud. week-ends' 
when (M_UNIT = 5 ) then 'Business days'
when (M_UNIT = 6 ) then 'Nearest months'  
end as Unit, 
M_CALENDAR as Calendar, 
case		when (M_INCLUSIVE = 0 ) then 'Exclusive: t2-t1 ]t1,t2] ' 
when (M_INCLUSIVE = 1 ) then 'Inclusive: t2-t1+1 [t1,t2]' 
when (M_INCLUSIVE = 2 ) then 't2-t1 [t1,t2[' 
when (M_INCLUSIVE = 3 ) then 't2-t1-1 ]t1,t2[' 
end as  InclusiveExclusive, 
case		when (M_CAPPED  = 0 ) then 'No' 
when (M_CAPPED  = 1 ) then 'Yes' 
end as Capped, 
case		when (M_REDEFINED0  = 0 ) then 'Inherited' 
when (M_REDEFINED0  = 1 ) then 'Redefined' 
end as FirstPeriod, 
CAST(M_PERBASIS0 AS VARCHAR2(20)) as FirstPeriodBasis, 
case		when (M_REDEFINED1  = 0 ) then 'Inherited' 
when (M_REDEFINED1  = 1 ) then 'Redefined' 
end as LastPeriod , 
M_PERBASIS1 as LastPeriodBasis,
case when (M_JUMP  = 0 ) then 'Year' 
when (M_JUMP  = 1 ) then 'Semester' 
when  (M_JUMP  = 2 ) then 'Quarter' 
when (M_JUMP  = 3 ) then 'Month' 
when (M_JUMP  = 4 ) then 'Coupon periodicity' 
else ' ' 
end as Periodicity, 
case		when (M_FULL_PER  = 0 ) then 'Yes' 
when (M_FULL_PER  = 1 ) then 'No' 
end as FullPeriodExctraction, 
case		when ((M_FULL_PER = 0) and (M_PER_INT = 0 )) then 'Apply Standard formula' 
when (M_FULL_PER = 0) and (M_PER_INT = 1 ) then '1+R' 
else ' ' 
end as PeriodInterpretation, 
case	when (M_PER_DET = 0 ) then 'Forward from start date' 
when (M_PER_DET  = 1 ) then 'Backward from end date' 
when  (M_PER_DET  = 2 ) then 'ISDA convention' 
when (M_PER_DET  = 3 ) then 'ISMA backward convention' 
when  (M_PER_DET = 4 ) then 'ISMA forward convention' 
else ' ' 
end as PeriodDetermination, 
case when (M_ENDTOEND  = 0 ) then 'No' 
when (M_ENDTOEND  = 1 ) then 'Yes' 
when (M_ENDTOEND  = 2 ) then 'Yes (28th)' 
		else ' ' 
end as EndMonthAdjustment 
from RT_BASIS_DBF 
order by  M_BASIS; 
quit;
SPOOL OFF;