update FXNG_DBF 
set M_STATUS = 1
where exists
(
select scop.TRN 
from  
(
select
to_char(fxg.M_CALC_END,'YYYYMMDD') CALLST,
rtrim(fcm.M_LABEL) FCM,
case fcm.M_EXR_MODE
when 0 then 'Cash' 
when 1 then 
   case fcm.M_INS_MODE
   when 0 then 'Fin.dlv'
   when 1 then
      case fcsgen.M_EXR_MODE
      when 0 then 'Fin.dlv'
      when 1 then 'Phy.dlv'
      else null end
   else null end   
else null end EXR,
rtrim(matdat.M_LABEL) MATLAB,
to_char(matdat.M_QT_END,'YYYYMMDD') MATDAT,
fxg.M_TRN_NUMBER TRN,
fxg.M_STATUS STAT

from FXNG_DBF fxg
left join RT_INDEX_DBF ind on rtrim(fxg.M_IND_LABEL) = rtrim(ind.M_INDEX)
left join CM_FUT_DBF   fcm on ind.M_COM_FUT = fcm.M_REFERENCE
left join CMC_MGEN_DBF fcsgen on (fcm.M_CM_INSTR = fcsgen.M_REFERENCE and fcm.M_LISTED in (1,2,16) and fcm.M_INS_MODE = 1)
left join CM_FMAT1_DBF matdat on ind.M_COM_MAT = matdat.M_REFERENCE

where 1 = 1
--and to_char(fxg.M_CALC_END,'YYYYMMDD') > '20260131'
--and to_char(fxg.M_CALC_END,'YYYYMMDD') < '20260301'
and ind.M_CATEGORY = 9
and fcsgen.M_EXR_MODE = 1

--order by fxg.M_CALC_END asc, FCM, MATDAT
) scop

where FXNG_DBF.M_TRN_NUMBER = scop.TRN)
