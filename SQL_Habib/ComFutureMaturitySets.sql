set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2584;
set pagesize 2048;
select  T1.M_LABEL as FutureMaturitySet, T1.M_DESC as Description, T1.M_CALENDAR as Calendar,
	case 	when T1.M_SYS_ID=0 then 'Rule Based'
		when T1.M_SYS_ID=7 then 'Calendar Sequential (No split)'
		when T1.M_SYS_ID=6 then 'Calendar Simultaneous (No split)'
		when T1.M_SYS_ID=1 then 'Calendar Simultaneous (Split)'
		when T1.M_SYS_ID=8 then 'Nordpool Future'
		when T1.M_SYS_ID=9 then 'Nordpool Forward'
		when T1.M_SYS_ID=4 then 'UK Power Exchange'
		when T1.M_SYS_ID=5 then 'IPE Electricity'
 		when T1.M_SYS_ID=10 then 'LME'
		when T1.M_SYS_ID=12 then 'Rule based on Quotation End'
		when T1.M_SYS_ID=13 then 'Calendar Sequential (no split, balance)'
		end as Structure,
	case 	when ((T1.M_SYS_ID <> 0) and (T1.M_SYS_ID <> 12) and (T1.M_MAT_COUNT=0)) then ' '
		else  to_char(T1.M_MAT_COUNT)
		end as Maturities,
	-------
	CAST(T1.M_ST_RULE0 AS VARCHAR2(18)) as StartingDelivery, 
	T1.M_ST_RULE1 as EndingDelivery,
	CAST(T1.M_QT_RULE0 AS VARCHAR2(20)) as StartingQuotation,
	T1.M_QT_RULE1 as EndingQuotation, 
	CAST(T1.M_NT_RULE0 AS VARCHAR2(20)) as StartingNotification,
	CAST(T1.M_NT_RULE1 AS VARCHAR2(20)) as EndingNotification,
	case 	when (T1.M_AUTO_ROLL=0) then 'No'
		when (T1.M_AUTO_ROLL=1) then 'Yes'
		end as AutomaticRoll,
-------
	case	when T3.M_BLK_TYPE=1 then 'Day'
		when T3.M_BLK_TYPE=2 then 'Week'
		when T3.M_BLK_TYPE=3 then 'Month'
		when T3.M_BLK_TYPE=4 then 'Quarter'
		when T3.M_BLK_TYPE=5 then 'Season'
		when T3.M_BLK_TYPE=6 then 'Year'
		when T3.M_BLK_TYPE=7 then 'Week-end'
		when T3.M_BLK_TYPE=8 then 'Weekdays'
		when T3.M_BLK_TYPE=9 then 'Bal. Month'
		when (T3.M_BLK_TYPE is null) then ' '
		end as Block,
-------
	case	when (T3.M_SPL_COUNT is null) then ' '
		else to_char(T3.M_SPL_COUNT)
		end as Generate, 
	case 	when T3.M_SPLITS=1 then 'Yes'
		when T3.M_SPLITS=0 then 'No'
		when (T3.M_SPLITS is null) then ' '
		end as Splits,
	case when (T3.M_SPLITS = 0 or T3.M_SPLITS is null) then ' ' 
		when T3.M_SON_BLK_TYPE=1 then 'Day'
		when T3.M_SON_BLK_TYPE=2 then 'Week'
		when T3.M_SON_BLK_TYPE=3 then 'Month'
		when T3.M_SON_BLK_TYPE=4 then 'Quarter'
		when T3.M_SON_BLK_TYPE=5 then 'Season'
		when T3.M_SON_BLK_TYPE=6 then 'Year'
		when (T3.M_SON_BLK_TYPE is null) then ' '
		end as SplitType,
-------
	case	when (T3.M_SPL_SHIFT0 is null) then ' '
		else to_char(T3.M_SPL_SHIFT0)
		end as QuotationPeriodStart, 
	case	when (T3.M_SPL_SHIFT1 is null) then ' '
		else to_char(T3.M_SPL_SHIFT1)
		end as QuotationPeriodEnd, 
-------
	case	when (T3.M_SD_SHIFT0 is null) then ' ' when T1.M_SYS_ID <> 10 then ' '
		else T3.M_SD_SHIFT0
		end as DeliveryPeriodStart, 
	case	when (T3.M_SD_SHIFT1 is null) then ' ' when T1.M_SYS_ID <> 10 then ' '
		else T3.M_SD_SHIFT1
		end as DeliveryPeriodEnd
-------
-------
from 	CM_FMAT_DBF T1  
left outer join CM_FMAT0_DBF T3 on T1.M_REFERENCE=T3.M_REFERENCE
order by T1.M_LABEL,T3.M_BLK_TYPE;
-------
quit;
SPOOL OFF;