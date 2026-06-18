select 
rtrim(lut.M_LABEL)      LUT,
rtrim(bdy.M_REGISTRLBL) REG,
rtrim(bdy.M_NDF)        NDF,
rtrim(bdy.M_SECDELIV)   SECDLV,
rtrim(bdy.M_CALLABLE)   CALLAB,
rtrim(bdy.M_MATURITY)   MATLAB,
rtrim(bdy.M_PATTERN_T)  PATTERN,
rtrim(bdy.M_GEN)        GEN,
rtrim(bdy.M_PRORATA)    PRORATA,
rtrim(bdy.M_FIXING)     FIXING,
rtrim(bdy.M_TYPOLOGY)   TYPO

from UDTB122_DBF bdy
left join UDTH122_DBF hdr on bdy.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH122'
