select
rtrim(src.M_LABEL) SRC,
rtrim(substr(clapur.M_NAME,26,100)) PURPOSE, 
trn.M_CONTRACT CNT, 
cnt.M_PACK_REF PCK,
trn.M_NB       TRN,
trn.M_NB_EXT   EXT, 
trn.M_GID      GID,
to_char(trn.M_SYS_DATE,'YYYY-MM-DD') SYSDAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
null PNLIMP,
cnt.M_VERSION CVS,
rtrim(trn.M_TRN_STATUS) TRNSTAT,
rtrim(cnt.M_STP_STATUS) STPSTAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctptyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
case when trn.M_BINTERNAL = 'Y' then rtrim(lenb.M_DSP_LABEL) else rtrim(lens.M_DSP_LABEL) end LE,
rtrim(trn.M_BENTITY) CE,
rtrim(ext.M_GROUP)  USRGRP,
case when trn.M_BINTERNAL  = 'Y' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
rtrim(pflsrc.M_LABEL) PFL,
-- case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case when trn.M_BINTERNAL = trn.M_BINTERNAL then rtrim(pfldst.M_LABEL) else rtrim(ctp.M_DSP_LABEL) end CTP,
null PCKLAB,
null PCKSEQ,
null PCKFGT,
case when rtrim(trn.M_TRN_FMLY) = 'CURR' then 'FXD' else rtrim(trn.M_TRN_FMLY) end FINASS,
rtrim(ass.M_LABEL) COMASS,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
trn.M_TRN_GTYPE FGT, 
rtrim(trn.M_TRN_FMLY) FML,
rtrim(trn.M_TRN_GRP)  GRP,
rtrim(trn.M_TRN_TYPE) TYP,
rtrim(typo.M_LABEL)   TYPO,
rtrim(usg.M_LABEL)    USG,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BSECTION)  else rtrim(trn.M_SSECTION)  end SEC_SRC,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_SSECTION)  else rtrim(trn.M_BSECTION)  end SEC_DST,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BSTRATEGY) else rtrim(trn.M_SSTRATEGY) end STG_SRC,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_SSTRATEGY) else rtrim(trn.M_BSTRATEGY) end STG_DST,
rtrim(plin.M_DSP_LABEL) PLILAB,
rtrim(trn.M_PL_INSCUR)  PLICUR,
rtrim(phy.M_LABEL) PHY,
null LOC,
rtrim(trn.M_PL_INSCUR) CUR,
case 
when trn.M_TRN_FMLY = 'COM'  then null
when trn.M_TRN_FMLY = 'CURR' then trn.M_BRW_NOMU1
else rtrim(trn.M_PL_INSCUR) end UOQ,
case 
when trn.M_TRN_FMLY = 'COM'  then null
when trn.M_TRN_FMLY = 'CURR' then trn.M_BRW_NOMU1
else null end UOD,
case 
when trn.M_TRN_FMLY = 'COM'  then null
when trn.M_TRN_FMLY = 'CURR' then trn.M_BRW_NOMU2
else null end UOV,
case 
when trn.M_TRN_GTYPE in (100, 101, 136, 146) then fcm.M_QTY
when trn.M_TRN_GTYPE in (76) then fxc.M_CNTSIZE0
when trn.M_TRN_GTYPE in (49) then 1
else 1 end LOTSIZ,
null LEG,
null IND0,
null UND0,
null QOT0,
null PUB0,
null HSR0,
null IND1,
null UND1,
null QOT1,
null PUB1,
null HSR1,
null EFF,
null SPAN,
null MATLAB0,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') MATDAT0,
null MATLAB1,
null MATDAT1,
null DLVFST,
null DLVLST,
null CLCFST0,
null CLCLST0,
null CLCFST1,
null CLCLST1,
to_char(trn.M_OPT_FLWLST,'YYYY-MM-DD') STL,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP_,
rtrim(trn.M_BRW_AE) EXRSTY,
null EXRMOD,
null STLMOD,
rtrim(trn.M_BRW_CP) RGT,
trn.M_BRW_STRK STK,
case 
when trn.M_TRN_GTYPE in (76,77) then trn.M_BRW_RTE1
when trn.M_TRN_GTYPE in (100,102,130,136) then trn.M_BRW_RTE2
else 0 end PRC,
null PRM,
null RTE0,
null MRG0,
null RTE1,
null MRG1,
trn.M_COMMENT_BS DIR,
null LS_CNT,
trn.M_BRW_NOM1 NOM0,
trn.M_BRW_NOM2 NOM1,
null QTY,
null FEE_TYPn,
null FEE_PFLn,
null FEE_CTPn,
null FEE_CURn,
null FEE_AMTn,
null FEE_DTCn,
null FEE_STLn,
null FEE_CODn,
null FEE_CMTn

from TRN_HDR_DBF trn
left join MUREX_MX_OWNER.TRN_PC_DBF pc on 1 = 1
left join CLASS_MAPPING_DBF clacnt on trn.M_CNT_INTID = clacnt.M_ID
left join CLASS_MAPPING_DBF clapur on trn.M_PURPOSE = clapur.M_ID
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_EXT_DBF ext on trn.M_NB = ext.M_TRADE_REF and ext.M_VERSION = cnt.M_VERSION
left join TABLE#DATA#DEALCOM_DBF udf on ext.M_UDF_REF = udf.M_NB
left join TRN_PFLD_DBF pflsrc on trn.M_SRC_PFOLIO = pflsrc.M_REF
left join TRN_PFLD_DBF pfldst on trn.M_DST_PFOLIO = pfldst.M_REF
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join TRN_CPDF_DBF lenb on trn.M_BLENTITY = lenb.M_ID
left join TRN_CPDF_DBF lens on trn.M_SLENTITY = lens.M_ID
left join CTP_TYPES_DBF ctptyp on (ctp.M_ID = ctptyp.M_CTN and ctptyp.M_REF = 16)
left join USAGE_DBF usg on trn.M_USAGE = usg.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE 
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE) and trn.M_TRN_FMLY = 'COM'
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CMT_DLV_DBF dlv on (trn.M_NB = dlv.M_NB and dlv.M_LEG_NB = 0)
left join CM_PHYS_DBF phy on plk.M_PRODUCT = phy.M_REFERENCE
left join CM_FUT_DBF fcm on  plk.M_FUTURE = fcm.M_REFERENCE
left join CMC_QUOT_DBF qot on plk.M_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF qotpub on qot.M_PUBLI = qotpub.M_REFERENCE
left join CM_INDEX_DBF qotind on qot.M_REFERENCE = qotind.M_QUOT_FWD
left join FX_CNT_DBF fxc on rtrim(plin.M_DSP_LABEL) = rtrim(fxc.M_LABEL)

where trn.M_NB = 33588552
