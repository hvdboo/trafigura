update TRN_PFLD_DBF
set M_COMMENT0 = 'Technical'
where (M_REF in (2,3,5,6,7,1723) or substr(M_LABEL,1,4) in ('ORDE','WASH'))


