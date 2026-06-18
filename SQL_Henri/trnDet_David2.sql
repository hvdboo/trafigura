select 
trn.M_NB        TRN,
trn.M_CONTRACT  CNT, 
cnt.M_VERSION   VSN, 
rtrim(trn.M_TRN_STATUS) TRNSTAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
rtrim(pflsrc.M_LAB) PFLSRC,
rtrim(pfldst.M_LAB) PFLDST,
rtrim(ctp.M_LABDSP) CTP,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
pli.M_FINASS FINASS,
pli.M_COMATP COMATP,
pli.M_COMASS COMASS,
rtrim(trn.M_TRN_GTYPE) FGT,
rtrim(trn.M_TRN_FMLY)  FML, 
rtrim(trn.M_TRN_GRP)   GRP, 
rtrim(trn.M_TRN_TYPE)  TYP,
rtrim(typo.M_LABEL)    TYPO,
rtrim(pli.M_BDYLAB)    PLI

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join VIW_PFL_DBF pflsrc on trn.M_SRC_PFOLIO = pflsrc.M_ID
left join VIW_PFL_DBF pfldst on trn.M_DST_PFOLIO = pfldst.M_ID
left join VIW_CTP_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join VIW_PLI_DBF pli on trn.M_INSTRUMENT = pli.M_PLIREF

where 1 = 1
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
and trn.M_TRN_STATUS <> 'DEAD'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') >= '2024-05-27'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') <= '2024-11-26'