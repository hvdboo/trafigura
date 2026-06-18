select
rtrim(dmt.M_LABEL) LAB, rtrim(dmt.M_DESC) DES, 
case dmt.M_MUREX
when 0 then 'User'
when 1 then 'Murex' end OWNER,
case dmt.M_HISTORIZATION 
when 0 then 'None'
when 1 then 'One dataset'
when 2 then 'One dataset per day'
when 3 then 'One dataset per run' end HIS,
case dmt.M_TYPE
when 0 then 'Dynamic'
when 1 then 'Data dictionary'
when 4 then 'SQL' end TYP,
-- rtrim(cla.M_NAME) DTM_CLASS,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then 'MR'
when 1 then 'MA'
when 2 then 'UR'
when 3 then 'UA' end DYN_DIR,
case dmt.M_TYPE when 0 then rtrim(dyn.M_DYN_TABLE) end DYN_TBL,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then
case dynmr.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end
when 1 then 
case dynma.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end 
when 2 then
case dynur.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end
when 3 then
case dynua.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end end DYN_TYP,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(dynmr.M_CLASS)
when 1 then rtrim(dynma.M_CLASS) 
when 2 then rtrim(dynur.M_CLASS)
when 3 then rtrim(dynua.M_CLASS) end DYN_CLASS,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(dynmr.M_CODE)
when 1 then rtrim(dynma.M_CODE) 
when 2 then rtrim(dynur.M_CODE)
when 3 then rtrim(dynua.M_CODE) end DYN_MODE,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(dynmr.M_DBFALIAS)
when 1 then rtrim(dynma.M_DBFALIAS) 
when 2 then rtrim(dynur.M_DBFALIAS)
when 3 then rtrim(dynua.M_DBFALIAS) end DYN_UND,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(dynmr.M_VIEW)
when 1 then rtrim(dynma.M_VIEW) 
when 2 then rtrim(dynur.M_VIEW)
when 3 then rtrim(dynua.M_VIEW) end DYN_VIEW,
case dmt.M_TYPE when 1 then 
case dic.M_BASED_ON_OBJECT
when 0 then 'Trade'
when 1 then 'Counterpart' 
when 2 then 'Security'
when 3 then 'Portfolio' end else '' end DIC,
case dmt.M_TYPE when 4 then qry.M_REQUEST end QRY
from RPO_DMSETUP_TABLE_DBF dmt
left join RPO_DMSETUP_DYN_TABLE_DBF dyn on dmt.M_REFERENCE = dyn.M_REFERENCE
left join RPO_DMSETUP_DCT_TABLE_DBF dic on dmt.M_REFERENCE = dic.M_REFERENCE
left join RPO_DMSETUP_SQL_TABLE_DBF qry on dmt.M_REFERENCE = qry.M_REFERENCE
left join DYNDBF1#TRN_DYND_DBF dynmr on (dyn.M_DYN_TABLE = dynmr.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 0)
left join DYNDBF2#TRN_DYND_DBF dynur on (dyn.M_DYN_TABLE = dynur.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 2)
left join DYNDBF3#TRN_DYND_DBF dynma on (dyn.M_DYN_TABLE = dynma.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 1)
left join DYNDBF4#TRN_DYND_DBF dynua on (dyn.M_DYN_TABLE = dynua.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 3)
left join CLASS_MAPPING_DBF cla on dmt.M__INTID_ = cla.M_ID
/*
where dmt.M_REFERENCE in
(
166, 198, 225, 231, 239, 241, 248, 304, 305, 318, 319, 341, 354, 355, 356, 357, 358, 359, 
368, 369, 370, 371, 373, 374, 377, 379, 380, 381, 383, 384, 393, 396, 397, 398, 399,
400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 414, 416, 418, 419,
435, 436, 437, 439, 440, 441, 443, 446, 448, 449, 450, 453, 454, 455, 456, 457, 458, 459,
460, 461, 462, 463, 464, 465, 466, 467, 468, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479,
480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 500
)
*/
order by TYP, DYN_TYP, DYN_CLASS, DYN_TBL, LAB