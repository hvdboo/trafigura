select *
from
(
select
-- rtrim(pfs.M_LABEL) PFL_SRC,
-- rtrim(pfd.M_LABEL) PFL_DST,
rtrim(pfs.M_LABEL) PFL,
to_char(trn.M_TRN_DATE,'YY-MM') MTHN,
to_char(trn.M_TRN_DATE,'MON-YY') MTHC,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(trn.M_COMMENT_BS) DIR,
rtrim(brk.M_CODE) CODE,
rtrim(ctp.M_DSP_LABEL) CTP,
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
left join SUCDEN suc on brk.M_NB = suc.TRD

where trn.M_NB in suc.TRD

group by 
rtrim(pfs.M_LABEL),
to_char(trn.M_TRN_DATE,'YY-MM'),
to_char(trn.M_TRN_DATE,'MON-YY'),
rtrim(plin.M_DSP_LABEL),
rtrim(trn.M_COMMENT_BS),
rtrim(brk.M_CODE), 
rtrim(ctp.M_DSP_LABEL), 
brk.M_CUR

order by PFL, MTHN, INS, CODE
)

-- where INS like '%LME%'

