set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 800;
set pagesize 2048;
select T1.M_IND_LAB as IndexLabel, T1.M_IND_DESC as Description,
case when T6.M_LABEL is null then ' ' else T6.M_LABEL end as Asset,
 T1.M_IND_CODE as Code,
CAST(T1.M_COM_CUR AS VARCHAR2(10)) as Currency, 
case when (T1.M_RESET =6 and T1.M_COM_NBY_T <>2) then ' ' else T4.M_GRP_DESC end as ArchivingGroup, 
case	when T1.M_ESTIM_MODE=0 then 'Current Index'
	when T1.M_ESTIM_MODE =1 then 'Underlying Indices' 
end as EstimationMode, 
case	when (T1.M_OFF_RESET = 0) then 'UNCHECKED' when (T1.M_OFF_RESET =1) then 'CHECKED' end as OfficialReset,
case 	when (T1.M_FLEX = 0 ) then 'UNCHECKED' when (T1.M_FLEX = 1) then 'CHECKED' end as Flex ,
case when T1.M_COM_NBY_T=0 then 'Standard'
     when T1.M_COM_NBY_T=1 then 'Floating'
     when T1.M_COM_NBY_T=2 then 'Ind'
end as NearbyType,
T1.M_COM_MAT as Maturity,
case when T1.M_COM_NBY_T <> 2 then T2.M_LABEL else ' ' end as UnderlyingFutureForPrice,  
case when T1.M_COM_NBY_T = 2 then T6.M_LABEL else ' ' end as UnderlyingCommodityIndex,
case when (T1.M_COM_NBY_T = 0 and T1.M_COM_NBY_R=0) then 'Expiry Date'
     when (T1.M_COM_NBY_T = 0 and T1.M_COM_NBY_R=1) then 'Notification First'
     when (T1.M_COM_NBY_T = 0 and T1.M_COM_NBY_R=2) then 'Notification Last'
else ' '
end as ShiftType,
T3.M_LABEL as IndexQuotation,
case when T1.M_COM_NBY_T=0 then to_char(T1.M_COM_NBY_O)  else ' ' end as NearbyOrder,
T1.M_UECF as Shifter
 
-------
from RT_INDEX_DBF T1, CM_FUT_DBF T2, CMC_QUOT_DBF T3, RT_GROUP_DBF T4, CM_INDEX_DBF T5, CM_ASSET_DBF T6
where    T1.M_CATEGORY=8 and T1.M_RESET=6 
 and  T1.M_COM_FUT = T2.M_REFERENCE (+)
 and  T1.M_COM_QUOT = T3.M_REFERENCE (+)
 and T1.M_HISFILE = T4.M_HISFILE (+)
 and T1.M_COM_FUT = T5.M_REFERENCE (+)
 and to_number ( case when T1.M_RT_SELAB = ' ' then '-1' else T1.M_RT_SELAB end) = T6.M_REFERENCE (+)
Order by T1.M_IND_LAB;
quit;
SPOOL OFF;