create view EXT_COM_DBF 
(
M_TNB,
M_PLKEY,
M_ASSETTYPE,
M_ASSET,
M_PUBLI1,
M_FUTURE1,
M_FUTDES,
M_INDEX1,
M_UNDERL1,
M_CMIND1,
M_CMIDES,
M_QOT1,
M_CUR1,
M_UOQ1,
M_LOTSIZE,
M_OBS,
M_OPTMAT1,
M_MATURITY1,
M_VINTAG1,
M_OPT_EXP,
M_QT_END,
M_DLV_FST,
M_DLV_LST,
M_EXCH_CODE,
M_CALC_FST,
M_CALC_LST,
M_CALC_FST1,
M_CALC_LST1,
M_MATLAB,
M_MATDAT,
M_STL,
M_EXRMODE,
M_SPLITMODE,
M_NETMODE,
M_PHYS1,
M_PHYSICAL,
M_LOCATION,
M_PROFILE,
M_TOT_QTY
)

as

select
trn.M_NB                            as M_TNB,
plk.M_PLKEY                         as M_PLKEY,
plk.M_ASSETTYPE                     as M_ASSETTYPE,
plk.M_ASSET                         as M_ASSET,
plk.M_PUBLI1                        as M_PUBLI1,
plk.M_FUTURE1                       as M_FUTURE1,
plk.M_FUTDES                        as M_FUTDES,
plk.M_inDEX1                        as M_INDEX1,
plk.M_UNDERL1                       as M_UNDERL1,
plk.M_CMinD1                        as M_CMIND1,
plk.M_CMIDES                        as M_CMIDES,
plk.M_QOT1                          as M_QOT1,
plk.M_CUR1                          as M_CUR1,
plk.M_UOQ1                          as M_UOQ1,
plk.M_LOTSIZE                       as M_LOTSIZE,
plk.M_COMMENT0                      as M_OBS,
plk.M_OPTMAT1                       as M_OPTMAT1,
plk.M_MATURITY1                     as M_MATURITY1,
plk.M_VINTAG1                       as M_VINTAG,
plk.M_OPT_EXP                       as M_OPT_EXP,
plk.M_QT_END                        as M_QT_END,
plk.M_DLV_FST                       as M_DLV_FST,
plk.M_DLV_LST                       as M_DLV_LST,
plk.M_EXCH_CODE                     as M_EXCH_CODE,
nvl(plk.M_DLV_FST, dlv0.M_CALC_FST) as M_CALC_FST,
nvl(plk.M_DLV_LST, dlv0.M_CALC_LST) as M_CALC_LST,
dlv1.M_CALC_FST                     as M_CALC_FST1,
dlv1.M_CALC_LST                     as M_CALC_LST1,
case
when trn.M_TRN_GTYPE in (100,102,146) then plk.M_MATURITY1
when trn.M_TRN_GTYPE in (101,103)     then plk.M_OPTMAT1
when trn.M_TRN_GTYPE in (130,131,154) then
   case 
   when (dlv0.M_CALC_LST-dlv0.M_CALC_FST) >26 and (dlv0.M_CALC_LST-dlv0.M_CALC_FST) <31
   then to_char(dlv0.M_CALC_LST,'MON-YY') else null end
else null end as M_MATLAB,
case
when trn.M_TRN_GTYPE in (100, 102) then
   case cmf.M_EXR_MODE
   when 0 then plk.M_QT_END 
   when 1 then 
     case cmf.M_INS_MODE
     when 0 then plk.M_QT_END
     when 1 then
        case mgen.M_EXR_MODE
        when 0 then plk.M_QT_END
        when 1 then plk.M_DLV_LST
        else null end
     else null end   
   else null end
when trn.M_TRN_GTYPE in (146)             then plk.M_QT_END
when trn.M_TRN_GTYPE in (101)             then plk.M_OPT_EXP
when trn.M_TRN_GTYPE in (103, 113)        then trn.M_TRN_EXP
when trn.M_TRN_GTYPE in (130,131,134,154) then dlv0.M_CALC_LST
else null end as M_MATDAT,
case
when trn.M_TRN_GTYPE in (100,102,146)     then trn.M_TRN_EXP
when trn.M_TRN_GTYPE in (101,103,113)     then trn.M_TRN_EXP
when trn.M_TRN_GTYPE in (130,131,134,154) then trn.M_TRN_EXP
else null end as M_STL,
case cmf.M_EXR_MODE
when 0 then 'CSH' 
when 1 then 
   case cmf.M_INS_MODE
   when 0 then 'FIN'
   when 1 then
      case mgen.M_EXR_MODE
      when 0 then 'FIN'
      when 1 then 'PHY'
      else null end
   else null end
else null end EXRMODE,
case
when trn.M_TRN_GTYPE in (100,102) and trn.M_TRN_STATUS<>'DEAD' and plk.M_DLV_LST > plk.M_DLV_FST+31
then plk.M_SPLITMODE else 'D' end as M_SPLITMODE,
plk.M_NETMODE          as M_NETMODE,
plk.M_PHYS1            as M_PHYS1,
rtrim(dlv0.M_PHYSICAL) as M_PHYSICAL,
rtrim(dlv0.M_LOCATION) as M_LOCATION,
rtrim(dlv0.M_PROFILE)  as M_PROFILE,
dlv0.M_TOT_QTY         as M_TOT_QTY

from CMT_DLV_VW_DBF dlv0
left join TRN_HDR_DBF trn on dlv0.M_NB = trn.M_NB and trn.M_TRN_FMLY='COM'
left join CMT_PLKEY_VW_DBF plk on to_number(trim(trn.M_PL_KEY1),'9999999999') = plk.M_PLKEY
left join CM_FUT_DBF cmf on rtrim(plk.M_FUTURE1) = rtrim(cmf.M_LABEL)
left join CMC_MGEN_DBF mgen on (cmf.M_CM_INSTR = mgen.M_REFERENCE and cmf.M_LISTED in (1,2,16,32) and cmf.M_INS_MODE = 1)
left join CMT_DLV_VW_DBF dlv1 on dlv0.M_NB = dlv1.M_NB and dlv1.M_LEG=1

where 1 = 1
and dlv0.M_LEG=0
and trn.M_NB = 79611362;