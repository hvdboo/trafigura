select 
viw.PHY,
viw.INS,
viw.CTP,
substr(viw.EXP,1,6) EXP,
viw.MAT,
case 
when substr(viw.USG,1,5) = 'Hedge' then 'Hedge'
when substr(viw.USG,1,4) = 'Spec'  then 'Spec'
else 'Undef' end NAT,
case 
when substr(viw.USG,5,5) = 'Short' then 'Short'
when substr(viw.USG,6,5) = 'Short' then 'Short'
when substr(viw.USG,5,4) = 'Long'  then 'Long'
when substr(viw.USG,6,4) = 'Long'  then 'Long'
else 'Undef' end POS,
sum(viw.NOM1) NOM

from TRNEXT_DET_VW01 viw
left join TABLE#DATA#PORTFOLI_DBF udf on viw.PFL = rtrim(udf.M_LABEL) 

group by 
viw.PHY,
viw.INS,
viw.CTP,
substr(viw.EXP,1,6),
viw.MAT,
viw.USG

order by PHY, INS, CTP, EXP, NAT, POS


