select 
rtrim(uom.M_LABEL) LAB,
rtrim(uom.M_DESC) DES,
case uom.M__TYPE_
when   1 then 'Volume'
when   2 then 'Weight' 
when   4 then 'Energy' 
when   8 then 'Power'
when  16 then 'Time' 
when  32 then 'Volume Flow' 
when  64 then 'Temperature' 
when 128 then 'Weight Flow' end TYP, 
case uom.M__TYPE_
when   1 then 'M3'
when   2 then 'MT' 
when   4 then 'GJ' 
when   8 then 'MW'
when  16 then 'S' 
when  32 then 'M3/S' 
when  64 then 'K' 
when 128 then 'MT/S' end REFUOM,
coalesce(stk.M_LABEL,'') STOCK,
uom.M_CNV_FCT CNVFCT,
case 
when uom.M_CNV_MLT = 1 then 'Multiple'
when uom.M_CNV_MLT = 2 then 'Linear' 
when uom.M_CNV_MLT = 4 then 'Fraction' end CNVMOD,
uom.M_CNV_OFST CNVOFF

from CM_UNIT_DBF uom
left join CM_UNIT_DBF stk on uom.M_STK_REF = stk.M_REFERENCE 

order by LAB




