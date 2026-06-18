select
trn.M_NB TRN, udf.M_HR_ID HR

from TABLE#DATA#DEALCOM_DBF udf
left join TRN_EXT_DBF ext on udf.M_NB = ext.M_UDF_REF
left join TRN_HDR_DBF trn on ext.M_TRADE_REF = trn.M_NB 

where regexp_like(udf.M_HR_ID,'1176405')