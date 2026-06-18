select 
rtrim(lut.M_LABEL)      LUT,
rtrim(bdy.M_REGISTRLBL) REG,
rtrim(bdy.M_EXERCMODE)  EXR,
rtrim(bdy.M_ASSET)      ASS,
rtrim(bdy.M_EXOTICTYPE) EXOTIC,
rtrim(bdy.M_PROFILTYPE) PRF,
rtrim(bdy.M_NBFLOATING) NBFLT,
rtrim(bdy.M_ISSPREAD)   SPREAD,
rtrim(bdy.M_PATTERN)    PAT,
rtrim(bdy.M_PUBLICATIO) PUB,
rtrim(bdy.M_TYPOLOGY)   TYPO

from UDTB133_DBF bdy
left join UDTH133_DBF hdr on bdy.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH133'

union all

select
rtrim(lut.M_LABEL)      LUT,
rtrim(bdy.M_REGISTRLBL) REG,
'' EXR, ' ' ASS,
rtrim(bdy.M_CRIT)       EXOTIC,
'','','','','',
rtrim(bdy.M_TYPOLOGY)   TYPO

from UDTB134_DBF bdy
left join UDTH134_DBF hdr on bdy.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH134'
