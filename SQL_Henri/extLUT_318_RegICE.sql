select
rtrim(tbl.M_ICE_PRDLAB) PRDLAB,
rtrim(tbl.M_ICE_PRDUID) PRDUID,
rtrim(tbl.M_ICE_PHY) CODPHY,
rtrim(tbl.M_ICE_LOG) CODLOG,
rtrim(tbl.M_ICE_SYM) SYM,
rtrim(tbl.M_ICE_GMI) GMI,
rtrim(tbl.M_ICE_MKTUID) MKTUID,
rtrim(tbl.M_ICE_MKTLAB) MKTLAB,
rtrim(tbl.M_ICE_GRP) GRP,
rtrim(tbl.M_ICE_MIC) MIC,
rtrim(tbl.M_ICE_CLRVEN) CLRVEN,
rtrim(tbl.M_ICE_CLRADM) CLRADM,
'>',
tbl.M_ICE_URL URL

from UDTB318_DBF tbl
order by PRDLAB