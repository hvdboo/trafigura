select 
dic.COL,
dic.FLD,
dic.DES,
rtrim(mapMxDbf.TGTTBL) MXTBL,
rtrim(mapMxDbf.TGTCOL) MXCOL,
rtrim(mapMxDbf.TGTVALC) CMT

from gtddic dic
left join gtdmap mapMxDbf on rtrim(dic.FLD) = rtrim(mapMxDbf.SRCCOL) and (mapMxDbf.SRCSCH = 'GTDDIC' and mapMxDbf.SRCTBL = 'TRD' and mapMxDbf.TGTSCH = 'mxdbf')

where dic.CAT01 = 'TRD'
order by dic.SEQ