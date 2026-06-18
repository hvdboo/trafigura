select
rownum SEQ,
SYSDAT,
TRN_IE,
CTP_IE,
-- SRC,
LE,
CE,
PFL,
CTP,
FML, GRP, TYP,
ASS,
LO,
-- FGT,
-- FGTLAB,
TYPO,
INS,
/*
FUTID, QOTID, MATSET,
PUBID, PUB,
HSRID, HSR,
CUR, UOM, LOTSIZ,
*/
EXP, 
MAT,
STK,
CP,
-- case when NOM1 > 0 then 'B' when NOM1 < 0 then 'S' else 'X' end  BS,
NOM1,
NOM2,
ABS(NOM1)*LOTSIZ QTY,
-- round(PRC1,6) PRC1,
-- round(PRC2,6) PRC2, 
-- TRN,
OCC

from 

(
select 
to_char(pc.M_DATE,'YYYYMMDD') SYSDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else (case when ctyp.M_REF = 16 then 'I' else 'E' end) end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
-- rtrim(src.M_LABEL) SRC,
/*
trn.M_NB TRN,
cnt.M_REFERENCE CNT,
cnt.M_VERSION CVS,
cnt.M_PACK_REF PCK,
*/
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end) CE,
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end) PFL,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then (case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_SPFOLIO) else rtrim(trn.M_BPFOLIO) end)
else rtrim(ctp.M_DSP_LABEL) end CTP,
trn.M_TRN_GTYPE FGT,
trn.M_TRN_FMLY FML, trn.M_TRN_GRP GRP, trn.M_TRN_TYPE TYP,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO, 
/*
case trn.M_TRN_GTYPE
when   1 then 'IR Swap'
when   2 then 'IR CurSwap'
when   5 then 'IR Swaption'
when  47 then 'Equity futures'
when  49 then 'IR Short Fut'
when  76 then 'FX Future'
when  77 then 'FX Spot'
when  84 then 'FX Opt.Smp'
when  90 then 'Simple Cash'
when  92 then 'Forex-Swap'
when 100 then 'CM Future'
when 101 then 'CM Opt.Fut LST'
when 102 then 'CM Forward'
when 103 then 'CM Opt.Fwd'
when 113 then 'CM Opt.Smp'
when 130 then 'CM Swap'
when 131 then 'CM Asian'
when 134 then 'CM Spot'
when 136 then 'CM Clr.Swap'
when 146 then 'CM Clr.Asian'
when 154 then 'CM Physical' else null end FGTLAB,
*/
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INS,
fut.M_REFERENCE FUTID, rtrim(fut.M_LABEL) FUT,
qotf.M_REFERENCE QOTID, rtrim(qotf.M_LABEL) QOT,
fut.M_QTY LOTSIZ, fut.M_FUT_MAT MATSET,
pub.M_REFERENCE PUBID, rtrim(pub.M_LABEL) PUB,
hsr.M_SERIE HSRID, rtrim(hsr.M_LABEL) HSR,
rtrim(grp.M_HISFILE) HIS,
(case when trn.M_TRN_FMLY='COM' then qotf.M_CURR else trn.M_BRW_NOMU1 end) CUR,
(case when trn.M_TRN_FMLY='COM' then rtrim(uniq.M_LABEL) else trn.M_BRW_NOMU2 end) UOM,
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP,
(case trn.M_TRN_FMLY when 'COM' then rtrim(trn.M_BRW_ODPL) else null end) MAT,
coalesce(trn.M_BRW_STRK,0) STK,
rtrim(trn.M_BRW_CP) CP,
-- rtrim(trn.M_COMMENT_BS) BS,
-- trn.M_NB TRN,

