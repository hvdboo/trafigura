select 
dic.COL,
dic.FLD,
dic.DES,
--rtrim(mapMxXml.TGTTBL) MXTBL,
rtrim(mapMxXml.TGTCOL) MXCOL,
rtrim(mapMxXml.TGTVALC) CMT

from gtddic dic
left join gtdmap mapMxXml on rtrim(dic.FLD) = rtrim(mapMxXml.SRCCOL) and (mapMxXml.SRCSCH = 'GTDDIC' and mapMxXml.SRCTBL = 'TRD' and mapMxXml.TGTSCH = 'mxxml')

where dic.CAT01 = 'TRD'
order by dic.SEQ