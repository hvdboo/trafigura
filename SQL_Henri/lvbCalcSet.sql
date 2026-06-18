select
rtrim(lvb.M_LABEL)    LVBLAB,
rtrim(lvbcsd.M_LABEL) CLCSET,
rtrim(lvbcsd.M_DESC)  CLCDES,
case lvbcsd.M_CALC_TYPE when 3 then 'Full Revaluation - Consolidated positions' else null end CLCTYP,
rtrim(posdis.M_LABEL) POSDIS,
/*
case lvbcss.M_START when 0 then 'False' when 1 then 'True' else null end AUTSTA,
case lvbcss.M_REALTIME when 0 then 'False' when 1 then 'True' else null end REATIM,
lvbcss.M_CYCLE REFCYC,
rtrim(fltset.M_LABEL) FLTSET,
case lvbcss.M_DISPLAY when 0 then 'False' when 1 then 'True' else null end DISCLI
*/
rtrim(cus.M_USER) USR,
rtrim(cus.M_GROUP) GRP,
rtrim(cus.M_DESK) DSK,
rtrim(cus.M_MDS) MDS,
rtrim(mdrt.M_LABEL) SUBRUL,
rtrim(lvbngn.M_LABEL) ENG,
rtrim(lvbsrv.M_LABEL) SRV

from LIVEBOOK_CSETS_DBF lvbcss
left join LIVEBOOK_CSETD_DBF lvbcsd on lvbcss.M_DEFINITION_REF = lvbcsd.M_REFERENCE
left join LIVEBOOK_DBF lvb on lvbcss.M_LIVEBOOK_REF = lvb.M_REFERENCE
left join LIVEBOOK_RE_DBF cus on lvbcsd.M_CUSTOM_REF = cus.M_CUSTOM_REF
left join MD_RTSRH_DBF mdrt on cus.M_SUBSCRIPTION_RULE = mdrt.M_REFERENCE
left join LIVEBOOK_POS_DISTR_DBF posdis on lvbcss.M_POS_DISTR_REF = posdis.M_REFERENCE
left join LIVEBOOK_FILTER_SET_DBF fltset on lvbcss.M_FILTER_SET_REF = fltset.M_REFERENCE
-- left join LIVEBOOK_VIEW_DBF lvbviw on lvbcss.M_DEFINITION_REF = lvbviw.M_DEFINITION_REF
left join LIVEBOOK_ENGINE_TMPL_DBF lvbngn on lvbcss.M_ENGINE_TMPL_REF = lvbngn.M_REFERENCE
left join LIVEBOOK_SERVICE_TMPL_DBF lvbsrv on lvbcss.M_SERVICE_TMPL_REF = lvbsrv.M_REFERENCE

order by LVBLAB, CLCSET
