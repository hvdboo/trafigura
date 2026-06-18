select
--- Dates
to_char(pc.M_DATE,'YYYYMMDD')      SYSDAT,
to_char(trn.M_TRN_DATE,'YYYYMMDD') TRNDAT,
--- Identifiers
rtrim(src.M_LABEL) SRC,
cnt.M_REFERENCE    CNT,
cnt.M_VERSION      CVS,
cnt.M_PACK_REF     PKG,
rtrim(pcktypo.M_LABEL) PKGTYPO,
trn.M_COMP_TYPO    PKGSEQ,
trn.M_NB           TRN,
rtrim(trn.M_GID)   GID,
-- trn.M_COMP_TYPO SEQNEAR,
rtrim(trn.M_TRN_STATUS) STAT,
--- Parties
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case 
when trn.M_COMMENT_BS = 'B' then
        case 
        when ble.M_DSP_LABEL = 'MAT' then 'FO_MATSA' 
        when ble.M_DSP_LABEL in ('PTE','TIC','TRA') then
                case 
                when rtrim(trn.M_BENTITY) = 'AP' then 'FO_ASIA'
                when rtrim(trn.M_BENTITY) = 'EM' then 'FO_EMEA'
                when rtrim(trn.M_BENTITY) = 'AM' then 'FO_AMERICA' else null end
        end
when trn.M_COMMENT_BS = 'S' then
        case 
        when sle.M_DSP_LABEL = 'MAT' then 'FO_MATSA' 
        when sle.M_DSP_LABEL in ('PTE','TIC','TRA') then
                case 
                when rtrim(trn.M_SENTITY) = 'AP' then 'FO_ASIA'
                when rtrim(trn.M_SENTITY) = 'EM' then 'FO_EMEA'
                when rtrim(trn.M_SENTITY) = 'AM' then 'FO_AMERICA' else null end end
else null end USRGRP,
case when trn.M_COMMENT_BS = 'B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
case when trn.M_BINTERNAL  = 'Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case 
when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
--- Product
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
trn.M_TRN_GTYPE       FGT,
rtrim(trn.M_TRN_FMLY) FML,
rtrim(trn.M_TRN_GRP)  GRP,
coalesce(rtrim(trn.M_TRN_TYPE),' ') TYP,
-- rtrim(pat.M_LABEL)  PAT,
rtrim(cnttypo.M_LABEL)  CNTTYPO,
rtrim(plin.M_DSP_LABEL) PLINS,
rtrim(trn.M_PL_INSCUR)  PLCUR,
-- case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BSTRATEGY) else rtrim(trn.M_SSTRATEGY) end STGSRC,
-- case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_SSTRATEGY) else rtrim(trn.M_BSTRATEGY) end STGDST,
--- Delivery
rtrim(phy.M_LABEL) PHY,
rtrim(loc.M_LABEL) LOC,
-- Quote
case trn.M_TRN_FMLY 
when 'COM'  then qot0.M_CURR
when 'CURR' then substr(fxc.M_QUOTMODE0,5,3) 
else rtrim(trn.M_PL_INSCUR) end CUR,
case trn.M_TRN_FMLY 
when 'COM'  then rtrim(unq.M_LABEL) 
when 'CURR' then substr(fxc.M_QUOTMODE0,1,3) 
else null end UOQ,
case trn.M_TRN_FMLY 
when 'COM' then 
   case 
   when trn.M_TRN_GTYPE in (100,101,102,103) then 'LOT'
   else rtrim(nomuni.M_LABEL) end
when 'CURR' then 
   case 
   when trn.M_TRN_GTYPE in (84) then 
      case fxo.M_XPINPON 
      when 0 then trn.M_BRW_NOMU1   
      when 1 then trn.M_BRW_NOMU2 
      else null end
   else trn.M_BRW_NOMU1 end 
else trn.M_BRW_NOMU1 end UOD,
case trn.M_TRN_FMLY 
when 'COM'  then rtrim(nomuni.M_LABEL)
when 'CURR' then 
   case when trn.M_TRN_GTYPE in (84) then 
      case fxo.M_XPINPON 
      when 0 then trn.M_BRW_NOMU1   
      when 1 then trn.M_BRW_NOMU2 end
   else trn.M_BRW_NOMU1 end 
