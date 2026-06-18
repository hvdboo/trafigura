select
rtrim(purp.M_ID) COD,
rtrim(substr(purp.M_NAME,26,100)) LAB

from CLASS_MAPPING_DBF purp
where substr(purp.M_NAME,1,25) = 'mxContractITRADE_PURPOSE_'

order by LAB
