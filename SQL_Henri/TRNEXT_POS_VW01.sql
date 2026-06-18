drop view TRNEXT_POS_VW01;

create view TRNEXT_POS_VW01  
(
PCDAT,
TRN_IE,
CTP_IE,
LE, 
CE,
PFL, 
CTP,
LO, 
ASS, 
FML,
GRP,
TYP, 
TYPO,
INS, 
PHY, 
IND1, 
QOT1, 
PUB1,
UND1, 
HSR1,
IND2, 
QOT2, 
PUB2,
UND2, 
HSR2,
CUR, 
UOM,
UOD, 
MAT, 
FUTMAT, 
OPTMAT,
CFST1, 
CLST1, 
CFST2, 
CLST2,
STL, 
EXP,
STK, 
RGT,
PRC1, 
MRG1,
PRC2, 
MRG2,
-- DIR, 
-- LOTSIZ,
NOM1, 
NOM2, 
-- QTY,
OCC
)

as 

( 
select
-- Dates
to_char(pc.M_DATE,'YYYYMMDD') PCDAT,
/*
to_char(trn.M_TRN_DATE,'YYYYMMDD') TRNDAT,
-- Identifiers
rtrim(src.M_LABEL) SRC,
trn.M_NB TRN,
cnt.M_REFERENCE CNT,
cnt.M_VERSION CVS,
cnt.M_PACK_REF PCK,
trn.M_TRN_GID GID,
*/
-- Parties
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case when trn.M_BINTERNAL ='Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
/*
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
*/
-- Product
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
rtrim(trn.M_TRN_FMLY) FML,
rtrim(trn.M_TRN_GRP) GRP,
rtrim(trn.M_TRN_TYPE) TYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(phy.M_LABEL) PHY,
---- Index 1
rtrim(coalesce(ind1.M_IND_LAB,fxs.M_XPFWGROUP)) IND1,
case 
when rtrim(trn.M_TRN_FMLY) = 'COM' then rtrim(qot1.M_LABEL)
when trn.M_TRN_GTYPE in (77,92) then rtrim(fxs.M_XPFWPRCQ)
when trn.M_TRN_GTYPE in (84) then rtrim(fxo.M_XPOPTFPQ) else null end QOT1,
rtrim(pub1.M_LABEL) PUB1,
rtrim(coalesce(cmu1.M_LABEL,fund.M_LABEL)) UND1,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(coalesce(ghsr1.M_LABEL,lhsr.M_LABEL))
when 'CURR' then rtrim(fxs.M_XPFWCOL) else null end HSR1,
---- Index 2
rtrim(ind2.M_IND_LAB) IND2,
rtrim(qot2.M_LABEL) QOT2,
rtrim(pub2.M_LABEL) PUB2,
rtrim(cmu2.M_LABEL) UND2,
rtrim(ghsr2.M_LABEL) HSR2,
-- Quote
case when trn.M_TRN_FMLY = 'COM' then qot1.M_CURR else trn.M_BRW_NOMU1 end CUR,
case when trn.M_TRN_FMLY = 'COM' then rtrim(unq.M_LABEL) else trn.M_BRW_NOMU2 end UOM,
case when trn.M_TRN_GTYPE in (84) then 
case fxo.M_XPINPON 
when 0 then trn.M_BRW_NOMU1 
when 1 then trn.M_BRW_NOMU2 end
else null end UOD,
-- Tenor
case when trn.M_TRN_FMLY = 'COM' then 
case when (trn.M_TRN_GTYPE in (100,101,102,103) and rtrim(pub1.M_LABEL) = 'LME') then 
case when trn.M_BRW_ODPL = '04-FEB-21' then 'CASH' else
case when trn.M_BRW_ODPL = '03-MAY-21' then '3M' else
case when to_date(trn.M_BRW_ODPL) = next_day(trunc(to_date(trn.M_BRW_ODPL,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(trn.M_BRW_ODPL,4,6)) 
else rtrim(trn.M_BRW_ODPL) end end end
else rtrim(trn.M_BRW_ODPL) end
else null end MAT,
rtrim(futmat.M_LABEL) FUTMAT, 
rtrim(optmat.M_LABEL) OPTMAT,
---- CFST1
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_FST,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWFST,'YYYYMMDD') end CFST1,
---- CLST1
case 
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_LST,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_MATURITY0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWLST,'YYYYMMDD') end CLST1,
---- CFST2
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(loan.M_START_DAT1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT1,'YYYYMMDD')
else null end CFST2,
---- CLST2
case 
when trn.M_TRN_GTYPE in (130,154) then to_char(loan.M_MATURITY1-1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (100,101,102,103,113,134) then to_char(loan.M_MATURITY1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2) then to_char(loan.M_MATURITY1,'YYYYMMDD')
else null end CLST2,
---- STL, EXP
case when trn.M_TRN_GTYPE in (84) then to_char(trn.M_OPT_FLWFST,'YYYYMMDD') else to_char(trn.M_BRW_SDTE,'YYYYMMDD') end STL,
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP,
-- Option
trn.M_BRW_STRK STK,
rtrim(trn.M_BRW_CP) RGT,
-- Price
sum(
(case 
when trn.M_TRN_GTYPE in (77)  then fxs.M_XPFWPRC 
when trn.M_TRN_GTYPE in (100) then hb1.M_P12
when trn.M_TRN_GTYPE in (102) then hb2.M_P12
else trn.M_BRW_RTE1 end) * trn.M_BRW_NOM1) / sum(trn.M_BRW_NOM1) PRC1, 
sum(trn.M_BRW_MRG1) MRG1,
round(sum(trn.M_BRW_RTE2 * trn.M_BRW_NOM2) / sum(trn.M_BRW_NOM1),4) PRC2,
sum(trn.M_BRW_MRG2) MRG2,
-- Option: weighted average price --
-- round(sum(trn.M_BRW_RTE1*trn.M_BRW_NOM1)/sum(trn.M_BRW_NOM1),4),
-- round(sum(trn.M_BRW_RTE2*trn.M_BRW_NOM1)/sum(trn.M_BRW_NOM1),4),
/*
-- Direction
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn.M_COMMENT_BS) end,
*/
-- NOM1
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
-- NOM2
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
/*
-- Quantity
ABS(trn.M_BRW_NOM1)*coalesce(fut.M_QTY,1),
loan.M_REF_CAP0,
dlv.M_TOT_QTY,
*/
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_PFLD_DBF bpf on trn.M_BPFOLIO = bpf.M_LABEL
left join TRN_PFLD_DBF spf on trn.M_SPFOLIO = spf.M_LABEL
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join CMT_DLV_DBF dlv on (trn.M_NB = dlv.M_NB and dlv.M_LEG_NB = 0)
left join CM_ASSET_DBF ass on plkey.M_ASSET = ass.M_REFERENCE
left join CM_FUT_DBF fut on plkey.M_FUTURE = fut.M_REFERENCE
left join CM_FMAT1_DBF futmat on plkey.M_FUT_MAT = futmat.M_REFERENCE
left join CM_FMAT1_DBF futmatlme on (rtrim(futmat.M_LABEL) = rtrim(futmatlme.M_LABEL) and futmatlme.M_FMAT_ID = 118)
left join CM_OMAT1_DBF optmat on plkey.M_OPT_MAT = optmat.M_REFERENCE
left join RT_INDEX_DBF ind1 on plkey.M_INDEX = ind1.M_INDEX
left join CM_INDEX_DBF cmi1 on ind1.M_COM_IND = cmi1.M_REFERENCE
left join CMC_QUOT_DBF qot1 on plkey.M_QUOT = qot1.M_REFERENCE
left join CM_MKT_DBF pub1 on qot1.M_PUBLI= pub1.M_REFERENCE
left join CM_INDEX_DBF cmu1 on plkey.M_UNDL = cmu1.M_REFERENCE
left join RT_INDEX_DBF ind2 on trim(substr(trn.M_MKT_INDEX,18,15)) = trim(ind2.M_INDEX)
left join CM_INDEX_DBF cmi2 on ind2.M_COM_IND = cmi2.M_REFERENCE
left join CMC_QUOT_DBF qot2 on ind2.M_COM_QUOT = qot2.M_REFERENCE
left join CM_MKT_DBF pub2 on qot2.M_PUBLI= pub2.M_REFERENCE
left join RT_INDEX_DBF und2 on rtrim(ind2.M_UNDRL) = rtrim(und2.M_INDEX)
left join CM_INDEX_DBF cmu2 on und2.M_COM_IND = cmu2.M_REFERENCE
left join CM_UNIT_DBF unq on qot1.M_UNIT = unq.M_REFERENCE
left join CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE
left join RT_INDEX_DBF find on mgen.M_INDEX = find.M_INDEX
left join CM_INDEX_DBF fund on find.M_COM_IND = fund.M_REFERENCE
left join RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot1.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15)))
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join CM_MKTSR_DBF ghsr1 on trim(substr(gen.M_FORMULA0,2,10)) = to_char(ghsr1.M_SERIE)
left join CM_MKTSR_DBF ghsr2 on trim(substr(gen.M_FORMULA1,2,10)) = to_char(ghsr2.M_SERIE)
left join CM_MKTSR_DBF lhsr on trim(substr(loan.M_GEN_FRM,2,10)) = to_char(lhsr.M_SERIE)
left join CM_PHYS_DBF phy on dlv.M_PHYSICAL = phy.M_REFERENCE
left join FD111200_DBF fxs on trn.M_NB = fxs.M_NB
left join FD111000_DBF fxo on trn.M_NB = fxo.M_NB 
-- Adapt historical table name and future reference
left join H047308_H1S hh1 on (futmat.M_REFERENCE = hh1.M_KEY0 and fut.M_REFERENCE = 74)
left join B047308_HBS hb1 on (hh1.M_KEYID = hb1.M_KEYID and pc.M_DATE-1 = hb1.M_DATE)
left join H047310_H1S hh2 on (futmat.M_REFERENCE = hh2.M_KEY0 and fut.M_REFERENCE = 56)
left join B047310_HBS hb2 on (hh2.M_KEYID = hb2.M_KEYID and pc.M_DATE-1 = hb1.M_DATE)
left join H047310_H1S hh3 on (futmatlme.M_REFERENCE = hh2.M_KEY0)
left join B047310_HBS hb3 on (hh2.M_KEYID = hb2.M_KEYID and pc.M_DATE-1 = hb2.M_DATE)

