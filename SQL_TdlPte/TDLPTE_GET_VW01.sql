drop view TDLPTE_VW01;

create view TDLPTE_VW01
(
TRN,
CNT,
PCK,
BS,
PR1,
PR2,
BLE,
SLE,
BINT,
BPFL,
SPFL,
PFL,
PFLS,
PFLD,
CTPID,
CTP
)

as

(
select 
trn.M_NB, 
cnt.M_REFERENCE,
cnt.M_PACK_REF,
trn.M_COMMENT_BS,
trn.M_BRW_PR1,
trn.M_BRW_PR2,
trn.M_BLENTITY,
trn.M_SLENTITY,
trn.M_BINTERNAL,
trn.M_BPFOLIO,
trn.M_SPFOLIO,
case trn.M_BINTERNAL when 'Y' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end,
trn.M_SRC_PFOLIO,
trn.M_DST_PFOLIO,
trn.M_COUNTRPART,
rtrim(ctp.M_DSP_LABEL)
from TRN_HDR_DBF trn  
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
where 
coalesce(cnt.M_PACK_REF,0) > 0
and trn.M_COUNTRPART = 1183
)
