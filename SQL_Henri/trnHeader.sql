select distinct
trn.M_NB TRN, 
rtrim(substr(clacnt.M_NAME,11,100)) CNTCLAS,
trn.M_CONTRACT  CNT, 
cnt.M_VERSION   VSN, 
cnt.M_PACK_REF  PCK,
trn.M_GID       GID,
ord.M_REFERENCE ORD,
trn.M_CREATOR   CREAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
trn.M__DT_TS TMS,
to_char(trn.M_SYS_DATE,'YYYY-MM-DD') SYSDAT,
to_char(floor(trn.M_TRN_TIME/3600),'FM09')||':'||to_char(floor(mod(trn.M_TRN_TIME,3600)/60),'FM09')||':'||to_char(mod(mod(trn.M_TRN_TIME,3600),60),'FM09') SYSTIM,
rtrim(trn.M_TRN_STATUS) TRNSTA,
rtrim(cnt.M_STP_STATUS) STPSTA,
rtrim(evt.M_EVT_DLABEL) EVTLST,
rtrim(src.M_LABEL) SRC, 
-- rtrim(trn.M_PURPOSE),
rtrim(substr(clapur.M_NAME,26,100)) PURP, 
rtrim(usg.M_LABEL)    USG,
rtrim(clafld.M_LABEL) CLASS,
-- udf.M_TRINITY_ID TRINITY,
trn.M_TRN_GTYPE GTYP, trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(pat.M_LABEL) PAT,
rtrim(trn.M_INSTRUMENT) INS,
gen.M_GEN_NUM GEN,
rtrim(plin.M_DSP_LABEL) PLI,
rtrim(trn.M_PL_INSCUR) CUR,
rtrim(ass.M_LABEL) ASS,
rtrim(phy.M_LABEL) PHY,
rtrim(trn.M_BSTRATEGY) STGB,
rtrim(trn.M_SSTRATEGY) STGS,
rtrim(trn.M_BSECTION) ACCB,
rtrim(trn.M_SSECTION) ACCS,
-- rtrim(trn.M_BRW_ODPL),
case trn.M_TRN_FMLY when 'COM' then rtrim(trn.M_BRW_ODPL) else null end TRNMAT,
rtrim(trn.M_PL_KEY1) PLKEY1,
-- plk.M_REFERENCE PLKEY,
rtrim(qotpub.M_LABEL) QOTPUB,
rtrim(qotind.M_LABEL) QOTIND,
rtrim(qotind.M_DESC) QOTINDDES,
plk.M_INDEX PLK_IND,
rtrim(trn.M_MKT_INDEX) MKTNDX,
rtrim(indmkt.M_IND_LAB) MKT_INDLAB,
rtrim(fut.M_LABEL) FUT,
rtrim(omat.M_LABEL) OPTMAT,
rtrim(fmat.M_LABEL) FUTMAT,
rtrim(fmatset.M_LABEL) MATSET,
-- plk.M_OPT_MAT,
-- plk.M_FUT_MAT,
to_char(trn.M_TRN_EXP,'DD-MM-YYYY') TRNEXP,
to_char(omat.M_MATURITY,'DD-MM-YYYY') OPTEXP,
to_char(fmat.M_QT_END,'DD-MM-YYYY') FUTEXP,
to_char(fmat.M_ST_START,'DD-MM-YYYY') DLVFST,
to_char(fmat.M_ST_END,'DD-MM-YYYY') DLVLST,
rtrim(ind0.M_IND_LAB) IND0,
rtrim(hsr0.M_LABEL) HSR0,
rtrim(indndx0.M_IND_LAB) NDXIND0,
ndxprm.M_MARGIN NDXMRG0,
rtrim(ind1.M_IND_LAB) IND1,
rtrim(hsr1.M_LABEL) HSR1,
ext.M_TRADE_REF EXT, ext.M_UDF_REF UDF,
udfcur.M_NB,
udfcur.M_PL_ASSIG,
udfcur.M_PL_ASSIG2
--udfcur.M_EX_RF_SY, udfcur.M_EX_RF_ID, udfcur.M_EX_RF_S2, udfcur.M_EX_RF_I2
--udfcom.M_EX_RF_SY, udfcom.M_EX_RF_ID, udfcom.M_EX_RF_S2, udfcom.M_EX_RF_I2 
-- udfird.M_EX_RF_SY, udfird.M_EX_RF_ID, udfird.M_EX_RF_S2, udfird.M_EX_RF_I2 

