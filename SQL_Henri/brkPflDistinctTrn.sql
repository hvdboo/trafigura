select 
TRN, 
PFL_SRC, PFL_TRN, 
CUR, FEE,
MOP

from
(
select 
brk.M_NB TRN,
rtrim(pfs.M_LABEL) PFL_SRC,
rtrim(pfd.M_LABEL) PFL_DST,
case trn.M_COMMENT_BS
when 'B' then rtrim(M_BPFOLIO)
when 'S' then rtrim(M_SPFOLIO) else null end PFL_TRN,
brk.M_CUR CUR, brk.M_FEE FEE,
trn.M_MOP_LAST MOP

from TRN_BROKER_DBF brk
left join TRN_PFLD_DBF pfs on brk.M_SRC_PFOLIO = pfs.M_REF
left join TRN_PFLD_DBF pfd on brk.M_DST_PFOLIO = pfd.M_REF
left join TRN_HDR_DBF trn on (brk.M_NB = trn.M_NB and trn.M_TRN_GTYPE = 100)

--where rtrim(pfs.M_LABEL) <> rtrim(coalesce(M_BPFOLIO, M_SPFOLIO))
)

where 
PFL_SRC <> PFL_TRN
and FEE <> 0
and MOP not in (6, 7)
