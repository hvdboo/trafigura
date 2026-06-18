select rtrim(src.M_LABEL) LAB, rtrim(src.M_DESC) DES, src.M_REFERENCE ID
from SRC_MOD_DBF src
where src.M_REFERENCE < 1002
order by src.M_LABEL