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
rtrim(ind.M_IND_LAB)      INDLAB,
rtrim(ind.M_IND_DESC)     INDDES,
'SPT'                     UNDTYP,
rtrim(icm.M_LABEL)        UNDLAB,
rtrim(icm.M_DESC)         UNDDES,
case icm.M_DEL_MECHAN
when 0 then 'Stock'
when 1 then 'Flow' else null end DLV,
case qot.M__TYPE_
when  1 then 'Index stock'
when  2 then 'Future stock'
when  4 then 'Dlv.flow'
when  5 then 'Index flow'
when  6 then 'Future flow'
when  8 then 'Spread'
when 14 then 'Spread fut.flow' 
when 16 then 'Opt.Listed' else null end QOTTYP,
rtrim(qot.M_LABEL)    QOTLAB,
rtrim(qotfwd.M_LABEL) QOTFWD,
rtrim(pub.M_LABEL)    PUB,
rtrim(qot.M_TRAD_SMB) SYM,
rtrim(hsr.M_HSR)      HSRDFL,
rtrim(pub.M_CALENDAR) CAL,
-- ind.M_COM_CUR  INDCUR,
rtrim(qot.M_CURR)     CUR,
rtrim(qotuoq.M_LABEL) UOQ,
rtrim(qotuod.M_LABEL) UOD,
icm.M_LOTSIZE         LOTSIZ,
-- DELIVERY
rtrim(phy.M_LABEL)    PHYLAB,
rtrim(loc.M_LABEL)    LOCLAB,
-- CURVE
case when crv.M_KEY is not null then concat(rtrim(icm.M_LABEL),substr(crv.M_KEY,21,5)) else null end CRVLAB,
case crvbld.M_GTYPE
when  256 then 'Swap PRC'
when  512 then 'Curve'
when 1024 then 'Future VOL'
when 2048 then 'Index VOL' 
when 4096 then 'Volume bucket'
when 8192 then 'Future VOL' else null end CRVNAT,
-- rtrim(crvgrp.M_LABEL) CRVGRP,
case crvbld.M_VAL_TYPE
when 0 then 'Lease Metal Rate'
when 2 then 'Lease Cash Rate'
when 4 then case when rtrim(crvfcm.M_LABEL) is not null then 'Future' else 'Index' end
when 5 then 'Forward Rate' else null end CRVTYP,
case crvbld.M_GEN_MODE
when 0 then 'Custom'
when 1 then 'Simple'
when 2 then 'Yield' else null end CRVMOD,
case 
when rtrim(crvfcm.M_LABEL) is not null then rtrim(crvfcm.M_LABEL) 
when rtrim(crvgnmind.M_IND_LAB) is not null then rtrim(crvgnmind.M_IND_LAB)
when rtrim(crvicm.M_LABEL) is not null then rtrim(crvicm.M_LABEL)
else null end CRVOBJ,
coalesce(rtrim(crvvin.M_LABEL),'.') CRVVIN,
-- HISTO
('B'||rtrim(indgrp.M_HISFILE)||'_HBS') HIS,
-- UID
ind.M_INDEX        INDNDX, 
ind.M_REFERENCE    INDUID,
icm.M_REFERENCE    ICMUID,
qot.M_REFERENCE    QOTUID,
qotfwd.M_REFERENCE QOTFWDUID,
crv.M_REFERENCE    CRVUID,
case when crvbld.M_FUTURE = 0 then crvgnmind.M_REFERENCE else crvbld.M_FUTURE end CRVOBJUID,
crvfcm.M_VINTAGE_FILTER CRVVINUID,
crvgrp.M_REFERENCE GRPUID

from RT_INDEX_DBF ind
left join TRN_PC_DBF   pc on 1 = 1
left join TRN_DSKD_DBF dsk on 1 = 1
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_INDEX_DBF icm on ind.M_COM_IND = icm.M_REFERENCE
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CMC_QUOT_DBF qotfwd on icm.M_QUOT_FWD = qotfwd.M_REFERENCE
left join CM_UNIT_DBF  qotuoq on qot.M_UNIT = qotuoq.M_REFERENCE
left join CM_UNIT_DBF  qotuod on qot.M_QTY_UNIT = qotuod.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI = pub.M_REFERENCE
left join VIW_ICMPUB_DBF hsr on pub.M_REFERENCE = hsr.M_PUBUID and hsr.M_HSRDFL = 1
left join CM_PHYS_DBF  phy on icm.M_PHYSICAL = phy.M_REFERENCE
left join CM_UNIT_DBF  cnv_ew_e  on phy.M_CNV_EWU0 = cnv_ew_e.M_REFERENCE  
left join CM_UNIT_DBF  cnv_ew_w on phy.M_CNV_EWU1 = cnv_ew_w.M_REFERENCE  
left join CM_UNIT_DBF  cnv_vw_v on phy.M_CNV_VWU0 = cnv_vw_v.M_REFERENCE  
left join CM_UNIT_DBF  cnv_vw_w on phy.M_CNV_VWU1 = cnv_vw_w.M_REFERENCE
left join CM_LOCAT_DBF loc on icm.M_LOCATION = loc.M_REFERENCE
left join CMK_SCCF_DBF crv on icm.M_REFERENCE = to_number(substr(crv.M_KEY,1,10)) and crv.M__DATE_ = pc.M_DATE and crv.M__ALIAS_ = 'RT'
left join CMG_GRPI_DBF crvbld on crv.M_OBJ_PIL = crvbld.M_GROUP and crvbld.M_GTYPE = 512 and crvbld.M_VAL_TYPE = 4 and crv.M__DATE_ = crvbld.M__DATE_ and crv.M__ALIAS_ = crvbld.M__ALIAS_ 
left join CMG_GRP_DBF  crvgrp on crvbld.M_GROUP = crvgrp.M_REFERENCE and crv.M__DATE_ = crvgrp.M__DATE_ and crv.M__ALIAS_ = crvgrp.M__ALIAS_
left join CM_FUT_DBF   crvfcm on crvbld.M_FUTURE = crvfcm.M_REFERENCE
left join CM_VINTAGE_DBF crvvin on crvfcm.M_VINTAGE_FILTER = crvvin.M_REFERENCE
left join CM_INDEX_DBF crvicm on crvbld.M_INDEX = crvicm.M_REFERENCE and crvbld.M_GEN_MODE = 2
left join CMC_MGEN_DBF crvgnm on crvbld.M_INSTR_GEN = crvgnm.M_REFERENCE and crvbld.M_GEN_MODE = 1
left join RT_INDEX_DBF crvgnmind on crvgnm.M_INDEX = crvgnmind.M_INDEX
left join RT_INSGN_DBF crvgni on crvbld.M_INSTR_GEN = crvgni.M_GEN_NUM
left join RT_GROUP_DBF indgrp on ind.M_HISFILE = indgrp.M_HISFILE
left join TABLE#DATA#COMMODIT_DBF udf on icm.M_REFERENCE = udf.M_REFERENCE

where 1 = 1
and ind.M_CATEGORY = 8 
and ind.M_RESET = 0 
and qot.M_REFERENCE = qotfwd.M_REFERENCE
and ass.M_LABEL not in ('_ASSET')
and icm.M_COMMENT4 <> 'OOS'
-- Extra condition to exclude double future in the build of the GG EUA_NDX curve
--and (grp.M_FUTURE is null or grp.M_FUTURE <> 1881)

order by INDLAB
