select *
from
(
select
rtrim(trnpfs.M_LABEL) TRN_PFLSRC,
rtrim(trnpfd.M_LABEL) TRN_PFLDST,
rtrim(brkpfs.M_LABEL) BRK_PFLSRC,
-- rtrim(brkpfd.M_LABEL) BRK_PFLDST,
rtrim(ctp.M_DSP_LABEL) CTP,
rtrim(brk.M_CODE) CODE,
brk.M_CUR CUR, 
brk.M_VALUE_DATE,
brk.M_FEE,
trn.M_NB
-- sum(brk.M_FEE) AMT

from TRN_BROKER_DBF brk
left join TRN_PFLD_DBF brkpfs on brk.M_SRC_PFOLIO = brkpfs.M_REF 
left join TRN_PFLD_DBF brkpfd on brk.M_DST_PFOLIO = brkpfd.M_REF
left join TRN_CPDF_DBF ctp on brk.M_CNTRP = ctp.M_ID
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_PFLD_DBF trnpfs on trn.M_SRC_PFOLIO = trnpfs.M_REF 
left join TRN_PFLD_DBF trnpfd on trn.M_DST_PFOLIO = trnpfd.M_REF

where brk.M_FEE <> 0
and trn.M_TRN_DATE >= (:DAT_FST)
and trn.M_TRN_DATE <= (:DAT_LST)
and trn.M_MOP_LAST not in (6, 7)
 
-- group by rtrim(trnpfs.M_LABEL), rtrim(trnpfd.M_LABEL), rtrim(brkpfs.M_LABEL), rtrim(ctp.M_DSP_LABEL), rtrim(brk.M_CODE), brk.M_CUR, brk.M_VALUE_DATE

order by BRK_PFLSRC, CTP, CODE
)

where rtrim(BRK_PFLSRC) in
(
'MCEX BLE PTEI'
)