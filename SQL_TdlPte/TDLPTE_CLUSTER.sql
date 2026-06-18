select 
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) LE,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
case when ctyp.M_REF = 16 then 'I' else 'E' end CTP_IE, 
case when trn.M_BINTERNAL = trn.M_SINTERNAL 
then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL))
else rtrim(ctp.M_DSP_LABEL) end CTP,
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end LO,
/*
rtrim(src.M_LABEL) SRC,
(case when coalesce(cnt.M_PACK_REF,0) = 0 then 'N' else 'Y' end) PCK,
(case when trn.M_COMMENT_BS ='B' then rtrim(trn.M_BPFOLIO) else rtrim(trn.M_SPFOLIO) end) PFL,
trn.M_TRN_GTYPE,
trn.M_TRN_FMLY||trn.M_TRN_GRP||trn.M_TRN_TYPE FGT,
rtrim(plin.M_DSP_LABEL) INSTRUMENT,
*/
count(case when trn.M_TRN_STATUS = 'LIVE' then 1 else null end) LIVE, 
count(case when trn.M_TRN_STATUS = 'MKT_OP' then 1 else null end) MKT_OP,
count(*) TRADES,
count(case when substr(trn.M_GID,1,6) <> 'TDLPTE' then 1 else null end) ORI,
count(case when substr(trn.M_GID,8,3) = 'OFF' then 1 else null end) OFFS,
count(case when substr(trn.M_GID,8,3) = 'TRF' then 1 else null end) TRF

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join TRN_CPDF_DBF ble on trn.M_BLENTITY = ble.M_ID
left join TRN_CPDF_DBF sle on trn.M_SLENTITY = sle.M_ID
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE

where 
coalesce(ble.M_DSP_LABEL,sle.M_DSP_LABEL) in ('TDL')
-- (trn.M_BLENTITY in (1183,1200) or trn.M_SLENTITY in (1183,1200))
and trn.M_BINTERNAL <> trn.M_SINTERNAL
and coalesce(ctyp.M_REF,0) = 0
and trn.M_TRN_STATUS <> 'DEAD'
and trn.M_TRN_EXP > pc.M_DATE
and trn.M_TRN_GTYPE not in (1,2)
and trn.M_NB not in
(
 9580582,
 9580604,
 9580607,
 9580617,
 9580625,
 9580633,
 9580641,
 9580653,
 9580657,
 9580665,
 9580669,
 9580681,
 9580689,
 9580701,
 9580708,
 9586365,
 9586387,
 9586553,
 9590098,
 9590772,
 9590878,
 9593486,
 9593493,
 9595415,
 9595433,
 9595506,
 9595923,
 9596144,
 9596189,
 9597614,
 9597650,
 9598105,
 9598519,
 9599378,
 9599382,
 9600908,
 9601343,
 9603112,
 9603135,
 9603658,
 9604811,
 9614970,
 9615478,
 9617788,
 9620576,
 9633354,
 9638830,
 9639144,
 9639188,
 9640613,
 9681511,
 9681586,
 9867773,
 9867780,
 9867786,
 9875232,
 9977494,
 9983775,
10036563,
10036572,
10036578,
10075219,
10114765,
10124399,
10124405,
10124427,
10152770,
10296989,
10324765,
10370457,
10370483,
10370607,
10416223,
10416237,
10454362,
10454384,
10463000,
10469399,
10480695,
10480701
)

group by 
pc.M_DATE,
coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)),
(case when trn.M_BINTERNAL=trn.M_SINTERNAL then 'I' else 'E' end), 
ctyp.M_REF,
(case when trn.M_BINTERNAL = trn.M_SINTERNAL then coalesce(rtrim(ble.M_DSP_LABEL),rtrim(sle.M_DSP_LABEL)) else rtrim(ctp.M_DSP_LABEL) end),
case when trn.M_TRN_GTYPE in (49, 76, 100, 101, 136, 146) then 'LST' else 'OTC' end
-- trn.M_TRN_GTYPE, trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE,
-- plin.M_DSP_LABEL

order by LE, TRN_IE, CTP_IE, CTP, LO