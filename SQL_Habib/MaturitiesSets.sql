set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 850;
set pagesize 2048;
select	CAST(M_LABEL AS VARCHAR2(15)) as MaturitySet,
case when (M_TYPE = 1) then 'Short and Long Futures'
	when (M_TYPE = 2) then 'Option on Short and Long Futures'
    when (M_TYPE = 3) then 'Option on Equity and Equity indices'
	else ' '
end as Type,
CAST(M_UNDSET AS VARCHAR2(15)) as UnderlyingSet, CAST(M_RULE AS VARCHAR2(10)) as LabelRule,
M_RULEADJT as AdjustmentRule, M_STRCALEN as Calendar,
case when ((M_RA0 = 0) and (M_SCHEDULE0 = ' ' )) then 'None'
	when (M_RA0 = 0) then 'Absolute'
	when (M_RA0 = 1) then 'Relative'
	when (M_RA0 = 2) then 'None'
end as MaturityType,
case when ((M_RA0 = 2) or ((M_RA0 = 0) and (M_SCHEDULE0 = ' ' ))) then ' '
	else M_SCHEDULE0 
end as MaturityScheduleShifter,
case when (M_RA0 <> 1) then ' '
  	when (M_RELATIF0 = 2) then 'ValueDate'
	when (M_RELATIF0 = 3) then 'FirstTradingDate'
	when (M_RELATIF0 = 4) then 'LastTradingDate'
	else ' ' 
end as MaturityRelativeTo,
case when ((M_SIGNE0 = 0) and (M_RA0 = 1)) then '+' 
	when ((M_SIGNE0 = 1) and (M_RA0 = 1)) then '-' 
	else ' ' 
end as MaturitySign,
case when (M_RA0 <> 1) then 0 else M_DECAL0 end as MaturityOffset,
case when ((M_RA1 = 0) and (M_SCHEDULE1 = ' ' )) then 'None'
	when (M_RA1 = 0) then 'Absolute'
	when (M_RA1 = 1) then 'Relative'
	when (M_RA1 = 2) then 'None'
end as ValueDateType,
case when ((M_RA1 = 2) or ((M_RA1 = 0) and (M_SCHEDULE1 = ' ' ))) then ' '
	else  M_SCHEDULE1 
end as ValueScheduleShifter,
case when (M_RA1 <> 1) then ' '
	when (M_RELATIF1 = 1) then 'MaturityDate'
	when (M_RELATIF1 = 3) then 'FirstTradingDate'
	when (M_RELATIF1 = 4) then 'LastTradingDate'
	else ' ' 
end  as ValueRelativeTo,
case when ((M_SIGNE1 = 0) and (M_RA1 = 1)) then '+' 
	when ((M_SIGNE1 = 1) and (M_RA1 = 1)) then '-' 
	else ' '
end as ValueSign,
case when (M_RA1 <> 1) then 0 else M_DECAL1 end as ValueOffset,
case when ((M_RA2 = 0) and (M_SCHEDULE2 = ' ' )) then 'None'
	when (M_RA2 = 0) then 'Absolute'
	when (M_RA2 = 1) then 'Relative'
	when (M_RA2 = 2) then 'None'
end as FirstTradingType, 
case when ((M_RA2 = 2) or ((M_RA2 = 0) and (M_SCHEDULE2 = ' ' ))) then ' ' else  M_SCHEDULE2 end as FirstTradScheduleShifter,
case when (M_RA2 <> 1) then ' '
	when (M_RELATIF2 = 1) then 'MaturityDate'
	when (M_RELATIF2 = 2) then 'ValueDate'
	when (M_RELATIF2 = 4) then 'LastTradingDate'
	else ' ' 
end as FirstTradRelativeTo,
case when ((M_SIGNE2 = 0) and (M_RA2 = 1)) then '+' when ((M_SIGNE2 = 1) and (M_RA2 = 1)) then '-' else ' ' end as FirstTradSign,
case when (M_RA2 <> 1) then 0 else M_DECAL2 end as FirstTradOffset,
case when ((M_RA3 = 0) and (M_SCHEDULE3 = ' ' )) then 'None'
	when (M_RA3 = 0)  then 'Absolute'
	when (M_RA3 = 1) then 'Relative'
	when (M_RA3 = 2) then 'None'
end as LastTradingType,
case when ((M_RA3 = 2) or ((M_RA3 = 0) and (M_SCHEDULE3 = ' ' ))) then ' ' else M_SCHEDULE3 end as LastTradScheduleShifter,
case when (M_RA3 <> 1) then ' '
	when (M_RELATIF3 = 1) then 'MaturityDate'
	when (M_RELATIF3 = 2) then 'ValueDate'
	when (M_RELATIF3 = 3) then 'FirstTradingDate'
	else ' '
end as LastTradRelativeTo,
case when ((M_SIGNE3 = 0) and (M_RA3 = 1)) then '+' when ((M_SIGNE3 = 1) and (M_RA3 = 1)) then '-' else' ' end as LastTradSign,
case when (M_RA3 <> 1) then 0 else M_DECAL3 end as LastTradOffset
from MATSET_DBF
where M_TYPE <> 0
order by M_LABEL, M_TYPE;
quit;
SPOOL OFF;