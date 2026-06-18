select distinct
to_char(pc.M_DATE,'YYYYMMDD') SYSDAT,
to_char(trn.M_TRN_DATE,'YYYYMMDD') TRNDAT,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE,
rtrim(substr(cla.M_NAME,26,30)) PURP,
rtrim(src.M_LABEL) SRC,
rtrim(evt.M_EVT_DLABEL) EVTLST,
trn.M_NB TRN, 
cnt.M_REFERENCE CNT,
cnt.M_VERSION   CVS,
cnt.M_PACK_REF  PCK,
trn.M_GID GID,
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn.M_COMMENT_BS) end DIR,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case when trn.M_COMMENT_BS ='B' 
then case when trn.M_BINTERNAL = trn.M_SINTERNAL then rtrim(trn.M_SPFOLIO) else rtrim(ctp.M_DSP_LABEL) end
else case when trn.M_BINTERNAL = trn.M_SINTERNAL then rtrim(trn.M_BPFOLIO) else rtrim(ctp.M_DSP_LABEL) end end CTP,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
(case trn.M_TRN_FMLY when 'COM' then rtrim(ass.M_LABEL) else rtrim(trn.M_TRN_FMLY) end) ASS,
rtrim(trn.M_TRN_FMLY)||'|'||rtrim(trn.M_TRN_GRP)||'|'||coalesce(rtrim(trn.M_TRN_TYPE),' ') FGT,
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
(trn.M_TRN_EXP - trn.M_TRN_DATE) CDTE,
(trn.M_TRN_EXP - trn.M_TRN_DATE - 2 * (to_char(trn.M_TRN_EXP,'WW') - to_char(trn.M_TRN_DATE,'WW'))) WDTE,
case when trn.M_TRN_FMLY = 'COM' then 
case when (trn.M_TRN_GTYPE in (100,101,102,103) and rtrim(pub.M_LABEL) = 'LME') then 
-- Cash
case when (trn.M_TRN_EXP - trn.M_TRN_DATE - 2 * (to_char(trn.M_TRN_EXP,'WW') - to_char(trn.M_TRN_DATE,'WW'))) in (2,3) then 'CASH' else
-- 3M
case when (trn.M_TRN_EXP - trn.M_TRN_DATE) in (90,91,92) then '3M' else
-- 3rd WED
case when to_date(trn.M_BRW_ODPL) = next_day(trunc(to_date(trn.M_BRW_ODPL,'DD-MON-YY'),'mm')-1,'Wednesday') + 14 then rtrim(substr(trn.M_BRW_ODPL,4,6)) 
else rtrim(trn.M_BRW_ODPL) end end end
else rtrim(trn.M_BRW_ODPL) end
else null end MAT,
rtrim(futmat.M_LABEL) FUTMAT, 
rtrim(optmat.M_LABEL) OPTMAT,
-- CFST1
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_FST,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD') 
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWFST,'YYYYMMDD') end CFST1,
-- CLST1
case 
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(dlv.M_CALC_LST,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_MATURITY0,'YYYYMMDD')
else to_char(trn.M_OPT_FLWLST,'YYYYMMDD') end CLST1,
-- CFST2
case  
when trn.M_TRN_GTYPE in (100,101,102,103,113,130,131,134, 146,154) then to_char(loan.M_START_DAT1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (76,77,84,92) then to_char(fxs.M_XPFWEXP,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2,5) then to_char(loan.M_START_DAT1,'YYYYMMDD')
else null end CFST2,
-- CLST2
case 
when trn.M_TRN_GTYPE in (130,154) then to_char(loan.M_MATURITY1-1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (100,101,102,103,113,134) then to_char(loan.M_MATURITY1,'YYYYMMDD')
when trn.M_TRN_GTYPE in (1,2) then to_char(loan.M_MATURITY1,'YYYYMMDD')
else null end CLST2,
-- STL
case when trn.M_TRN_GTYPE in (84) then to_char(trn.M_OPT_FLWFST,'YYYYMMDD') else to_char(trn.M_BRW_SDTE,'YYYYMMDD') end STL,
-- EXP
to_char(trn.M_TRN_EXP,'YYYYMMDD') EXP,
coalesce(trn.M_BRW_STRK,0) STK,
rtrim(trn.M_BRW_CP) RGT,
coalesce(fut.M_QTY,1) LOTSIZ,
case 
when trn.M_TRN_GTYPE in (130,131,154) then trn.M_BRW_NOM1/und.M_LOTSIZE
else trn.M_BRW_NOM1 end NOM1,
trn.M_BRW_NOM2 NOM2,
ABS(trn.M_BRW_NOM1)*coalesce(fut.M_QTY,1) QTY,
loan.M_REF_CAP0 CAPQTY,
dlv.M_TOT_QTY DLVQTY,
case when trn.M_TRN_GTYPE in (77) then fxs.M_XPFWPRC else trn.M_BRW_RTE1 end PRC1, 
trn.M_BRW_MRG1 MRG1,
trn.M_BRW_RTE2 PRC2,
trn.M_BRW_MRG2 MRG2

from MUREX_MX_OWNER.TRN_HDR_DBF trn
left join MUREX_MX_OWNER.TRN_PC_DBF pc on 1 = 1
left join MUREX_MX_OWNER.CLASS_MAPPING_DBF cla on trn.M_PURPOSE = cla.M_ID
left join MUREX_MX_OWNER.EVT_MAP_DBF evt on trn.M_MOP_LAST = evt.M_EVT_ID
left join MUREX_MX_OWNER.CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join MUREX_MX_OWNER.TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join MUREX_MX_OWNER.TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join MUREX_MX_OWNER.TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join MUREX_MX_OWNER.CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join MUREX_MX_OWNER.SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE
left join MUREX_MX_OWNER.TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join MUREX_MX_OWNER.TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join MUREX_MX_OWNER.CMT_PLKEY1_DBF plkey on trim(trn.M_PL_KEY1) = to_char(plkey.M_REFERENCE)
left join MUREX_MX_OWNER.CMT_DLV_DBF dlv on (trn.M_NB = dlv.M_NB and dlv.M_LEG_NB = 0)
left join MUREX_MX_OWNER.CM_ASSET_DBF ass on plkey.M_ASSET = ass.M_REFERENCE
left join MUREX_MX_OWNER.CM_FUT_DBF fut on plkey.M_FUTURE = fut.M_REFERENCE
left join MUREX_MX_OWNER.CM_FMAT1_DBF futmat on plkey.M_FUT_MAT = futmat.M_REFERENCE
left join MUREX_MX_OWNER.CM_OMAT1_DBF optmat on plkey.M_OPT_MAT = optmat.M_REFERENCE
left join MUREX_MX_OWNER.RT_INDEX_DBF ind on plkey.M_INDEX = ind.M_INDEX 
left join MUREX_MX_OWNER.CM_INDEX_DBF und on plkey.M_UNDL = und.M_REFERENCE
left join MUREX_MX_OWNER.CMC_QUOT_DBF qot on plkey.M_QUOT = qot.M_REFERENCE
left join MUREX_MX_OWNER.CM_MKT_DBF pub on qot.M_PUBLI= pub.M_REFERENCE
left join MUREX_MX_OWNER.CM_UNIT_DBF unq on qot.M_UNIT = unq.M_REFERENCE
left join MUREX_MX_OWNER.CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE
left join MUREX_MX_OWNER.RT_INDEX_DBF find on mgen.M_INDEX = find.M_INDEX
left join MUREX_MX_OWNER.CM_INDEX_DBF fund on find.M_COM_IND = fund.M_REFERENCE
left join MUREX_MX_OWNER.RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15)))
left join MUREX_MX_OWNER.RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join MUREX_MX_OWNER.RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join MUREX_MX_OWNER.CM_MKTSR_DBF ghsr on trim(substr(gen.M_FORMULA0,2,10)) = to_char(ghsr.M_SERIE)
left join MUREX_MX_OWNER.CM_MKTSR_DBF ghsr2 on trim(substr(gen.M_FORMULA1,2,10)) = to_char(ghsr2.M_SERIE)
left join MUREX_MX_OWNER.CM_MKTSR_DBF lhsr on trim(substr(loan.M_GEN_FRM,2,10)) = to_char(lhsr.M_SERIE)
left join MUREX_MX_OWNER.CM_PHYS_DBF phy on dlv.M_PHYSICAL = phy.M_REFERENCE
left join MUREX_MX_OWNER.FD111200_DBF fxs on trn.M_NB = fxs.M_NB
left join MUREX_MX_OWNER.FD111000_DBF fxo on trn.M_NB = fxo.M_NB
left join MUREX_MX_OWNER.NP_IDATA_DBF pflini on (trn.M_NB = pflini.M_SNAP_ID and rtrim(pflini.M_LABEL) = 'Portfolio (input)')
left join MUREX_MX_OWNER.NP_IDATA_DBF ctpini on (trn.M_NB = ctpini.M_SNAP_ID and rtrim(ctpini.M_LABEL) = 'Counterpart (input)')
left join MUREX_MX_OWNER.TRN_EXT_DBF ext on trn.M_NB = ext.M_TRADE_REF 
left join MUREX_MX_OWNER.TABLE#DATA#DEALCOM_DBF udf on ext.M_UDF_REF = udf.M_NB

/*-- Where clause depends on scope*/
where
trn.M_PURPOSE <> 'MeHzv70053'
-- and trn.M_TRN_STATUS <> 'DEAD'
and trn.M_MOP_LAST not in (6,7)
and to_char(trn.M_TRN_EXP,'YYYYMMDD') > '20211201'
and to_char(trn.M_TRN_EXP,'YYYYMMDD') < '20220110'
-- and trn.M_TRN_GTYPE in (113,134)
and trim(trn.M_INSTRUMENT) in
(
'8696',
'8697',
'8904',
'10995'
)
-- and (trn.M_BLENTITY in (1205) or trn.M_SLENTITY in (1205))
-- and (rtrim(trn.M_BPFOLIO) in ('BKOT MWI TICI','BKEX TRE PTEI') or rtrim(trn.M_SPFOLIO) in ('BKOT MWI TICI','BKEX TRE PTEI'))

order by TRN
