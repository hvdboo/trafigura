-- Datamart
select M_MX_REF_JOB, count (*) 
from TRAF_TDLPTE_REP
group by M_MX_REF_JOB

-- External trades
select count(*) 
from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join CTP_TYPES_DBF ctyp on (ctp.M_ID = ctyp.M_CTN and ctyp.M_REF = 16)
where 
(trn.M_BLENTITY = 1183 or trn.M_SLENTITY = 1183)
and trn.M_BINTERNAL <> trn.M_SINTERNAL
and coalesce(ctyp.M_REF,0) = 0
and trn.M_TRN_STATUS <> 'DEAD'
and TRN.M_TRN_EXP > PC.M_DATE
and TRN.M_TRN_GTYPE NOT IN (1,2)
-- and TRN.M_NB > 10406015;

-- Brokerage
select 
trn.M_GID, brk.* 
from TRN_BROKER_DBF brk
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
where substr(trn.M_GID,1,6) = 'TDLPTE';

-- TRN, Per Typo
select
trn.M_TRN_GTYPE FGTID,
trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE,
rtrim(typo.M_LABEL) TYPO, 
count(*)
from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
where trn.M_TRN_STATUS <> 'DEAD'
group by trn.M_TRN_GTYPE, trn.M_TRN_FMLY, trn.M_TRN_GRP, trn.M_TRN_TYPE, typo.M_LABEL;

-- TRN, Per Phase, Status
select
case 
when substr(trn.M_GID,1,6) <> 'TDLPTE' then 'ORI'
else substr(trn.M_GID,8,3) end PHASE,
cnt.M_STP_STATUS STP, count(*)
from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
where substr(trn.M_GID,1,6) = 'TDLPTE' and trn.M_TRN_STATUS <> 'DEAD'
group by 
case 
when substr(trn.M_GID,1,6) <> 'TDLPTE' then 'ORI'
else substr(trn.M_GID,8,3) end, 
cnt.M_STP_STATUS
order by PHASE, STP;

-- TRAF_TDLPTE
select 
-- PFL, SRC, 
count(*) 
from TRAF_TDLPTE 
group by PFL, SRC;




