select distinct
pss.M_REF PSREF,
rtrim(pss.M_NAME) as SCRIPT, rtrim(pss.M_DESC) as DESCRIPTION,
psi.M_ORDER as ORD, 
case psi.M_PERIOD
when 1 then 'Daily'
when 2 then 'Weekly' 
when 3 then 'Monthly'
when 4 then 'Yearly' end as FRQ,
case rtrim(psi.M_UNIT)
when 'ACCCOPY-FX'               then 'EOD.ACCOUNTING.FIXING.FX.UPDATE'          
when 'ACCEOD-ACCEPT'            then 'EOD.ACCOUNTING.MANUALENTRIES.ACCEPT'       
when 'ACCEOD-BAL'          	then 'EOD.ACCOUNTING.BALANCE.GENERATION'          
when 'ACCMNT_AUD_DP'       	then 'ACCOUNT.MAINTENANCE_DEPENDENCY_OBJECTS_AUDIT'       
when 'ACCMNT_MAINT'        	then 'ACCOUNT.MAINTENANCE'        
when 'ACCMNT_MV_DATE'      	then 'ACCOUNT.ENTITY_INVENTORY_DATE_MOVE'      
when 'ACCMNT_PURGE'        	then 'ACCOUNT.OFFLINE_DATASET_STOP_PURGE'        
when 'ACCUNDO-FLW'         	then 'ADMINISTRATION.ACCOUNTING.ENTRYUNDO.SETTLEMENT'         
when 'ACGBALREVERT'        	then 'EOD.ACCOUNTING.BALANCE.REVERT'        
when 'ACGHDG'              	then 'EOD.ACCOUNTING.ENTRY.GENERATION.HEDGE'              
when 'ACGHDGINTR'          	then 'EOD.ACCOUNTING.ENTRY.GENERATION.HEDGE.INTRINSIC'          
when 'ACGHDGREVERT'        	then 'EOD.ACCOUNTING.ENTRY.REVERT.HEDGE'        
when 'ACGMOVEDATE'         	then 'EOD.ACCOUNTING.MOVEDATE'         
when 'ACGMOVELIMDATE'      	then 'EOD.ACCOUNTING.MOVE_LIMITATION_DATE'      
when 'ACGPOS'              	then 'EOD.ACCOUNTING.ENTRY.GENERATION.POSITION'             
when 'ACGPOSREVERT'        	then 'EOD.ACCOUNTING.ENTRY.REVERT.POSITION'        
when 'ACGREVERT'           	then 'EOD.ACCOUNTING.ENTRY.REVERT.TRADE'           
when 'ACGTRDINTR'          	then 'EOD.ACCOUNTING.ENTRY.GENERATION.TRADE.INTRINSIC'          
when 'ACGTRDREVAL'         	then 'EOD.ACCOUNTING.ENTRY.GENERATION.TRADE.REVALUATION'         
when 'ACGTRDREVALALL'      	then 'EOD.ACCOUNTING.ENTRY.REGENERATION.TRADE.REVAL'      
when 'ACGUNDO'             	then 'EOD.ACCOUNTING.UNDO.GLOBAL'             
when 'AM.FUND.NAV.STORAGE' 	then 'AM.FUND.NAV.STORAGE' 
when 'AUTO-FIX'            	then 'EVENT.AUTOMATION.FIXING'
when 'AUTO-MODIFY-FIX'          then 'EVENT.AUTOMATION.MODIFYFIXING'            
when 'AUTO_CASH_SETTL'     	then 'EOD.PCENTER.AUTOMATIC_SETTLEMENT.CASH'     
when 'AUTO_SEC_SETTL'      	then 'EOD.PCENTER.AUTOMATIC_SETTLEMENT.SECURITY'      
when 'BATCH-PRINT'         	then 'DATAMART.REPORTING.MREPORT'         
when 'BENCHMARK.ASCII_READ'	then 'BENCHMARK.ASCII_READ'
when 'BENCHMARK.VALUATION' 	then 'BENCHMARK.VALUATION'
when 'BULK-EXERCISE'            then 'EVENT.AUTOMATION.BULKEXERCISE'
when 'CASH ROLL OVER'           then 'PL.FUNDING.ROLLOVER'
when 'CASH TRANSFER'            then 'PL.CASHTRANSFER'      
when 'CLOSE-DOWN'               then 'EOD.PCENTER.CLOSEDOWN'
when 'DB-CHECK'                 then 'EOD.DATAMODEL.SQLCHECK'
when 'DLV_GENERATION'           then 'EOD.PCENTER.UPDATE.DLV_GENERATION'
when 'DLV_INSPECTION'           then 'EOD.PCENTER.UPDATE.DLV_INSPECTION'
when 'DLV_INS_GEN'              then 'EOD.PCENTER.UPDATE.DLV_INS_GEN'
when 'ENTITY-EOD'               then 'EOD.PCENTER.ENTITYEOD'
when 'EOD-DM-REFRESH'           then 'EOD.PCENTER.DATAMART.REFRESH'
when 'EOD-MD-REFRESH'           then 'EOD.PCENTER.MARKETDATA.REFRESH'
when 'EOD-SD-REFRESH'           then 'EOD.PCENTER.STATICDATA.REFRESH'
when 'EOD-TRADES-CHECK'         then 'EOD.PCENTER.TRADES.CHECK' 
when 'EOD_PCENTER_EVENT_OR'     then 'EOD.PCENTER.EVENT.ORDER.CANCEL'         
when 'EOD.PCENTER.EVENT.BU'	then 'EOD.PCENTER.EVENT.BULK'
when 'FG.EXPORT.MDCS'      	then 'FIXING.EXPORT.CONTRIBUTIONSERVICE'      
when 'FG.IMPORT.MDCS'      	then 'FIXING.IMPORT.CONTRIBUTIONSERVICE'
when 'FIXING-CHECK'             then 'EVENT.AUTOMATION.FIXINGCHECK'
when 'FIXING.ENGINE.COPY'       then 'FIXING.ENGINE.COPY'       
when 'FLOW NETTING'        	then 'EOD.PCENTER.FLOW.NETTING'        
when 'FODESK-EOD'          	then 'EOD.FODESK.DATE.MOVE'          
when 'FUTURE FLOW SELL DOW'	then 'PL.FUTUREFLOWSELLDOWN'
when 'FX BACKUP'           	then 'EOD.FODESK.POSITIONREPOSITORY.FXBACKUP'           
when 'FX CLOSING'          	then 'EOD.PCENTER.POSITIONREPOSITORY.FXCLOSING'
when 'FX CLOSING SANITY CH'     then 'EOD.PCENTER.POSITIONREPOSITORY.FXCLOSINGSANITYCHEC'
when 'FX WAREHOUSE START'       then 'EOD.FODESK.POSITIONREPOSITORY.STARTFXENGINE'
when 'FX WAREHOUSE STOP'        then 'EOD.FODESK.POSITIONREPOSITORY.STOPFXENGINE'    
when 'GLOBAL EXPIRY'       	then 'EOD.PCENTER.EVENT.TERMINATION'      
when 'GLOBAL NETTING'      	then 'EOD.PCENTER.EVENT.NETTING'
when 'HDG-CALC-FV'              then 'EOD.HEDGE.CALCULATION.FAIRVALUE'
when 'HDG-GEN-FV-BE'            then 'EOD.HEDGE.GENERATION.BUSINESSEVENTS.FAIRVALUE'
when 'HDG-RECALC-FV'            then 'EOD.HEDGE.RECALCULATION.FAIRVALUE'     
when 'HEDGE-EFFECT'        	then 'EOD.HEDGE.RETROSPECTIVE'        
when 'HEDGE-PROSPECTIVE'   	then 'EOD.HEDGE.PROSPECTIVE'
when 'LATE-TRADING-CLOSE'       then 'EOD.PCENTER.LATETRADING.END'
when 'LATE-TRADING-OPEN'        then 'EOD.PCENTER.LATETRADING.START'   
when 'LIMITS LTS'          	then 'LIMITS.LTS.PROCESSINGSCRIPTS'
when 'LIMIT-COPY'               then 'EOD.MLC.ENGINE.COPY'
when 'LIMIT-MVDATE'             then 'EOD.MLC.DATE.MOVE'
when 'LIMIT-RESET'              then 'EOD.MLC.RESET'
when 'LIMIT-RESET-MLC'          then 'EOD.MLC.RESET.DATAMART.UPLOAD'
when 'LIMIT-RESET-MX'           then 'EOD.MLC.RESET.DATAMART.REFRESH'
when 'LISTED FX IMPORT CLO'     then 'MARKETDATA.LISTED.FX_IMPORT_CLOSING_PRICE'          
when 'MD-COPY'             	then 'MARKETDATA.COPY'             
when 'MD-DIV-CLEAN'        	then 'MARKETDATA.DIV.CLEAN'        
when 'MD-PURGE'            	then 'MARKETDATA.PURGE'            
when 'MD.EXPORT.MDCS'      	then 'MARKETDATA.EXPORT.CONTRIBUTIONSERVICE'      
when 'MD.IMPORT.MDCS'      	then 'MARKETDATA.IMPORT.CONTRIBUTIONSERVICE'
when 'MESSAGE-NOTIFICATION'     then 'MESSAGE.NOTIFICATION'      
when 'MHtRn46485'          	then 'EOD.PCENTER.CORPORATE.ACTIONS.PROPAGATION'
when 'MoUJG65854'               then 'EOD.CASH.ADJ.FO.TRADES.GENERATION'
when 'MPsMM69396'               then 'EOD.CA.HISTORICAL.DATA.UPDATE'
when 'MP-IMPORT-ASCII'          then 'MARKETDATA.IMPORT.ASCII'
when 'MREPORTS_EXECUTE'         then 'MREPORTS.EXECUTE'
when 'MTM IMPORT'               then 'PL.IMPORT.MTM.ASCII'         
when 'MTpZo62416'          	then 'ACCOUNT.CA_PROPAGATION_ENTRIES_AUDIT'          
when 'MuBxr59796'          	then 'EOD.PCENTER.CORPORATE.ACTIONS.INSERTION'          
when 'MxQNB61060'          	then 'EOD.CA.FO.TRADES.GENERATION'          
when 'P&L SELL DOWN'       	then 'PL.SELLDOWN'
when 'PAY_FIX_RETRY'            then 'EOD.PCENTER.UPDATE.SETTLEMENTFIXING_WINDOW_RETRY'       
when 'PAY_FIX_WINDOW'      	then 'EOD.PCENTER.UPDATE.SETTLEMENTFIXING_WINDOW'     
when 'PHISICAL-PURGE'      	then 'ADMINISTRATION.AUTOMATION.PHYSICALPURGE'      
when 'PL-ENGINE'           	then 'EOD.ACCOUNTING.ECONOMICEVENT.PL'           
when 'PLCCENTER-EOD'       	then 'EOD.PLCCENTER.DATE.MOVE'       
when 'POSITIONCLEANUP'     	then 'ADMINISTRATION.POSITIONREPOSITORY.CLEANUP'     
when 'POSITIONREPAIR'      	then 'ADMINISTRATION.WAREHOUSE.POSITIONREPAIR'      
when 'PROCESSING-EOD'      	then 'EOD.PCENTER.DATE.MOVE'      
when 'PURGE'               	then 'ADMINISTRATION.AUTOMATION.LOGICALPURGE'               
when 'REP_BATCHES_EXT'     	then 'DATAMART.REPORTING.BATCHES.EXTRACTIONS'     
when 'REP_BATCHES_FEED'   	then 'DATAMART.REPORTING.BATCHES.FEEDERS'  
when 'REP_BATCHES_PROC'         then 'DATAMART.REPORTING.BATCHES.PROCEDURES'    
when 'REP_JOB_PURGE'       	then 'ADMINISTRATION.DATAMART.PURGE.JOB'       
when 'REP_PURGE_RULE'      	then 'ADMINISTRATION.DATAMART.PURGE'      
when 'SAVE-FUT-CLOSING'    	then 'SAVE-FUT-CLOSING'    
when 'SINGLE FX CLOSING'        then 'EOD.FODESK.POSITIONREPOSITORY.FXCLOSING'
when 'TRADES-ACCEPT'            then 'EOD.PCENTER.TRADES.ACCEPT'
when 'UNDO-CLOSE-DOWN'          then 'EOD.PCENTER.CLOSEDOWN.UNDO'
when 'UNDO-ENTITY-EOD'          then 'EOD.PCENTER.ENTITYEOD.UNDO'
when 'VAR BATCH BY PTF'         then 'EOD.VAR' 
when 'VOLX SCRIPT_COM'     	then 'MARKETDATA.VOLX.MANAGEMENT.COMMODITY'
when 'VOLX SCRIPT_EQD'          then 'MARKETDATA.VOLX.MANAGEMENT.EQUITY'
when 'VOLX SCRIPT_FUTURE'       then 'MARKETDATA.VOLX.MANAGEMENT.FUTURE'
when 'VOLX SCRIPT_IRD_CF'       then 'MARKETDATA.VOLX.MANAGEMENT.IRD.CAPFLOORS'
when 'VOLX SCRIPT_IRD_OSWP'     then 'MARKETDATA.VOLX.MANAGEMENT.IRD.SWAPTIONS'
when 'WAREHOUSE FX MAINTEN'     then 'EOD.FODESK.POSITIONREPOSITORY.FXMAINTENANCE'
when 'WAREHOUSE MAINTENANC'	then 'EOD.FODESK.POSITIONREPOSITORY.MAINTENANCE'
when 'WAREHOUSE START'     	then 'EOD.FODESK.POSITIONREPOSITORY.STARTENGINE'     
when 'WAREHOUSE STOP'      	then 'EOD.FODESK.POSITIONREPOSITORY.STOPENGINE'      
when 'WAREHOUSE.BUILD'    	then 'ADMINISTRATION.WAREHOUSE.REBUILD'     
end as UNIT,
case rtrim(psi.M_UNIT)
when 'ACGUNDO'              then 'Shifter: '||rtrim(par.M_SHIFTER)
when 'BATCH-PRINT'          then 'Batch: '||rtrim(psi.M_PARAM_LAB1)
when 'FLOW NETTING'         then 'Shifter: '||rtrim(par.M_SHIFTER)
when 'EOD.PCENTER.EVENT.BU' then 'Event: '||rtrim(clas.M_NAME)
when 'GLOBAL EXPIRY'        then 'Shifter: '||rtrim(par.M_SHIFTER)
when 'MD-COPY'              then 'Source:'||rtrim(mdss.M_LABEL)
when 'MD.IMPORT.MDCS'       then 'Dataset: '||rtrim(psi.M_PARAM_LAB1)
when 'PROCESSING-EOD'       then case par.M_NO_OVERWT when 0 then 'Overwrite MD' when 1 then 'No overwrite MD' end
when 'PLCCENTER-EOD'        then case par.M_NO_OVERWT when 0 then 'Overwrite MD' when 1 then 'No overwrite MD' end
when 'PURGE'                then 'Shifter: '||rtrim(par.M_SHIFTER)
when 'REP_BATCHES_EXT'      then 'Batch: '||rtrim(psi.M_PARAM_LAB2) 
when 'REP_BATCHES_FEED'     then 'Batch: '||rtrim(psi.M_PARAM_LAB2)
when 'REP_BATCHES_PROC'     then 'Procedure: '||rtrim(psi.M_PARAM_LAB2)
else null end as ARG01,
case rtrim(psi.M_UNIT)
when 'BATCH-PRINT'          then 'Shifter: '||rtrim(psi.M_PARAM_SHFT)
when 'EOD.PCENTER.EVENT.BU' then 'Filter: '||rtrim(par.M_FILTER_LBL)
when 'FLOW NETTING'         then 'Key: '||rtrim(par.M_KEY_LBL)
when 'GLOBAL EXPIRY'        then 'Filter: '||rtrim(par.M_FILTER_LBL)
when 'MD.IMPORT.MDCS'       then 'Rule: '||rtrim(mdcs.M_LABEL)
when 'MD-COPY'              then 'Target:'||
case mditm.M_DEST_TYPE 
when 0 then '[MDS] '
when 1 then '[HIS] '
when 2 then '[ON] ' end ||rtrim(mdst.M_LABEL)
when 'PHISICAL-PURGE'       then 'Filter: '||rtrim(par.M_FILTER_LBL)
when 'PURGE'                then 'Filter: '||rtrim(par.M_FILTER_LBL)
when 'REP_BATCHES_EXT'      then 'Entity: '||rtrim(psi.M_PARAM_LAB3)
when 'REP_BATCHES_FEED'     then 'Entity: '||rtrim(psi.M_PARAM_LAB3)
when 'REP_BATCHES_PROC'     then 'Entity: '||rtrim(psi.M_PARAM_LAB3)
else null end as ARG02,
rtrim(fltb.M_FMLA_TEXT) as FILTR