where
-- coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
-- and trn.M_BINTERNAL <> trn.M_SINTERNAL 
-- and coalesce(ctyp.M_REF,0) = 0
trn.M_TRN_STATUS <> 'DEAD'
and trn.M_TRN_EXP > pc.M_DATE
and 
(
trn.M_BPFOLIO IN 
(
'MCEX BWR PTEI', 'RMOP BWR PTEI'
)
OR
trn.M_SPFOLIO IN 
(
'MCEX BWR PTEI', 'RMOP BWR PTEI'
)
)
group by

pc.M_DATE,
null,
RAGENISH.BABUcase when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end,
case when ctyp.M_REF = 16 then 'I' else 'E' end,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end,
case when trn.M_BINTERNAL ='Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end),
rtrim(trn.M_TRN_FMLY),rtrim(trn.M_TRN_GRP),rtrim(trn.M_TRN_TYPE),
rtrim(typo.M_LABEL),
rtrim(plin.M_DSP_LABEL),
rtrim(phy.M_LABEL),
rtrim(coalesce(ind1.M_IND_LAB,fxs.M_XPFWGROUP)),
case 
when rtrim(trn.M_TRN_FMLY) = 'COM' then rtrim(qot1.M_LABEL)
when trn.M_TRN_GTYPE in (77,92) then rtrim(fxs.M_XPFWPRCQ)
when trn.M_TRN_GTYPE in (84) then rtrim(fxo.M_XPOPTFPQ) else null end,
rtrim(pub1.M_LABEL),
rtrim(coalesce(cmu1.M_LABEL,fund.M_LABEL)),
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(coalesce(ghsr1.M_LABEL,lhsr.M_LABEL))
when 'CURR' then rtrim(fxs.M_XPFWCOL) else null end,
rtrim(ind2.M_IND_LAB),
rtrim(qot2.M_LABEL),
rtrim(pub2.M_LABEL),
rtrim(cmu2.M_LABEL),
rtrim(ghsr2.M_LABEL),
case when trn.M_TRN_FMLY = 'COM' then qot1.M_CURR else trn.M_BRW_NOMU1 end,
case when trn.M_TRN_FMLY = 'COM' then rtrim(unq.M_LABEL) else trn.M_BRW_NOMU2 end,
case when trn.M_TRN_GTYPE in (84) then 
case fxo.M_XPINPON 
when 0 then trn.M_BRW_NOMU1 
when 1 then trn.M_BRW_NOMU2 end
else null end,
case when trn.M_TRN_FMLY = 'COM' then 
case when (trn.M_TRN_GTYPE in (100,101,102,103) and rtrim(pub1.M_LABEL) = 'LME') then 
case when trn.M_BRW_ODPL = '04-FEB-21' then 'CASH' else
case when trn.M_BRW_ODPL = '03-MAY-21' then '3M' else
case when to_date(trn.M_BRW_ODPL) = next_day(trunc(to_date(trn.M_BRW_ODPL,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(trn.M_BRW_ODPL,4,6)) 
else rtrim(trn.M_BRW_ODPL) end end end
else rtrim(trn.M_BRW_ODPL) end
else null end,
futmat.M_LABEL, 
optmat.M_LABEL,
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_FST,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWFST,'YYYYMMDD') end,
case 
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_LST,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_MATURITY0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWLST,'YYYYMMDD') end,
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134,146,154) then to_char(loan.M_START_DAT1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT1,'YYYYMMDD')
else null end,
case 
when trn.M_TRN_GTYPE in (130,154) then to_char(loan.M_MATURITY1-1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (100,101,102,103,113,134) then to_char(loan.M_MATURITY1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2) then to_char(loan.M_MATURITY1,'YYYYMMDD')
else null end,
case when trn.M_TRN_GTYPE in (84) then to_char(trn.M_OPT_FLWFST,'YYYYMMDD') else to_char(trn.M_BRW_SDTE,'YYYYMMDD') end,
trn.M_TRN_EXP,
trn.M_BRW_STRK,
trn.M_BRW_CP

);


