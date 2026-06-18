select
to_char(mpx.M__DATE_,'YYYY-MM-DD') MKDDAT,
to_char(mpi.M_U_DATE0,'YYYY-MM-DD') UPDDAT,
rtrim(mpx.M__ALIAS_) MDS,
case mpx.M_EVALUATION
when 0 then 'Rate curve'
when 1 then 'Credit curve'
when 2 then 'Commodities'
when 3 then 'Hedge'
when 4 then 'Credit hedge'
when 5 then 'Inflation'
when 6 then 'Correlation' else null end NAT,
mpx.M_CURRENCY CUR,
-- rtrim(mpx.M_LABEL) CRV_,
rtrim(rtc.M_DLABEL) CRV,
rtrim(mpy.M_TYPE) TYP,
-- rtrim(mpy.M_GENERAT) GEN_,
coalesce(rtrim(sec.M_SE_D_LABEL),coalesce(rtrim(gen.M_INSTR),rtrim(mpy.M_GENERAT))) GEN,
rtrim(mpi.M_LABEL) MATLAB,
to_char(mpi.M_DATE,'YYYY-MM-DD') MATDAT,
to_char(mpi.M_BID0,'990.99999') BID,
to_char(mpi.M_ASK0,'990.99999') ASK,
mpy.M_SEED DSCRTE
-- mpy.M_RT_KEY KEY_

from MPX_RTC_DBF mpx
left join TRN_PC_DBF pc on 1 = 1
-- left join TRN_DSKD_DBF dsk on 1 = 1 and rtrim(dsk.M_LABEL) = 'FO EMEA'
left join RT_CT_DBF rtc on mpx.M_RT_KEY = rtc.M_REFERENCE
left join MPY_RTC_DBF mpy on mpx.M__INDEX_ = mpy.M__INDEX_
left join MPX_IN_DBF mpi on (mpx.M__DATE_ = mpi.M__DATE_ and mpx.M__ALIAS_ = mpi.M__ALIAS_ and mpx.M_CURRENCY = mpi.M_CURRENCY and mpy.M_TYPE = mpi.M_TYPE and mpy.M_GENERAT = mpi.M_GENERAT and mpy.M_LABEL_D = mpi.M_LABEL)
left join RT_INSGN_DBF gen on mpy.M_GENINTNB = gen.M_GEN_NUM
left join SE_HEAD_DBF sec on mpy.M_GENERAT = sec.M_SE_LABEL

where 1 = 1
and mpx.M__ALIAS_ = 'LANA MDS'
and mpx.M__DATE_ = pc.M_DATE
and mpx.M_EVALUATION = 0
and mpx.M_CURRENCY = 'USD'
and rtrim(mpx.M_LABEL) = 'USD :Std'
and mpi.M_DATE >= mpx.M__DATE_
and mpi.M_U_DATE0 > (mpx.M__DATE_ - 14)
and mpi.M_BID0 <> 0
order by CUR, CRV, MATDAT

