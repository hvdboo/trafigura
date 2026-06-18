select 
dic.COL,
dic.FLD,
dic.DES,
--rtrim(mapMxXml.TGTTBL) MXTBL,
rtrim(mapMxBuz.TGTCOL) MXCOL,
rtrim(mapMxBuz.TGTVALC) CMT

from gtddic dic
left join gtdmap mapMxBuz on rtrim(dic.FLD) = rtrim(mapMxBuz.SRCCOL) and (mapMxBuz.SRCSCH = 'GTDDIC' and mapMxBuz.SRCTBL = 'TRD' and mapMxBuz.TGTSCH = 'mxbuz')

where dic.CAT01 = 'TRD'
order by dic.SEQ