select 
rtrim(pfl.M_LABEL) PFLLAB,
pfl.M_REF PFLUID,
rtrim(b.M_BPFOLIO) B,
rtrim(s.M_SPFOLIO) S

from TRN_PFLD_DBF pfl
left join (select distinct M_BPFOLIO from TRN_HDR_DBF) b on rtrim(pfl.M_LABEL) = rtrim(b.M_BPFOLIO)
left join (select distinct M_SPFOLIO from TRN_HDR_DBF) s on rtrim(pfl.M_LABEL) = rtrim(s.M_SPFOLIO)