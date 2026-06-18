set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2048;
set pagesize 2048;
select T1.M_SE_D_LABEL as Label,
case when (T7.M_BD_TG_MT = 3 ) then 'Reset' else 'None' end as ClausesType,
case when (T7.M_BD_TG_BD is null) then ' ' else to_char(T7.M_BD_TG_BD,'DD MON YY') end as ResetDate,
case when (T7.M_BD_TG_TV is null) then ' ' else to_char(T7.M_BD_TG_TV) end as Reset,
case when (T7.M_BD_TG_FPA0 is null) then ' ' else to_char(T7.M_BD_TG_FPA0) end as CapPrevailingCP,
case when (T7.M_BD_TG_SPA0 is null) then ' ' else to_char(T7.M_BD_TG_SPA0) end as CapInitialCP,
case when (T7.M_BD_TG_BLE is null) then ' ' else to_char(T7.M_BD_TG_BLE) end as FloorPrevailingCP,
case when (T7.M_BD_TG_ELE is null) then ' ' else to_char(T7.M_BD_TG_ELE) end as FloorInitialCP,
case when (T7.M_BD_TG_OT = 0) then 'Spot' when (T7.M_BD_TG_OT = 1) then 'Average' else ' ' end as ObservationType,
case when (T7.M_BD_TG_NOD is null) then ' ' else to_char(T7.M_BD_TG_NOD) end as AveragingDays,
case when (T7.M_BD_TG_SS is null) then ' ' else to_char(T7.M_BD_TG_SS) end  as AveragingStart,
case when (T7.M_BD_TG_FCS is null) then ' ' else to_char(T7.M_BD_TG_FCS) end as Cash
from SE_HEAD_DBF  T1 , SE_ROOT_DBF T2   , TRN_CPDF_DBF T3 , SE_MKTOP_DBF T4 ,  RT_SEN_DBF T5   ,  BD_BOND_DBF  T6 ,
BD_TRIG_DBF T7  , RT_LNSEC_DBF T8  , RT_INSGN_DBF T9 , SE_TRDC_DBF T10 ,  SE_TRDS_DBF T11 ,  RT_LNGN_DBF T12, SE_HEAD_DBF  T13
where T1.M_SE_LABEL	= T2.M_SE_LABEL
and	T1.M_SE_GROUP	= 'Bond'
and T1.M_SE_TYPE	= 'Convert'
and	T1.M_SE_LABEL	= T4.M_SE_LABEL
and	T6.M_BD_INUM	= T4.M_SE_INUM
and T9.M_GEN_NUM 	= T6.M_BD_GEN
and	T2.M_SE_TRDCL 	= T10.M_SE_TRDCL
and	T10.M_SE_TCS_L	= T11.M_SE_TCS_L
and	T9.M_GEN_NUM    = T12.M_GEN_NUM
and	T13.M_SE_LABEL  = T6.M_BD_EQUITY
and T1.M_SE_ISS    = T3.M_LABEL (+)
and T4.M_SE_INUM   = T8.M_NB (+)
and T4.M_SE_INUM   = T7.M_BD_INUM 
and T1.M_SE_SEN    = T5.M_REFERENCE (+)
and	T7.M_BD_TG_MT	= 3
order by  T1.M_SE_D_LABEL;
quit; 
SPOOL OFF;