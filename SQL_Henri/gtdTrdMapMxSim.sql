select 
dic.COL,
dic.FLD,
dic.DES,
--rtrim(mapMxSim.TGTTBL) MXTBL,
rtrim(mapMxSim.TGTCOL) MXCOL,
rtrim(mapMxSim.TGTVALC) CMT

from gtddic dic
left join gtdmap mapMxSim on rtrim(dic.FLD) = rtrim(mapMxSim.SRCCOL) and (mapMxSim.SRCSCH = 'GTDDIC' and mapMxSim.SRCTBL = 'TRD' and mapMxSim.TGTSCH = 'mxsim')

where dic.CAT01 = 'TRD'
order by dic.SEQ