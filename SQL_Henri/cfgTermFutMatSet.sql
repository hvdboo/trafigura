select 
rtrim(fcmmathdr.M_LABEL) LAB, 
rtrim(fcmmathdr.M_DESC)  DES, 
case fcmmathdr.M_SYS_ID
when  0 then 'Rule Based'
when  1 then 'Calendar simultaneous (split)'
when  4 then 'UK Power Exchange'
when  5 then 'IPE Electricity'
when  6 then 'Calendar sequential (no split, balance)'
when  7 then 'Calendar sequential (no split)'
when  8 then 'Nordpool Future'
when  9 then 'Nordpool Forward'
when 10 then 'LME'
when 12 then 'Rule based on quotation end'
when 14 then 'User defined' end as   TYP,
rtrim(fcmmathdr.M_CALENDAR) CAL, 
rtrim(vin.M_LABEL)          VIN_SET,
case fcmmathdr.M_HIDE_VINTAGE_LABEL when 0 then 'No' else 'Yes' end VIN_HIDE,
-- rtrim(cal.M_DESC) CAL_DESC,
case fcmmathdr.M_ALIAS_GEN 
when 0 then 'None' 
when 1 then 'Ticker code' 
when 2 then 'Formula' else null end ALIAS_FRM,
case fcmmathdr.M_DSP_ALIAS when 1 then 'Yes' else 'No' end ALIAS_DSP,
case fcmmathdr.M_AUTO_ROLL when 1 then 'Yes' else 'No' end ROLL_AUTO,
fcmmathdr.M_CUTOFF ROLL_CUTOFF, 
case fcmmathdr.M_CUTOFF_AUTOSET when 1 then 'Yes' else 'No' end CUTOFF_QE,
case fcmmathdr.M_QT_ST_CHECK    when 1 then 'Yes' else 'No' end QS_CHECK,
case 
when fcmmathdr.M_SYS_ID =  0 then 'RULE'
when fcmmathdr.M_SYS_ID <> 0 then
   case fcmmatbdy.M_BLK_TYPE 
   when  1 then 'Day'
   when  2 then 'Week'
   when  3 then 'Month'
   when  4 then 'Quarter'
   when  5 then 'Season'
   when  6 then 'Year'
   when  7 then 'Week-end'
   when  8 then 'Weekdays'
   when  9 then 'Bal.Month'
   when 15 then 'Month 2nd BD LME' 
   when 16 then 'Floating' else null end
else null end TENOR,
case
when fcmmathdr.M_SYS_ID = 0 then fcmmathdr.M_MAT_COUNT
when fcmmathdr.M_SYS_ID > 0 then fcmmatbdy.M_SPL_COUNT end as NMBMAT,
coalesce(rtrim(fcmmathdr.M_QT_RULE0), rtrim(fcmmatbdy.M_SPL_SHIFT0))   QOT_FST,
coalesce(rtrim(fcmmathdr.M_QT_RULE1), rtrim(fcmmatbdy.M_SPL_SHIFT1))   QOT_LST,
coalesce(rtrim(fcmmathdr.M_ST_RULE0), rtrim(fcmmatbdy.M_SPL_D_SHIFT0), rtrim(M_SD_SHIFT0)) DLV_FST,
coalesce(rtrim(fcmmathdr.M_ST_RULE1), rtrim(fcmmatbdy.M_SPL_D_SHIFT1), rtrim(M_SD_SHIFT1)) DLV_LST,
rtrim(fcmmathdr.M_NT_RULE0) NOT_FST,
rtrim(fcmmathdr.M_NT_RULE1) NOT_LST,
/*
rtrim(frm.M_BUFNB)  FRMSEQ,
rtrim(frm.M_BUFFER) FRMCOD,
*/
fcmmathdr.M_REFERENCE SETUID

from CM_FMAT_DBF fcmmathdr 
left join CAL_DEF_DBF cal on fcmmathdr.M_CALENDAR = cal.M_LABEL
left join CM_VINTAGESET_DBF vin on fcmmathdr.M_VINTAGE_SET = vin.M_REFERENCE
left join CM_FMAT0_DBF fcmmatbdy on fcmmathdr.M_REFERENCE = fcmmatbdy.M_REFERENCE
--left join CM_FMAT_RA_DBF fcmmatral on fcmmathdr.M_REFERENCE = fcmmatral.M_SET
--left join FRM_FILE_DBF frm on fcmmathdr.M_ALIAS_FORMULA = frm.M_GROUP

order by fcmmathdr.M_LABEL
