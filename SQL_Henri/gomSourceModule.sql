select src.M_LABEL LAB, src.M_DESC DES, src.M_REFERENCE ID
from SRC_MOD_DBF src
where src.M_REFERENCE = 1 or src.M_REFERENCE > 1000
order by src.M_LABEL