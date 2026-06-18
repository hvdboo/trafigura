select 
to_char(mpx.M__DATE_,'YYYY-MM-DD') DAT,
rtrim(mpx.M__ALIAS_) MDSET,
case mpx.M_EVALUATION
when 0 then 'Rate curve'
when 1 then 'Credit curve'
when 2 then 'Commodities'
when 3 then 'Hedge'
when 4 then 'Credit hedge'
when 5 then 'Inflation'
when 6 then 'Correlation' else null end NAT,
mpx.M_CURRENCY CUR, 
rtrim(rtc.M_DLABEL) CRV,
rtrim(mpy.M_TYPE) TYP, 
coalesce(rtrim(sec.M_SE_D_LABEL),coalesce(rtrim(gen.M_INSTR),rtrim(mpy.M_GENERAT))) GEN

from MPY_RTC_DBF mpy
left join MPX_RTC_DBF mpx on mpy.M__INDEX_ = mpx.M__INDEX_
left join TRN_PC_DBF bo on mpx.M__DATE_ = bo.M_DATE
left join RT_CT_DBF rtc on mpx.M_RT_KEY = rtc.M_REFERENCE
left join RT_INSGN_DBF gen on mpy.M_GENINTNB = gen.M_GEN_NUM
left join SE_HEAD_DBF sec on mpy.M_GENERAT = sec.M_SE_LABEL
where mpx.M__DATE_ = bo.M_DATE
and mpx.M_EVALUATION = 0
-- and mpx.M__ALIAS_ = 'RT'
-- and mpx.M_CURRENCY = 'CHF'
group by
mpx.M__DATE_, mpx.M__ALIAS_,
case mpx.M_EVALUATION
when 0 then 'Rate curve'
when 1 then 'Credit curve'
when 2 then 'Commodities'
when 3 then 'Hedge'
when 4 then 'Credit hedge'
when 5 then 'Inflation'
when 6 then 'Correlation' else null end,
mpx.M_CURRENCY, rtrim(rtc.M_DLABEL), 
rtc.M_REFERENCE,
rtrim(mpy.M_TYPE), 
coalesce(rtrim(sec.M_SE_D_LABEL),coalesce(rtrim(gen.M_INSTR),rtrim(mpy.M_GENERAT)))
order by DAT, MDSET, CUR, CRV, TYP, GEN