from PROCESS#PS_ITEM_DBF psi
left join PROCESS#PS_SCRPT_DBF pss on psi.M_REF = pss.M_REF
left join SPB_PS_DBF par on trim(psi.M_PARAM_LAB1) = to_char(par.M_REFERENCE)
left join CLASS_MAPPING_DBF clas on par.M_OBJECT_ID = clas.M_ID
left join MD_RTSRH_DBF mdcs on trim(substr(psi.M_PARAM_LAB3,1,2)) = to_char(mdcs.M_REFERENCE)
left join SFVFLTM_DBF flth on rtrim(par.M_FILTER_LBL) = rtrim(flth.M_LABEL)
left join SFVFLTS_DBF fltb on flth.M_ID = fltb.M_ID
left join MD_TEMPL_DBF mdtmp on  trim(psi.M_PARAM_LAB1) = to_char(mdtmp.M_REFERENCE)
left join MD_ITEML_DBF mditl on mdtmp.M_ITEMS = mditl.M_CTN and mditl.M_REF > 0
left join MD_ITEM_DBF mditm on mditl.M_REF = mditm.M_REFERENCE
left join TRN_MDS_DBF mdss on  mditm.M_SOURCE = mdss.M_REFERENCE
left join TRN_MDS_DBF mdst on  mditm.M_DEST = mdst.M_REFERENCE

order by SCRIPT, ORD, UNIT

--when       1 then 'Credit correlation curve set'
--when       2 then 'Security future prices'
--when       4 then 'Dividends'
--when       8 then 'Repo margins'
--when      16 then 'Price factors'
--when      32 then 'Volatilities'
--when      64 then 'Rate market sheets'
--when     128 then 'Rate curves'
--when     256 then 'FX Future prices'  
--when     512 then 'FX Spots'
--when    1024 then 'Correlations'
--when    2048 then 'Bond spreads'
--when    4096 then 'Credit market sheets'
--when    8192 then 'Generic market parameters'
--when   16384 then 'Recovery rate curves'
--when   32768 then 'Security prices'
--when   65536 then 'Screening'
--when  131072 then 'Commodity index prices'
--when  262144 then 'Commodity future prices'
--when  524288 then 'Assignments'
--when 1048576 then 'Commodity market sheet'
--when 2097152 then 'Commodity listed option prices'
--when 4194304 then 'Commodity listed asian prices'
--when  1073741824 then 'Links'
--when -2147483648 then 'Formal producers'