from TRN_HDR_DBF trn
left join CLASS_MAPPING_DBF clacnt on trn.M_CNT_INTID = clacnt.M_ID
left join CLASS_MAPPING_DBF clapur on trn.M_PURPOSE = clapur.M_ID
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_EXT_DBF ext on trn.M_NB = ext.M_TRADE_REF and ext.M_VERSION = cnt.M_VERSION
left join TABLE#DATA#DEALCOM_DBF udf on ext.M_UDF_REF = udf.M_NB
left join USAGE_DBF usg on trn.M_USAGE = usg.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join CSF_CLASSIFICATION_DBF cntcla on trn.M_NB = cntcla.M_OBJ_REF
left join CSF_FOLDER_DBF clafld on cntcla.M_NODE_REF = clafld.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join DCF_OBJ_DBF pat on cnt.M_PATTERN = pat.M_ITEM_ID and pat.M_CATEG = 1
left join ORDERCMP_DBF ocmp on cnt.M_REFERENCE = ocmp.M_BO_REF
left join ORDER_DBF ord on ocmp.M_REFERENCE = ord.M_REFERENCE
left join EVT_MAP_DBF evt on trn.M_MOP_LAST = evt.M_EVT_ID
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CM_PHYS_DBF phy on plk.M_PRODUCT = phy.M_REFERENCE
left join CM_FUT_DBF fut on plk.M_FUTURE = fut.M_REFERENCE
left join CMC_QUOT_DBF qot on plk.M_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF qotpub on qot.M_PUBLI = qotpub.M_REFERENCE
left join CM_INDEX_DBF qotind on qot.M_REFERENCE = qotind.M_QUOT_FWD
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join RT_LN_INDEXATION_DBF lnndx on trn.M_NB = lnndx.M_NB
left join RT_INDEXATION_DBF ndxprm on lnndx.M_REF_INDEXATION = ndxprm.M_REFERENCE
left join RT_LNDXG_DBF ndx on ndxprm.M_REF_INDEXATION_TEMPL = ndx.M_REFERENCE
left join RT_INDEX_DBF indmkt on trn.M_MKT_INDEX = indmkt.M_INDEX
left join RT_INDEX_DBF ind0 on gen.M_INDEX0 = ind0.M_INDEX
left join RT_INDEX_DBF ind1 on gen.M_INDEX1 = ind1.M_INDEX
left join RT_INDEX_DBF indndx0 on ndx.M_INDEX = indndx0.M_INDEX
left join CM_MKTSR_DBF hsr0 on rtrim(substr(gen.M_FORMULA0,2,10)) = ltrim(to_char(hsr0.M_SERIE))
left join CM_MKTSR_DBF hsr1 on rtrim(substr(gen.M_FORMULA1,2,10)) = ltrim(to_char(hsr1.M_SERIE))
left join CM_OMAT1_DBF omat on plk.M_OPT_MAT = omat.M_REFERENCE
left join CM_FMAT1_DBF fmat on plk.M_FUT_MAT = fmat.M_REFERENCE
left join CM_FMAT_DBF fmatset on fmat.M_FMAT_ID = fmatset.M_REFERENCE
left join TABLE#DATA#DEALCOM_DBF udfcom  on (ext.M_UDF_REF = udfcom.M_NB and ext.M_VERSION = cnt.M_VERSION)
left join TABLE#DATA#DEALCURR_DBF udfcur on (ext.M_UDF_REF = udfcur.M_NB and ext.M_VERSION = cnt.M_VERSION)
left join TABLE#DATA#DEALIRD_DBF udfird  on (ext.M_UDF_REF = udfird.M_NB and ext.M_VERSION = cnt.M_VERSION)
 
where 1 = 1 
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
--and trn.M_MOP_LAST not in (6,7)
-- and trn.M_TRN_STATUS <> 'DEAD'
and trn.M_NB = 75241841
-- and trn.M_TRN_FMLY = 'CURR'
-- trn.M_TRN_GTYPE = 100
-- and rtrim(ass.M_LABEL) in ('COAL','FMT')
-- and trim(trn.M_INSTRUMENT) in ('24144')
-- and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') > '2019-12-10'
-- and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') < '2020-01-31'
-- and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') <> to_char(fmat.M_QT_END,'YYYY-MM-DD')
-- and (rtrim(trn.M_BPFOLIO) in ('MCEX KTE PTEI') or rtrim(trn.M_SPFOLIO) in ('MCEX KTE PTEI'))
-- and (udfcur.M_PL_ASSIG <> 'FOREX' or udfcur.M_PL_ASSIG2 <> 'FOREX')
-- and rtrim(typo.M_LABEL) = 'SCF'
-- and (rtrim(trn.M_BSTRATEGY) = 'FOREX' or rtrim(trn.M_SSTRATEGY) = 'FOREX')

order by INS, TRNMAT

