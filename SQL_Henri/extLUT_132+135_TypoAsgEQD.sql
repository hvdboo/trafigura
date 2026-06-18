
select
rtrim(lut.M_LABEL)      LUT,
rtrim(bdy.M_SECURTYPE)  SECTYP_REG,
rtrim(bdy.M_COMPOUND)   COMPND,
rtrim(bdy.M_DIGITAL)    DIGITAL,
rtrim(bdy.M_TOTRETURN)  TOTRETURN,
rtrim(bdy.M_FWDSTART)   FWDSTART,
rtrim(bdy.M_FXOPT)      FXOPT,
rtrim(bdy.M_PAYOUTTYPE) PAYOUT,
rtrim(bdy.M_TYPOLOGY)   TYPO

from UDTB135_DBF bdy
left join UDTH135_DBF hdr on bdy.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH135'

union all

select 
rtrim(lut.M_LABEL)      LUT,
rtrim(bdy.M_REGISTRLBL) REG,
rtrim(bdy.M_CRIT)       CRIT,
'','','','','',
rtrim(bdy.M_TYPOLOGY)   TYPO

from UDTB132_DBF bdy
left join UDTH132_DBF hdr on bdy.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH132'
