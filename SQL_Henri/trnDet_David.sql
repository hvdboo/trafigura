select 
trn.M_NB        TRN,
trn.M_CONTRACT  CNT, 
cnt.M_VERSION   VSN, 
rtrim(trn.M_TRN_STATUS) TRNSTAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
rtrim(pflsrc.M_LABEL) PFLSRC,
rtrim(pfldst.M_LABEL) PFLDST,
rtrim(ctp.M_DSP_LABEL) CTP,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
rtrim(trn.M_TRN_FMLY) FINASS,
rtrim(atp.M_LABEL) COMATP,
rtrim(ass.M_LABEL) COMASS,
rtrim(trn.M_TRN_GTYPE) FGT,
rtrim(trn.M_TRN_FMLY)  FML, 
rtrim(trn.M_TRN_GRP)   GRP, 
rtrim(trn.M_TRN_TYPE)  TYP,
rtrim(typo.M_LABEL)    TYPO,
rtrim(pli.M_DSP_LABEL) PLI

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PFLD_DBF pflsrc on trn.M_SRC_PFOLIO = pflsrc.M_REF
left join TRN_PFLD_DBF pfldst on trn.M_DST_PFOLIO = pfldst.M_REF
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join TRN_PLIN_DBF pli on rtrim(trn.M_INSTRUMENT) = rtrim(pli.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE

where 1 = 1
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
and trn.M_TRN_STATUS <> 'DEAD'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') >= '2024-05-27'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') <= '2024-11-26'