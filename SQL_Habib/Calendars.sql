set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 450;
set pagesize 2048;
select T1.M_LABEL as Calendar, T1.M_DESC as Description, T1.M_SWIFTCDE as SwiftCode,
case when (T1.M_ISUNION =0) then 'No' 
when (T1.M_ISUNION  =1) then 'Yes'
end  as CalendarUnion, 
case when ((T1.M_ISUNION=0) and (T1.M_MONDAY=1)) then 'Holiday' 
when ((T1.M_ISUNION=0) and (T1.M_MONDAY=0)) then 'Business Day'
when ((T1.M_ISUNION=1) and (T1.M_MONDAY=1)) then ' '
when ((T1.M_ISUNION=1) and (T1.M_MONDAY=0)) then ' '
end as Monday,
case when ((T1.M_ISUNION=0) and (T1.M_TUESDAY=1)) then 'Holiday' 
when ((T1.M_ISUNION=0) and (T1.M_TUESDAY=0)) then 'Business Day'
when ((T1.M_ISUNION=1) and (T1.M_TUESDAY=1)) then ' '
when ((T1.M_ISUNION=1) and (T1.M_TUESDAY=0)) then ' '
end as Tuesday ,
case when ((T1.M_ISUNION=0) and (T1.M_WDNESDAY=1)) then 'Holiday' 
when ((T1.M_ISUNION=0) and (T1.M_WDNESDAY=0)) then 'Business Day'
when ((T1.M_ISUNION=1) and (T1.M_WDNESDAY=1)) then ' '
when ((T1.M_ISUNION=1) and (T1.M_WDNESDAY=0)) then ' '
end as Wednesday,
case when ((T1.M_ISUNION=0) and (T1.M_THURSDAY=1)) then 'Holiday' 
when ((T1.M_ISUNION=0) and (T1.M_THURSDAY=0)) then 'Business Day'
when ((T1.M_ISUNION=1) and (T1.M_THURSDAY=1)) then ' '
when ((T1.M_ISUNION=1) and (T1.M_THURSDAY=0)) then ' '
end as Thursday,
case when ((T1.M_ISUNION=0) and (T1.M_FRIDAY=1)) then 'Holiday' 
when ((T1.M_ISUNION=0) and (T1.M_FRIDAY=0)) then 'Business Day'
when ((T1.M_ISUNION=1) and (T1.M_FRIDAY=1)) then ' '
when ((T1.M_ISUNION=1) and (T1.M_FRIDAY=0)) then ' '
end as Friday,
case when ((T1.M_ISUNION=0) and (T1.M_SATURDAY=1)) then 'Holiday' 
when ((T1.M_ISUNION=0) and (T1.M_SATURDAY=0)) then 'Business Day' 
when ((T1.M_ISUNION=1) and (T1.M_SATURDAY=1)) then ' '
when ((T1.M_ISUNION=1) and (T1.M_SATURDAY=0)) then ' '
end as Saturday ,
case when ((T1.M_ISUNION=0) and (T1.M_SUNDAY=1)) then 'Holiday'
when ((T1.M_ISUNION=0) and (T1.M_SUNDAY=0)) then 'Business Day'
when ((T1.M_ISUNION=1) and (T1.M_SUNDAY=1)) then ' '
when ((T1.M_ISUNION=1) and (T1.M_SUNDAY=0)) then ' '
end as Sunday,
case when (T1.M_ISUNION=1) then T2.M_REF else ' ' end as CalendarComponents
-------
from CAL_DEF_DBF T1
-------
left outer join CAL_UNI_DBF T2 on T1.M_LABEL=T2.M_CTN
-------
order by T1.M_LABEL, T2.M_REF;
quit;
SPOOL OFF;