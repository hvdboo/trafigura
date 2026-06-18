select
-- Dates
to_char(pc.M_DATE,'YYYYMMDD') PCDAT,
to_char(trn.M_TRN_DATE,'YYYYMMDD') TRNDAT,
-- Identifiers
cnt.M_REFERENCE CNT,
cnt.M_VERSION CVS,
cnt.M_PACK_REF PCK,
rtrim(typo.M_LABEL) TYPO,
rtrim(src.M_LABEL) SRC,
rtrim(trn.M_GID) GID,
-- Parties
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
case when trn.M_BINTERNAL ='Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
-- TRN1 --
-- Identifier
trn.M_COMP_TYPO SEQ,
trn.M_NB TRN,
rtrim(trn.M_TRN_STATUS) STAT,
-- Product
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
rtrim(trn.M_TRN_FMLY) FML,
rtrim(trn.M_TRN_GRP) GRP,
coalesce(rtrim(trn.M_TRN_TYPE),' ') TYP,
rtrim(pli1.M_DSP_LABEL) INS,
-- Delivery
rtrim(phy.M_LABEL) PHY,
rtrim(loc.M_LABEL) LOC,
-- Index 1
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
-- Index 2
rtrim(ind2.M_IND_LAB) IND2,
rtrim(qot2.M_LABEL) QOT2,
rtrim(pub2.M_LABEL) PUB2,
rtrim(cmu2.M_LABEL) UND2,
rtrim(ghsr2.M_LABEL) HSR2,
-- Quote
case when trn.M_TRN_FMLY = 'COM' then qot1.M_CURR else trn.M_BRW_NOMU2 end CUR,
case when trn.M_TRN_FMLY = 'COM' then rtrim(unq.M_LABEL) else trn.M_BRW_NOMU1 end UOM,
case when trn.M_TRN_GTYPE in (84) then 
case fxo.M_XPINPON 
when 0 then trn.M_BRW_NOMU1 
when 1 then trn.M_BRW_NOMU2 end
else trn.M_BRW_NOMU1 end UOD,
-- Tenor
case when trn.M_TRN_FMLY = 'COM' then 
case when (trn.M_TRN_GTYPE in (100,101,102,103) and rtrim(pub1.M_LABEL) = 'LME') then 
-- !! Adapt contextually !! --
case when trn.M_BRW_ODPL = '27-JUN-19' then 'CASH' else
case when trn.M_BRW_ODPL = '25-SEP-19' then '3M' else
case when to_date(trn.M_BRW_ODPL) = next_day(trunc(to_date(trn.M_BRW_ODPL,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(trn.M_BRW_ODPL,4,6)) 
else rtrim(trn.M_BRW_ODPL) end end end
else rtrim(trn.M_BRW_ODPL) end
when trn.M_TRN_FMLY = 'CURR' then rtrim(trn.M_PL_KEY1)
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
case when trn.M_TRN_GTYPE in (84) then to_char(trn.M_OPT_FLWFST,'YYYYMMDD') else to_char(trn.M_OPT_FLWLST,'YYYYMMDD') end STL,
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP_,
-- Option
coalesce(trn.M_BRW_STRK,0) STK,
rtrim(trn.M_BRW_CP) RGT,
case when trn.M_TRN_GTYPE in (84,101,103,113,131,146) then trn.M_BRW_RTE1 else 0 end PRM,
-- Price
case when trn.M_TRN_GTYPE in (77) then fxs.M_XPFWPRC else trn.M_BRW_RTE1 end PRC1, 
trn.M_BRW_MRG1 MRG1,
trn.M_BRW_RTE2 PRC2,
trn.M_BRW_MRG2 MRG2,
-- Direction
case when trn.M_TRN_GTYPE in (1, 2, 130, 113, 131, 134, 136, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn.M_COMMENT_BS) end DIR,
(
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1 
when 'R' then 1 
when 'P' then -1 else null end
else case trn.M_COMMENT_BS 
when 'B' then 1 
when 'S' then -1 end 
end) *
(
case trn.M_BRW_CP 
when 'C' then 1
when 'P' then -1 else 1 end
) LS,
-- Volume
coalesce(fut.M_QTY,1) LOTSIZ,
case 
when trn.M_TRN_GTYPE in (130,131,154) then trn.M_BRW_NOM1/cmu1.M_LOTSIZE
else trn.M_BRW_NOM1 end NOM1,
trn.M_BRW_NOM2 NOM2,
abs(trn.M_BRW_NOM1)*coalesce(fut.M_QTY,1) QTY,
loan.M_REF_CAP0 CAPQTY,
dlv.M_TOT_QTY DLVQTY,
-- TRN2 --
-- Identifiers
trn2.M_COMP_TYPO S_SEQ,
trn2.M_NB S_TRN2,
rtrim(trn2.M_TRN_STATUS) S_STAT,
-- Product
case when trn2.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end S_LO,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) S_ASS,
rtrim(trn.M_TRN_FMLY) S_FML,
rtrim(trn.M_TRN_GRP) S_GRP,
coalesce(rtrim(trn.M_TRN_TYPE),' ') S_TYP,
rtrim(pli2.M_DSP_LABEL) S_INS,
-- Tenor
case 
when trn2.M_TRN_FMLY = 'COM' then 
case when (trn2.M_TRN_GTYPE in (100,101,102,103) and rtrim(pub1.M_LABEL) = 'LME') then 
case when to_date(trn2.M_BRW_ODPL) = next_day(trunc(to_date(trn2.M_BRW_ODPL,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(trn2.M_BRW_ODPL,4,6))
else rtrim(trn2.M_BRW_ODPL) end end
when trn2.M_TRN_FMLY = 'CURR' then rtrim(trn2.M_PL_KEY1) end S_MAT,

rtrim(futmat.M_LABEL) FUTMAT,
rtrim(optmat.M_LABEL) OPTMAT,
---- CFST1
case  
when trn2.M_TRN_GTYPE in (100,101,102,103,113,130,131,134,146,154) then to_char(dlv2.M_CALC_FST,'YYYYMMDD') 
else to_char(trn2.M_OPT_FLWFST,'YYYYMMDD') end S_CFST1,
---- CLST1
case 
when trn2.M_TRN_GTYPE in (100,101,102,103,113,130,131,134,146,154) then to_char(dlv2.M_CALC_LST,'YYYYMMDD')
else to_char(trn2.M_OPT_FLWLST,'YYYYMMDD') end S_CLST1,
---- CFST2
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134,146,154) then to_char(loan2.M_START_DAT1,'YYYYMMDD')
else null end S_CFST2,
---- CLST2
case 
when trn.M_TRN_GTYPE in (130,154) then to_char(loan2.M_MATURITY1-1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (100,101,102,103,113,134) then to_char(loan2.M_MATURITY1,'YYYYMMDD')
else null end S_CLST2,
---- STL, EXP
to_char(trn2.M_OPT_FLWLST,'YYYYMMDD') S_STL,
to_char(trn2.M_TRN_EXP,'YYYYMMDD') S_EXP,
-- Price
trn2.M_BRW_RTE1 S_PRC1, 
trn2.M_BRW_MRG1 S_MRG1,
trn2.M_BRW_RTE2 S_PRC2,
trn2.M_BRW_MRG2 S_MRG2,
-- Direction
case when trn2.M_TRN_GTYPE in (1, 2, 130, 113, 131, 134, 136, 154) then
case trn2.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn2.M_COMMENT_BS) end S_DIR,
-- Volume
coalesce(fut2.M_QTY,1) S_LOTSIZ,
case 
when trn2.M_TRN_GTYPE in (130,131,154) then trn2.M_BRW_NOM1/cmu2.M_LOTSIZE
else trn2.M_BRW_NOM1 end S_NOM1,
trn2.M_BRW_NOM2 S_NOM2,
abs(trn2.M_BRW_NOM1)*coalesce(fut.M_QTY,1) S_QTY,
loan2.M_REF_CAP0 S_CAPQTY,
dlv2.M_TOT_QTY S_DLVQTY,
-- Fees --
/*-- BRK0
case brk0.M_TYPE 
when 0 then 'None'
when 1 then 'Broker fee'
when 2 then 'Broker tax'
when 3 then 'Clearer fee'
when 4 then 'Clearer tax'
when 5 then 'Internal fee'
when 6 then 'Client fee'
when 7 then 'CVA fee' else null end FEE0_TYP,
rtrim(brkpfl0.M_LABEL) FEE0_PFL,
rtrim(brkctp0.M_DSP_LABEL) FEE0_CTP,
rtrim(brk0.M_CODE) FEE0_COD,
brk0.M_CUR FEE0_CUR,
brk0.M_FEE FEE0_AMT,
to_char(brk0.M_VALUE_DATE,'YYYYMMDD') FEE0_STL,
rtrim(brk0.M_COMMENT) FEE0_CMT,
*/
-- BRK1
case brk1.M_TYPE 
when 0 then 'None'
when 1 then 'Broker fee'
when 2 then 'Broker tax'
when 3 then 'Clearer fee'
when 4 then 'Clearer tax'
when 5 then 'Internal fee'
when 6 then 'Client fee'
when 7 then 'CVA fee' else null end FEE1_TYP,
rtrim(brkpfl1.M_LABEL) FEE1_PFL,
rtrim(brkctp1.M_DSP_LABEL) FEE1_CTP,
rtrim(brk1.M_CODE) FEE1_COD,
brk1.M_CUR FEE1_CUR,
brk1.M_FEE FEE1_AMT,
to_char(brk1.M_VALUE_DATE,'YYYYMMDD') FEE1_STL,
rtrim(brk1.M_COMMENT) FEE1_CMT,
-- BRK2
case brk2.M_TYPE 
when 0 then 'None'
when 1 then 'Broker fee'
when 2 then 'Broker tax'
when 3 then 'Clearer fee'
when 4 then 'Clearer tax'
when 5 then 'Internal fee'
when 6 then 'Client fee'
when 7 then 'CVA fee' else null end FEE2_TYP,
rtrim(brkpfl2.M_LABEL) FEE2_PFL,
rtrim(brkctp2.M_DSP_LABEL) FEE2_CTP,
rtrim(brk2.M_CODE) FEE2_COD,
brk2.M_CUR FEE2_CUR,
brk2.M_FEE FEE2_AMT,
to_char(brk2.M_VALUE_DATE,'YYYYMMDD') FEE2_STL,
rtrim(brk2.M_COMMENT) FEE2_CMT,
-- BRK3
case brk3.M_TYPE 
when 0 then 'None'
when 1 then 'Broker fee'
when 2 then 'Broker tax'
when 3 then 'Clearer fee'
when 4 then 'Clearer tax'
when 5 then 'Internal fee'
when 6 then 'Client fee'
when 7 then 'CVA fee' else null end FEE3_TYP,
rtrim(brkpfl3.M_LABEL) FEE3_PFL,
rtrim(brkctp3.M_DSP_LABEL) FEE3_CTP,
rtrim(brk3.M_CODE) FEE3_COD,
brk3.M_CUR FEE3_CUR,
brk3.M_FEE FEE3_AMT,
to_char(brk3.M_VALUE_DATE,'YYYYMMDD') FEE3_STL,
rtrim(brk3.M_COMMENT) FEE3_CMT,
-- Technical IDs
trn.M_TRN_GTYPE FGTID,
fut.M_REFERENCE FUTID,
ind1.M_REFERENCE INDID,
qot1.M_REFERENCE QOTID,
pub1.M_REFERENCE PUBID, 
coalesce(lhsr.M_SERIE, ghsr1.M_SERIE) HSRID,
case  
when trn.M_TRN_GTYPE in (100, 101, 102, 103, 113, 134, 146, 154) then 'H'||rtrim(ind1.M_HISFILE)||'_H1S' 
when trn.M_TRN_GTYPE in (130, 131) then rtrim(substr(ind1.M_HISFILE,1,8))||'_DBF'
else null end HISFIL,
fut.M_FUT_MAT MATSETID,
plk1.M_FUT_MAT FMATID,
plk1.M_OPT_MAT OMATID

from CONTRACT_DBF cnt
left join TRN_PC_DBF pc on 1 = 1
left join TRN_HDR_DBF trn on (cnt.M_REFERENCE = trn.M_CONTRACT and trn.M_COMP_TYPO in (0,1))
left join TRN_HDR_DBF trn2 on (cnt.M_REFERENCE = trn2.M_CONTRACT and trn2.M_COMP_TYPO in (2))
left join TRN_PFLD_DBF bpf on trn.M_BPFOLIO = bpf.M_LABEL
left join TRN_PFLD_DBF spf on trn.M_SPFOLIO = spf.M_LABEL
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF pli1 on trn.M_INSTRUMENT = pli1.M_REFERENCE
left join TRN_PLIN_DBF pli2 on trn2.M_INSTRUMENT = pli2.M_REFERENCE
left join CMT_PLKEY1_DBF plk1 on trim(trn.M_PL_KEY1) = to_char(plk1.M_REFERENCE)
left join CMT_PLKEY1_DBF plk2 on trim(trn2.M_PL_KEY1) = to_char(plk2.M_REFERENCE)
left join CMT_DLV_DBF dlv on (trn.M_NB = dlv.M_NB and dlv.M_LEG_NB = 0)
left join CMT_DLV_DBF dlv2 on trn2.M_NB = dlv2.M_NB
left join CM_ASSET_DBF ass on plk1.M_ASSET = ass.M_REFERENCE
left join CM_FUT_DBF fut on plk1.M_FUTURE = fut.M_REFERENCE
left join CM_FUT_DBF fut2 on plk2.M_FUTURE = fut2.M_REFERENCE
left join CM_FMAT1_DBF futmat on plk1.M_FUT_MAT = futmat.M_REFERENCE
left join CM_OMAT1_DBF optmat on plk1.M_OPT_MAT = optmat.M_REFERENCE
left join RT_INDEX_DBF ind1 on plk1.M_INDEX = ind1.M_INDEX
left join CM_INDEX_DBF cmi1 on ind1.M_COM_IND = cmi1.M_REFERENCE
left join CMC_QUOT_DBF qot1 on plk1.M_QUOT = qot1.M_REFERENCE
left join CM_MKT_DBF pub1 on qot1.M_PUBLI= pub1.M_REFERENCE
left join CM_INDEX_DBF cmu1 on plk1.M_UNDL = cmu1.M_REFERENCE
left join CM_INDEX_DBF cmu2 on plk2.M_UNDL = cmu2.M_REFERENCE
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
left join RT_LOAN_DBF loan2 on trn2.M_NB = loan2.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join CM_MKTSR_DBF ghsr1 on trim(substr(gen.M_FORMULA0,2,10)) = to_char(ghsr1.M_SERIE)
left join CM_MKTSR_DBF ghsr2 on trim(substr(gen.M_FORMULA1,2,10)) = to_char(ghsr2.M_SERIE)
left join CM_MKTSR_DBF lhsr on trim(substr(loan.M_GEN_FRM,2,10)) = to_char(lhsr.M_SERIE)
left join CM_PHYS_DBF phy on dlv.M_PHYSICAL = phy.M_REFERENCE
left join CM_LOCAT_DBF loc on dlv.M_LOCATION = loc.M_REFERENCE
left join FD111200_DBF fxs on trn.M_NB = fxs.M_NB
left join FD111000_DBF fxo on trn.M_NB = fxo.M_NB
left join TRN_BROKER_DBF brk0 on (trn.M_NB = brk0.M_NB and brk0.M_LINE = 0)
left join TRN_BROKER_DBF brk1 on (trn.M_NB = brk1.M_NB and brk1.M_LINE = 1)
left join TRN_BROKER_DBF brk2 on (trn.M_NB = brk2.M_NB and brk2.M_LINE = 2)
left join TRN_BROKER_DBF brk3 on (trn.M_NB = brk3.M_NB and brk3.M_LINE = 3)
left join TRN_PFLD_DBF brkpfl0 on brk0.M_SRC_PFOLIO = brkpfl0.M_REF
left join TRN_PFLD_DBF brkpfl1 on brk1.M_SRC_PFOLIO = brkpfl1.M_REF
left join TRN_PFLD_DBF brkpfl2 on brk2.M_SRC_PFOLIO = brkpfl2.M_REF
left join TRN_PFLD_DBF brkpfl3 on brk3.M_SRC_PFOLIO = brkpfl3.M_REF
left join TRN_CPDF_DBF brkctp0 on brk0.M_CNTRP = brkctp0.M_ID
left join TRN_CPDF_DBF brkctp1 on brk1.M_CNTRP = brkctp1.M_ID
left join TRN_CPDF_DBF brkctp2 on brk2.M_CNTRP = brkctp2.M_ID
left join TRN_CPDF_DBF brkctp3 on brk3.M_CNTRP = brkctp3.M_ID

where 1 = 1
-- and trn.M_TRN_STATUS <> 'DEAD'
-- trn.M_BINTERNAL <> trn.M_SINTERNAL
-- coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
-- and coalesce(ctyp.M_REF,0) = 0
-- and trn.M_TRN_EXP > pc.M_DATE
and trn.M_TRN_GTYPE NOT IN (1,2)
-- and trn.M_COUNTRPART in (1430)
and trn.M_CONTRACT in
(
5158227
)

order by 
trn.M_BPFOLIO, trn.M_SPFOLIO,
sle.M_DSP_LABEL, ble.M_DSP_LABEL, ctp.M_DSP_LABEL,
trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE,
typo.M_LABEL,
pli1.M_DSP_LABEL,
to_char(trn.M_TRN_EXP,'YYYYMMDD'),
to_char(trn.M_BRW_STRK,'99999.9999'),
trn.M_BRW_CP
