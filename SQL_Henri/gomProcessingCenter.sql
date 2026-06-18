select 
rtrim(pc.M_LABEL) LABEL, 
rtrim(pc.M_DESC) DESCRIPTION, 
rtrim(wfl.M_LABEL) PROC_TMPL, 
rtrim(pc.M_CWF_TRIG) EVT_TRIG,
case pc.M_ACTIVITY
when  0  then 'Inherited from FOD/PC'
when  1  then 'Interest rate'
when  2  then 'Bond'
when  3  then 'Currency'
when  4  then 'Commodity'
when  5  then 'Equity'
when  6  then 'Security options'
when  7  then 'Credit'
when  8  then 'Risk management'  end as ACTIVITY,
rtrim(ent.M_LABEL) CLS_ENTITY, 
rtrim(stg.M_LABEL) SETTING, 
rtrim(calc.M_CFGLABEL) CALC_TMPL, 
rtrim(dlv.M_LABEL) DLV_SET,
rtrim(pc.M_EOD_SHIFT) EOD_SHIFT, 
rtrim(pc.M_CALENDAR) EOD_CAL, 
pc.M_HBTEOD EOD_HOUR

from TRN_PC_DBF  pc
left join TRN_ENTD_DBF ent on pc.M_MD_ENTITY = ent.M_REF
left join TRN_STG_DBF stg on pc.M_STG_LBL = stg.M_LABEL
left join MRKP_FRM_DBF calc on pc.M_CALCCYCLE = calc.M_CFGLABEL
left join WF_TPL_DBF wfl on pc.M_STP_TPL = wfl.M_REFERENCE
left join PAY_CFG_DBF dlv on pc.M_DLVSETTING = dlv.M_REFERENCE

order by pc.M_LABEL