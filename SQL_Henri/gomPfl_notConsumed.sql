select 
rtrim(udf.M_STREAM) STREAM,
rtrim(pfl.M_LABEL)  PFLLAB,
case when rtrim(b.M_BPFOLIO) is null and rtrim(s.M_SPFOLIO) is null then 'NA' else 'A' end STAT,
pfl.M_REF PFLUID
--rtrim(b.M_BPFOLIO) B,
--rtrim(s.M_SPFOLIO) S

from TRN_PFLD_DBF pfl
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join (select distinct M_BPFOLIO from TRN_HDR_DBF) b on rtrim(pfl.M_LABEL) = rtrim(b.M_BPFOLIO)
left join (select distinct M_SPFOLIO from TRN_HDR_DBF) s on rtrim(pfl.M_LABEL) = rtrim(s.M_SPFOLIO)

where 1 = 1
and pfl.M_TYPE = 0
and pfl.M_REF not in (2,3,5,6,7,1723)
and substr(pfl.M_LABEL,1,4) not in ('ORDE','WASH')

order by STREAM, PFLLAB