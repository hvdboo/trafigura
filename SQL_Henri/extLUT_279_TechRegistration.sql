select
rtrim(tbl.M_REG_CLALAB) CLASS,
-- rtrim(tbl.M_REG_CLAUID) CLAUID,
tbl.M_REG_FGT           FGT,
rtrim(tbl.M_REG_FML)    FML,
rtrim(tbl.M_REG_GRP)    GRP,
rtrim(tbl.M_REG_TYP)    TYP,
case tbl.M_REG_CLAUID when '1.238' then '' else rtrim(tbl.M_REG_DES) end DES,
rtrim(tbl.M_REG_FCC)    FCC,
rtrim(M_REG_COD)        COD,
rtrim(M_REG_LO)         LO

from UDTB279_DBF tbl

order by FML, CLASS, GRP, TYP
