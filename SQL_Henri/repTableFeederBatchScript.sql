select 
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then 
        case vw1.M_CLASS_TYPE 
        when  0 then 'Transaction'
        when  1 then 'Accounting'
        when  2 then 'Copy creation'
        when  3 then 'External'
        when  4 then 'Payment'
        when  5 then 'Definition report'
        when  6 then 'Accounting'
        when  7 then 'Cash balances'
        when  8 then 'Simulation'
        when  9 then 'PLVar'
        when 10 then 'Java plugin'
        when 11 then 'Dictionary engine'
        when 12 then 'Theta analysis'
        when 13 then 'VaR'
        when 14 then 'Simulation PLE'
        when 15 then 'PLVar PLE'
        when 16 then 'Dlv - Cash'
        when 17 then 'Dlv - Nostro Cash'
        when 18 then 'ODR Engine'
        when 19 then 'Trn.version audit'
        when 20 then 'Navigation templates'		
        when 21 then 'LRB Request'
        when 22 then 'STP Rights'
        when 23 then 'STP Rights Audit'	
        when 24 then 'Risk matrix'
        when 32 then 'Portfolio tree'
        when 41 then 'Market risk'
        when 47 then 'Risk Hedge' else null end
when 1 then 
        case vw3.M_CLASS_TYPE
        when  0 then 'Transaction'
        when  1 then 'Accounting'
        when  2 then 'Copy creation'
        when  3 then 'External'
        when  4 then 'Payment'
        when  5 then 'Definition report'		
        when  6 then 'Accounting'
        when  7 then 'Cash balances'		
        when  8 then 'Simulation' 
        when  9 then 'PLVar'
        when 10 then 'Java plugin'		
        when 11 then 'Dictionary engine'
        when 12 then 'Theta analysis'
        when 13 then 'VaR'
        when 14 then 'Simulation PLE'
        when 15 then 'PLVar PLE'		
        when 16 then 'Dlv - Cash'
        when 17 then 'Dlv - Nostro Cash'
        when 18 then 'ODR Engine'
        when 19 then 'Trn.version audit'
        when 20 then 'Navigation templates'		
        when 21 then 'LRB Request'
        when 22 then 'STP Rights'
        when 23 then 'STP Rights Audit'		
        when 24 then 'Risk matrix'
        when 32 then 'Portfolio tree'
        when 41 then 'Market risk'
        when 47 then 'Risk Hedge' else null end
when 2 then 
        case vw2.M_CLASS_TYPE
        when  0 then 'Transaction'
        when  1 then 'Accounting'
        when  2 then 'Copy creation'
        when  3 then 'External'
        when  4 then 'Payment'
        when  5 then 'Definition report'		
        when  6 then 'Accounting'
        when  7 then 'Cash balances'		
        when  8 then 'Simulation' 
        when  9 then 'PLVar'
        when 10 then 'Java plugin'		
        when 11 then 'Dictionary engine'
        when 12 then 'Theta analysis'
        when 13 then 'VaR'
        when 14 then 'Simulation PLE'
        when 15 then 'PLVar PLE'		
        when 16 then 'Dlv - Cash'
        when 17 then 'Dlv - Nostro Cash'
        when 18 then 'ODR Engine'
        when 19 then 'Trn.version audit'
        when 20 then 'Navigation templates'		
        when 21 then 'LRB Request'
        when 22 then 'STP Rights'
        when 23 then 'STP Rights Audit'		
        when 24 then 'Risk matrix'
        when 32 then 'Portfolio tree'
        when 41 then 'Market risk'
        when 47 then 'Risk Hedge' else null end
