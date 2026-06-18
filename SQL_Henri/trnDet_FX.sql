select 
to_char(pc.M_DATE,'YYYYMMDD') REPDAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
rtrim(src.M_LABEL) SRC,
cnt.M_REFERENCE CNT,
trn.M_NB TRN, 
rtrim(trn.M_GID) GID,
-- cnt.M_PACK_REF PCK,
trn.M_TRN_GTYPE GTYP, trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
rtrim(typo.M_LABEL) TYPO,
-- rtrim(trn.M_INSTRUMENT) INS,
rtrim(plin.M_DSP_LABEL) PLIN,
-- trn.M_PL_INSCUR CUR,
coalesce(fxs.M_XPLCUR, fxo.M_XPLCUR) PLCUR,
rtrim(typo.M_LABEL) TYPO,
trn.M_BRW_NOMU1 UND, trn.M_BRW_NOMU2 BASE,
fxs.M_XPTCUR TRN_STLCUR,
fxc.M_SETTL_CUR CFG_STLCUR,
case fxo.M_XPOPTDELIV
when 0 then 'Cash'
when 1 then 'Delivery'
when 2 then 'Early CSH'
when 3 then 'Early DLV' else null end EXR,
case fxs.M_XPFWSETT
when 0 then 'Cash'
when 1 then 'Delivery' else null end DLV,
fxs.M_XPFWGROUP FIXPUB,
fxs.M_XPFWCOL FIXHSR,
to_char(fxs.M_XPFWEXP,'YYYY-MM-DD') FIXDAT,
to_char(fxs.M_XPFWDEL,'YYYY-MM-DD') DLVDAT,
(fxs.M_XPFWDEL-fxs.M_XPFWEXP) DIFF,
to_char(trn.M_BRW_SDTE,'YYYY-MM-DD') STLDAT,
case trn.M_TRN_GTYPE
when 77 then fxs.M_XPFWMPRC
when 84 then fxo.M_XPOPTFPRIC else null end STK,

case trn.M_TRN_GTYPE
when 77 then fxs.M_XPQTY
when 84 then fxo.M_XPQTY else null end NOMU,
case trn.M_TRN_GTYPE
when 77 then fxs.M_XPOQTY
when 84 then fxo.M_XPOQTY else null end NOMB

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join FD111000_DBF fxo on trn.M_NB = fxo.M_NB
left join FD111200_DBF fxs on trn.M_NB = fxs.M_NB
left join FX_CNT_DBF fxc on rtrim(plin.M_DSP_LABEL) = rtrim(fxc.M_LABEL)

where 
-- cnt.M_TYPOLOGY in (1263,1264)
-- and cnt.M_SRC_MODULE in (1005)
-- and rtrim(plin.M_DSP_LABEL) = 'USD/COP'
-- and to_char(M_TRN_EXP,'YYYYMMDD') > '20180301'
-- and trn.M_TRN_STATUS <> 'DEAD'
-- and fxd.M_XPTCUR <> fxc.M_SETTL_CUR
trn.M_NB in 
(
61363460
)

order by STLDAT, trn.M_NB 
