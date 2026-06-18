select
--- Dates
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
to_char(pc.M_DATE,'YYYY-MM-DD') TRNDAT,
--- Parties
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case when trn.M_BINTERNAL ='Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
-- !! Counterpart not required if PFL level transfer !! --
/*
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
*/
--- Product
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
trn.M_TRN_GTYPE FGT,
rtrim(trn.M_TRN_FMLY) FML,
rtrim(trn.M_TRN_GRP) GRP,
rtrim(trn.M_TRN_TYPE) TYP,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) PLINS,
rtrim(trn.M_PL_INSCUR) PLCUR,
-- rtrim(phy.M_LABEL) PHY,
-- rtrim(loc.M_LABEL) LOC,
--- Quote
case trn.M_TRN_FMLY 
when 'COM'  then qot0.M_CURR
when 'CURR' then substr(fxc.M_QUOTMODE0,5,3) else rtrim(trn.M_PL_INSCUR) end CUR,
case trn.M_TRN_FMLY 
when 'COM'  then rtrim(unq.M_LABEL) 
when 'CURR' then substr(fxc.M_QUOTMODE0,1,3) else null end UOQ,
case trn.M_TRN_FMLY 
when 'COM'  then rtrim(nomuni.M_LABEL)
when 'CURR' then 
   case when trn.M_TRN_GTYPE in (84) then 
      case fxo.M_XPINPON 
      when 0 then trn.M_BRW_NOMU1   
      when 1 then trn.M_BRW_NOMU2 end
   else trn.M_BRW_NOMU1 end 
