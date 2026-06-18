select 
dic.COL COL,
dic.FLD,
dic.DES,
rtrim(mapMxDyn.TGTTBL) MXTBL,
rtrim(mapMxDyn.TGTCOL) MXCOL,
rtrim(mapMxDyn.TGTVALC) CMT

from gtddic dic
left join gtdmap mapMxDyn on rtrim(dic.FLD) = rtrim(mapMxDyn.SRCCOL) and (mapMxDyn.SRCSCH = 'GTDDIC' and mapMxDyn.SRCTBL = 'PNL' and mapMxDyn.TGTSCH = 'mxdyn')

where dic.CAT01 = 'RES'
order by dic.SEQ