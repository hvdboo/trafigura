select 
rtrim(sch.M_LABEL) LAB,
case sch.M_GENERAT
when 0 then 'Schedule'
when 1 then 'Shifter' else null end TYP,
case sch.M_REL_ABS
when 0 then 'Simple'
when 1 then 'Relative' 
when 2 then 'Mat.set' else null end NAT,
rtrim(sch.M_LABELTWO) UND,
case sch.M_CALENDAR
when 0 then 'None'
when 1 then 'Week-end'
when 2 then 'External'
when 3 then 'Internal'
when 4 then 'External+' else null end CALCHK,
rtrim(sch.M_STRCALEN) CALINT,
case sch.M_IDENTICAL
when 0 then 'No'
when 1 then 'Yes' else null end KEEPIDT,
case sch.M_ADJTSTYN 
when 0 then 'No'
when 1 then 'Yes' else null end ADJ_B,
-- rtrim(sch.M_ADJTRUST) ADJ_BEF,
rtrim(adjb.M_LABEL) ADJ_BEFORE,
case sch.M_FOR_BACK
when 0 then 'Backward'
when 1 then 'Forward' else null end GEN_DIR,
case sch.M_DEF_UNIT
when 0 then 'Open day'
when 1 then 'Day' 
when 2 then 'Week'
when 3 then 'Month'
when 4 then 'Quarter'
when 5 then 'Semester'
when 6 then 'Year'
when 7 then 'Intraday' else null end GEN_UNIT,
case sch.M_REL_ABS 
when 0 then
case sch.M_RECURSIF
when 0 then 'Normal'
when 1 then 'Recursive' else null end 
when 2 then
case sch.M_RECURSIF
when 0 then 'Normal'
when 1 then 'Recursive' else null end else null end GEN_MOD,
sch.M_DEF_FREQ GEN_FRQ,
case sch.M_ETOEFLAG
when 0 then 'Off'
when 1 then 'On'
when 2 then 'On (last open day)' else null end ETOE,
case sch.M_OPENCLOSED
when 0 then 'Previous'
when 1 then 'Next'
when 2 then 'Modified following'
when 3 then 'Indifferent'
when 4 then 'Modified preceding'
when 5 then 'LME' else null end ROLL,
case sch.M_ADJTCOYN 
when 0 then 'No'
when 1 then 'Yes' else null end ADJ_A,
-- rtrim(sch.M_ADJTRUCO) ADJ_AFT,
rtrim(adja.M_LABEL) ADJ_AFTER,
case sch.M_SCONV
when 0 then 'Indifferent'
when 1 then 'Roll Convention'
when 2 then 'Shifter'
when 3 then 'Specific Adjustment'
when 4 then 'Roll Convention+Adjustment'
when 5 then 'Shifter+Roll Convention' end START_CNV,
case sch.M_ECONV
when 0 then 'Indifferent'
when 1 then 'Roll Convention'
when 2 then 'Shifter'
when 3 then 'Specific Adjustment'
when 4 then 'Roll Convention+Adjustment'
when 5 then 'Shifter+Roll Convention' 
when 6 then 'Relative to Start Date' end END_CNV

from DAT_ECH_DBF sch
left join DAT_ADJT_DBF adjb on sch.M_ADJTRUST = adjb.M_LABEL
left join DAT_ADJT_DBF adja on sch.M_ADJTRUCO = adja.M_LABEL
where sch.M_GENERAT = 0
order by sch.M_LABEL