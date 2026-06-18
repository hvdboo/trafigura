
select 
brk.M_NB TRN,
case trn.M_COMMENT_BS
when 'B' then rtrim(M_BPFOLIO)
when 'S' then rtrim(M_SPFOLIO) else null end TRN_PFL,
rtrim(ctptrn.M_DSP_LABEL) TRN_CTP,
-- trn.M_MOP_LAST TRN_MOPLST,
brk.M_LINE FEE_LIN,
brk.M_AUTOF FEE_AUT,
case brk.M_TYPE 
when 0 then 'None'
when 1 then 'Broker fee'
when 2 then 'Broker tax'
when 3 then 'Clearer fee'
when 4 then 'Clearer tax'
when 5 then 'Internal fee'
when 6 then 'Client fee'
when 7 then 'CVA fee' else null end FEE_TYP,
rtrim(brk.M_CODE) FEE_COD,
rtrim(pfs.M_LABEL) FEE_SRC,
rtrim(pfd.M_LABEL) FEE_DST,
rtrim(ctpbrk.M_DSP_LABEL) FEE_CTP,
case brk.M_VALUE_TYPE
when -1 then 'No selection'
when 0 then 'Transaction'
when 1 then 'Settlement'
when 2 then 'Flow fst'
when 3 then 'Flow lst'
when 4 then 'Expiry'
when 5 then 'Delivery' else null end FEE_STLTYP,
to_char(brk.M_VALUE_DATE,'YYYY-MM-DD') FEE_STLDAT,
brk.M_CUR FEE_CUR, 
brk.M_FEE FEE_AMT,
rtrim(brk.M_COMMENT) FEE_CMT

from TRN_BROKER_DBF brk
left join TRN_PFLD_DBF pfs on brk.M_SRC_PFOLIO = pfs.M_REF
left join TRN_PFLD_DBF pfd on brk.M_DST_PFOLIO = pfd.M_REF
left join TRN_CPDF_DBF ctpbrk on brk.M_CNTRP = ctpbrk.M_ID 
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
left join TRN_CPDF_DBF ctptrn on trn.M_COUNTRPART = ctptrn.M_ID 

where brk.M_NB in 
(
select 
trn.M_NB
-- trn.M_TRN_GTYPE GTYP,
-- trn.M_INSTRUMENT INS_REF,
-- rtrim(plin.M_DSP_LABEL) INS_LAB, -- rtrim(plin.M_DESC) INS_DES,
-- rtrim(trn.M_MKT_INDEX) MKTNDX, rtrim(indmkt.M_IND_LAB) MKT_INDLAB,

-- count(case when trn.M_TRN_STATUS in ('LIVE','MKT_OP') then 1 else null end) LIVE, 
-- count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
-- count(*) OCC

from TRN_HDR_DBF trn
-- left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
-- left join RT_INDEX_DBF indmkt on trn.M_MKT_INDEX = indmkt.M_INDEX

where 
trn.M_TRN_STATUS <> 'DEAD'
-- and (rtrim(trn.M_BLENTITY) = 1204 or rtrim(trn.M_SLENTITY) = 1204 )
and trn.M_BLENTITY <> trn.M_SLENTITY
-- and trn.M_TRN_GTYPE in (100, 101)
and brk.M_FEE <> 0
and to_char(brk.M_VALUE_DATE,'YYYY-MM-DD') > '2022-10-01'
and brk.M_TYPE = 1
)