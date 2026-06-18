select rtrim(dsk.M_LABEL) DESK, 
rtrim(dsk.M_DESC) DESCRIPTION, 
rtrim(mds.M_LABEL) MDS, 
case dsk.M_MDS_LS
when 0 then 'Default'
when 1 then 'On login' end MDS_S,
rtrim(dsk.M_CALCCYCLE) CALC,
case dsk.M_ACTIVITY
when  0  then 'Inherited from FOD/PC'
when  1  then 'Interest rate'
when  2  then 'Bond'
when  3  then 'Currency'
when  4  then 'Commodity'
when  5  then 'Equity'
when  6  then 'Security options'
when  7  then 'Credit'
when  8  then 'Risk management'  end as ACTIVITY,
rtrim(dsk.M_STG_LBL) SETTING, 
rtrim(pc.M_LABEL) PC, 
rtrim(wf.M_LABEL) PC_TMPL,
rtrim(dsk.M_EOD_SHIFT) EOD_SHIFT, 
rtrim(dsk.M_CALENDAR) EOD_CAL, 
dsk.M_HBTEOD EOD_HOURS

from TRN_DSKD_DBF dsk
left join TRN_MDS_DBF mds on dsk.M_MD_SET = mds.M_REFERENCE
left join TRN_PC_DBF  pc on dsk.M_PC = pc.M_REFERENCE
left join WF_TPL_DBF wf on dsk.M_STP_TPL = wf.M_REFERENCE

order by dsk.M_LABEL
