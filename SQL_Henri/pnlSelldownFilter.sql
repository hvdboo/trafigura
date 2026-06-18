select
rtrim(sd.M_LABEL) RULE,
rtrim(flt.M_SNAME) FLT,
rtrim(flt.M_SDESC) FLTDES,
rtrim(substr(fltval.M_ID,8,10)) FLTOBJ, 
rtrim(fltval.M_FLDNAME) FLTVAL

from REPBATCH#TRN_DYSC_DBF fltval
left join REPBATCH#TRN_DYSD_DBF flt on rtrim(fltval.M_VALUE) = rtrim(flt.M_SNAME)
left join SD_CFG_DBF sd on rtrim(flt.M_SNAME) = rtrim(sd.M_FILTER)
where substr(fltval.M_VALUE,1,3) = 'SDN'

union 

select
rtrim(sd.M_LABEL) SDN,
rtrim(flt.M_SNAME) FLT,
rtrim(flt.M_SDESC) FLTDES,
'_HDR.EXP' FLTOBJ, 
rtrim(hdrexp.M_FMLA_TEXT) FLTVAL

from REPBATCH#TRN_DYSC_DBF fltval
left join REPBATCH#TRN_DYSD_DBF flt on rtrim(fltval.M_VALUE) = rtrim(flt.M_SNAME)
left join SD_CFG_DBF sd on rtrim(flt.M_SNAME) = rtrim(sd.M_FILTER)
left join SFVFLTM_DBF hdrflt on rtrim(flt.M_FLTLAB1) = rtrim(hdrflt.M_LABEL)
left join SFVFLTS_DBF hdrexp on hdrflt.M_ID = hdrexp.M_ID
where substr(fltval.M_VALUE,1,3) = 'SDN'

order by RULE, FLT, FLTOBJ
