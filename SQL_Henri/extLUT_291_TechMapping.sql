select

rtrim(tbl.M_SRCSCH) SRCSCH,
rtrim(tbl.M_SRCTBL) SRCTBL,
rtrim(tbl.M_SRCCOL) SRCCOL,
tbl.M_SRCVALN       SRCVALN,
rtrim(tbl.M_SRCVALC)SRCVALC,
'>',
rtrim(tbl.M_TGTSCH) TGTSCH,
rtrim(tbl.M_TGTTBL) TGTTBL,
rtrim(tbl.M_TGTCOL) TGTCOL,
tbl.M_TGTVALN       TGTVALN,
rtrim(tbl.M_TGTVALC) TGTVALC

from UDTB291_DBF tbl
order by SRCSCH, SRCTBL, SRCCOL