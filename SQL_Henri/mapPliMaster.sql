select 
case 
when pli.M_FAMILY =  2 and insgen.M_INSTR_TYPE = 12 then 'OAS'
when pli.M_FAMILY =  2 and insgen.M_INSTR_TYPE = 13 then 'SWP'
when pli.M_FAMILY =  2 and insgen.M_INSTR_TYPE = 27 then 'PHY'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 1 then 'FUT'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 1 and fcm.M_LOOKALIKE_ENABLED = 1 then 'FUT, FWD'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 2 then 'FWD'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 64 then 'OFW'
when pli.M_FAMILY = 32 and fcm.M_LOOKALIKE_ENABLED = 0 then 'FUT'
when pli.M_FAMILY = 32 and fcm.M_LOOKALIKE_ENABLED = 0 then 'FUT'
when pli.M_FAMILY = 16384 and fcm.M_LISTED = 32 then 'OAP'
when pli.M_FAMILY = 16384 and fcm.M_LISTED = 64 then 'OFT'
else null end PLITYP,
rtrim(pli.M_DSP_LABEL) PLILAB,
rtrim(pli.M_DESC) PLIDES,
rtrim(fcmpub.M_LABEL) PUBLAB,
rtrim(altpub.M_OBJ_ALBL) PUBMIC,
rtrim(fcmqot.M_TRAD_SMB) CNTSYM,
rtrim(altcomurl.M_OBJ_ALBL) CNTCOD,
rtrim(altcomurl.M_OBJ_ALT) CNTURL,
pli.M_ID PLIUID

from TRN_PLIN_DBF pli
left join RT_INSGN_DBF insgen on rtrim(pli.M_LABEL) = to_char(insgen.M_GEN_NUM) and pli.M_FAMILY in (2,512)
left join CM_FUT_DBF fcm on (rtrim(substr(pli.M_LABEL,9,4)) = to_char(fcm.M_REFERENCE) and pli.M_FAMILY in (32, 16384))
left join CM_ASSET_DBF fcmass on fcm.M_ASSET = fcmass.M_REFERENCE
left join CMC_QUOT_DBF fcmqot on fcm.M_QUOT_FWD = fcmqot.M_REFERENCE
left join CM_MKT_DBF   fcmpub on fcmqot.M_PUBLI = fcmpub.M_REFERENCE
left join KEYMAP_STC_DBF altcomurl on fcm.M_REFERENCE = altcomurl.M_OBJ_ID and altcomurl.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altcomurl.M_OBJ_ASYS,5,3)) = 'URL'
left join KEYMAP_STC_DBF altpub on fcmpub.M_REFERENCE = altpub.M_OBJ_ID and rtrim(altpub.M_OBJ_CLASS)  in ('MnVuQ71331') and rtrim(altpub.M_OBJ_ASYS) = 'MIC'
--left join LST_PREFV_DBF prfpli on rtrim(pli.M_DSP_LABEL) = rtrim(prfpli.M_VALUE) --and prfpli.M_INDEX2 = 197 
--left join LST_PREFH_DBF prflst on prfpli.M_INDEX2 = prflst.M_INDEX

where 
(
(pli.M_FAMILY = 2 and insgen.M_INSTR_TYPE in (12, 13, 17, 18, 20,27)) or
pli.M_FAMILY in (32, 16384)
) and 
upper(rtrim(pli.M_DSP_LABEL)) not in 
(select rtrim(prfpli.M_VALUE) from LST_PREFV_DBF prfpli where prfpli.M_INDEX2 = 197)