when 3 then 
        case vw4.M_CLASS_TYPE 
        when  0 then 'Transaction'
        when  1 then 'Accounting'
        when  2 then 'Copy creation'
        when  3 then 'External'
        when  4 then 'Payment'
        when  5 then 'Definition report'		
        when  6 then 'Accounting'
        when  7 then 'Cash balances'		
        when  8 then 'Simulation' 
        when  9 then 'PLVar'
        when 10 then 'Java plugin'		
        when 11 then 'Dictionary engine'
        when 12 then 'Theta analysis'
        when 13 then 'VaR'
        when 14 then 'Simulation PLE'
        when 15 then 'PLVar PLE'		
        when 16 then 'Dlv - Cash'
        when 17 then 'Dlv - Nostro Cash'
        when 18 then 'ODR Engine'
        when 19 then 'Trn.version audit'
        when 20 then 'Navigation templates'		
        when 21 then 'LRB Request'
        when 22 then 'STP Rights'
        when 23 then 'STP Rights Audit'		
        when 24 then 'Risk matrix'
        when 32 then 'Portfolio tree'
        when 41 then 'Market risk'
        when 47 then 'Risk Hedge' else null end
else 'SQL' end CLASTYP,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(vw1.M_CLASS)
when 1 then rtrim(vw3.M_CLASS)
when 2 then rtrim(vw2.M_CLASS)
when 3 then rtrim(vw4.M_CLASS) else '_' end DYN_CLAS,
rtrim(dyn.M_DYN_TABLE) DYN_LAB,
rtrim(dtm.M_LABEL) DTM, 
--rtrim(req.M_LABEL) QRY,
--case fed.M_EXECTX
--when 5 then 'Feeder'
--when 6 then 'Actuate'
--when 7 then 'Extraction'
--when 8 then 'Procedure' else '_' end FEED_TYP,
rtrim(fed.M_LABEL) FEED_LAB, 
--rtrim(fed.M_DESC) FEED_DES,
--case bat.M_TYPE
--when 1 then 'Feeders'
--when 2 then 'Extracts' else '_' end BATCH_TYP,
rtrim(bat.M_LABEL) BATCH_LAB, 
--rtrim(bat.M_DESC) BATCH_DES,
--bat.M_FLTTEMP BATCH_FLT, 
--case bat.M_DATAHIS
--when 0 then 'One set'
--when 1 then 'One set per day'
--when 2 then 'One set per run' else '_' end BATCH_DATHIS, 
bat.M_TAGDATA BATCH_DATTAG,
rtrim(scr.M_NAME) SCR_LAB
--rtrim(scr.M_DESC) SCR_DES
from ACT_DYN_DBF rep
left join ACT_BAT_DBF fed on rep.M_REF = fed.M_REF
left join ACT_SETREP_DBF lnk on fed.M_REF = lnk.M_REFBAT
left join ACT_SET_DBF bat on lnk.M_REFSET = bat.M_REF
join PROCESS#PS_ITEM_DBF itm on bat.M_LABEL = itm.M_PARAM_LAB2 and (itm.M_UNIT = 'REP_BATCHES_EXT' or itm.M_UNIT = 'REP_BATCHES_FEED')
left join PROCESS#PS_SCRPT_DBF scr on itm.M_REF = scr.M_REF 
left join ACT_EXTR_DBF xtr on fed.M_REF = xtr.M_REF_BATCH
left join ACT_REQXTR_DBF req on xtr.M_REF_REQ = req.M_REF
left join DAPFILTER_DBF flt on rtrim(bat.M_FLTTEMP) = rtrim(flt.M_LABEL)
left join RPO_DMSETUP_TABLE_DBF dtm on rtrim(rep.M_OUTPUT) = rtrim(dtm.M_LABEL)
left join RPO_DMSETUP_DYN_TABLE_DBF dyn on dtm.M_REFERENCE = dyn.M_REFERENCE
left join DYNDBF1#TRN_DYND_DBF vw1 on dyn.M_DYN_TABLE = vw1.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 0
left join DYNDBF2#TRN_DYND_DBF vw2 on dyn.M_DYN_TABLE = vw2.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 2
left join DYNDBF3#TRN_DYND_DBF vw3 on dyn.M_DYN_TABLE = vw3.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 1
left join DYNDBF4#TRN_DYND_DBF vw4 on dyn.M_DYN_TABLE = vw4.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 3
where fed.M_EXECTX = 5
order by CLASTYP, DYN_CLAS, DTM, SCR_LAB, FEED_LAB, BATCH_LAB