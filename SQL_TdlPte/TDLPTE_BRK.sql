select
brk.M_NB TRN_ORI, trn.M_TRN_STATUS STAT,
trn.M_TRN_GTYPE FGTID, 
rtrim(trn.M_TRN_FMLY)||'/'||rtrim(trn.M_TRN_GRP)||'/'||coalesce(rtrim(trn.M_TRN_TYPE),' ') FGT,
rtrim(typo.M_LABEL) TYPO,
trnt.M_NB TRN_TRF, rtrim(trnt.M_GID) GID,
greatest(trn.M_BLENTITY,trn.M_SLENTITY) LE,
rtrim(greatest(trn.M_BPFOLIO,trn.M_SPFOLIO)) TRN_PFL,
rtrim(pfls.M_LABEL) BRK_SPFL, rtrim(pfld.M_LABEL) BRK_DPFL,
rtrim(ctp.M_DSP_LABEL) BROKER,
brk.M_AUTOF BRK_AUT, brk.M_CODE BRK_COD,
brk.M_FEE BRK_AMT, brk.M_CUR BRK_CUR,
to_char(brk.M_VALUE_DATE,'DD-MON-YY') BRK_STL,
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT
from TRN_BROKER_DBF brk
left join TRN_PC_DBF pc on 1 = 1
left join TRN_HDR_DBF trn on brk.M_NB = trn.M_NB
left join TRN_PFLD_DBF pfls on brk.M_SRC_PFOLIO = pfls.M_REF
left join TRN_PFLD_DBF pfld on brk.M_DST_PFOLIO = pfld.M_REF
left join TRN_CPDF_DBF ctp  on brk.M_CNTRP = ctp.M_ID
left join TRN_HDR_DBF trnt on (to_char(brk.M_NB) = trim(substr(trnt.M_GID,12,10)) and substr(trnt.M_GID,8,3) = 'TRF')
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
where 
brk.M_VALUE_DATE > pc.M_DATE
and brk.M_FEE > 0
and (trn.M_BLENTITY = 1200 or trn.M_SLENTITY = 1200)
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') > '2017-09-08'
and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') < '2017-09-18'
and trn.M_TRN_STATUS <> 'DEAD'
order by BRK_SPFL, BROKER, BRK_STL;

