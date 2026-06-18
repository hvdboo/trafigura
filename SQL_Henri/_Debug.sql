-- HDR
select M_MKT_INDEX, M_NB
from TRN_HDR_DBF
where rtrim(M_MKT_INDEX) = '    573     730'
order by M_MKT_INDEX, M_NB

-- LOAN
select M_GEN_IND, M_NB
from RT_LOAN_DBF
where rtrim(M_GEN_IND) = '    573     730'
order by M_GEN_IND, M_NB

-- GRPI
select *
from CMG_GRPI_DBF grpi
left join TRN_PC_DBF pc on  1 = 1
where grpi.M__DATE_ = pc.M_DATE

-- INDP
select * 
from CMG_INDP_DBF inp
left join TRN_PC_DBF pc on  1 = 1
where inp.M__DATE_ = pc.M_DATE

select *
from CMG_GRP_DBF grp
left join TRN_PC_DBF pc on  1 = 1
where grp.M__DATE_ = pc.M_DATE

-- MGEN
select *
from CMC_MGEN_DBF gen
