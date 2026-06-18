select 
M_ASSTYP ASSTYP,
M_ASSLAB ASSLAB,
M_INDTYP INDTYP,
M_INDLAB INDLAB,
M_INDDES INDDES,
M_INDPUB INDPUB,
M_INDCAL INDCAL,
M_INDSYM INDSYM,
M_INDCUR INDCUR,
M_INDUOQ INDUOQ,
M_INDUOD INDUOD,
M_LOTSIZ LOTSIZ,
/*
M_UNDTYP,
M_UNDLAB,
M_UNDDES,
M_UNDQOT,
M_UNDHSR,
M_UNDPUB,
M_UNDCAL,
M_UNDCUR,
M_UNDUOQ,
M_UNDUOD,
M_OBSFRM,
M_OBSFRQ,
M_OBSCAL,
M_RNDRUL,
M_RNDDEC,
M_BSKELTR,
M_BSKELT0,
M_BSKELT1,
*/
M_CRVICM CRVICM,
M_CRVQOT CRVQOT,
M_PHYLAB PHYLAB,
M_LOCLAB LOCLAB,
-- M_HIS,
M_INDNDX,
M_INDUID,
-- M_QOTUID,
-- M_UNDNDX,
-- M_UNDUID,
M_ICMUID,
-- M_PHYUID,
-- M_LOCUID,
rtrim(crp.M_OBJ_ALT) REFPRC,
coalesce(rtrim(altundeai.M_OBJ_ALBL),rtrim(altindeai.M_OBJ_ALBL)) EAICOD,
coalesce(rtrim(altundeai.M_OBJ_ALT), rtrim(altindeai.M_OBJ_ALT))  EAILAB,
coalesce(rtrim(hisspt.M_DGMODEL), rtrim(hisfwd.M_DGMODEL)) MKDHIS

from VIW_ICMALL_DBF ind
left join CM_INDEX_DBF icm on ind.M_ICMUID = icm.M_REFERENCE
left join KEYMAP_STC_DBF crp on rtrim(ind.M_INDNDX) = rtrim(crp.M_OBJ_DESC) and rtrim(crp.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(crp.M_OBJ_ASYS) = 'CRP'
left join KEYMAP_STC_DBF altindeai on ind.M_INDUID = altindeai.M_OBJ_ID and rtrim(altindeai.M_OBJ_CLASS) in ('MnXbT37735', 'MwOJI56899') and rtrim(substr(altindeai.M_OBJ_ASYS,1,3)) = 'EAI'
left join KEYMAP_STC_DBF altundeai on rtrim(ind.M_INDNDX) = rtrim(altundeai.M_OBJ_DESC) and rtrim(altundeai.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altundeai.M_OBJ_ASYS,1,3)) = 'EAI'
left join UDTB274_DBF hisspt on (rtrim(ind.M_INDPUB) = rtrim(hisspt.M_DGPUBLICAT) and rtrim(icm.M_LABEL) = rtrim(hisspt.M_DGMXLABEL) and rtrim(hisspt.M_DGPTYPE) in ('COM_SIND_FIXING','COM_SIND_FIXING1'))
left join UDTB274_DBF hisfwd on (rtrim(icm.M_COMMENT1) = rtrim(hisfwd.M_DGMXLABEL) and rtrim(hisfwd.M_DGPTYPE) in ('COM_FUT_FIXING'))
--left join TABLE#DATA#INDEXES_DBF indudf on ind.M_INDNDX = indudf.M_INDEX
--left join UDTB322_DBF eai on rtrim(mapeai.M_OBJ_ALBL) = to_char(eai.M_EAI_CODE)

where icm.M_COMMENT4 <> 'OOS'

order by ASSTYP, ASSLAB, INDLAB
