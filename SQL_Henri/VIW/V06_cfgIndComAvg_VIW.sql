drop view INDCOM_AVG_VIW;
create view INDCOM_AVG_VIW

(
M_ASSTYP,
M_ASSLAB,
M_INDCAT,
M_INDTYP,
M_INDLAB,
M_INDDES,
M_INDPUB,
M_INDCAL,
M_UNDTYP,
M_UNDLAB,
M_UNDDES,
M_UNDQOTTYP,
M_UNDQOT,
M_UNDHSR,
M_UNDPUB,
M_UNDSYM,
M_UNDCAL,
M_CUR,
M_UOQ,
M_UOD,
M_FCMLAB,
M_ICMLAB,
M_ICMQOT,
M_ICMPUB,
M_ICMSYM,
M_ICMHSR,
M_ICMCAL,
M_RNDRUL,
M_RNDDEC,
M_OBSTYP,
M_OBSESTIM,
M_OBSFRM,
M_OBSFRQ,
M_OBSCALMOD,
M_OBSCAL,
M_OBSSHIFDAT1,
M_OBSSHIFSHIFT1,
M_OBSSHIFDAT2,
M_OBSSHIFSHIFT2,
M_OBSEXCFST,
M_OBSEXCLST,
M_OBSEXCDAT,
M_OBSSTUB,
M_HIS,
M_INDNDX,
M_INDUID,
M_UNDNDX,
M_UNDUID,
M_UNDQOTUID

)

as

