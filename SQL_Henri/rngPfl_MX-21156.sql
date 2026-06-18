update TRN_PFLD_DBF pfl
set M_ACCSECTION = 
(select udf.M_RMDCOD from TABLE#DATA#PORTFOLI_DBF udf where rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL))
where exists
(select udf.M_RMDCOD from TABLE#DATA#PORTFOLI_DBF udf where rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL))