else trn.M_BRW_NOMU1 end UOV,
coalesce(fut.M_QTY,1) LOTSIZ,
--- Index 0
case trn.M_TRN_FMLY
when 'COM' then rtrim(ind0.M_IND_LAB)
when 'CURR' then trn.M_BRW_NOMU1 end IND0,
case 
when rtrim(trn.M_TRN_FMLY) = 'COM' then rtrim(qot0.M_LABEL)
when trn.M_TRN_GTYPE in (76,77,92) then rtrim(fxs.M_XPFWPRCQ)
when trn.M_TRN_GTYPE in (84) then rtrim(fxo.M_XPOPTFPQ) else null end QOT0,
rtrim(coalesce(cmu0.M_LABEL,fund.M_LABEL)) UND0,
rtrim(coalesce(pub0.M_LABEL, fxs.M_XPFWGROUP)) PUB0,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(coalesce(ghsr0.M_LABEL,lhsr.M_LABEL))
when 'CURR' then rtrim(fxs.M_XPFWCOL) else null end HSR0,
--- Index 1
case trn.M_TRN_FMLY
when 'COM' then rtrim(ind1.M_IND_LAB)
when 'CURR' then trn.M_BRW_NOMU2 end IND1,
rtrim(qot1.M_LABEL) QOT1,
rtrim(cmu1.M_LABEL) UND1,
rtrim(pub1.M_LABEL) PUB1,
rtrim(ghsr1.M_LABEL) HSR1,
--- Tenor
case 
when rtrim(trn.M_TRN_FMLY) = 'COM' then 
   case 
   when trn.M_TRN_GTYPE in (100,102) then
      case 
      -- !! Adapt contextually !! --
      when rtrim(pub0.M_LABEL) = 'LME' and trn.M_BRW_ODPL = '04-FEB-21' then 'CASH' 
      when rtrim(pub0.M_LABEL) = 'LME' and trn.M_BRW_ODPL = '03-MAY-21' then '3M'
      when rtrim(pub0.M_LABEL) = 'LME' and to_date(trn.M_BRW_ODPL) = next_day(trunc(to_date(trn.M_BRW_ODPL,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(trn.M_BRW_ODPL,4,6)) 
      else rtrim(futmat.M_LABEL) end
   when trn.M_TRN_GTYPE in (101,103) then rtrim(optmat.M_LABEL) 
   else rtrim(trn.M_BRW_ODPL) end 
when rtrim(trn.M_TRN_FMLY) = 'CURR' then rtrim(fxs.M_XCCNTMAT)
else null end MAT0,
' ' MAT1,
--- CFST0
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_FST,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWFST,'YYYYMMDD') end CFST0,
--- CLST0
case 
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_LST,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_MATURITY0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWLST,'YYYYMMDD') end CLST0,
--- CFST1
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(loan.M_START_DAT1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT1,'YYYYMMDD')
else null end CFST1,
--- CLST1
case 
when trn.M_TRN_GTYPE in (130,154) then to_char(loan.M_MATURITY1-1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (100,101,102,103,113,134) then to_char(loan.M_MATURITY1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2) then to_char(loan.M_MATURITY1,'YYYYMMDD')
else null end CLST1,
--- DLV, STL, EXP 
case 
when trn.M_TRN_GTYPE in (100,101,102,103,113,154) then to_char(dlv.M_CALC_LST,'YYYYMMDD')
else null end DLV,
case when trn.M_TRN_GTYPE in (84) then to_char(trn.M_OPT_FLWFST,'YYYYMMDD') else to_char(trn.M_OPT_FLWLST,'YYYYMMDD') end STL,
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP_,
-- Option
case 
when trn.M_TRN_GTYPE in (131, 146) then 'Asian'
when trn.M_TRN_GTYPE in (84, 101, 103, 113) then
   case  
   when trn.M_BRW_AE = 'A' then 'American'
   when trn.M_BRW_AE = 'E' then 'European' 
   else null end 
else null end EXRSTY,
case trn.M_TRN_FMLY 
when 'COM' then 
   case 
   when trn.M_TRN_GTYPE in (100,102) then 
      case fut.M_EXR_MODE
      when 0 then 'Cash' 
      when 1 then 
         case fut.M_INS_MODE
         when 0 then 'Fin.dlv'
         when 1 then
            case mgen.M_EXR_MODE
            when 0 then 'Fin.dlv'
            when 1 then 'Phy.dlv'
            else null end
        else null end   
      else null end      
   when trn.M_TRN_GTYPE in (101,103) then
      case fut.M_EXR_MODE
      when 0 then 'Cash' 
      when 1 then 'Delivery'
      else null end  
   when trn.M_TRN_GTYPE in (130,131,136,146, 154) then 
      case gen.M_SETTLE0
      when 0 then 'Cash'
      when 1 then 'Delivery' 
      else null end
   else null end    
when 'CURR' then 
   case fxo.M_XPOPTDELIV
   when 0 then 'Cash'
   when 1 then 'Delivery'
   when 2 then 'Early cash'
   when 3 then 'Early delivery'
   else null end
else null end EXRMOD,
rtrim(trn.M_BRW_CP) RGT,
coalesce(trn.M_BRW_STRK,trn.M_BRW_RTE1) STK,
--- Price
case when trn.M_TRN_GTYPE in (77) then fxs.M_XPFWPRC else trn.M_BRW_RTE1 end PRC,
case when trn.M_TRN_GTYPE in (77) then fxs.M_XPFWPRC else trn.M_BRW_RTE1 end RTE0, 
trn.M_BRW_MRG1 MRG0,
case trn.M_BRW_FV2 when 'V' then trn.M_BRW_RTE2 else 0 end RTE1,
case trn.M_BRW_FV2 when 'V' then trn.M_BRW_MRG2 else 0 end MRG1,
case 
when trn.M_TRN_GTYPE in (84) then fxo.M_XPRMPA
when trn.M_TRN_GTYPE in (101,103,113,131,146) then loan.M_STL_FLW 
else 0 end PRMAMT,
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
trn.M_BRW_NOM1 NOM0,
trn.M_BRW_NOM2 NOM1,
loan.M_INITPRIC0 DLVVOL,
abs(trn.M_BRW_NOM1)*coalesce(fut.M_QTY,1) QTY,
-- loan.M_REF_CAP0 CAPQTY,
-- loan.M_PRINCIPAL0,
-- dlv.M_TOT_QTY DLVQTY,
--- Fees
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
--- Technical IDs
/*
fut.M_REFERENCE FUTID,
ind0.M_REFERENCE INDID,
qot0.M_REFERENCE QOTID,
pub0.M_REFERENCE PUBID, 
coalesce(lhsr.M_SERIE, ghsr0.M_SERIE) HSRID,
case  
when trn.M_TRN_GTYPE in (100, 101, 102, 103, 113, 134, 146, 154) then 'H'||rtrim(ind0.M_HISFILE)||'_H1S' 
when trn.M_TRN_GTYPE in (130, 131) then rtrim(substr(ind0.M_HISFILE,1,8))||'_DBF'
else null end HISFIL,
fut.M_FUT_MAT MATSETID,
plkey.M_FUT_MAT FMATID,
plkey.M_OPT_MAT OMATID,
*/
null ORD

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE --and trn.M_COMP_TYPO in (0,1))
left join PACKAGE_DBF  pck on cnt.M_PACK_REF = pck.M_REFERENCE
left join TRN_PFLD_DBF bpf on trn.M_BPFOLIO = bpf.M_LABEL
left join TRN_PFLD_DBF spf on trn.M_SPFOLIO = spf.M_LABEL
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF cnttypo on cnt.M_TYPOLOGY = cnttypo.M_REFERENCE
left join TYPOLOGY_DBF pcktypo on pck.M_TYPOLOGY = pcktypo.M_REFERENCE
-- left join DCF_OBJ_DBF pat on cnt.M_PATTERN = pat.M_ITEM_ID
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join FX_CNT_DBF fxc on rtrim(plin.M_DSP_LABEL) = rtrim(fxc.M_LABEL)
left join CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join CMT_DLV_DBF dlv on (trn.M_NB = dlv.M_NB and dlv.M_LEG_NB = 0)
left join CM_ASSET_DBF ass on plkey.M_ASSET = ass.M_REFERENCE
left join CM_UNIT_DBF nomuni on (rtrim(trn.M_BRW_NOMU1) = to_char(nomuni.M_REFERENCE) and trn.M_TRN_FMLY = 'COM')
left join CM_FUT_DBF fut on plkey.M_FUTURE = fut.M_REFERENCE
left join CM_FMAT1_DBF futmat on plkey.M_FUT_MAT = futmat.M_REFERENCE
left join CM_OMAT1_DBF optmat on plkey.M_OPT_MAT = optmat.M_REFERENCE
left join RT_INDEX_DBF ind0 on plkey.M_INDEX = ind0.M_INDEX
left join CM_INDEX_DBF cmi0 on ind0.M_COM_IND = cmi0.M_REFERENCE
left join CMC_QUOT_DBF qot0 on plkey.M_QUOT = qot0.M_REFERENCE
left join CM_MKT_DBF pub0 on qot0.M_PUBLI= pub0.M_REFERENCE
left join CM_INDEX_DBF cmu0 on plkey.M_UNDL = cmu0.M_REFERENCE
left join RT_INDEX_DBF ind1 on trim(substr(trn.M_MKT_INDEX,18,15)) = trim(ind1.M_INDEX)
left join CM_INDEX_DBF cmi1 on ind1.M_COM_IND = cmi1.M_REFERENCE
left join CMC_QUOT_DBF qot1 on ind1.M_COM_QUOT = qot1.M_REFERENCE
left join CM_MKT_DBF pub1 on qot1.M_PUBLI= pub1.M_REFERENCE
left join RT_INDEX_DBF und1 on rtrim(ind1.M_UNDRL) = rtrim(und1.M_INDEX)
left join CM_INDEX_DBF cmu1 on und1.M_COM_IND = cmu1.M_REFERENCE
left join CM_UNIT_DBF unq on qot0.M_UNIT = unq.M_REFERENCE
left join CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE
left join RT_INDEX_DBF find on mgen.M_INDEX = find.M_INDEX
left join CM_INDEX_DBF fund on find.M_COM_IND = fund.M_REFERENCE
left join RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot0.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15)))
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join CM_MKTSR_DBF ghsr0 on trim(substr(gen.M_FORMULA0,2,10)) = to_char(ghsr0.M_SERIE)
left join CM_MKTSR_DBF ghsr1 on trim(substr(gen.M_FORMULA1,2,10)) = to_char(ghsr1.M_SERIE)
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
--left join TRN_HDR_DBF trnfar on (trn.M_CONTRACT = trnfar.M_CONTRACT and trnfar.M_COMP_TYPO = 2)
--left join CMT_DLV_DBF dlvfar on trnfar.M_NB = dlvfar.M_NB
--left join CSF_CLASSIFICATION_DBF cntcla on trn.M_NB = cntcla.M_OBJ_REF and rtrim(cntcla.M_OBJ_CLASS) = '1.239' and cntcla.M_JOIN = 128

where 1 = 1
-- and trn.M_TRN_STATUS <> 'DEAD'
-- trn.M_BINTERNAL <> trn.M_SINTERNAL
-- coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
-- and coalesce(ctyp.M_REF,0) = 0
-- and trn.M_TRN_EXP > pc.M_DATE
-- and trn.M_TRN_GTYPE NOT IN (1,2)
-- and trn.M_COUNTRPART in (1430)
-- and trn.M_NB in ()
and trn.M_BCOMMENT2 = 'U64_C01'

order by 
trn.M_BPFOLIO, trn.M_SPFOLIO,
sle.M_DSP_LABEL, ble.M_DSP_LABEL, ctp.M_DSP_LABEL,
trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE,
cnttypo.M_LABEL,
plin.M_DSP_LABEL,
to_char(trn.M_TRN_EXP,'YYYYMMDD'),
to_char(trn.M_BRW_STRK,'99999.9999'),
trn.M_BRW_CP
