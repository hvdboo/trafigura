--drop view EXT_COM_DBF2;
create view EXT_COM_DBF2 
(
M_TNB,
M_PLKEY,
M_ASSETTYPE,
M_ASSET,
M_PHYS1,
M_PHYSICAL,
M_LOCATION,
M_PROFILE,
M_VINTAG1,
M_PUBLI1,
M_FUTURE1,
M_FUTDES,
M_EXCH_CODE,
M_OBS,
M_MATCAST,
M_INDEX1,
M_UNDERL1,
M_CMIND1,
M_CMIDES,
M_QOT1,
M_CUR1,
M_UOQ1,
M_LOTSIZE,
M_MATLAB,
M_MATDAT,
M_MATURITY1,
M_OPTMAT1,
M_OPT_EXP,
M_QT_END,
M_DLV_FST,
M_DLV_LST,
M_CALC_FST,
M_CALC_LST,
M_FIX_FST,
N_FIX_LST,
M_CALC_FST1,
M_CALC_LST1,
M_FIX_FST1,
N_FIX_LST1,
M_STL,
M_EXRMODE,
M_SPLITMODE,
M_NETMODE,
M_TOT_QTY
)

as

(
select
trn.M_NB         as M_TNB,
plk.M_PLKEY      as M_PLKEY,
plk.M_ASSETTYPE  as M_ASSETTYPE,
plk.M_ASSET      as M_ASSET,
plk.M_PHYS             as M_PHYS1,
rtrim(dlv0.M_PHYSICAL) as M_PHYSICAL,
rtrim(dlv0.M_LOCATION) as M_LOCATION,
rtrim(dlv0.M_PROFILE)  as M_PROFILE,
plk.M_VINTAGE          as M_VINTAGE,
plk.M_PUBLI      as M_PUBLI,
plk.M_FUTURE     as M_FUTURE,
plk.M_FUTDES     as M_FUTDES,
plk.M_EXCH_CODE  as M_EXCH_CODE,
plk.M_OBS        as M_OBS,
plk.M_MATCAST    as M_MATCAST,
plk.M_INDEX      as M_INDEX1,
plk.M_UNDERL     as M_UNDERL1,
plk.M_CMIND      as M_CMIND1,
plk.M_CMIDES     as M_CMIDES,
plk.M_QOT        as M_QOT1,
plk.M_CUR        as M_CUR1,
plk.M_UOQ        as M_UOQ1,
plk.M_LOTSIZE    as M_LOTSIZE,
case
when trn.M_TRN_GTYPE in (100,102,146) then plk.M_FUTMATLAB
when trn.M_TRN_GTYPE in (101,103)     then plk.M_OPTMATLAB
when trn.M_TRN_GTYPE in (130,131,154) then
   case 
   when (dlv0.M_CALC_LST-dlv0.M_CALC_FST) >26 and (dlv0.M_CALC_LST-dlv0.M_CALC_FST) <31
   then to_char(dlv0.M_CALC_LST,'MON-YY') else null end
else null end    as M_MATLAB,
case
when trn.M_TRN_GTYPE in (100,102) then
   case fcm.M_EXR_MODE
   when 0 then plk.M_FUTQOTEND 
   when 1 then 
     case fcm.M_INS_MODE
     when 0 then plk.M_FUTQOTEND
     when 1 then
        case mgen.M_EXR_MODE
        when 0 then plk.M_FUTQOTEND
        when 1 then plk.M_FUTDLVLST
        else null end
     else null end   
   else null end
when trn.M_TRN_GTYPE in (146)             then plk.M_FUTQOTEND
when trn.M_TRN_GTYPE in (101)             then plk.M_OPTMATDAT
when trn.M_TRN_GTYPE in (103,113)         then trn.M_TRN_EXP
when trn.M_TRN_GTYPE in (130,131,134,154) then dlv0.M_CALC_LST
else null end   as M_MATDAT,
plk.M_FUTMATLAB as M_MATURITY1,
plk.M_OPTMATLAB as M_OPTMAT1,
plk.M_OPTMATDAT as M_OPT_EXP,
plk.M_FUTQOTEND as M_QT_END,
plk.M_FUTDLVFST as M_DLV_FST,
plk.M_FUTDLVLST as M_DLV_LST,
nvl(plk.M_FUTDLVFST, dlv0.M_CALC_FST) as M_CALC_FST,
nvl(plk.M_FUTDLVLST, dlv0.M_CALC_LST) as M_CALC_LST,
plk.M_FIXFST     as M_FIX_FST,
case rtrim(fcmudf.M_OBS) when 'BAS' then plk.M_FIXFST else plk.M_FIXLST end as M_FIX_LST,
dlv1.M_CALC_FST  as M_CALC_FST1,
dlv1.M_CALC_LST  as M_CALC_LST1,
case rtrim(fcmudf.M_OBS) when 'BAS' then plk.M_FIXLST else null end as M_FIX_FST1,
case rtrim(fcmudf.M_OBS) when 'BAS' then plk.M_FIXLST else null end as M_FIX_LST1,
case
when trn.M_TRN_GTYPE in (100,102,146)     then trn.M_TRN_EXP
when trn.M_TRN_GTYPE in (101,103,113)     then trn.M_TRN_EXP
when trn.M_TRN_GTYPE in (130,131,134,154) then trn.M_TRN_EXP
else null end as M_STL,
case fcm.M_EXR_MODE
when 0 then 'CSH' 
when 1 then 
   case fcm.M_INS_MODE
   when 0 then 'FIN'
   when 1 then
      case mgen.M_EXR_MODE
      when 0 then 'FIN'
      when 1 then 'PHY'
      else null end
   else null end
else null end EXRMODE,
case
when trn.M_TRN_GTYPE in (100,102) and trn.M_TRN_STATUS<>'DEAD' and plk.M_FUTDLVLST > plk.M_FUTDLVFST+31
then plk.M_SPLITMODE else 'D' end as M_SPLITMODE,
plk.M_NETMODE          as M_NETMODE,
dlv0.M_TOT_QTY         as M_TOT_QTY

from CMT_DLV_VW_DBF dlv0
left join TRN_HDR_DBF trn on dlv0.M_NB = trn.M_NB and trn.M_TRN_FMLY='COM'
left join CMT_PLKEY_VW_DBF2 plk on to_number(trim(trn.M_PL_KEY1),'9999999999') = plk.M_PLKEY
left join CM_FUT_DBF fcm on rtrim(plk.M_FUTURE) = rtrim(fcm.M_LABEL)
left join TABLE#DATA#COMMODIT_DBF fcmudf on fcm.M_REFERENCE = fcmudf.M_REFERENCE
left join CMC_MGEN_DBF mgen on (fcm.M_CM_INSTR = mgen.M_REFERENCE and fcm.M_LISTED in (1,2,16,32) and fcm.M_INS_MODE = 1)
left join CMT_DLV_VW_DBF dlv1 on dlv0.M_NB = dlv1.M_NB and dlv1.M_LEG = 1

where 1 = 1
and dlv0.M_LEG=0
--and trn.M_NB = 79611362
);