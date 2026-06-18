select
rtrim(lvb.M_LABEL) LVBLAB,
rtrim(lvbcsd.M_LABEL) CLCSET,
rtrim(lay.M_CFG_LBL) LAY,
rtrim(viw.M_CFG_LBL) VIW,
case lvbviw.M_SELECTED when 0 then 'False' when 1 then 'True' else null end ACTIVE,
case lvbviw.M_BUSINESS_ACTION when 0 then 'False' when 1 then 'True' else null end BUZACT

from LIVEBOOK_VIEW_DBF lvbviw
left join LIVEBOOK_CSETD_DBF lvbcsd on lvbviw.M_DEFINITION_REF = lvbcsd.M_REFERENCE
left join LIVEBOOK_CSETS_DBF lvbcss on lvbcsd.M_REFERENCE = lvbcss.M_DEFINITION_REF
left join LIVEBOOK_DBF lvb on lvbcss.M_LIVEBOOK_REF = lvb.M_REFERENCE
left join VWR_CFGS_DBF lay on lvbviw.M_LAYOUT_REF = lay.M_CFG_REF
left join VWR_CFGS_DBF viw on lvbviw.M_VIEW_REF = viw.M_CFG_REF

order by LVBLAB, CLCSET, LAY desc, VIW
