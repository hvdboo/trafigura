drop view TRNEXC_GET;

create view TRNEXC_GET as 
(
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
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BENTITY) else rtrim(trn.M_SENTITY) end CE,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BTRADER) else rtrim(trn.M_STRADER) end USR,
case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end PFL,
case when trn.M_COMMENT_BS ='B' 
then case when trn.M_BINTERNAL = trn.M_SINTERNAL then rtrim(trn.M_SPFOLIO) else rtrim(ctp.M_DSP_LABEL) end
else case when trn.M_BINTERNAL = trn.M_SINTERNAL then rtrim(trn.M_BPFOLIO) else rtrim(ctp.M_DSP_LABEL) end end CTP,
rtrim(blb.M_BL) BLB, rtrim(blS.M_BL) BLS, 
rtrim(pflini.M_CHAR_VAL) PFLINI,
rtrim(ctpini.M_CHAR_VAL) CTPINI,
rtrim(udf.M_MIG_PTFSRC)  PFLSRC,
rtrim(udf.M_MIG_PTFDST)  PFLDST,
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
case when trn.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end
else rtrim(trn.M_COMMENT_BS) end BS,
rtrim(trn.M_COMMENT_BS) BSM,
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
left join MUREX_DM_OWNER.ACC_BL_MAP_REP blb on rtrim(trn.M_BPFOLIO) = blb.M_PTF
left join MUREX_DM_OWNER.ACC_BL_MAP_REP bls on rtrim(trn.M_SPFOLIO) = bls.M_PTF

/*-- Where clause depends on scope*/
where
trn.M_NB in
(
10949232,
10949234,
10949235,
10949327,
10963935,
10963939,
10963943,
10963944,
11063023,
11063024,
11063025,
11063028,
11088739,
11088740,
11088743,
11088744,
11093443,
11093446,
11093447,
11093448,
11425359,
11426190,
11426196,
11426199,
11426205,
11426225,
11426226,
11426227,
11426229,
11426230,
11426231,
11426232,
11426233,
11426240,
11426267,
11426276,
11426287,
11426295,
11426299,
11426301,
11426303,
11426304,
11426306,
11426311,
11426312,
11426314,
11426448,
11426486,
11426490,
11426499,
11426572,
11426573,
11426582,
11426585,
11426589,
11434731,
11434736,
11434747,
11434754,
11481540,
11481541,
11481542,
11481543,
11481544,
11481818,
11481819,
11481824,
11481829,
11486188,
11486189,
11486197,
11520435,
11520436,
11520437,
11520438,
11520441,
11520442,
11520443,
11520444,
11520445,
11520446,
11520447,
11520448,
11632184,
11632185,
11632186,
11638249,
11638251,
11638253,
11638256,
11638265,
11638266,
11638267,
11638268,
11638269,
11638270,
11638271,
11638383,
11638677,
11638678,
11638679,
11638680,
11638681,
11638682,
11638683,
11638684,
11638685,
11638687,
11638688,
11638689,
11797356,
11797359,
11797360,
11797364,
11797365,
11797366,
11797367,
11797368,
11797369,
11797370,
11797371,
11797372,
11849041,
11855603,
11856466,
11938368,
11938369,
11938370,
11938371,
11938374,
11938375,
11938378,
11938379,
11938380,
11938381,
11938508,
11938515,
11991496,
11991497,
11991500,
11991501,
11991529,
11991537,
11991540,
11991543,
11991546,
11991550,
11991553,
11991557,
11991559,
11991562,
11991563,
11991566,
11991569,
11991572,
11991575,
11991576,
11991597,
11991599,
11991880,
11991887,
12153867,
12153868,
12153869,
12153870,
12153973,
12153974,
12153975,
12153976,
12153977,
12153978,
12159967,
12159970,
12159971,
12159972,
12159975,
12159981,
12226496,
12226497,
12226498,
12226499,
12226500,
12226503,
12233019,
12233020,
12233026,
12233032,
12233331,
12233332,
12233333,
12233334,
12233335,
12233336,
12233337,
12233338,
12291834,
12291835,
12291836,
12291837,
12291838,
12291839,
12291840,
12291841,
12291842,
12291843,
12291844,
12291845,
12303832,
12303833,
12303834,
12303835,
12303836,
12303837,
12303838,
12303839,
12303840,
12303841,
12303842,
12303843,
12303857,
12303858,
12303859,
12310285,
12310286,
12310288,
12310289,
12310290,
12413843
)
-- order by TRN

);


