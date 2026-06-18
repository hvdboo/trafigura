select distinct
trn.M_NB TRD, 
trn.M_CONTRACT CNT, 
cnt.M_VERSION VSN, 
cnt.M_PACK_REF PCK,
trn.M_GID GID,
rtrim(src.M_LABEL) SRC, 
-- rtrim(trn.M_PURPOSE),
rtrim(substr(clapur.M_NAME,26,100)) PURP, 
rtrim(usg.M_LABEL) USG,
trn.M_TRN_GTYPE GTYP, trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(trn.M_INSTRUMENT) INS,
rtrim(plin.M_DSP_LABEL) PLIN,
ext.M_TRADE_REF EXT, ext.M_UDF_REF UDF,
udfcom.*
--udfcur.M_EX_RF_SY, udfcur.M_EX_RF_ID, udfcur.M_EX_RF_S2, udfcur.M_EX_RF_I2
--udfcom.M_EX_RF_SY, udfcom.M_EX_RF_ID, udfcom.M_EX_RF_S2, udfcom.M_EX_RF_I2 
-- udfird.M_EX_RF_SY, udfird.M_EX_RF_ID, udfird.M_EX_RF_S2, udfird.M_EX_RF_I2 

from TRN_HDR_DBF trn
left join CLASS_MAPPING_DBF clacnt on trn.M_CNT_INTID = clacnt.M_ID
left join CLASS_MAPPING_DBF clapur on trn.M_PURPOSE = clapur.M_ID
left join USAGE_DBF usg on trn.M_USAGE = usg.M_REFERENCE
left join TRN_EXT_DBF ext on trn.M_NB = ext.M_TRADE_REF 
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE 
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join TABLE#DATA#DEALCOM_DBF udfcom  on (ext.M_UDF_REF = udfcom.M_NB and ext.M_VERSION = cnt.M_VERSION)
left join TABLE#DATA#DEALCURR_DBF udfcur on (ext.M_UDF_REF = udfcur.M_NB and ext.M_VERSION = cnt.M_VERSION)
left join TABLE#DATA#DEALIRD_DBF udfird  on (ext.M_UDF_REF = udfird.M_NB and ext.M_VERSION = cnt.M_VERSION)
 
where 1 = 1 
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_NB = 15940302
-- and trn.M_MOP_LAST not in (6,7)
-- and trn.M_TRN_STATUS <> 'DEAD'
-- trn.M_TRN_GTYPE = 100
-- and trim(trn.M_INSTRUMENT) in ('8694','8695','8696','8697','8698','8904','10995')
-- and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') > '2019-12-10'
-- and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') < '2020-01-31'
-- and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') <> to_char(fmat.M_QT_END,'YYYY-MM-DD')

order by TRD