else trn.M_BRW_NOMU1 end UOD,
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
/*
--- CFST0
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134,146,154) then to_char(dlv.M_CALC_FST,'YYYYMMDD') 
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
*/
--- EXP, DLV, STL
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP,
/*
case 
when trn.M_TRN_GTYPE in (100,101,102,103,113,154) then to_char(dlv.M_CALC_LST,'YYYYMMDD')
else null end DLV,
case when trn.M_TRN_GTYPE in (84) then to_char(trn.M_OPT_FLWFST,'YYYYMMDD') else to_char(trn.M_BRW_SDTE,'YYYYMMDD') end STL,
*/
--- Option
/*
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
*/
trn.M_BRW_STRK STK,
rtrim(trn.M_BRW_CP) RGT,
--- Price
-- !! If last closing !! --
/*
max(
case 
-- when trn.M_TRN_GTYPE in (77)  then max(fxs.M_XPFWPRC)
when trn.M_TRN_GTYPE = 100 and fut.M_REFERENCE =  74 then round(hb_PBLMEFUT.M_P12, 2)
when trn.M_TRN_GTYPE = 100 and fut.M_REFERENCE =  56 then round(hb_ZNLMEFUT.M_P12, 2)
when trn.M_TRN_GTYPE = 102 and fut.M_REFERENCE = 507 then round(hb_PBLMEFWD.M_P12, 2)
when trn.M_TRN_GTYPE = 102 and fut.M_REFERENCE = 509 then round(hb_ZNLMEFWD.M_P12, 2)
else 0 end) PRC1,
null MRG1,
null PRC2,
null MRG2,

-- !! If weighted average price !! --
round(
sum(
(case 
when trn.M_TRN_GTYPE in (77)  then fxs.M_XPFWPRC 
when trn.M_TRN_GTYPE in (100) then hb1.M_P12
when trn.M_TRN_GTYPE in (102) then hb2.M_P12
else trn.M_BRW_RTE1 end) * trn.M_BRW_NOM1) / sum(trn.M_BRW_NOM1) , 
4) PRC1, 
sum(trn.M_BRW_MRG1) MRG1,
round(sum(trn.M_BRW_RTE2 * trn.M_BRW_NOM2) / sum(trn.M_BRW_NOM1),4) PRC2,
sum(trn.M_BRW_MRG2) MRG2,

-- !! Direction not required if by position, net figures are computed !! --
--- NOM1
sum((
case 
when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
   case 
   when trn.M_BRW_FV1='V' and M_BRW_PR1 = 'R' then 1 
   when trn.M_BRW_FV1='F' and M_BRW_PR1 = 'P' then 1  
   else -1 end
when trn.M_TRN_GTYPE in (90) then case when M_BRW_PR1 = 'R' then 1 else -1 end
else case when trn.M_COMMENT_BS = 'B' then 1 else -1 end 
end ) * trn.M_BRW_NOM1) NOM1,
--- NOM2
sum((
case 
when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
   case 
   when trn.M_BRW_FV1='V' and M_BRW_PR1 = 'R' then 1 
   when trn.M_BRW_FV1='F' and M_BRW_PR1 = 'P' then 1 
   else -1 end
when trn.M_TRN_GTYPE in (90) then case when M_BRW_PR1 = 'R' then 1 else -1 end
else case when trn.M_COMMENT_BS = 'B' then 1 else -1 end 
end) * trn.M_BRW_NOM2) NOM2,
--- Quantity
sum(abs(trn.M_BRW_NOM1)*coalesce(fut.M_QTY,1)) QTY,
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
left join FX_CNT_DBF fxc on rtrim(plin.M_DSP_LABEL) = rtrim(fxc.M_LABEL)
left join CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join CMT_DLV_DBF dlv on (trn.M_NB = dlv.M_NB and dlv.M_LEG_NB = 0)
left join CM_ASSET_DBF ass on plkey.M_ASSET = ass.M_REFERENCE
left join CM_UNIT_DBF nomuni on (rtrim(trn.M_BRW_NOMU1) = to_char(nomuni.M_REFERENCE) and trn.M_TRN_FMLY = 'COM')
left join CM_FUT_DBF fut on plkey.M_FUTURE = fut.M_REFERENCE
left join CM_FMAT1_DBF futmat on plkey.M_FUT_MAT = futmat.M_REFERENCE
left join CM_FMAT1_DBF futmatlme on (rtrim(futmat.M_LABEL) = rtrim(futmatlme.M_LABEL) and futmatlme.M_FMAT_ID = 118)
left join CM_OMAT1_DBF optmat on plkey.M_OPT_MAT = optmat.M_REFERENCE
left join RT_INDEX_DBF ind0 on plkey.M_INDEX = ind0.M_INDEX
left join CM_INDEX_DBF cmi0 on ind0.M_COM_IND = cmi0.M_REFERENCE
left join CMC_QUOT_DBF qot0 on plkey.M_QUOT = qot0.M_REFERENCE
left join CM_UNIT_DBF unq on qot0.M_UNIT = unq.M_REFERENCE
left join CM_MKT_DBF pub0 on qot0.M_PUBLI = pub0.M_REFERENCE
left join CM_INDEX_DBF cmu0 on plkey.M_UNDL = cmu0.M_REFERENCE
left join RT_INDEX_DBF ind1 on trim(substr(trn.M_MKT_INDEX,18,15)) = trim(ind1.M_INDEX)
left join CM_INDEX_DBF cmi1 on ind1.M_COM_IND = cmi1.M_REFERENCE
left join CMC_QUOT_DBF qot1 on ind1.M_COM_QUOT = qot1.M_REFERENCE
left join CM_MKT_DBF pub1 on qot1.M_PUBLI= pub1.M_REFERENCE
left join RT_INDEX_DBF und1 on rtrim(ind1.M_UNDRL) = rtrim(und1.M_INDEX)
left join CM_INDEX_DBF cmu1 on und1.M_COM_IND = cmu1.M_REFERENCE
left join CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE
left join RT_INDEX_DBF find on mgen.M_INDEX = find.M_INDEX
left join CM_INDEX_DBF fund on find.M_COM_IND = fund.M_REFERENCE
left join RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot1.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15)))
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join CM_MKTSR_DBF ghsr0 on trim(substr(gen.M_FORMULA0,2,10)) = to_char(ghsr0.M_SERIE)
left join CM_MKTSR_DBF ghsr1 on trim(substr(gen.M_FORMULA1,2,10)) = to_char(ghsr1.M_SERIE)
left join CM_MKTSR_DBF lhsr on trim(substr(loan.M_GEN_FRM,2,10)) = to_char(lhsr.M_SERIE)
left join CM_PHYS_DBF phy on dlv.M_PHYSICAL = phy.M_REFERENCE
left join FD111200_DBF fxs on trn.M_NB = fxs.M_NB
left join FD111000_DBF fxo on trn.M_NB = fxo.M_NB 
-- Adapt historical table name and future reference
-- PB LME FUT
left join H047310_H1S hh_PBLMEFUT on (futmatlme.M_REFERENCE = hh_PBLMEFUT.M_KEY0)
left join B047310_HBS hb_PBLMEFUT on (hh_PBLMEFUT.M_KEYID = hb_PBLMEFUT.M_KEYID and pc.M_DATE-1 = hb_PBLMEFUT.M_DATE)
-- PB LME FWD
left join H498779_H1S hh_PBLMEFWD on (futmat.M_REFERENCE = hh_PBLMEFWD.M_KEY0 and fut.M_REFERENCE = 507)
left join B498779_HBS hb_PBLMEFWD on (hh_PBLMEFWD.M_KEYID = hb_PBLMEFWD.M_KEYID and pc.M_DATE-1 = hb_PBLMEFWD.M_DATE)
-- ZN LME FUT
left join H047308_H1S hh_ZNLMEFUT on (futmatlme.M_REFERENCE = hh_ZNLMEFUT.M_KEY0)
left join B047308_HBS hb_ZNLMEFUT on (hh_ZNLMEFUT.M_KEYID = hb_ZNLMEFUT.M_KEYID and pc.M_DATE-1 = hb_ZNLMEFUT.M_DATE)
-- ZN LME FWD
left join H498798_H1S hh_ZNLMEFWD on (futmat.M_REFERENCE = hh_ZNLMEFWD.M_KEY0 and fut.M_REFERENCE = 509)
left join B498798_HBS hb_ZNLMEFWD on (hh_ZNLMEFWD.M_KEYID = hb_ZNLMEFWD.M_KEYID and pc.M_DATE-1 = hb_ZNLMEFWD.M_DATE)

where
trn.M_TRN_STATUS <> 'DEAD'
and trn.M_TRN_EXP > pc.M_DATE
and  trn.M_NB in 
(
18603042,
18603043,
18606188,
18607207,
18611675,
18611676,
18468403,
18468404,
18467065,
18467068,
18467069,
18051725,
18081325,
18349091,
18349092,
18628767,
18628830,
18627959,
18627960,
18627548,
18627585,
18599437,
18599438,
18629584,
18629750,
18629751,
18629752,
18628516,
18623792,
18623862,
18623890,
18623897,
18624026,
18624027,
18614805,
18614807,
17638030,
17638031,
17638032,
18629606,
18629629,
18630115, 
17356871,
11444670
)


group by
pc.M_DATE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end,
case when ctyp.M_REF = 16 then 'I' else 'E' end,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end,
case when trn.M_BINTERNAL ='Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end),
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end,
trn.M_TRN_GTYPE FGT,
rtrim(trn.M_TRN_FMLY),
rtrim(trn.M_TRN_GRP),
rtrim(trn.M_TRN_TYPE),
rtrim(typo.M_LABEL),
rtrim(plin.M_DSP_LABEL)
rtrim(trn.M_PL_INSCUR),
case trn.M_TRN_FMLY 
when 'COM'  then qot0.M_CURR
when 'CURR' then substr(fxc.M_QUOTMODE0,5,3) else rtrim(trn.M_PL_INSCUR) end,
case trn.M_TRN_FMLY 
when 'COM'  then rtrim(unq.M_LABEL) 
when 'CURR' then substr(fxc.M_QUOTMODE0,1,3) else null end,
case trn.M_TRN_FMLY 
when 'COM'  then rtrim(nomuni.M_LABEL)
when 'CURR' then 
   case when trn.M_TRN_GTYPE in (84) then 
      case fxo.M_XPINPON 
      when 0 then trn.M_BRW_NOMU1   
      when 1 then trn.M_BRW_NOMU2 end
   else trn.M_BRW_NOMU1 end 
else trn.M_BRW_NOMU1 end,
coalesce(fut.M_QTY,1),
case trn.M_TRN_FMLY
when 'COM' then rtrim(ind0.M_IND_LAB)
when 'CURR' then trn.M_BRW_NOMU1 end,
case 
when rtrim(trn.M_TRN_FMLY) = 'COM' then rtrim(qot0.M_LABEL)
when trn.M_TRN_GTYPE in (76,77,92) then rtrim(fxs.M_XPFWPRCQ)
when trn.M_TRN_GTYPE in (84) then rtrim(fxo.M_XPOPTFPQ) else null end,
rtrim(coalesce(cmu0.M_LABEL,fund.M_LABEL)),
rtrim(coalesce(pub0.M_LABEL, fxs.M_XPFWGROUP)),
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(coalesce(ghsr0.M_LABEL,lhsr.M_LABEL))
when 'CURR' then rtrim(fxs.M_XPFWCOL) else null end,
case trn.M_TRN_FMLY
when 'COM' then rtrim(ind1.M_IND_LAB)
when 'CURR' then trn.M_BRW_NOMU2 end,
rtrim(qot1.M_LABEL),
rtrim(cmu1.M_LABEL),
rtrim(pub1.M_LABEL),
rtrim(ghsr1.M_LABEL),
/*
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134,146,154) then to_char(dlv.M_CALC_FST,'YYYYMMDD') 
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
*/
trn.M_TRN_EXP,
trn.M_BRW_STRK,
trn.M_BRW_CP
