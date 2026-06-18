select 
rtrim(lstlst.M_LABEL) CLU,
lst.M_INDEX LSTUID,
rtrim(lst.M_ORIGIN) LSTOBJ,
rtrim(lst.M_LABEL) LSTLAB,
case lst.M_COMPLEMENTARY
when 0 then 'Explicit'
when 1 then 'All but' end LSTTYP,
lst.M_EXCLUSIVE LSTEXC,
rtrim(itm.M_VALUE) ITMLAB,
rtrim(itm.M_ALIAS) ITMALI

from LST_PREFV_DBF itm
left join LST_PREFH_DBF lst on itm.M_INDEX2 = lst.M_INDEX
left join LST_PREFL_DBF clu on lst.M_INDEX = clu.M_INDEX2
left join LST_PREFH_DBF lstlst on clu.M_INDEX1 = lstlst.M_INDEX 

where 1 = 1
-- === By origin ===
-- and rtrim(lst.M_ORIGIN) = 'CALENDAR'              
-- and rtrim(lst.M_ORIGIN) = 'CF_GEN'                      
-- and rtrim(lst.M_ORIGIN) = 'COM'                            
-- and rtrim(lst.M_ORIGIN) = 'COM_CF_GEN'                     
-- and rtrim(lst.M_ORIGIN) = 'COM_CLR'                        
-- and rtrim(lst.M_ORIGIN) = 'COM_CLR_OPT'                    
-- and rtrim(lst.M_ORIGIN) = 'COM_FUT'                        
-- and rtrim(lst.M_ORIGIN) = 'COM_FWD'                        
-- and rtrim(lst.M_ORIGIN) = 'COM_LOCATIONS'                  
-- and rtrim(lst.M_ORIGIN) = 'COM_OFUT_LST'                   
-- and rtrim(lst.M_ORIGIN) = 'COM_PRODUCTS'                   
-- and rtrim(lst.M_ORIGIN) = 'COM_SWAP_GEN'                   
-- and rtrim(lst.M_ORIGIN) = 'CTPRT'                          
-- and rtrim(lst.M_ORIGIN) = 'CUR_SWP_GEN'                    
-- and rtrim(lst.M_ORIGIN) = 'CURRENCY'                    
-- and rtrim(lst.M_ORIGIN) = 'EQ_FUTURES'                     
-- and rtrim(lst.M_ORIGIN) = 'IRD_L_FUT'                      
-- and rtrim(lst.M_ORIGIN) = 'IRD_S_FUT'                      
-- and rtrim(lst.M_ORIGIN) = 'IRF OPT CTR'                    
-- and rtrim(lst.M_ORIGIN) = 'ORDER_DURATION'                 
-- and rtrim(lst.M_ORIGIN) = 'PL_INSTRUMENT'                  
-- and rtrim(lst.M_ORIGIN) = 'PORTFOLIO'                      
-- and rtrim(lst.M_ORIGIN) = 'SWP_GEN'                        
-- and rtrim(lst.M_ORIGIN) = 'VOLUME_PROF'                                        
-- === By index === 
-- and lst.M_INDEX = 142
and clu.M_INDEX1 = 169

order by LSTOBJ, LSTLAB, ITMLAB

