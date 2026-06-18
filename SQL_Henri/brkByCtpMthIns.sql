select *
from
(
select
-- rtrim(pfs.M_LABEL) PFL_SRC,
-- rtrim(pfd.M_LABEL) PFL_DST,
rtrim(ctp.M_DSP_LABEL) CTP,
to_char(trn.M_TRN_DATE,'YY-MM') MTHN,
to_char(trn.M_TRN_DATE,'MON-YY') MTHC,
rtrim(pfs.M_LABEL) PFL,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(trn.M_COMMENT_BS) DIR,
rtrim(brk.M_CODE) CODE,
brk.M_CUR CUR,
sum(trn.M_BRW_NOM1) LOTS,
sum(brk.M_FEE) BRKAMT,
count(*) OCC

from TRN_BROKER_DBF brk
left join TRN_PFLD_DBF pfs on brk.M_SRC_PFOLIO = pfs.M_REF 
left join TRN_PFLD_DBF pfd on brk.M_DST_PFOLIO = pfd.M_REF
left join TRN_CPDF_DBF ctp on brk.M_CNTRP = ctp.M_ID
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)

where 1 = 1
-- and brk.M_FEE <> 0
and trn.M_MOP_LAST not in (6, 7)
-- and trn.M_TRN_DATE >= (:DAT_FST)
-- and trn.M_TRN_DATE <= (:DAT_LST)
-- and brk.M_CNTRP = 1484
and rtrim(ctp.M_DSP_LABEL) like '%SUCDEN%'

group by 
rtrim(ctp.M_DSP_LABEL), 
to_char(trn.M_TRN_DATE,'YY-MM'),
to_char(trn.M_TRN_DATE,'MON-YY'),
rtrim(pfs.M_LABEL),
rtrim(plin.M_DSP_LABEL),
rtrim(trn.M_COMMENT_BS), 
rtrim(brk.M_CODE), 
brk.M_CUR

order by CTP, MTHN, INS, CODE
)

-- where INS like '%LME%'

