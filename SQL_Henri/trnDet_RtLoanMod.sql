select 
rownum ID,
lnmod.M_NB TRN,
'Standard' TYP, -- RT_LNMOD_DBF
-- 'Alignment'
to_char(lnmod.M_OP_DATE,'YYYY-MM-DD') OPRDAT, 
lnmod.M_PHASE PHA,
lnmod.M_LEG LEG,
case M_TYPE
when   0 then 'Payment date'
when   2 then 'Calc.start'
when   5 then 'Interest flow'
when 190 then 'Fxg.date'
else null end ATTRIB,
to_char(lnmod.M_START_CALC,'YYYY-MM-DD') STARTDAT, 
to_char(lnmod.M_DATE,'YYYY-MM-DD') VALDAT,
lnmod.M_OFFSET OFFSET

from RT_LNMOD_DBF lnmod
where lnmod.M_NB = 14208268

order by TRN, PHA, LEG, ATTRIB, STARTDAT