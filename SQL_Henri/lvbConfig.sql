select
rtrim(lvb.M_LABEL) LVBLAB,
rtrim(lvb.M_DESC)  LVBDES,
case lvb.M_CLIENT_SCOPE_TYPE when 0 then 'Portfolio' else null end LVBBY,
rtrim(lvbpfs.M_LABEL) PFLSET,
case lvb.M_REFRESH_MODE when 0 then 'Live feed' when 1 then 'On demand' else null end RTMMOD,
rtrim(lvbcsd.M_LABEL) CLCSET,
-- case lvbcsd.M_CALC_TYPE when 3 then 'Full Revaluation - Consolidated positions' else null end CLCTYP,
rtrim(posdis.M_LABEL) POSDIS,
case lvbcss.M_START    when 0 then 'False' when 1 then 'True' else null end AUTOST,
case lvbcss.M_REALTIME when 0 then 'False' when 1 then 'True' else null end REALTM,
lvbcss.M_CYCLE REFCYC,
rtrim(fltset.M_LABEL) FLTSET,
case lvbcss.M_DISPLAY  when 0 then 'False' when 1 then 'True' else null end DISPCL

from LIVEBOOK_CSETS_DBF lvbcss
left join LIVEBOOK_CSETD_DBF lvbcsd on lvbcss.M_DEFINITION_REF = lvbcsd.M_REFERENCE
left join LIVEBOOK_DBF lvb on lvbcss.M_LIVEBOOK_REF = lvb.M_REFERENCE
left join LIVEBOOK_PTF_SET_DBF lvbpfs on lvb.M_PTF_SET_REF = lvbpfs.M_REFERENCE
left join LIVEBOOK_POS_DISTR_DBF posdis on lvbcss.M_POS_DISTR_REF = posdis.M_REFERENCE
left join LIVEBOOK_FILTER_SET_DBF fltset on lvbcss.M_FILTER_SET_REF = fltset.M_REFERENCE
-- left join LIVEBOOK_VIEW_DBF lvbviw on lvbcss.M_DEFINITION_REF = lvbviw.M_DEFINITION_REF

order by LVBLAB, CLCSET