(

select 
-- ASSET
rtrim(ast.M_LABEL) ASSTYP, 
rtrim(ass.M_LABEL) ASSLAB,
-- INDEX
case ind.M_CATEGORY
when 0 then 'Rate'
when 1 then 'Equity'
when 2 then 'Bond'
when 3 then 'Inflation'
when 4 then 'Forex'
when 8 then 'Commodity'
when 9 then 'Com FWD' else null end INDCAT,
case ind.M_CATEGORY
when 8 then 
    case ind.M_RESET
    when 0 then 'Spot'
    when 3 then 'Average' 
    when 4 then 'Basket'
    when 5 then 'Start-end'
    when 6 then 'Nearby' end 
when 9 then 
    case ind.M_FUT_CAT 
    when 0 then 'Forward' 
    when 1 then 'Option' end
end INDTYP,
rtrim(ind.M_IND_LAB)     INDLAB, 
rtrim(ind.M_IND_DESC)    INDDES,
rtrim(indgrp.M_GRP_DESC) INDPUB,
rtrim(indgrp.M_CALENDAR) INDCAL,
-- UNDERLYING
case und.M_RESET
when 0 then 'SPT'
when 3 then 'AVG'
when 4 then 'BSK'
when 6 then 'NBY' end UNDTYP,
rtrim(und.M_IND_LAB)  UNDLAB,
rtrim(und.M_IND_DESC) UNDDES,
case undqot.M__TYPE_
when  1 then 'Index'
when  2 then 'Future'
when  4 then 'Dlv.flow'
when  8 then 'Spread'
when  5 then 'Index flow'
when  6 then 'Future flow'
when 14 then 'Spread fut.flow' 
when 16 then 'Opt.Listed' else null end UNDQOTTYP,
rtrim(undqot.M_LABEL) UNDQOT,
rtrim(hsr.M_LABEL)    UNDHSR,
case und.M_RESET
when 0 then rtrim(undicmviw.M_PUB)
when 3 then rtrim(undgrp.M_GRP_DESC)  
when 4 then rtrim(undgrp.M_GRP_DESC)
when 6 then coalesce(rtrim(undnbyfccicmviw.M_PUB), rtrim(undnbyfcsicmviw.M_PUB), rtrim(undnbyicmviw.M_PUB)) else null end UNDPUB,
rtrim(undqot.M_TRAD_SMB) UNDSYM,

case und.M_RESET
when 0 then coalesce(rtrim(undicmviw.M_CAL), rtrim(undpub.M_CALENDAR))
when 3 then rtrim(undgrp.M_CALENDAR)  
when 4 then rtrim(undgrp.M_CALENDAR)
when 6 then coalesce(rtrim(undnbyfccicmviw.M_CAL), rtrim(undnbyfcsicmviw.M_CAL), rtrim(undnbyicmviw.M_CAL)) else null end UNDCAL,
coalesce(rtrim(undqot.M_CURR), rtrim(und.M_CURRENCY))   CUR, 
coalesce(rtrim(undicmviw.M_UOQ), rtrim(unduoq.M_LABEL)) UOQ,
coalesce(rtrim(undicmviw.M_UOD), rtrim(unduod.M_LABEL)) UOD,
case und.M_RESET
when 6 then rtrim(undnbyfcm.M_LABEL) else null end FCMLAB,
case und.M_RESET
when 0 then rtrim(undicm.M_LABEL) 
when 3 then null
when 4 then null
when 6 then coalesce(rtrim(undnbyicm.M_LABEL), rtrim(undnbyfccicm.M_LABEL), rtrim(undnbyfcsicm.M_LABEL)) else null end ICMLAB,
case und.M_RESET
when 0 then rtrim(undqot.M_LABEL) 
when 3 then null
when 4 then null
when 6 then coalesce(rtrim(undnbyqot.M_LABEL), rtrim(undnbyfccqot.M_LABEL), rtrim(undnbyfcsqot.M_LABEL)) else null end ICMQOT,
case und.M_RESET
when 0 then rtrim(undicmviw.M_PUB) 
when 3 then null
when 4 then null
when 6 then coalesce(rtrim(undnbyicmviw.M_PUB), rtrim(undnbyfccicmviw.M_PUB), rtrim(undnbyfcsicmviw.M_PUB)) else null end ICMPUB,
case und.M_RESET
when 0 then rtrim(undqot.M_TRAD_SMB) 
when 3 then null
when 4 then null
when 6 then coalesce(rtrim(undnbyqot.M_TRAD_SMB), rtrim(undnbyfccqot.M_TRAD_SMB), rtrim(undnbyfcsqot.M_TRAD_SMB)) else null end ICMSYM,
case und.M_RESET
when 0 then rtrim(undicmviw.M_HSR) 
when 3 then null
when 4 then null
when 6 then coalesce(rtrim(undnbyicmviw.M_HSR), rtrim(undnbyfccicmviw.M_HSR), rtrim(undnbyfcsicmviw.M_HSR)) else null end ICMHSR,
case und.M_RESET
when 0 then rtrim(undicmviw.M_CAL) 
when 3 then null
when 4 then null
when 6 then coalesce(rtrim(undnbyicmviw.M_CAL), rtrim(undnbyfccicmviw.M_CAL), rtrim(undnbyfcsicmviw.M_CAL)) else null end ICMCAL,
-- ROUNDING
case ind.M_CRND_RULE
when 0 then 'None' 
when 1 then 'Nearest'  
when 2 then 'By default' 
when 3 then 'By excess' else null end  RNDRUL,
/*
when (ind.M_ROUND_RUL = 5) then 'Nearest 5th' 
when (ind.M_ROUND_RUL = 6) then 'By excess 5th'
when (ind.M_ROUND_RUL = 7) then 'By default 5th' end RNDRUL,
*/
ind.M_CRND_DEC RNDDEC,
-- OBSERVATION
case ind.M_RESET
when 0 then 'Spot'
when 3 then 'Average' 
when 4 then 'Basket'
when 5 then 'Start-end'
when 6 then 'Nearby' end OBSTYP,
case
when (ind.M_RESET <> 0) and (ind.M_ESTIM_MODE = 0) then 'Current'
when (ind.M_RESET <> 0) and (ind.M_ESTIM_MODE = 1) then 'Underlying' else null end OBSESTIM,
case ind.M_MEAN_TYPE
when 0 then 'Simple'
when 1 then 'Built on weighting schedule'
when 2 then 'Manually weighted'
when 3 then 'Automatically weighted'
when 4 then 'Sum'
when 5 then 'Min'
when 6 then 'Max'
when 7 then 'Variance' else null end OBSFRM,
rtrim(ind.M_UEI) OBSFRQ,
case sch.M_CALENDAR
when 0 then 'None'
when 1 then 'Week-end'
when 2 then 'External'
when 3 then 'Internal'
when 4 then 'External+' else null end OBSCALMOD,
rtrim(sch.M_STRCALEN) OBSCAL,
case when ind.M_F_SHIFT = 1  
    then case ind.M_U_FSHIFT when 0 then 'first' when 1  then 'last' end
    else null end OBSSHIFDAT1,
rtrim(ind.M_F_SHIFTER) OBSSHIFSHIFT1,
case when ind.M_L_SHIFT = 1 
    then case ind.M_U_LSHIFT when 0 then 'first' when 1 then 'last'  end 
    else null end OBSSHIFDAT2,
rtrim(ind.M_L_SHIFTER) OBSSHIFSHIFT2,
case ind.M_FIRST_EXCL
when 0 then 'Included' 
when 1 then 'Excluded' else null end OBSEXCFST,
case ind.M_LAST_EXCL        
when 0 then 'Included' 
when 1 then 'Excluded' else null end OBSEXCLST, 
case ind.M_EXCLUDE
when 0 then 'No' 
when 1 then 'Yes' else null end OBSEXCDAT,
case ind.M_BROKEN
when 0 then 'Up front' 
when 1 then 'In arrears' else null end OBSSTUB,
rtrim(ind.M_HISFILE) HIS,
-- UID
rtrim(ind.M_INDEX) INDNDX,
ind.M_REFERENCE    INDUID,
rtrim(und.M_INDEX) UNDNDX,
und.M_REFERENCE    UNDUID,
undqot.M_REFERENCE UNDQOTUID

from RT_INDEX_DBF ind
left join RT_GROUP_DBF indgrp on ind.M_HISFILE = indgrp.M_HISFILE
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB)) = ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
/*
left join CM_INDEX_DBF icm on ind.M_COM_IND = icm.M_REFERENCE
left join CM_PHYS_DBF  icmphy on icm.M_PHYSICAL = icmphy.M_REFERENCE
left join CM_LOCAT_DBF icmloc on icm.M_LOCATION = icmloc.M_REFERENCE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT = indqot.M_REFERENCE
left join CM_UNIT_DBF  indqotuoq on indqot.M_UNIT = indqotuoq.M_REFERENCE
left join CM_UNIT_DBF  indqotuod on indqot.M_QTY_UNIT = indqotuod.M_REFERENCE
left join CM_MKT_DBF   indpub on indqot.M_PUBLI = indpub.M_REFERENCE
*/
left join DAT_ECH_DBF  sch on rtrim(ind.M_UEI) = rtrim(sch.M_LABEL)
left join RT_INDEX_DBF und on ind.M_UNDRL = und.M_INDEX
left join CM_UNIT_DBF  unduoq on und.M_UNIT_REF1 = unduoq.M_REFERENCE
left join CM_UNIT_DBF  unduod on und.M_UNIT_REF0 = unduod.M_REFERENCE
left join RT_GROUP_DBF undgrp on und.M_HISFILE = undgrp.M_HISFILE
left join CM_MKTSR_DBF hsr on rtrim(substr(ind.M_UNDRL_FORMULA,2,8)) = to_char(hsr.M_SERIE)
left join CM_INDEX_DBF undicm on und.M_COM_IND = undicm.M_REFERENCE
left join CMC_QUOT_DBF undqot on und.M_COM_QUOT = undqot.M_REFERENCE
left join CM_MKT_DBF   undpub on undqot.M_PUBLI = undpub.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undicmviw on undicm.M_REFERENCE = undicmviw.M_ICMUID
left join CM_FUT_DBF   undnbyfcm on (und.M_COM_FUT = undnbyfcm.M_REFERENCE and und.M_COM_NBY_T = 0 and undnbyfcm.M_LISTED in (1,2,16,32))
left join RT_INSGN_DBF undnbyfccins on (undnbyfcm.M_CM_INSTR = undnbyfccins.M_GEN_NUM and undnbyfcm.M_INS_MODE = 0)
left join RT_LNGN_DBF  undnbyfccgen on (undnbyfcm.M_CM_INSTR = undnbyfccgen.M_GEN_NUM and undnbyfcm.M_INS_MODE = 0)
left join RT_INDEX_DBF undnbyfccind on undnbyfccgen.M_INDEX0 = undnbyfccind.M_INDEX
left join CM_INDEX_DBF undnbyfccicm on undnbyfccind.M_COM_IND = undnbyfccicm.M_REFERENCE
left join CMC_QUOT_DBF undnbyfccqot on undnbyfccind.M_COM_QUOT = undnbyfccqot.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undnbyfccicmviw on undnbyfccicm.M_REFERENCE = undnbyfccicmviw.M_ICMUID
left join CMC_MGEN_DBF undnbyfcsgen on (undnbyfcm.M_CM_INSTR = undnbyfcsgen.M_REFERENCE and undnbyfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF undnbyfcsind on undnbyfcsgen.M_INDEX = undnbyfcsind.M_INDEX
left join CM_INDEX_DBF undnbyfcsicm on undnbyfcsind.M_COM_IND = undnbyfcsicm.M_REFERENCE
left join CMC_QUOT_DBF undnbyfcsqot on undnbyfcsind.M_COM_QUOT = undnbyfcsqot.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undnbyfcsicmviw on undnbyfcsicm.M_REFERENCE = undnbyfcsicmviw.M_ICMUID
left join CM_INDEX_DBF undnbyicm on (und.M_COM_FUT = undnbyicm.M_REFERENCE and und.M_COM_NBY_T = 2)
left join CMC_QUOT_DBF undnbyqot on (und.M_COM_QUOT = undnbyqot.M_REFERENCE and und.M_COM_NBY_T = 2)
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) undnbyicmviw on undnbyicm.M_REFERENCE = undnbyicmviw.M_ICMUID

where 1 = 1 
and ind.M_CATEGORY = 8 
and ind.M_RESET = 3 
and ind.M_CREAT_MODE = 0 
and ass.M_LABEL not in ('_ASSET')

);

drop table VIW_ICMAVG_DBF;
create table VIW_ICMAVG_DBF as (select * from INDCOM_AVG_VIW);
