UPDATE TRN_HDR_DBF trn
SET (trn.M_BSTRATEGY) = 
(
select udf.BSTG 
from UDF_UPDATE_DBF udf
where trn.M_NB = udf.TRN
)
WHERE EXISTS (SELECT 1 FROM UDF_UPDATE_DBF udf WHERE trn.M_NB = udf.TRN and trim(udf.BSTG) is not null);

UPDATE TRN_HDR_DBF trn
SET (trn.M_SSTRATEGY) = 
(
select udf.SSTG 
from UDF_UPDATE_DBF udf
where trn.M_NB = udf.TRN
)
WHERE EXISTS (SELECT 1 FROM UDF_UPDATE_DBF udf WHERE trn.M_NB = udf.TRN and trim(udf.SSTG) is not null);