sum( 
(case 
when trn.M_TRN_GTYPE in (1, 2, 130, 134, 154) then
        case 
        when trn.M_BRW_FV1='V' and M_BRW_PR1 = 'R' then 1 
        when trn.M_BRW_FV1='F' and M_BRW_PR1 = 'P' then 1 else -1 
        end
when trn.M_TRN_GTYPE in (90) then case when M_BRW_PR1 = 'R' then 1 else -1 end
else case when trn.M_COMMENT_BS = 'B' then 1 else -1 end 
end) * trn.M_BRW_NOM1) NOM1,
sum(
(case 
when trn.M_TRN_GTYPE in (1, 2, 130, 134, 154) then
        case 
        when trn.M_BRW_FV1='V' and M_BRW_PR1 = 'R' then 1 
        when trn.M_BRW_FV1='F' and M_BRW_PR1 = 'P' then 1 else -1 
        end
when trn.M_TRN_GTYPE in (90) then case when M_BRW_PR1 = 'R' then 1 else -1 end
else case when trn.M_COMMENT_BS = 'B' then 1 else -1 end 
end) * trn.M_BRW_NOM2) NOM2,
-- sum(trn.M_BRW_RTE1*trn.M_BRW_NOM1)/sum(trn.M_BRW_NOM1) PRC1,
-- sum(trn.M_BRW_RTE2*trn.M_BRW_NOM1)/sum(trn.M_BRW_NOM1) PRC2, 
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join HDREXT_VW_DBF ext on trn.M_NB = ext.M_TNB
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join CM_ASSET_DBF ass on plkey.M_ASSET = ass.M_REFERENCE
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join CM_FUT_DBF fut on rtrim(plin.M_DSP_LABEL) = rtrim(fut.M_LABEL)
left join CMC_QUOT_DBF qotf on fut.M_QUOT_FWD = qotf.M_REFERENCE
left join CM_MKT_DBF pub on qotf.M_PUBLI= pub.M_REFERENCE
left join CM_UNIT_DBF uniq on qotf.M_UNIT = uniq.M_REFERENCE
left join RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qotf.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15)))
left join RT_LOAN_DBF loan on (trn.M_NB = loan.M_NB and trn.M_TRN_GTYPE = 154)
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join CM_MKTSR_DBF hsr on trim(substr(gen.M_FORMULA1,2,10)) = to_char(hsr.M_SERIE)

where 
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) = 'TDL' 
-- and trn.M_BINTERNAL <> trn.M_SINTERNAL
-- and coalesce(ctyp.M_REF,0) = 0
-- and ((trn.M_BINTERNAL = trn.M_SINTERNAL) or (coalesce(ctyp.M_REF,0) = 16))
and trn.M_TRN_GTYPE not in (146)
-- and rtrim(grp.M_HISFILE) not in (047044, 135880, 150284, 409272, 409830, 410035, 409282, 509786)
-- and trn.M_TRN_GTYPE <> 2
-- and src.M_LABEL = 'TRT'
and trn.M_TRN_STATUS <> 'DEAD'
-- and rtrim(ctp.M_DSP_LABEL) = ?

group by 
pc.M_DATE,
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end), 
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else (case when ctyp.M_REF = 16 then 'I' else 'E' end) end,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
-- src.M_LABEL,
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end),
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end),
(case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then (case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_SPFOLIO) else rtrim(trn.M_BPFOLIO) end)
else rtrim(ctp.M_DSP_LABEL) end),
trn.M_TRN_GTYPE, trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end),
typo.M_LABEL,
plin.M_DSP_LABEL,
fut.M_REFERENCE, fut.M_LABEL,
qotf.M_REFERENCE, qotf.M_LABEL,
fut.M_QTY, fut.M_FUT_MAT,
pub.M_REFERENCE, pub.M_LABEL,
hsr.M_SERIE, hsr.M_LABEL,
grp.M_HISFILE,
(case when trn.M_TRN_FMLY='COM' then qotf.M_CURR else trn.M_BRW_NOMU1 end),
(case when trn.M_TRN_FMLY='COM' then rtrim(uniq.M_LABEL) else trn.M_BRW_NOMU2 end),
trn.M_TRN_EXP, 
(case trn.M_TRN_FMLY when 'COM' then rtrim(trn.M_BRW_ODPL) else null end),
trn.M_BRW_STRK, trn.M_BRW_CP
-- ,trn.M_NB
order by PFL, CTP_IE, CTP, ASS, LO, TYPO, INS, EXP
)
where NOM1 <> 0

