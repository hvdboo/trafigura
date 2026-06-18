drop view INDCOM_SPT_VIW;
create view INDCOM_SPT_VIW 
(
M_ASSTYP,
M_ASSLAB,
M_INDCAT,
M_INDTYP,
M_INDLAB,
M_INDDES,
M_UNDTYP,
M_UNDLAB,
M_UNDES,
M_DLV,
M_QOTTYP,
M_QOTLAB,
M_QOTFWD,
M_PUB,
M_SYM,
M_HSR,
M_CAL,
M_CUR,
M_UOQ,
M_UOD,
M_LOTSIZ,
M_RNDRUL,
M_RNDDEC,
M_V2WFCT,
M_V2WNOM,
M_V2WDEN,
M_E2WFCT,
M_E2WNOM,
M_E2WDEN,
M_PHYTYP,
M_PHYLAB,
M_LOCTYP,
M_LOCLAB,
M_CRVLAB,
M_CRVTYP,
M_CRVMOD,
M_CRVOBJ,
M_HIS,
M_INDNDX,
M_INDUID,
M_ICMUID,
M_QOTUID,
M_QOTFWDUID,
M_PHYUID,
M_LOCUID,
M_CRVUID

)

as 

(
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
rtrim(hsr.M_HSR)      HSR,
rtrim(pub.M_CALENDAR) CAL,
-- ind.M_COM_CUR  INDCUR,
rtrim(qot.M_CURR)     CUR,
rtrim(qotuoq.M_LABEL) UOQ,
rtrim(qotuod.M_LABEL) UOD,
icm.M_LOTSIZE         LOTSIZ,
-- ROUNDING
'Quoted'      RNDRUL,
qot.M_PRC_DEC RNDDEC,
case when phy.M_CNV_VW = 1 then phy.M_CNV_VWF1 else null end V2WFCT,  
cnv_vw_v.M_LABEL V2WNOM,  
cnv_vw_w.M_LABEL V2WDEN,
case when phy.M_CNV_EW = 1 then phy.M_CNV_EWF1 else null end E2WFCT,  
cnv_ew_e.M_LABEL E2WNOM,  
cnv_ew_w.M_LABEL E2WDEN,--
-- DELIVERY
rtrim(phytyp.M_LABEL) PHYTYP, 
rtrim(phy.M_LABEL)    PHYLAB,
rtrim(loctyp.M_LABEL) LOCTYP, 
rtrim(loc.M_LABEL)    LOCLAB,
-- CURVE
case when crv.M_KEY is not null then concat(rtrim(icm.M_LABEL),substr(crv.M_KEY,21,5)) else null end CRVLAB,
case grp.M_VAL_TYPE
when 0 then 'Lease Metal Rate'
when 2 then 'Lease Cash Rate'
when 4 then case when rtrim(crvfcm.M_LABEL) is not null then 'Future' else 'Index' end
when 5 then 'Forward Rate' else null end CRVTYP,
case grp.M_GEN_MODE
when 0 then 'Custom'
when 1 then 'Simple'
when 2 then 'Yield' else null end CRVMOD,
case 
when rtrim(crvfcm.M_LABEL) is not null then rtrim(crvfcm.M_LABEL) 
when rtrim(crvgnmind.M_IND_LAB) is not null then rtrim(crvgnmind.M_IND_LAB)
when rtrim(crvicm.M_LABEL) is not null then rtrim(crvicm.M_LABEL)
else null end CRVOBJ,
-- HISTO
('B'||rtrim(indgrp.M_HISFILE)||'_HBS') HIS,
-- UID
ind.M_INDEX        INDNDX, 
ind.M_REFERENCE    INDUID,
icm.M_REFERENCE    ICMUID,
qot.M_REFERENCE    QOTUID,
qotfwd.M_REFERENCE QOTFWDUID,
phy.M_REFERENCE    PHYUID,
loc.M_REFERENCE    LOCUID,
crv.M_REFERENCE    CRVUID

from RT_INDEX_DBF ind
left join TRN_PC_DBF   pc on 1 = 1
left join TRN_DSKD_DBF dsk on 1 = 1
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_INDEX_DBF icm on ind.M_COM_IND = icm.M_REFERENCE
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CMC_QUOT_DBF qotfwd on icm.M_QUOT_FWD = qotfwd.M_REFERENCE
left join CM_UNIT_DBF  qotuoq on qot.M_UNIT = qotuoq.M_REFERENCE
left join CM_UNIT_DBF  qotuod on qot.M_QTY_UNIT = qotuod.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI = pub.M_REFERENCE
left join VIW_ICMPUB_DBF hsr on pub.M_REFERENCE = hsr.M_PUBUID and hsr.M_HSRDFL = 1
left join CM_PHYS_DBF  phy on icm.M_PHYSICAL = phy.M_REFERENCE
left join CM_PTYPE_DBF phytyp on phy.M_TYPE = phytyp.M_REFERENCE
left join CM_UNIT_DBF  cnv_ew_e  on phy.M_CNV_EWU0 = cnv_ew_e.M_REFERENCE  
left join CM_UNIT_DBF  cnv_ew_w on phy.M_CNV_EWU1 = cnv_ew_w.M_REFERENCE  
left join CM_UNIT_DBF  cnv_vw_v on phy.M_CNV_VWU0 = cnv_vw_v.M_REFERENCE  
left join CM_UNIT_DBF  cnv_vw_w on phy.M_CNV_VWU1 = cnv_vw_w.M_REFERENCE
left join CM_LOCAT_DBF loc on icm.M_LOCATION = loc.M_REFERENCE
left join CM_LTYPE_DBF loctyp on loc.M_TYPE = loctyp.M_REFERENCE
left join CMK_SCCF_DBF crv on icm.M_REFERENCE = to_number(substr(crv.M_KEY,1,10)) and crv.M__DATE_ = pc.M_DATE and crv.M__ALIAS_ = 'RT'
left join CMG_GRPI_DBF grp on crv.M_OBJ_PIL = grp.M_GROUP and grp.M_GTYPE = 512 and grp.M_VAL_TYPE = 4 and crv.M__DATE_ = grp.M__DATE_ and crv.M__ALIAS_ = grp.M__ALIAS_ 
left join CM_FUT_DBF   crvfcm on grp.M_FUTURE = crvfcm.M_REFERENCE
left join CM_INDEX_DBF crvicm on grp.M_INDEX = crvicm.M_REFERENCE and grp.M_GEN_MODE = 2
left join CMC_MGEN_DBF crvgnm on grp.M_INSTR_GEN = crvgnm.M_REFERENCE and grp.M_GEN_MODE = 1
left join RT_INDEX_DBF crvgnmind on crvgnm.M_INDEX = crvgnmind.M_INDEX
left join RT_INSGN_DBF crvgni on grp.M_INSTR_GEN = crvgni.M_GEN_NUM
left join RT_GROUP_DBF indgrp on ind.M_HISFILE = indgrp.M_HISFILE
left join TABLE#DATA#COMMODIT_DBF udf on icm.M_REFERENCE = udf.M_REFERENCE

where 1 = 1
and ind.M_CATEGORY = 8 
and ind.M_RESET = 0 
and ass.M_LABEL not in ('_ASSET')
-- and icm.M_COMMENT4 <> 'OOS'
-- Extra condition to exclude double future in the build of the GG EUA_NDX curve
and (grp.M_FUTURE is null or grp.M_FUTURE <> 1881)

);

drop table VIW_ICMSPT_DBF;
create table VIW_ICMSPT_DBF as (select * from INDCOM_SPT_VIW);
