select 
to_char(M_TRN_DATE,'YYYYMMDD') TRNDAT,
cnt.M_REFERENCE CNT,
trn.M_NB TRN, 
-- cnt.M_PACK_REF PCK,
rtrim(src.M_LABEL) SRC, rtrim(typo.M_LABEL) TYPO,
-- trn.M_INSTRUMENT, 
rtrim(plin.M_DSP_LABEL) INS, 
fxd.M_XPLCUR PLCUR,
trn.M_BRW_NOMU1 UND, trn.M_BRW_NOMU2 BASE,
fxd.M_XPTCUR TRN_STLCUR,
fxc.M_SETTL_CUR CFG_STLCUR,
fxd.M_XPFWGROUP FIXPUB,
fxd.M_XPFWCOL FIXHSR,
to_char(trn.M_BRW_SDTE,'YYYY-MM-DD') STLDAT,
trn.M_TRN_STATUS STATUS

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join FD111200_DBF fxd on trn.M_NB = fxd.M_NB
left join FX_CNT_DBF fxc on rtrim(plin.M_DSP_LABEL) = rtrim(fxc.M_LABEL)

where 
cnt.M_TYPOLOGY in (1263,1264)
and cnt.M_SRC_MODULE in (1005)
-- and rtrim(plin.M_DSP_LABEL) = 'USD/PEN'
and to_char(M_TRN_DATE,'YYYYMMDD') > '20171218'
and trn.M_TRN_STATUS <> 'DEAD'
and fxd.M_XPTCUR <> fxc.M_SETTL_CUR

order by STLDAT, trn.M_NB
