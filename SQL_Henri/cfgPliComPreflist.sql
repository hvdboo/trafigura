select 
pli.M_COMASS   ASS,
pli.M_LSTOTC   LO,
pli.M_SUBFML   FGT,
pli.M_EXRMOD   EXR,
pli.M_PLILAB   PLI,
pli.M_PUBLAB   PUB,
pli.M_CNTSYM   SYM,
pli.M_CUR      CUR,
pli.M_UOQ      UOQ,
pli.M_PRFLST   PRFLST

from VIW_PLI_DBF pli
left join KEYMAP_STC_DBF altcomurl on pli.M_BDYUID = altcomurl.M_OBJ_ID and altcomurl.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altcomurl.M_OBJ_ASYS,5,3)) = 'URL'
left join KEYMAP_STC_DBF altetdeqv on rtrim(pli.M_PLILAB) = to_char(altetdeqv.M_OBJ_ID) and pli.M_FMLUID in (2,512) and rtrim(altetdeqv.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(altetdeqv.M_OBJ_ASYS) = 'ETD_EQV'
left join KEYMAP_STC_DBF altpub on pli.M_PUBUID = altpub.M_OBJ_ID and rtrim(altpub.M_OBJ_CLASS)  in ('MnVuQ71331') and rtrim(altpub.M_OBJ_ASYS) = 'MIC'

where pli.M_FINASS = 'COM'
