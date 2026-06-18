select *
from
(
select
rtrim(pfs.M_LABEL) PFL_SRC,
-- rtrim(pfd.M_LABEL) PFL_DST,
rtrim(ctp.M_DSP_LABEL) CTP,
rtrim(brk.M_CODE) CODE,
brk.M_CUR CUR, 
sum(brk.M_FEE) AMT

from TRN_BROKER_DBF brk
left join TRN_PFLD_DBF pfs on brk.M_SRC_PFOLIO = pfs.M_REF 
left join TRN_PFLD_DBF pfd on brk.M_DST_PFOLIO = pfd.M_REF
left join TRN_CPDF_DBF ctp on brk.M_CNTRP = ctp.M_ID
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE

where brk.M_FEE <> 0
and trn.M_TRN_DATE >= (:DAT_FST)
and trn.M_TRN_DATE <= (:DAT_LST)
and trn.M_MOP_LAST not in (6, 7)
 
group by rtrim(pfs.M_LABEL), rtrim(ctp.M_DSP_LABEL), rtrim(brk.M_CODE), brk.M_CUR

order by PFL_SRC, CTP, CODE
)

where PFL_SRC in
(
'MCEX CWU TICI',
'MCEX CWU PTEI',
'MCEX CWU TDLI',
'MCEX KLI PTEI',
'MCEX KLI TICI',
'MCEX SLI PTEI',
'MCEX SLI TDLI',
'MCEX SLI TICI',
'MCEX VLI PTEI',
'MCEX VLI TDLI',
'MCEX VLI TICI',
'MCEX ZLI PTEI',
'MCEX ZLI TDLI',
'MCEX ZLI TICI',
'RMAR SLI PTEI',
'RMAR SLI TDLI',
'RMAR SLI TICI',
'RMAR VLI PTEI',
'RMAR VLI TDLI',
'RMAR VLI TICI',
'RMAR ZLI PTEI',
'RMAR ZLI TDLI',
'RMAR ZLI TICI'
)