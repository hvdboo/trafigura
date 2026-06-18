set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 250;
set pagesize 2048;
select M_LABEL as Adjustment, 
case  when (M_TYPE = 5 ) then 'Condition' when (M_TYPE=6 ) then 'StubCondition' end as Type, 
case when (M_TYPEC=0) then 'Adjusted' when  (M_TYPEC=1) then 'Shifted' end as InputAdjustment,
CAST(M_LABELC AS VARCHAR2(20)) as InputAdjustmentLabel,
case when ( M_TYPEI=0) then 'Adjusted' when  ( M_TYPEI=1) then 'Shifted' end as OutputAdjustment,
CAST(M_LABELI2 AS VARCHAR2(25)) as OutputAdjustmentLabel,
Case when (M_TYPES=0) then 'Adjusted' when  (M_TYPES=1) then 'Shifted' end as ElseAdjustment,
CAST(M_LABELS2 AS VARCHAR2(20)) as ElseAdjustmentLabel
from DAT_ADJT_DBF
where M_TYPE=5
order by M_LABEL;
quit;
SPOOL OFF;