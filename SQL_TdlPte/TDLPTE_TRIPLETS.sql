select
SRC, TRN_ORI, TRN_TRF, PFL_ORI, PFL_TRF
from

(
select 

rtrim(typo.M_LABEL) TYPO,
rtrim(plin.M_DSP_LABEL) INS,
case when trn0.M_TRN_FMLY in ('COM','IRD') then rtrim(trn0.M_BRW_ODPL) else null end MAT,
to_char(trn0.M_TRN_EXP,'YYYYMMDD') EXP,
coalesce(trn0.M_BRW_STRK,0) STK,
rtrim(trn0.M_BRW_CP) CP,

-- Origin
rtrim(src.M_LABEL) SRC,
trn0.M_NB TRN_ORI,
cnt0.M_REFERENCE CNT_ORI,
cnt0.M_PACK_REF PCK_ORI,
rtrim(trn0.M_GID) GID_ORI,
case when trn0.M_BINTERNAL ='Y' then rtrim(trn0.M_BPFOLIO) else rtrim(trn0.M_SPFOLIO) end PFL_ORI,
case when trn0.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn0.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end 
else rtrim(trn0.M_COMMENT_BS) end BS_ORI,
rtrim(ctp0.M_DSP_LABEL) CTP_ORI,
-- Offset
trn1.M_NB TRN_OFF,
cnt1.M_REFERENCE CNT_OFF,
cnt1.M_PACK_REF PCK_OFF,
rtrim(trn1.M_GID) GID_OFF,
case when trn1.M_BINTERNAL ='Y' then rtrim(trn1.M_BPFOLIO) else rtrim(trn1.M_SPFOLIO) end PFL_OFF,
case when trn1.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn1.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end 
else rtrim(trn1.M_COMMENT_BS) end BS_OFF,
rtrim(ctp1.M_DSP_LABEL) CTP_OFF,
-- Transfer
trn2.M_NB TRN_TRF,
cnt2.M_REFERENCE CNT_TRF,
cnt2.M_PACK_REF PCK_TRF,
rtrim(trn2.M_GID) GID_TRF,
case when trn2.M_BINTERNAL ='Y' then rtrim(trn2.M_BPFOLIO) else rtrim(trn2.M_SPFOLIO) end PFL_TRF,
case when trn2.M_TRN_GTYPE in (1, 2, 130, 131, 134, 136, 146, 154) then
case trn2.M_BRW_PR1
when 'R' then 'B'
when 'P' then 'S' else null end 
else rtrim(trn2.M_COMMENT_BS) end BS_TRF,
rtrim(ctp2.M_DSP_LABEL) CTP_TRF

from TRN_HDR_DBF trn0
left join TRN_PC_DBF pc on 1 = 1
left join TRN_HDR_DBF trn1 on (to_char(trn0.M_NB) = rtrim(substr(trn1.M_GID,12,10)) and rtrim(substr(trn1.M_GID,8,3)) = 'OFF') and trn1.M_TRN_STATUS <> 'DEAD'
left join TRN_HDR_DBF trn2 on (to_char(trn0.M_NB) = rtrim(substr(trn2.M_GID,12,10)) and rtrim(substr(trn2.M_GID,8,3)) = 'TRF') and trn2.M_TRN_STATUS <> 'DEAD'
left join CONTRACT_DBF cnt0 on trn0.M_CONTRACT = cnt0.M_REFERENCE
left join CONTRACT_DBF cnt1 on trn1.M_CONTRACT = cnt1.M_REFERENCE
left join CONTRACT_DBF cnt2 on trn2.M_CONTRACT = cnt2.M_REFERENCE
left join TRN_CPDF_DBF ctp0 on trn0.M_COUNTRPART = ctp0.M_ID
left join TRN_CPDF_DBF ctp1 on trn1.M_COUNTRPART = ctp1.M_ID
left join TRN_CPDF_DBF ctp2 on trn2.M_COUNTRPART = ctp2.M_ID
left join TRN_CPDF_DBF ble on trn0.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn0.M_SLENTITY = sle.M_ID
left join CTP_TYPES_DBF ctyp on (ctp0.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join SRC_MOD_DBF src on cnt0.M_SRC_MODULE = src.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt0.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn0.M_INSTRUMENT = plin.M_REFERENCE

where 
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
and trn0.M_BINTERNAL <> trn0.M_SINTERNAL
and coalesce(ctyp.M_REF,0) = 0
and trn0.M_TRN_STATUS <> 'DEAD'
and trn0.M_TRN_EXP > PC.M_DATE
and trn0.M_TRN_GTYPE NOT IN (1,2)
and trn0.M_NB < 10406016

-- and rtrim(ctp0.M_DSP_LABEL) = ?
-- and trn0.M_NB = 9596144
)

where TRN_ORI in
(
 9733243,
 9733244,
10359176,
10359181,
10359186,
10359195,
10359200,
10359205,
10359211,
10359216,
10359221,
10396889,
10388236,
10396855,
10396845,
10396840,
10396850,
10378916,
10370702,
10378968,
10370707,
10372581,
10372589,
10372597,
10397270,
10388210,
10388222,
10388229,
10396866,
10396873,
10388243,
10388250,
10394220,
10394213,
10370687,
10370692,
10370697,
10376319,
10376326,
10376333,
10371558,
10371565
10371570
10371575
10371582
10371587
10371592
10371597
10370765
10370613
10370774
10370618
10370779
10370629
10371602
10405891
10397227
10396880
10371609
10397169
10394206
10397178
)