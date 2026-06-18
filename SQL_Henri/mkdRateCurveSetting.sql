select 
to_char(mpx.M__DATE_,'YYYY-MM-DD') DAT, 
rtrim(mpx.M__ALIAS_) MDS,
case mpx.M_EVALUATION
when 0 then 'Rate curve'
when 1 then 'Credit curve'
when 2 then 'Commodities'
when 3 then 'Hedge'
when 4 then 'Credit hedge'
when 5 then 'Inflation'
when 6 then 'Correlation' else null end NAT,
mpx.M_CURRENCY CUR, rtrim(rtc.M_DLABEL) CRV,
case mpx.M_CURVE_USAGE
when -1 then 'Inherited'
when  0 then 'Zero coupon'
when  1 then 'Forward' else null end CALVAL,
case mpx.M_MODEL
when -1 then 'Inherited'
when  0 then 'Murex Model'
when 50 then 'Prior Absolute Minimization'
when 51 then 'MxEnhanced'
when 52 then 'Interpolated'
when 53 then 'Smooth Curve'
when 54 then 'Step Wise'
when 55 then 'Prior Relative Minimization'
when 56 then 'Mx Base Correl'
when 57 then 'Interpolated Yield'
when 58 then 'Nelson Siegel'
when 59 then 'Prior Vertical Translation'
when 60 then 'Flow Calibration' else null end MODEL,
case mpx.M_INTERPOL
when -1 then 'Inherited'
when  0 then 'Murex Linear'
when  1 then 'Murex Spline'
when  2 then 'Seasonal Additive'
when  3 then 'Seasonal Multiplicative'
when 50 then 'MxEnhanced Linear'
when 51 then 'Fwd Quartic'
when 52 then 'Fwd Linear'
when 53 then 'Cubic Spline'
when 54 then 'Exp Spline'
when 55 then 'Constrained Cubic Spline'
when 56 then 'BackwardScale'
when 57 then 'ForwardScale'
when 58 then 'Quadratic'
when 59 then 'Polynomial'
when 60 then 'MxEnhanced Spline'
when 61 then 'Adaptive Spline'
when 62 then 'Hermite Spline'
when 63 then 'Nelson Siegel Continuous'
when 64 then 'Nelson Siegel Discrete'
when 65 then 'LME'
when 66 then 'Monotone Convexe'
when 67 then 'Constant Piece Wise'
when 68 then 'Log Linear'
when 69 then 'OIS'
when 70 then 'Linear Cubic Spline'
when 71 then 'Log Cap Cubic Spline'
when 72 then 'Gantz' else null end INTERPOL_FRM,
case mpx.M_INTERPOL2
when -1 then 'Inherited'
when  0 then 'rate'
when  1 then 'rate*time' 
when  2 then 'cap.Factor'
when  5 then 'disc.Factor'
when  6 then 'log(factor)'
when  8 then 'swap point' else null end INTERPOL_VAL,
case mpx.M_FIRST_INT
when -1 then 'Inherited'
when  0 then 'Flat'
when  1 then 'Extrapolate'
when  2 then 'Extrapolate F(0)=0' else null end INT_BEFFST,
case mpx.M_LAST_INT
when -1 then 'Inherited'
when  0 then 'Flat'
when  1 then 'Extrapolate' else null end INT_AFTLST,
case mpx.M_CONV
when -1 then 'Inherited' else rtrim(zrtcnv.M_RATE_CONV) end ZRT_CNV,
case mpx.M_FUTURES
when -1 then 'Inherited'
when  0 then 'Standard interpolation'
when  1 then 'No intermediate interpolation' else null end FUTURES,
case mpx.M_BLOCK
when -1 then 'Inherited'
when  0 then 'maturity date'
when  1 then 
case mpx.M_BLOCKDATE
when  0 then 'blocks according Maturity'
when  1 then 'blocks according First date'
when  2 then 'blocks according First date + stub' else null end
when  2 then 'periods' else null end PRIOPILL,
case mpx.M_FREDIFINED
when -1 then 'Inherited'
when  0 then 'From Currency'
when  1 then rtrim(fwdcnv.M_RATE_CONV) else null end FWD_CNV,
case mpx.M_ZCSPREAD
when -1 then 'Inherited'
when  0 then 'Absolute'
when  1 then 'Percentage' else null end ZC_SPRD,
case mpx.M_RT_IGN_FIX
when -1 then 'Inherited'
when  0 then 'No'
when  1 then 'Today'
when  2 then 'All'
when  3 then 'No-Apply last known' else null end IGNFIX,
case mpx.M_GEN_NEWT
when -1 then 'Inherited'
when  0 then 'Standard'
when  1 then 'Curve assignments'
when  2 then 'Estimation yes' else null end CALIB,
case mpx.M_BUSINESS_D
when -1 then 'Inherited'
when  0 then 'None'
when  1 then 'Calendar '||rtrim(cal.M_LABEL)
when  2 then 'Shifter' else null end BUZDAYS,
case mpx.M_SPREADC
when -1 then 'Inherited'
when  0 then 'None'
when  1 then 'ZC+S'
when  2 then 'Rate+S'
when  3 then 'Rate*S'
when  4 then 'Disc(ZC)*Disc(S)' else null end SPRCRV,
case mpx.M_HEDGEC
when -1 then 'Inherited'
when  0 then 'No'
when  1 then 'Curve  '||rtrim(hdgcrv.M_DLABEL)
when  2 then 'Pillar set  '||rtrim(hdgpil.M_LABEL) else null end HDG,
case mpx.M_DEF_ENTRY
when -1 then 'Inherited'
when  0 then 'market rates'
when  1 then 'FX swap points'
when  2 then 'zero coupons' else null end DFLT,
case mpx.M_MAT_GAP
when -1 then 'Inherited'
when  0 then rtrim(mpx.M_MAT_GAP_SHFT)
else to_char(mpx.M_MAT_GAP,'99') end MATGAP,
case mpx.M_SNAP_GEN
when -1 then 'Inherited'
when  0 then 'Never'
when  1 then 'After save' else null end SNAPGEN,
case mpx.M_CLASSIF
when -1 then 'Inherited'
when  0 then 'Default'
when  1 then 'Hedge  '||rtrim(hdgund.M_DLABEL) else null end CLASS,
case mpx.M_CAL_METH
when -1 then 'Inherited'
when  0 then 'Global Newton'
when  1 then 'Newton by pillar'
when  2 then 'Interpolation'
when  3 then 'BPV Weighted' else null end CALMTH,
case mpx.M_CHK_CONST
when -1 then 'Inherited'
when  0 then 'Stop calibration'
when  1 then 'Ignore'
when  2 then 'Interpolate' else null end CALINCO,
case mpx.M_HCAL_METH
when -1 then 'Inherited'
when  0 then 'Global Newton'
when  1 then 'Newton by pillar'
when  2 then 'Interpolation'
when  3 then 'BPV Weighted' else null end HDGCALMTH,
case mpx.M_HCHK_CONST
when -1 then 'Inherited'
when  0 then 'Stop calibration'
when  1 then 'Ignore'
when  2 then 'Interpolate' else null end HDGCALINCO,
case mpx.M_CAL_TOLE
when -1 then 'Inherited'
else to_char(mpx.M_CAL_TOLE,'90.99999999') end CALTOL,
case mpx.M_CAL_ITER
when -1 then 'Inherited'
else to_char(mpx.M_CAL_ITER,'99') end CALITR,
case mpx.M_ZERO_RATES
when -1 then 'Inherited'
when  0 then 'No'
when  1 then 'Yes' else null end ZERORT,
case mpx.M_SEASONALIT
when -1 then 'Inherited'
when  0 then 'None'
when  1 then 'Multiplicative'
when  3 then 'Turns' else null end SEASON,
case mpx.M_PILLAR_DAT
when -1 then 'Inherited'
when  1 then 'Last Flow'
when  2 then 'Last Discount' else null end PILMAT,
case mpx.M_FXPAR_CONV
when -1 then 'Inherited'
when  0 then 'Equivalent Deposit'
when  1 then 'Fx Instrument' else null end FXPAR,
case mpx.M_SP_REF_CCY
when '-1' then 'Inherited'
else mpx.M_SP_REF_CCY||' - '||rtrim(swpcrv.M_DLABEL) end SWPCUR
from MPX_RTC_DBF mpx
left join TRN_PC_DBF bo on mpx.M__DATE_ = bo.M_DATE
left join RT_CT_DBF rtc on mpx.M_RT_KEY = rtc.M_REFERENCE
left join RT_CONV_DBF zrtcnv on mpx.M_CONV = zrtcnv.M_REFERENCE
left join RT_CONV_DBF fwdcnv on mpx.M_FWDCONV = fwdcnv.M_REFERENCE
left join CAL_DEF_DBF cal on mpx.M_BUSNSD_CAL = cal.M_REFERENCE
left join RT_CT_DBF hdgcrv on (mpx.M_HED_CURVE = hdgcrv.M_LABEL and hdgcrv.M_EVALUATION = 3 and mpx.M_CURRENCY = hdgcrv.M_CURRENCY)
left join MATSET_DBF hdgpil on mpx.M_HED_PILSET = hdgpil.M_LABEL 
left join RT_CT_DBF hdgund on (mpx.M_H_UND_CURVE = hdgund.M_REFERENCE and hdgund.M_EVALUATION = 0 and mpx.M_CURRENCY = hdgund.M_CURRENCY)
left join RT_CT_DBF swpcrv on (mpx.M_SP_REF_CURVE = swpcrv.M_REFERENCE and swpcrv.M_EVALUATION = 0 and mpx.M_SP_REF_CCY = swpcrv.M_CURRENCY)
where mpx.M__DATE_ = bo.M_DATE
and mpx.M_EVALUATION = 0
-- and mpx.M_CURRENCY = 'CHF'
-- and mpx.M__ALIAS_ = 'RT'
order by DAT, MDS, NAT, CUR, CRV