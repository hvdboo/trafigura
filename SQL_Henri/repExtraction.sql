select
'Extraction' as XTR_TYP, 
xtr.M_ID,
--fed.M_REF,
rtrim(fed.M_LABEL) XTR_LAB, rtrim(fed.M_DESC) XTR_DESC,
case fed.M_CATEG
when  1 then 'accounting'
when  2 then 'audit' 
when  3 then 'cash_management' 
when  4 then 'credit_risk'
when  5 then 'euro'
when  6 then 'fixing'
when  7 then 'market_param'
when  8 then 'market_risk'
when  9 then 'credit_risk'
when 10 then 'open_position'
when 11 then 'P&L'
when 13 then 'regulatory'
when 14 then 'static_tables' else cat.M_LABEL end XTR_CAT,
rtrim(req.M_LABEL) QRY_LAB, rtrim(req.M_DESC) QRY_DESC,
rtrim(xtr.M_LBL_VIEW) OUT_VIEW, rtrim(xtr.M_LBL_LAY) OUT_LAY, --xtr.M_VIEWER_SEL,
rtrim(rep.M_OUTPUT) REP,
req.M_REF REQ_REF,
req.M_REQUEST REQ_QRY

from murex_mx_owner.ACT_EXTR_DBF xtr
left join ACT_BAT_DBF fed on xtr.M_REF_BATCH = fed.M_REF
left join ACT_DYN_DBF rep on fed.M_REF = rep.M_REF
left join RPO_CATEG_DBF cat on fed.M_CATEG = cat.M_REF
left join ACT_REQXTR_DBF req on xtr.M_REF_REQ = req.M_REF

order by XTR_LAB