select distinct
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
rtrim(ind.M_IND_LAB)  INDLAB,
rtrim(ind.M_IND_DESC) INDDES,
-- UND
case ind.M_COM_NBY_T
when 0 then 'FWD'
when 1 then 'FLT'
when 2 then 'SPT' else null end UNDTYP,
case ind.M_COM_NBY_T
when 0 then rtrim(nbyfcm.M_LABEL)
when 2 then rtrim(nbyicm.M_LABEL) else null end UNDLAB,
case ind.M_COM_NBY_T
when 0 then rtrim(nbyfcm.M_DESC)
when 2 then rtrim(nbyicm.M_DESC) else null end UNDDES,
case nbyqot.M__TYPE_
when  1 then 'Index'
when  2 then 'Future'
when  4 then 'Dlv.flow'
when  8 then 'Spread'
when  5 then 'Index flow'
when  6 then 'Future flow'
when 14 then 'Spread fut.flow' 
when 16 then 'Opt.Listed' else null end QOTTYP,
rtrim(nbyqot.M_LABEL)    QOTLAB,
rtrim(nbypub.M_LABEL)    PUB,
rtrim(nbyqot.M_TRAD_SMB) SYM,
rtrim(hsr.M_HSR)         HSR,
rtrim(nbypub.M_CALENDAR) CAL,
-- rtrim(ind.M_COM_CUR)  INDCUR,
rtrim(nbyqot.M_CURR)  CUR,
rtrim(qotuoq.M_LABEL) UOQ,
rtrim(qotuod.M_LABEL) UOD,
coalesce(nbyfcm.M_QTY, nbyicm.M_LOTSIZE) LOTSIZ,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenicm.M_LABEL), rtrim(nbyfccgenucm.M_LABEL))
     when 1 then coalesce(rtrim(nbyfcsgenundicm.M_LABEL), rtrim(nbyfcsgenicm.M_LABEL), rtrim(nbyfcsgenucm.M_LABEL)) end
when 2 then rtrim(nbyicm.M_LABEL) else null end ICMLAB,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenqot.M_LABEL), rtrim(nbyfccgenuqt.M_LABEL))
     when 1 then coalesce(rtrim(nbyfcsgenqot.M_LABEL), rtrim(nbyfcsgenuqt.M_LABEL)) end
when 2 then rtrim(nbyqot.M_LABEL) else null end ICMQOT,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenqot.M_TRAD_SMB), rtrim(nbyfccgenuqt.M_TRAD_SMB))
     when 1 then coalesce(rtrim(nbyfcsgenqot.M_TRAD_SMB), rtrim(nbyfcsgenuqt.M_TRAD_SMB)) end
when 2 then rtrim(nbyqot.M_TRAD_SMB) else null end ICMSYM,
-- ROUNDING
'Quoted'      RNDRUL,
nbyqot.M_PRC_DEC RNDDEC,
-- OBSERVATION
case ind.M_COM_NBY_T
when 0 then 'Future'
when 1 then 'Floating'
when 2 then 'Index' 
else null end OBSFRM,
case ind.M_COM_NBY_T when 0 then
    case ind.M_COM_NB_MT
    when -9 then 'All'
    when -1 then 'Floating'
    when  0 then 'Fixed'
    when  1 then 'Day'
    when  2 then 'Week'
    when  3 then 'Month'
    when  4 then 'Quarter'
    when  5 then 'Season'
    when  6 then 'Year'
    when  7 then 'Week-end'
    when  8 then 'Weekdays'
    when  9 then 'Bal.Month' else null end 
else null end OBSMATTYP,
case ind.M_COM_NBY_T when 0 then
    case ind.M_COM_NBY_R 
    when 0 then 'Quotation end'
    when 1 then 'Notification first'
    when 2 then 'Notification last' 
    when 3 then 'Delivery first' else null end 
else null end OBSSHFTYP,
case ind.M_COM_NBY_T when 0 then ind.M_COM_NBY_O else null end OBSORD,
case ind.M_COM_NBY_T when 0 then
    case ind.M_COM_NBY_SHIFTER_MODE
    when 0 then 'Roll-over'
    when 1 then 'Maturity' else null end 
else null end OBSSHFMOD,
rtrim(ind.M_UECF) OBSSHIFT,
case ind.M_COM_NBY_T
when 0 then to_char(ind.M_COM_NBY_O)||'L_'||
    case ind.M_COM_NBY_R 
    when 0 then 'QL'
    when 1 then 'NF'
    when 2 then 'NL' 
    when 3 then 'DF' else null end||'_'||
    case ind.M_COM_NBY_SHIFTER_MODE
    when 0 then 'ROLL'
    when 1 then 'MAT ' else null end||'_'||
    rtrim(ind.M_UECF)
