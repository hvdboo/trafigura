select 
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
case when trn.M_BINTERNAL = 'Y' then rtrim(trn.M_BPFOLIO) else 'CTP' end BPFL,
rtrim(udfb.M_PTFCAT) CATB,
rtrim(udfb.M_STREAM_C) STRB,
rtrim(pflb.M_ACCSECTION) ACCB,
rtrim(accb.M_DESC) RMDB,
case when trn.M_SINTERNAL = 'Y' then rtrim(trn.M_SPFOLIO) else 'CTP' end SPFL,
rtrim(udfs.M_PTFCAT) CATS,
rtrim(udfs.M_STREAM_C) STRS,
rtrim(pfls.M_ACCSECTION) ACCS,
rtrim(accs.M_DESC) RMDS,
trn.M_TRN_FMLY FML,
trn.M_TRN_GRP  GRP,
trn.M_TRN_TYPE TYP,
-- trn.M_TRN_GTYPE GTYP,
rtrim(typo.M_LABEL) TYPO,
-- trn.M_INSTRUMENT INS_REF,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(phy.M_LABEL) PHY,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(udfcom.M_PL_ASSIG)
when 'CURR' then rtrim(udfcur.M_PL_ASSIG) else null end ASGNOS,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(udfcom.M_PL_ASSIG2)
when 'CURR' then rtrim(udfcur.M_PL_ASSIG2) else null end ASGVOS,
sum(case when trn.M_TRN_STATUS <> 'DEAD' then 1 else null end) LIVE,
sum(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CM_PHYS_DBF phy on plk.M_PRODUCT = phy.M_REFERENCE
left join RT_INDEX_DBF indmkt on trn.M_MKT_INDEX = indmkt.M_INDEX
left join TRN_PFLD_DBF pflb on rtrim(trn.M_BPFOLIO) = rtrim(pflb.M_LABEL)
left join TRN_PFLD_DBF pfls on rtrim(trn.M_SPFOLIO) = rtrim(pfls.M_LABEL)
left join TRN_ACSC_DBF accb on rtrim(pflb.M_ACCSECTION) = rtrim(accb.M_LABEL)
left join TRN_ACSC_DBF accs on rtrim(pfls.M_ACCSECTION) = rtrim(accs.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF udfb on rtrim(pflb.M_LABEL) = rtrim(udfb.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF udfs on rtrim(pfls.M_LABEL) = rtrim(udfs.M_LABEL)
left join TRN_EXT_DBF ext on trn.M_NB = ext.M_TRADE_REF 
left join TABLE#DATA#DEALCOM_DBF  udfcom on ext.M_UDF_REF = udfcom.M_NB
left join TABLE#DATA#DEALCURR_DBF udfcur on ext.M_UDF_REF = udfcur.M_NB

where 1 = 1
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and 
(
rtrim(trn.M_BPFOLIO) in
(
'MCEX OMU PTEI',
'RMOP KJO PTEI',
'RMOP OMU PTEI',
'RMOT OMU PTEI'
)
or 
rtrim(trn.M_SPFOLIO) in
(
'MCEX OMU PTEI',
'RMOP KJO PTEI',
'RMOP OMU PTEI',
'RMOT OMU PTEI'
)
)
group by
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end,
case when trn.M_BINTERNAL = 'Y' then rtrim(trn.M_BPFOLIO) else 'CTP' end,
udfb.M_PTFCAT,
udfb.M_STREAM_C,
pflb.M_ACCSECTION,
accb.M_DESC,
case when trn.M_SINTERNAL = 'Y' then rtrim(trn.M_SPFOLIO) else 'CTP' end,
udfs.M_PTFCAT,
udfs.M_STREAM_C,
pfls.M_ACCSECTION,
accs.M_DESC,
trn.M_TRN_FMLY,
trn.M_TRN_GRP,
trn.M_TRN_TYPE,
typo.M_LABEL,
plin.M_DSP_LABEL,
phy.M_LABEL,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(udfcom.M_PL_ASSIG)
when 'CURR' then rtrim(udfcur.M_PL_ASSIG) else null end,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(udfcom.M_PL_ASSIG2)
when 'CURR' then rtrim(udfcur.M_PL_ASSIG2) else null end

order by IE, BPFL, FML, GRP, TYP, TYPO, INS
