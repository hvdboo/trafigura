
select
rtrim(ctp.M_DSP_LABEL) BRK_CTP,
trn.M_NB TRN,
to_char(trn.M_TRN_DATE,'YYYY-MM-DD') TRNDAT,
case when trn.M_COMMENT_BS = 'B' then rtrim(M_BPFOLIO) else rtrim(M_SPFOLIO) end PFL,
trn.M_TRN_GRP TYP,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(trn.M_BRW_ODPL) TEN,
trn.M_BRW_RTE1 PRC, 
trn.M_BRW_NOM1 QTY,

-- rtrim(pfs.M_LABEL) PFL_SRC,
-- rtrim(pfd.M_LABEL) PFL_DST,

rtrim(brk.M_CODE) BRK_COD,
brk.M_CUR BRK_CUR, 
brk.M_FEE BRK_AMT

from TRN_BROKER_DBF brk
left join TRN_PFLD_DBF pfs on brk.M_SRC_PFOLIO = pfs.M_REF 
left join TRN_PFLD_DBF pfd on brk.M_DST_PFOLIO = pfd.M_REF
left join TRN_CPDF_DBF ctp on brk.M_CNTRP = ctp.M_ID
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)

where brk.M_FEE <> 0
and trn.M_MOP_LAST not in (6, 7)
-- and trn.M_TRN_DATE >= (:DAT_FST)
-- and trn.M_TRN_DATE <= (:DAT_LST)
and rtrim(ctp.M_DSP_LABEL) in
(
'MACQUARIE BANK LIMITED',
'J.P. MORGAN FUTURES CO., LTD',
'J.P. MORGAN SECURITIES PLC',
'JPMORGAN CHASE BANK, N.A. (SINGAPOR',
'JPMORGAN CHASE BANK, NATIONAL ASSOC',
'JPMORGAN CORPORACION FINANCIERA S.A'
)
and rtrim(plin.M_DSP_LABEL) like '%LME%' 
-- group by rtrim(ctp.M_DSP_LABEL), rtrim(plin.M_DSP_LABEL), rtrim(brk.M_CODE), brk.M_CUR,
order by BRK_CTP, INS, TYP, TRN, BRK_COD
