select
tbl.M_BUZCLA BUZCLA,
rtrim(tbl.M_BUZFLD) BUZFLD,
'>',
rtrim(tbl.M_BUZTIT) BUZTIT

from UDTB293_DBF tbl
