select distinct 
-- rtrim(cat.M_LABEL) CAT,
rtrim(objPat.M_LABEL) PATTERN, 
rtrim(objLay.M_LABEL) LAYOUT,
rtrim(pat.M_REG_DESC) REGISTRY, 
case pat.M_REG_DESC
when 'FX swap'                       then 'CURR|FXD |XSW'
when 'Interest rate swaps'           then 'IRD |IRS'
when 'Currency swaps'                then 'IRD |CS'
when 'Swaptions'                     then 'IRD |OSWP'
when 'Futures'                       then 'CURR|FUT |FUT'
when 'Spot-Forward'                  then 'CURR|FXD |FXD'
when 'Simple Option'                 then 'CURR|OPT |SMP'
when 'Simple cash flow'              then 'SCF |SCF |SCF'
when 'Forex-Swap Leg'                then 'FXD |FXD |SWLEG'
when 'COM Future'                    then 'COM |FUT'
when 'COM Option on Future - Listed' then 'COM |OFUT|LST' 
when 'COM Forward'                   then 'COM |FWD' 
when 'COM Option on Future - OTC'    then 'COM |OFUT|OTC'
when 'COM Simple option'             then 'COM |OPT |SMP' 
when 'COM Swap'                      then 'COM |SWAP' 
when 'COM Asian'                     then 'COM |ASIAN' 
when 'COM Spot/Forward'              then 'COM |SPOT' 
when 'COM Cleared swap'              then 'COM |SWAP |CLR'
when 'COM Cleared asian'             then 'COM |ASIAN|CLR' 
when 'COM Physical Forward'          then 'COM |SWAP |PHYS'
when 'Arbitrage External'            then 'COM |FUT + COM |FUT'  
when 'Carry Bull'                    then 'COM |SPOT + COM |SPOT' 
when 'Carry External'                then 'COM |FUT + COM |FUT' 
when 'Arbitrage Average'             then 'COM |SWAP + COM |SWAP'
when 'Arbitrage Forward'             then 'COM |FWD + COM |FWD' 
when 'Arbitrage Bull Fwd'            then 'COM |SPOT + COM |FWD' 
when 'Arbitrage Bull Fut'            then 'COM |SPOT + COM |FUT' 
when 'Carry Forward'                 then 'COM |FWD  + COM |FWD' 
when 'Carry Physical'                then 'COM |SWAP|PHYS + COM |SWAP|PHYS' 
when 'HighLow'                       then 'COM |SWAP + COM |ASIAN' 
when 'Carry Average'                 then 'COM |SWAP + COM |SWAP' else null end FGT,
rtrim(cla.M_NAME) CLASS_LAB,
rtrim(pat.M_REG_LBL) CLASS_ID,
case pat.M_REG_DESC
when 'FX swap'                       then    0
when 'Interest rate swaps'           then    1
when 'Currency swaps'                then    2
when 'Swaptions'                     then    5
when 'Futures'                       then   76
when 'Spot-Forward'                  then   77
when 'Simple Option'                 then   84
when 'Simple cash flow'              then   90
when 'Forex-Swap Leg'                then   92
when 'COM Future'                    then  100
when 'COM Option on Future - Listed' then  101 
when 'COM Forward'                   then  102 
when 'COM Option on Future - OTC'    then  103 
when 'COM Simple option'             then  113 
when 'COM Swap'                      then  130 
when 'COM Asian'                     then  131 
when 'COM Spot/Forward'              then  134 
when 'COM Cleared swap'              then  136 
when 'COM Cleared asian'             then  146 
when 'COM Physical Forward'          then  154 
when 'Arbitrage External'            then 2661  
when 'Carry Bull'                    then 2666
when 'Carry External'                then 2670 
when 'Arbitrage Average'             then 2711 
when 'Arbitrage Forward'             then 2724 
when 'Arbitrage Bull Fwd'            then 2728 
when 'Arbitrage Bull Fut'            then 2732 
when 'Carry Forward'                 then 2744 
when 'Carry Physical'                then 2833 
when 'HighLow'                       then 2911 
when 'Carry Average'                 then 2915 else null end CLASS_INST,
pat.M_PAT_ID PAT, 
pat.M_PRF_ID LAY
from NPD_PAT_DBF pat
left join DCF_OBJ_DBF objPat on (pat.M_PAT_ID = objPat.M_ITEM_ID and pat.M_PAT_TYPE = 0)
left join DCF_GRPB_DBF tmp on objPat.M_OBJ_ID = tmp.M_OBJ_ID
left join DCF_GRPH_DBF tmpl on tmp.M_GRP_ID = tmpl.M_GRP_ID
left join CLASS_MAPPING_DBF cla on pat.M_REG_LBL = cla.M_ID
left join NPD_PAT_DBF patLay on pat.M_PRF_ID = patLay.M_PRF_ID and patLay.M_PAT_TYPE = 1
left join DCF_OBJ_DBF objLay on patLay.M_PAT_ID = objLay.M_ITEM_ID
left join NPD_PAT_DBF patDvl on pat.M_TMP_ID = patDvl.M_TMP_ID and patDvl.M_PAT_TYPE = 2
left join DCF_OBJ_DBF objDvl on patDvl.M_PAT_ID = objDvl.M_ITEM_ID
left join NPD_PAT_DBF patOpt on pat.M_OPT_ID = patOpt.M_OPT_ID and patOpt.M_PAT_TYPE = 3
left join DCF_OBJ_DBF objOpt on patOpt.M_PAT_ID = objOpt.M_ITEM_ID
left join NPD_PAT_DBF patIni on pat.M_INIT_ID = patIni.M_INIT_ID and patIni.M_PAT_TYPE = 5
left join DCF_OBJ_DBF objIni on patIni.M_PAT_ID = objIni.M_ITEM_ID
left join TYPOLOGY_DBF typo on (pat.M_TYPO_REF = typo.M_REFERENCE)
left join CATEGORY_DBF cat on typo.M_CATEGORY = cat.M_REFERENCE
-- left join TRAF_REG reg on rtrim(pat.M_REG_DESC) = rtrim(reg.LAB)
where 
tmpl.M_LABEL  = 'PT_TRAF_ALL' and (
pat.M_REG_LBL='1.238' 
or pat.M_REG_LBL='1.394' 
or pat.M_REG_LBL='1.526' 
)  
and pat.M_PAT_TYPE = 0 
and objPat.M_CATEG = 1
and rtrim(pat.M_REG_DESC) in
(
'FX swap',
'Interest rate swaps',
'Currency swaps',
'Swaptions',
'Futures',
'Spot-Forward',
'Simple Option',
'Forex-Swap Leg',
'Simple cash flow',
'COM Future',
'COM Option on Future - Listed',
'COM Forward',
'COM Option on Future - OTC',
'COM Simple option',
'COM Swap',
'COM Asian',
'COM Spot/Forward',
'COM Cleared swap',
'COM Cleared asian',
'COM Physical Forward',
'Arbitrage External',
'Carry Bull',
'Carry External',
'Arbitrage Average',
'Arbitrage Forward',
'Arbitrage Bull Fwd',
'Arbitrage Bull Fut',
'Carry Forward',
'Carry Physical',
'HighLow',
'Carry Average'
)
/*
and reg.CLASS_INST in (
100, 101, 102, 103, 113, 130, 131, 134, 136, 154,
2661,
2666,
2670,
2711,
2724,
2728,
2732,
2744,
2833
)
*/
order by substr(FGT,1,4), PATTERN