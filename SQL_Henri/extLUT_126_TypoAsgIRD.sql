select 
rtrim(lut.M_LABEL)      LUT,
rtrim(bdy.M_REGISTRLBL) REG,
rtrim(bdy.M_CRIT)       CRIT,
rtrim(bdy.M_OPT)        OPT,
rtrim(bdy.M_PAYOUTTYPE) PAYOUT,
rtrim(bdy.M_TYPOLOGY)   TYPO

from UDTB126_DBF bdy
left join UDTH126_DBF hdr on bdy.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH126'
