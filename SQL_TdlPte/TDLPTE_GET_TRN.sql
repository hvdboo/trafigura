select distinct
to_char(pc.M_DATE,'YYYYMMDD') SYSDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
rtrim(src.M_LABEL) SRC,
trn.M_NB TRN,
cnt.M_REFERENCE CNT,
cnt.M_VERSION CVS,
cnt.M_PACK_REF PCK,
rtrim(trn.M_GID) GID,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
case when trn.M_BINTERNAL ='Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
rtrim(trn.M_TRN_FMLY)||'/'||rtrim(trn.M_TRN_GRP)||'/'||coalesce(rtrim(trn.M_TRN_TYPE),' ') FGT,
rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(fut.M_LABEL) FUT,
rtrim(coalesce(ind.M_IND_LAB,fxs.M_XPFWGROUP)) IND,
rtrim(coalesce(und.M_LABEL,fund.M_LABEL)) UND,
case 
when rtrim(trn.M_TRN_FMLY) = 'COM' then rtrim(qot.M_LABEL)
when trn.M_TRN_GTYPE in (77,92) then rtrim(fxs.M_XPFWPRCQ)
when trn.M_TRN_GTYPE in (84) then rtrim(fxo.M_XPOPTFPQ)
else null end QOT,
rtrim(pub.M_LABEL) PUB,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(coalesce(ghsr.M_LABEL,lhsr.M_LABEL))
when 'CURR' then rtrim(fxs.M_XPFWCOL)
else null end HSR,
case rtrim(trn.M_TRN_FMLY) 
when 'COM' then rtrim(ghsr2.M_LABEL)
else null end HSR2,
case when trn.M_TRN_FMLY = 'COM' then qot.M_CURR else trn.M_BRW_NOMU1 end CUR,
case when trn.M_TRN_FMLY = 'COM' then rtrim(unq.M_LABEL) else trn.M_BRW_NOMU2 end UOM,
case when trn.M_TRN_GTYPE in (84) then 
case fxo.M_XPINPON 
when 0 then trn.M_BRW_NOMU1 
when 1 then trn.M_BRW_NOMU2 end
else null end UOD,
rtrim(phy.M_LABEL) PHY,
case when trn.M_TRN_FMLY = 'COM' then 
case when (trn.M_TRN_GTYPE in (100,101,102,103) and rtrim(pub.M_LABEL) = 'LME') then 
case when trn.M_BRW_ODPL = '19-SEP-17' then 'CASH' else
case when trn.M_BRW_ODPL = '15-DEC-17' then '3M' else
case when to_date(trn.M_BRW_ODPL) = next_day(trunc(to_date(trn.M_BRW_ODPL,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(trn.M_BRW_ODPL,4,6)) 
else rtrim(trn.M_BRW_ODPL) end end end
else rtrim(trn.M_BRW_ODPL) end
else null end MAT,
rtrim(futmat.M_LABEL) FUTMAT, 
rtrim(optmat.M_LABEL) OPTMAT,
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_FST,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWFST,'YYYYMMDD') end CFST1,
case 
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_LST,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_MATURITY0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWLST,'YYYYMMDD') end CLST1,
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(loan.M_START_DAT1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT1,'YYYYMMDD')
else null end CFST2,
case 
when trn.M_TRN_GTYPE in (130,154) then to_char(loan.M_MATURITY1-1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (100,101,102,103,113,134) then to_char(loan.M_MATURITY1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2) then to_char(loan.M_MATURITY1,'YYYYMMDD')
else null end CLST2,
case when trn.M_TRN_GTYPE in (84) then to_char(trn.M_OPT_FLWFST,'YYYYMMDD') else to_char(trn.M_BRW_SDTE,'YYYYMMDD') end STL,
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP,
coalesce(trn.M_BRW_STRK,0) STK,
rtrim(trn.M_BRW_CP) CP,
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end 
else rtrim(trn.M_COMMENT_BS) end BS,
rtrim(trn.M_COMMENT_BS) BSM,
coalesce(fut.M_QTY,1) LOTSIZ,
case 
when trn.M_TRN_GTYPE in (130, 131,154) then trn.M_BRW_NOM1/und.M_LOTSIZE
else trn.M_BRW_NOM1 end NOM1,
trn.M_BRW_NOM2 NOM2,
ABS(trn.M_BRW_NOM1)*coalesce(fut.M_QTY,1) QTY,
loan.M_REF_CAP0 CAPQTY,
dlv.M_TOT_QTY DLVQTY,
case when trn.M_TRN_GTYPE in (77) then fxs.M_XPFWPRC else trn.M_BRW_RTE1 end PRC1, 
trn.M_BRW_MRG1 MRG1,
trn.M_BRW_RTE2 PRC2,
trn.M_BRW_MRG2 MRG2,
trn.M_TRN_GTYPE FGTID,
fut.M_REFERENCE FUTID,
ind.M_REFERENCE INDID,
qot.M_REFERENCE QOTID,
pub.M_REFERENCE PUBID, 
coalesce(lhsr.M_SERIE, ghsr.M_SERIE) HSRID,
case  
when trn.M_TRN_GTYPE in (100, 101, 102, 103, 113, 134, 146, 154) then 'H'||rtrim(ind.M_HISFILE)||'_H1S' 
when trn.M_TRN_GTYPE in (130, 131) then rtrim(substr(ind.M_HISFILE,1,8))||'_DBF'
else null end HISFIL,
fut.M_FUT_MAT MATSETID,
plkey.M_FUT_MAT FMATID,
plkey.M_OPT_MAT OMATID

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
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
left join CM_OMAT1_DBF optmat on plkey.M_OPT_MAT = optmat.M_REFERENCE
left join RT_INDEX_DBF ind on plkey.M_INDEX = ind.M_INDEX 
left join CM_INDEX_DBF und on plkey.M_UNDL = und.M_REFERENCE
left join CMC_QUOT_DBF qot on plkey.M_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI= pub.M_REFERENCE
left join CM_UNIT_DBF unq on qot.M_UNIT = unq.M_REFERENCE
left join CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE
left join RT_INDEX_DBF find on mgen.M_INDEX = find.M_INDEX
left join CM_INDEX_DBF fund on find.M_COM_IND = fund.M_REFERENCE
left join RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15)))
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join CM_MKTSR_DBF ghsr on trim(substr(gen.M_FORMULA0,2,10)) = to_char(ghsr.M_SERIE)
left join CM_MKTSR_DBF ghsr2 on trim(substr(gen.M_FORMULA1,2,10)) = to_char(ghsr2.M_SERIE)
left join CM_MKTSR_DBF lhsr on trim(substr(loan.M_GEN_FRM,2,10)) = to_char(lhsr.M_SERIE)
left join CM_PHYS_DBF phy on dlv.M_PHYSICAL = phy.M_REFERENCE
left join FD111200_DBF fxs on trn.M_NB = fxs.M_NB
left join FD111000_DBF fxo on trn.M_NB = fxo.M_NB
where
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
and trn.M_BINTERNAL <> trn.M_SINTERNAL
and coalesce(ctyp.M_REF,0) = 0
and trn.M_TRN_STATUS <> 'DEAD'
and trn.M_TRN_EXP > PC.M_DATE
and trn.M_TRN_GTYPE NOT IN (1,2)
and trn.M_NB not in
(
 9580582,
 9580604,
 9580607,
 9580617,
 9580625,
 9580633,
 9580641,
 9580653,
 9580657,
 9580665,
 9580669,
 9580681,
 9580689,
 9580701,
 9580708,
 9586365,
 9586387,
 9586553,
 9590098,
 9590772,
 9590878,
 9593486,
 9593493,
 9595415,
 9595433,
 9595506,
 9595923,
 9596144,
 9596189,
 9597614,
 9597650,
 9598105,
 9598519,
 9599378,
 9599382,
 9600908,
 9601343,
 9603112,
 9603135,
 9603658,
 9604811,
 9614970,
 9615478,
 9617788,
 9620576,
 9633354,
 9638830,
 9639144,
 9639188,
 9640613,
 9681511,
 9681586,
 9867773,
 9867780,
 9867786,
 9875232,
 9977494,
 9983775,
10036563,
10036572,
10036578,
10075219,
10114765,
10124399,
10124405,
10124427,
10152770,
10296989,
10324765,
10370457,
10370483,
10370607,
10416223,
10416237,
10454362,
10454384,
10463000,
10469399,
10480695,
10480701
)
