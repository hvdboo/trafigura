select distinct
pli.M_COMATP  ATP,
pli.M_COMASS  ASSET,
pli.M_SUBFML  FGT,
pli.M_LSTOTC  LSTOTC,
pli.M_OPTLIN  OPTLIN,
pli.M_BDYLAB  PLILAB,
pli.M_BDYDES  PLIDES,
pli.M_EXRMOD  EXR,
pli.M_PUBLAB  PUB,
rtrim(altmic.M_OBJ_ALBL) MIC,
pli.M_CNTSYM  SYM,
pli.M_OBS     OBS,
pli.M_MATCAS  MATCAST,
pli.M_CUR     CUR,
pli.M_UOQ     UOQ,
pli.M_INDTYP0 INDTYP0,
pli.M_INDLAB0 INDLAB0,
pli.M_UNDLAB0 UNDLAB0,
pli.M_PLUTO   PLUTO_CODE,
plu.M_PLUDES  PLUTO_NAME,
/*
case 
when pli.M_FMLUID in (2, 512)    then rtrim(altgentit.M_OBJ_ALBL)
when pli.M_FMLUID in (32, 16384) then rtrim(altfuttit.M_OBJ_ALBL) else null end PLUTO_ALT,
case
when pli.M_FMLUID in (2,512)     then rtrim(altgenplu.M_OBJ_ALBL)
when pli.M_FMLUID in (32, 16384) then rtrim(altfutplu.M_OBJ_ALBL) else null end PLUTO,
*/
case
when pli.M_FMLUID in (2,512)     then rtrim(altgenplu.M_OBJ_ALT)
when pli.M_FMLUID in (32, 16384) then rtrim(altfutplu.M_OBJ_ALT) else null end PLUTO_MX,
case 
when pli.M_FMLUID in (2, 512)    then rtrim(altgentit.M_OBJ_ALT)
when pli.M_FMLUID in (32, 16384) then rtrim(altfuttit.M_OBJ_ALT) else null end TITAN,
case
when pli.M_FMLUID in (2,512)     then rtrim(altgentcm.M_OBJ_ALT)
when pli.M_FMLUID in (32, 16384) then rtrim(altfuttcm.M_OBJ_ALT) else null end TITCOM,
case
when pli.M_FMLUID in (2,512)     then rtrim(altgentmk.M_OBJ_ALT)
when pli.M_FMLUID in (32, 16384) then rtrim(altfuttmk.M_OBJ_ALT) else null end TITMKT,
case
when pli.M_FMLUID in (2,512)     then rtrim(altgentin.M_OBJ_ALT)
when pli.M_FMLUID in (32, 16384) then rtrim(altfuttin.M_OBJ_ALT) else null end TITINS,
M_FMLUID,
M_PLIUID,
M_BDYUID,
M_INDUID


from VIW_PLI_DBF pli
left join KEYMAP_STC_DBF altcomurl on pli.M_BDYUID = altcomurl.M_OBJ_ID and altcomurl.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altcomurl.M_OBJ_ASYS,1,3)) = 'URL'
left join KEYMAP_STC_DBF altetdeqv on rtrim(pli.M_BDYLAB) = to_char(altetdeqv.M_OBJ_ID) and pli.M_FMLUID in (2,512) and rtrim(altetdeqv.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(altetdeqv.M_OBJ_ASYS) = 'ETD_EQV'
left join KEYMAP_STC_DBF altmic on pli.M_MKTUID = altmic.M_OBJ_ID and rtrim(altmic.M_OBJ_CLASS)  in ('MnVuQ71331') and rtrim(altmic.M_OBJ_ASYS) = 'MIC'
left join KEYMAP_STC_DBF altfuttit on pli.M_BDYUID = altfuttit.M_OBJ_ID and rtrim(altfuttit.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(altfuttit.M_OBJ_ASYS) = 'TITAN'
left join KEYMAP_STC_DBF altgentit on pli.M_BDYUID = altgentit.M_OBJ_ID and rtrim(altgentit.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(altgentit.M_OBJ_ASYS) = 'TITAN'
left join KEYMAP_STC_DBF altfuttcm on pli.M_BDYUID = altfuttcm.M_OBJ_ID and rtrim(altfuttcm.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfuttcm.M_OBJ_ASYS,1,9)) = 'COMMODITY'
left join KEYMAP_STC_DBF altgentcm on pli.M_BDYUID = altgentcm.M_OBJ_ID and rtrim(altgentcm.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgentcm.M_OBJ_ASYS,1,9)) = 'COMMODITY'
left join KEYMAP_STC_DBF altfuttmk on pli.M_BDYUID = altfuttmk.M_OBJ_ID and rtrim(altfuttmk.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfuttmk.M_OBJ_ASYS,1,6)) = 'MARKET'
left join KEYMAP_STC_DBF altgentmk on pli.M_BDYUID = altgentmk.M_OBJ_ID and rtrim(altgentmk.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgentmk.M_OBJ_ASYS,1,6)) = 'MARKET'
left join KEYMAP_STC_DBF altfuttin on pli.M_BDYUID = altfuttin.M_OBJ_ID and rtrim(altfuttin.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfuttin.M_OBJ_ASYS,1,10)) = 'INSTRUMENT'
left join KEYMAP_STC_DBF altgentin on pli.M_BDYUID = altgentin.M_OBJ_ID and rtrim(altgentin.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgentin.M_OBJ_ASYS,1,10)) = 'INSTRUMENT'
left join KEYMAP_STC_DBF altfutplu on pli.M_BDYUID = altfutplu.M_OBJ_ID and rtrim(altfutplu.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutplu.M_OBJ_ASYS,1,5)) = 'PLUTO'
left join KEYMAP_STC_DBF altgenplu on pli.M_BDYUID = altgenplu.M_OBJ_ID and rtrim(altgenplu.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgenplu.M_OBJ_ASYS,1,5)) = 'PLUTO'
left join xtr_pluto_dbf plu on rtrim(pli.M_PLUTO) = rtrim(plu.M_PLUCOD)

where 1 = 1
and pli.M_FINASS = 'COM'
and pli.M_COMASS not in ('BMT','FMT','PMT')

order by PLILAB
