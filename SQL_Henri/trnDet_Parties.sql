drop view MUREX_MX_OWNER.TRDSTG;
create view MUREX_MX_OWNER.TRDSTG
(
SYSENV,
SYSDAT,
TRD,
CNT, 
CVS, 
PCK,
GID,
TYPO,
PLIN,
PHY,
TRN_IE,
CTP_IE,
DIR,
LE,
CE,
PFL,
CTP,
GRCSRC,
DIVSRC,
STRSRC,
CATSRC,
PFLSRC,
STGSRC,
GRCDST,
DIVDST,
STRDST,
CATDST,
PFLDST,
STGDST
)

as

(
select 
-- 'DEV07' SYSENV,
to_char(pc.M_DATE,'YYYYMMDD') SYSDAT,
trn.M_NB TRD,
trn.M_CONTRACT CNT, 
cnt.M_VERSION  VSN, 
cnt.M_PACK_REF PCK,
trn.M_GID GID,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) PLIN,
rtrim(phy.M_LABEL) PHY,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn.M_COMMENT_BS) end DIR,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,

case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
-- case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
case when trn.M_COMMENT_BS ='B' 
then case when trn.M_BINTERNAL = trn.M_SINTERNAL then rtrim(trn.M_SPFOLIO) else rtrim(ctp.M_DSP_LABEL) end
else case when trn.M_BINTERNAL = trn.M_SINTERNAL then rtrim(trn.M_BPFOLIO) else rtrim(ctp.M_DSP_LABEL) end end CTP,
-- SRC
rtrim(ctosrc.M_DSP_LABEL) GRCSRC,
rtrim(udfsrc.M_DIVISION) DIVSRC,
rtrim(udfsrc.M_STREAM_C)  STRSRC,
rtrim(udfsrc.M_PTFCAT) CATSRC,
rtrim(pflsrc.M_LABEL) PFLSRC,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BSTRATEGY) else rtrim(trn.M_SSTRATEGY) end STGSRC,
-- DST
rtrim(ctodst.M_DSP_LABEL) GRCDST,
rtrim(udfdst.M_DIVISION) DIVDST,
rtrim(udfdst.M_STREAM_C)  STRDST,
rtrim(udfdst.M_PTFCAT) CATDST,
rtrim(pfldst.M_LABEL) PFLDST,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_SSTRATEGY) else rtrim(trn.M_BSTRATEGY) end STGDST

from MUREX_MX_OWNER.TRN_HDR_DBF trn
left join MUREX_MX_OWNER.TRN_PC_DBF pc on 1 = 1
left join MUREX_MX_OWNER.CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join MUREX_MX_OWNER.SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE 
left join MUREX_MX_OWNER.TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join MUREX_MX_OWNER.TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join MUREX_MX_OWNER.CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join MUREX_MX_OWNER.CM_PHYS_DBF phy on plk.M_PRODUCT = phy.M_REFERENCE
left join MUREX_MX_OWNER.TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join MUREX_MX_OWNER.TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join MUREX_MX_OWNER.TRN_PFLD_DBF pflsrc on trn.M_SRC_PFOLIO = pflsrc.M_REF
left join MUREX_MX_OWNER.TRN_CPDF_DBF ctosrc on pflsrc.M_PROC_AREA = ctosrc.M_ID
left join MUREX_MX_OWNER.TABLE#DATA#PORTFOLI_DBF udfsrc on rtrim(pflsrc.M_LABEL) = rtrim(udfsrc.M_LABEL)
left join MUREX_MX_OWNER.TRN_PFLD_DBF pfldst on trn.M_DST_PFOLIO = pfldst.M_REF
left join MUREX_MX_OWNER.TRN_CPDF_DBF ctodst on pflsrc.M_PROC_AREA = ctodst.M_ID
left join MUREX_MX_OWNER.TABLE#DATA#PORTFOLI_DBF udfdst on rtrim(pfldst.M_LABEL) = rtrim(udfdst.M_LABEL)
left join MUREX_MX_OWNER.TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join MUREX_MX_OWNER.CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)

where 1 = 1 
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
and (rtrim(trn.M_BSTRATEGY) = 'FOREX' or rtrim(trn.M_SSTRATEGY) = 'FOREX')
)

