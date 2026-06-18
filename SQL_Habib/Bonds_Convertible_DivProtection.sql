set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2048;
set pagesize 2048;
select T1.M_SE_D_LABEL as Label,
case when (T7.M_BD_TG_MT = 4 ) then 'Div Protection' else 'None' end as Settings,
case when (T6.M_BD_TGS_DPC =0) then 'UNCHECKED' 
	when (T6.M_BD_TGS_DPC =1) then 'CHECKED'
	else ' ' 
end as Contingent,
case when (T7.M_BD_TG_BD is null) then ' ' else to_char(T7.M_BD_TG_BD,'DD MON YY') end as ProtectionStart,
case when (T7.M_BD_TG_ED is null) then ' ' else to_char(T7.M_BD_TG_ED,'DD MON YY') end as ProtectionEnd,
case when (T7.M_BD_TG_TY = 0) then 'spot'
	when (T7.M_BD_TG_TY = 1) then 'derferred'
	else ' ' 
end as Payment,
case when (T7.M_BD_TG_FPA0 is null) then ' ' else to_char(T7.M_BD_TG_FPA0) end as PassTroughRate,
case when (T7.M_BD_TG_MOD = 0) then 'None'
	when (T7.M_BD_TG_MOD = 1) then '(M/(M-D))'
else ' ' end as CPAdjustment,
case when (T7.M_BD_TG_LE is null) then ' ' else to_char(T7.M_BD_TG_LE) end as RefDiv,
/*T7.M_BD_TG_LE in this case is equal to T7.M_BD_TG_BLE*/
case when (T7.M_BD_TG_TS is null) then ' ' else to_char(T7.M_BD_TG_TS) end as RefDivDate,
case when (T7.M_BD_TG_ELE is null) then ' ' else to_char(T7.M_BD_TG_ELE) end as RefSpot,
case when (T7.M_BD_TG_SS is null) then ' ' else to_char(T7.M_BD_TG_SS) end  as RefSpotDate,
case when (T7.M_BD_TG_LT =0 ) then 'Min(RefDiv%*RefDiv,RefSpot%*RefSpot)'
	when (T7.M_BD_TG_LT =1 ) then 'CP Price'
	when (T7.M_BD_TG_LT =2 ) then 'Spot Price'
	else ' ' 
end as TriggerType
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
and	T7.M_BD_TG_MT	= 4
order by  T1.M_SE_D_LABEL;
quit;
SPOOL OFF;