when 2 then rtrim(ind.M_UECF)
else null end OBSFRQ,
-- DELIVERY
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenicmviw.M_PHYLAB), rtrim(nbyfccgenucmviw.M_PHYLAB))
     when 1 then coalesce(rtrim(nbyfcsgenundicmviw.M_PHYLAB), rtrim(nbyfcsgenicmviw.M_PHYLAB), rtrim(nbyfcsgenucmviw.M_PHYLAB)) end
when 2 then rtrim(nbyicmviw.M_PHYLAB) else null end PHYLAB,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenicmviw.M_LOCLAB), rtrim(nbyfccgenucmviw.M_LOCLAB))
     when 1 then coalesce(rtrim(nbyfcsgenundicmviw.M_LOCLAB), rtrim(nbyfcsgenicmviw.M_LOCLAB), rtrim(nbyfcsgenucmviw.M_LOCLAB)) end
when 2 then rtrim(nbyicmviw.M_LOCLAB) else null end LOCLAB,
-- CURVE
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenicmviw.M_CRVTYP), rtrim(nbyfccgenucmviw.M_CRVTYP))
     when 1 then coalesce(rtrim(nbyfcsgenundicmviw.M_CRVTYP), rtrim(nbyfcsgenicmviw.M_CRVTYP), rtrim(nbyfcsgenucmviw.M_CRVTYP)) end
when 2 then rtrim(nbyicmviw.M_CRVTYP) else null end CRVTYP,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenicmviw.M_CRVOBJ), rtrim(nbyfccgenucmviw.M_CRVOBJ))
     when 1 then coalesce(rtrim(nbyfcsgenundicmviw.M_CRVOBJ), rtrim(nbyfcsgenicmviw.M_CRVOBJ), rtrim(nbyfcsgenucmviw.M_CRVOBJ)) end
when 2 then rtrim(nbyicmviw.M_CRVOBJ) else null end CRVOBJ,
-- HIS
('B'||rtrim(ind.M_HISFILE)||'_HBS') HIS,
-- UID
ind.M_INDEX        INDNDX, 
ind.M_REFERENCE    INDUID,
nbyqot.M_REFERENCE QOTUID,
nbyfcm.M_REFERENCE FCMUID,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(nbyfccgenind.M_INDEX, nbyfccgenund.M_INDEX)
     when 1 then coalesce(nbyfcsgenind.M_INDEX, nbyfcsgenund.M_INDEX) end
when 2 then concat(lpad(nbyicm.M_REFERENCE,7), lpad(nbyqot.M_REFERENCE,8)) end ICMNDX,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(nbyfccgenicm.M_REFERENCE, nbyfccgenucm.M_REFERENCE)
     when 1 then coalesce(nbyfcsgenundicm.M_REFERENCE, nbyfcsgenicm.M_REFERENCE, nbyfcsgenucm.M_REFERENCE) end
when 2 then nbyicm.M_REFERENCE else null end ICMUID,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(nbyfccgenicmviw.M_PHYUID, nbyfccgenucmviw.M_PHYUID)
     when 1 then coalesce(nbyfcsgenundicmviw.M_PHYUID, nbyfcsgenicmviw.M_PHYUID, nbyfcsgenucmviw.M_PHYUID) end
when 2 then nbyicmviw.M_PHYUID else null end PHYUID,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(nbyfccgenicmviw.M_LOCUID, nbyfccgenucmviw.M_LOCUID)
     when 1 then coalesce(nbyfcsgenundicmviw.M_LOCUID, nbyfcsgenicmviw.M_LOCUID, nbyfcsgenucmviw.M_LOCUID) end
when 2 then nbyicmviw.M_LOCUID else null end LOCUID,
case ind.M_COM_NBY_T
when 0 then 
     case nbyfcm.M_INS_MODE
     when 0 then coalesce(rtrim(nbyfccgenicmviw.M_CRVUID), rtrim(nbyfccgenucmviw.M_CRVUID))
     when 1 then coalesce(rtrim(nbyfcsgenundicmviw.M_CRVUID), rtrim(nbyfcsgenicmviw.M_CRVUID), rtrim(nbyfcsgenucmviw.M_CRVUID)) end
when 2 then rtrim(nbyicmviw.M_CRVUID) else null end CRVUID

