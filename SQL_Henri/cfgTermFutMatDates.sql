
select
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
rtrim(fut.M_LABEL) FUT,
rtrim(matset.M_LABEL) MATSET,
rtrim(matdat.M_LABEL) MAT,
rtrim(vin.M_LABEL) VIN,
to_char(matdat.M_QT_START,'YYYY-MM-DD') QOTF,
to_char(matdat.M_QT_END,'YYYY-MM-DD') QOTL,
to_char(matdat.M_ST_START,'YYYY-MM-DD') DLVF,
to_char(matdat.M_ST_END,'YYYY-MM-DD') DLVL,
case matdat.M_BLK_TYPE
when -1 then 'Floating'
when  0 then 'Open'
when  1 then 'Day'
when  2 then 'Week'
when  3 then 'Month'
when  4 then 'Quarter'
when  5 then 'Season'
when  6 then 'Year'
when  7 then 'Week-end'
when  8 then 'Weekdays'
when  9 then 'Balmo' 
when 15 then 'Month 2nd BD'
else null end BUC,
matset.M_REFERENCE MATSETREF,
matdat.M_REFERENCE MATREF

from CM_FMAT1_DBF matdat
left join TRN_PC_DBF pc on 1 = 1
left join CM_FMAT_DBF matset on matdat.M_FMAT_ID = matset.M_REFERENCE
left join CM_FUT_DBF fut on matset.M_REFERENCE = fut.M_FUT_MAT 
left join CM_VINTAGE_PERIOD_DBF vinper on matdat.M_VINTAGE_PERIOD = vinper.M_REFERENCE
left join CM_VINTAGE_DBF vin on vinper.M_VINTAGE_REF = vin.M_REFERENCE

-- Instrument
where 1 = 1 
-- and matset.M_REFERENCE in (280)
--and substr(matset.M_LABEL,1,3) in ('CBT', 'CME', 'CMX', 'NMX')
-- and rtrim(fut.M_LABEL) = 'CU LME'

-- Expiry date
-- and matdat.M_BLK_TYPE in (3, 15)
and M_ST_START > pc.M_DATE -90
and to_char(M_ST_END,'YYYY-MM-DD') < '2028-12-01'

order by MATSET, FUT, M_ST_START
