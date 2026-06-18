select 
to_char(pc.M_DATE,'YYYYMMDD') REPDAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
rtrim(src.M_LABEL) SRC,
cnt.M_REFERENCE CNT,
trn.M_NB TRN, 
-- cnt.M_PACK_REF PCK,
trn.M_TRN_GTYPE GTYP, trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
rtrim(typo.M_LABEL) TYPO,
-- rtrim(trn.M_INSTRUMENT) INS,
rtrim(plin.M_DSP_LABEL) PLIN,
-- trn.M_PL_INSCUR CUR,
fxd.M_XPLCUR PLCUR,
rtrim(typo.M_LABEL) TYPO,
trn.M_BRW_NOMU1 UND, trn.M_BRW_NOMU2 BASE,
fxd.M_XPTCUR TRN_STLCUR,
fxc.M_SETTL_CUR CFG_STLCUR,
fxd.M_XPFWGROUP FIXPUB,
fxd.M_XPFWCOL FIXHSR,
to_char(fxd.M_XPFWEXP,'YYYY-MM-DD') FIXDAT,
to_char(fxd.M_XPFWDEL,'YYYY-MM-DD') DLVDAT,
(fxd.M_XPFWDEL-fxd.M_XPFWEXP) DIFF,
to_char(trn.M_BRW_SDTE,'YYYY-MM-DD') STLDAT

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join FD111200_DBF fxd on trn.M_NB = fxd.M_NB
left join FX_CNT_DBF fxc on rtrim(plin.M_DSP_LABEL) = rtrim(fxc.M_LABEL)

where 
cnt.M_TYPOLOGY in (1263,1264)
-- and cnt.M_SRC_MODULE in (1005)
-- and rtrim(plin.M_DSP_LABEL) = 'USD/COP'
-- and to_char(M_TRN_EXP,'YYYYMMDD') > '20180301'
-- and trn.M_TRN_STATUS <> 'DEAD'
-- and fxd.M_XPTCUR <> fxc.M_SETTL_CUR
-- trn.M_NB in (12830033)

order by STLDAT, trn.M_NB 
