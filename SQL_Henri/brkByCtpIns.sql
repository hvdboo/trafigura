select *
from
(
select
-- rtrim(pfs.M_LABEL) PFL_SRC,
-- rtrim(pfd.M_LABEL) PFL_DST,
rtrim(ctp.M_DSP_LABEL) CTP,
to_char(trn.M_TRN_DATE,'YY-MM') MTHN,
to_char(trn.M_TRN_DATE,'MON-YY') MTHC,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(brk.M_CODE) CODE,
brk.M_CUR CUR, 
sum(brk.M_FEE) AMT

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
and rtrim(ctp.M_DSP_LABEL) = 'MACQUARIE BANK LIMITED'

group by 
rtrim(ctp.M_DSP_LABEL), 
to_char(trn.M_TRN_DATE,'YY-MM'),
to_char(trn.M_TRN_DATE,'MON-YY'),
rtrim(plin.M_DSP_LABEL), 
rtrim(brk.M_CODE), brk.M_CUR
order by CTP, MTHN, INS, CODE
)

where INS like '%LME%'

