select distinct
case fed.M_EXECTX
when 5 then 'Feeder'
when 6 then 'Actuate'
when 7 then 'Extraction'
when 8 then 'Procedure' else '_' end FEED_TYP,
rtrim(fed.M_LABEL) FEED_LAB, rtrim(fed.M_DESC) FEED_DESC,
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
when 14 then 'static_tables' else cat.M_LABEL end FEED_CAT,
rtrim(rep.M_OUTPUT) REP, rtrim(dtm.M_LABEL) DTM_LAB, rtrim(dtm.M_DESC) DTM_DES,
rtrim(dyn.M_DYN_TABLE) DYN_TBL,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(dynmr.M_CLASS)
when 1 then rtrim(dynma.M_CLASS)
when 2 then rtrim(dynur.M_CLASS)
when 3 then rtrim(dynua.M_CLASS) else '_' end DYN_CLASS,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then 
case dynmr.M_CLASS_TYPE
when 8 then rtrim(dynmr.M_VIEW) else rtrim(dynmr.M_DBFALIAS) end 
when 1 then 
case dynma.M_CLASS_TYPE
when 8 then rtrim(dynma.M_VIEW) else rtrim(dynma.M_DBFALIAS) end 
when 2 then 
case dynur.M_CLASS_TYPE
when 8 then rtrim(dynur.M_VIEW) else rtrim(dynur.M_DBFALIAS) end
when 3 then 
case dynua.M_CLASS_TYPE
when 8 then rtrim(dynua.M_VIEW) else rtrim(dynua.M_DBFALIAS) end end DYN_UND
from ACT_DYN_DBF rep
left join ACT_BAT_DBF fed on rep.M_REF = fed.M_REF
left join ACT_SETREP_DBF lnk on fed.M_REF = lnk.M_REFBAT
left join ACT_SET_DBF bat on lnk.M_REFSET = bat.M_REF
left join ACT_EXTR_DBF xtr on fed.M_REF = xtr.M_REF_BATCH
left join ACT_REQXTR_DBF req on xtr.M_REF_REQ = req.M_REF
left join DAPFILTER_DBF flt on rtrim(bat.M_FLTTEMP) = rtrim(flt.M_LABEL)
left join RPO_CATEG_DBF cat on fed.M_CATEG = cat.M_REF
left join RPO_DMSETUP_TABLE_DBF dtm on rtrim(rep.M_OUTPUT) = rtrim(dtm.M_LABEL)
left join RPO_DMSETUP_DYN_TABLE_DBF dyn on dtm.M_REFERENCE = dyn.M_REFERENCE
left join DYNDBF1#TRN_DYND_DBF dynmr on dyn.M_DYN_TABLE = dynmr.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 0
left join DYNDBF2#TRN_DYND_DBF dynur on dyn.M_DYN_TABLE = dynur.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 2
left join DYNDBF3#TRN_DYND_DBF dynma on dyn.M_DYN_TABLE = dynma.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 1
left join DYNDBF4#TRN_DYND_DBF dynua on dyn.M_DYN_TABLE = dynua.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 3
--where fed.M_EXECTX = 5 and substr(fed.M_DESC,1,4) = 'EDFM'
order by FEED_TYP, FEED_LAB, REP