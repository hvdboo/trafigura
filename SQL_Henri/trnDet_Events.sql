select 
trn.M_NB        TRN, 
cnt.M_REFERENCE CNT,
cnt.M_VERSION   CVS,
cnt.M_PACK_REF  PCK,
trn.M_GID       GID,
rtrim(substr(cla.M_NAME,26,30)) PRP,
rtrim(src.M_LABEL) SRC,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
rtrim(trn.M_TRN_GTYPE)  GTYP,
rtrim(trn.M_TRN_FMLY)   FML,
rtrim(trn.M_TRN_GRP)    GRP, 
rtrim(trn.M_TRN_TYPE)   TYP,
rtrim(typo.M_LABEL)     TYPO,
rtrim(plin.M_DSP_LABEL) PL_INS,
to_char(pc.M_DATE,'YYYY-MM-DD') REPDAT,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
to_char(trn.M_SYS_DATE,'YYYY-MM-DD') SYSDAT,
to_char(floor(trn.M_TRN_TIME/3600),'FM09')||':'||to_char(floor(mod(trn.M_TRN_TIME,3600)/60),'FM09')||':'||to_char(mod(mod(trn.M_TRN_TIME,3600),60),'FM09') SYSTIM,
trn.M__DT_TS SYSTMS,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
to_char(trn.M_OPT_FLWFST,'YYYY-MM-DD') FLWFST,
to_char(trn.M_OPT_FLWLST,'YYYY-MM-DD') FLWLST,
to_char(trn.M_OPT_ACCLST,'YYYY-MM-DD') ACCLST,
rtrim(trn.M_TRN_STATUS) TRNSTAT,
rtrim(cnt.M_STP_STATUS) CNTSTAT,
/*
case trn.M_OPT_NATURE
when  0 then ''
when  2 then ''
when  4 then ''
when  6 then ''
when  8 then ''
when 10 then ''
when 12 then ''
when 14 then ''
when 32 then ''
when 34 then ''
when 36 then ''
when 40 then ''
when 42 then ''
else null end OPTNAT,
*/
trn.M_CREATOR TRNCREA,
cnt.M_ROOT_REF CNTROOT,
cnt.M_ORIG_REF CNTORI,
-- GXIT (Global termination)
trn.M_CAN_GXIT XIT,
to_char(trn.M_GXIT_DATE,'YYYY-MM-DD') XITDAT,
-- RPL (Restructure)
to_char(trn.M_MRPL_DATE,'YYYY-MM-DD') RSTDAT,
trn.M_MRPL_ONB RSTTRN,
-- MOP (Event)
trn.M_OPT_MOPCNT MOPOCC,
to_char(trn.M_OPT_MOPFST,'YYYY-MM-DD') MOPFST,
to_char(trn.M_OPT_MOPLST,'YYYY-MM-DD') MOPLST,
trn.M_MOP_LAST MOPLSTNUM,
rtrim(mop.M_EVT_CODE)   MOPLSTCOD,
rtrim(mop.M_EVT_DLABEL) MOPLSTLAB,
-- trn.M_OPT_MOPNB MOPLSTEVT,
rtrim(evttyp.M_EVT_DLABEL) EVTTYP,
rtrim(substr(evtcla.M_NAME,17,30)) EVTCLA,
rtrim(evtsrc.M_LABEL) EVTSRC,
evt.M_REFERENCE EVT,
ext.M_REFERENCE TRNEXT,
trn.M_LEXTREF,
trn.M_LEVTEXTREF,
trn.M_OPT_STSVER

from TRN_HDR_DBF trn
left join MUREX_MX_OWNER.TRN_PC_DBF pc on 1 = 1
left join MUREX_MX_OWNER.CLASS_MAPPING_DBF cla on trn.M_PURPOSE = cla.M_ID
left join MUREX_MX_OWNER.CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join MUREX_MX_OWNER.SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join MUREX_MX_OWNER.TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join MUREX_MX_OWNER.FOP_DESC_DBF fop on cnt.M_FOP_DESC = fop.M_REFERENCE
left join MUREX_MX_OWNER.TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join MUREX_MX_OWNER.TRN_EXT_DBF ext on trn.M_NB = ext.M_TRADE_REF and cnt.M_VERSION = ext.M_VERSION
left join MUREX_MX_OWNER.EVT_MAP_DBF mop on trn.M_MOP_LAST = mop.M_EVT_ID
left join MUREX_MX_OWNER.EVT_IMP_DBF evtimp on trn.M_OPT_MOPNB = evtimp.M_REFERENCE
left join MUREX_MX_OWNER.EVT_MAP_DBF evttyp on evtimp.M_TYPE = evttyp.M_EVT_ID
-- left join MUREX_MX_OWNER.EVT_EVENT_DBF evt on evtimp.M_EVT = evt.M_REFERENCE
left join MUREX_MX_OWNER.EVT_EVENT_DBF evt on ext.M_EVT_REF = evt.M_REFERENCE
left join CLASS_MAPPING_DBF evtcla on evt.M__INTID_ = evtcla.M_ID
left join MUREX_MX_OWNER.SRC_MOD_DBF evtsrc on evt.M_SRC_MODULE = evtsrc.M_REFERENCE

where 1 = 1
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') > '2021-07-11'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') <  '2021-08-29'
and trn.M_MOP_LAST = 6
and trn.M_TRN_DATE+3 < trn.M_OPT_MOPLST
--and M_NB = 20459037
and M_NB = 20719548