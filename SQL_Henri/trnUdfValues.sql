select distinct
rtrim(udf.M_PL_ASSIG) PL_ASG,
rtrim(udf.M_PL_ASSIG2) PL_ASG2 

from TABLE#DATA#DEALCURR_DBF udf
-- from TABLE#DATA#DEALCOM_DBF udf
-- from TABLE#DATA#DEALSCF_DBF udf
