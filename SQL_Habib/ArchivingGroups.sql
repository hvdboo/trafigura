set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 300;
set pagesize 2048;
select T1.M_GRP_DESC as ArchivingGroup,
case 	when (T1.M_PRICE=0) then 'Published rates format' 
when (T1.M_PRICE=1) then 'Market prices format' 
when (T1.M_PRICE=2) then 'Multi column format' end as FileFormat ,
T1.M_GRP_CATEG as Category, 
case 	when (T1.M_GRP_NAT=0) then 'Published' when(T1.M_GRP_NAT=1) then 'Time Serie'  end as Nature,
case 	when (T1.M_FREQUENCY=0) then 'Daily' when (T1.M_FREQUENCY=1) then 'Working Days' when (T1.M_FREQUENCY=2) then 'Weekly' 
	when (T1.M_FREQUENCY=3) then 'Monthly' end as FixingFrequency,
CAST(T1.M_CALENDAR AS VARCHAR2(15)) as FixingCalendar,
case	when (T1.M_ROUND_RUL=0) then 'None' when (T1.M_ROUND_RUL=1) then 'Nearest ' when (T1.M_ROUND_RUL=2) then 'By default' 
	when (T1.M_ROUND_RUL=3) then 'By Excess'  when (T1.M_ROUND_RUL=5) then 'Nearest 5th' when (T1.M_ROUND_RUL=6) then 'By excess 5th'
	when (T1.M_ROUND_RUL=7) then 'By default 5th' end  as RoundingRule,
T1.M_DECIMALS as Decimals,
case when  T1.M_PRICE=2 then T2.M_LABEL else ' ' end as Series, 
case when (T1.M_GRP_TYPE = 0) then 'User Defined'
	when (T1.M_GRP_TYPE = 5) then 'Pool Factor' 
	when (T1.M_GRP_TYPE = 9) then 'EQ publication' 
end as GroupType 
from RT_GROUP_DBF T1, CM_MKTSR_DBF T2
where T1.M_SERIES = T2.M_REFERENCE (+)
and T1.M_GRP_CATEG = 'User defined' 
order by T1.M_GRP_DESC;
quit;
SPOOL OFF;