from RT_INDEX_DBF ind
left join TRN_PC_DBF   bo on 1 = 1
left join TRN_DSKD_DBF fo on 1 = 1
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_FUT_DBF   nbyfcm       on (ind.M_COM_FUT = nbyfcm.M_REFERENCE and ind.M_COM_NBY_T = 0 and nbyfcm.M_LISTED in (1,2,16,32))
left join RT_LNGN_DBF  nbyfccgen    on (nbyfcm.M_CM_INSTR = nbyfccgen.M_GEN_NUM and nbyfcm.M_INS_MODE = 0)
left join RT_INDEX_DBF nbyfccgenind on rtrim(nbyfccgen.M_INDEX0) = rtrim(nbyfccgenind.M_INDEX)
left join CM_INDEX_DBF nbyfccgenicm on nbyfccgenind.M_COM_IND = nbyfccgenicm.M_REFERENCE
left join CMC_QUOT_DBF nbyfccgenqot on nbyfccgenind.M_COM_QUOT = nbyfccgenqot.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfccgenicmviw on nbyfccgenicm.M_REFERENCE = nbyfccgenicmviw.M_ICMUID
left join RT_INDEX_DBF nbyfccgenund on nbyfccgenind.M_UNDRL = nbyfccgenund.M_INDEX
left join CM_INDEX_DBF nbyfccgenucm on nbyfccgenund.M_COM_IND = nbyfccgenucm.M_REFERENCE
left join CMC_QUOT_DBF nbyfccgenuqt on nbyfccgenund.M_COM_QUOT = nbyfccgenuqt.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfccgenucmviw on nbyfccgenucm.M_REFERENCE = nbyfccgenucmviw.M_ICMUID
left join CMC_MGEN_DBF nbyfcsgen    on (nbyfcm.M_CM_INSTR = nbyfcsgen.M_REFERENCE and nbyfcm.M_LISTED in (1,2,16,32) and nbyfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF nbyfcsgenind on nbyfcsgen.M_INDEX = nbyfcsgenind.M_INDEX
left join CM_INDEX_DBF nbyfcsgenicm on nbyfcsgenind.M_COM_IND = nbyfcsgenicm.M_REFERENCE
left join CMC_QUOT_DBF nbyfcsgenqot on nbyfcsgenind.M_COM_QUOT = nbyfcsgenqot.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsgenicmviw on nbyfcsgenicm.M_REFERENCE = nbyfcsgenicmviw.M_ICMUID
left join RT_INDEX_DBF nbyfcsgenund on nbyfcsgenind.M_UNDRL = nbyfcsgenund.M_INDEX
left join CM_INDEX_DBF nbyfcsgenucm on nbyfcsgenund.M_COM_IND = nbyfcsgenucm.M_REFERENCE
left join CMC_QUOT_DBF nbyfcsgenuqt on nbyfcsgenund.M_COM_QUOT = nbyfcsgenuqt.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsgenucmviw on nbyfcsgenucm.M_REFERENCE = nbyfcsgenucmviw.M_ICMUID
left join CM_FUT_DBF   nbyfcsgenundfcm on (nbyfcsgenund.M_COM_FUT = nbyfcsgenundfcm.M_REFERENCE and nbyfcsgenund.M_COM_NBY_T = 0 and nbyfcsgenundfcm.M_LISTED in (1,2,16))
left join CMC_MGEN_DBF nbyfcsgenundgnm on (nbyfcsgenundfcm.M_CM_INSTR = nbyfcsgenundgnm.M_REFERENCE and nbyfcsgenundfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF nbyfcsgenundind on nbyfcsgenundgnm.M_INDEX = nbyfcsgenundind.M_INDEX
left join CM_INDEX_DBF nbyfcsgenundicm on (nbyfcsgenundind.M_COM_IND = nbyfcsgenundicm.M_REFERENCE and nbyfcsgenundind.M_RESET = 0)
left join CMC_QUOT_DBF nbyfcsgenundqot on nbyfcsgenundind.M_COM_QUOT = nbyfcsgenundqot.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyfcsgenundicmviw on nbyfcsgenundicm.M_REFERENCE = nbyfcsgenundicmviw.M_ICMUID
left join CM_INDEX_DBF nbyicm on (ind.M_COM_FUT = nbyicm.M_REFERENCE and ind.M_COM_NBY_T = 2)
left join CMC_QUOT_DBF nbyqot on ind.M_COM_QUOT = nbyqot.M_REFERENCE
left join (select distinct M_ICMUID, M_PUB, M_HSR, M_CAL, M_UOQ, M_UOD, M_PHYLAB, M_LOCLAB, M_CRVTYP, M_CRVOBJ, M_PHYUID, M_LOCUID, M_QOTUID, M_QOTFWDUID, M_CRVUID from VIW_ICMSPT_DBF where M_QOTUID = M_QOTFWDUID) nbyicmviw on nbyicm.M_REFERENCE = nbyicmviw.M_ICMUID
left join CM_UNIT_DBF  qotuoq on nbyqot.M_UNIT = qotuoq.M_REFERENCE
left join CM_UNIT_DBF  qotuod on nbyqot.M_QTY_UNIT = qotuod.M_REFERENCE
left join CM_MKT_DBF   nbypub on nbyqot.M_PUBLI = nbypub.M_REFERENCE
left join VIW_ICMPUB_DBF hsr  on nbypub.M_REFERENCE = hsr.M_PUBUID and hsr.M_HSRDFL = 1

where 1 = 1
and ind.M_CREAT_MODE = 0
and ind.M_CATEGORY = 8 
and ind.M_RESET = 6

order by INDLAB
