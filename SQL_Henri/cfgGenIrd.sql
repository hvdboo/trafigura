
select 
case ins.M_INSTR_TYPE
when  0 then 'IR Swap'
when  1 then 'IR Bond'
when  2 then 'IR Cap/Floor'
when  3 then 'IR Loan'
when  4 then 'IR FRA'
when  7 then 'IR Asset swap' 
when  8 then 'FI Call depo' else null end GENTYP,
rtrim(ins.M_INSTR)      PLILAB, 
rtrim(ins.M_INSTR_DESC) PLIDES, 
ins.M_SING_CURR CUR,
ins.M_NB_LEG LEGOCC,
case ins.M_RAT_DISP
when 0 then 'Fix'
when 1 then
   case gen.M_RATE_TYPE0
   when 0 then 'Fix-Flt'
   when 1 then 'Flt-Fix' else null end
when 2 then 'Fix-Fix'
when 4 then 'Flt-Flt' 
when 8 then 'Multileg' else null end LEGPAT,
case
when gen.M_RATE_TYPE0 = 0 then 'Fix'
when gen.M_RATE_TYPE0 = 1 then 'Flt' end LEGNAT0,
case gen.M_SETTLE0
when 0 then 'Cash'
when 1 then 'Fys.dlv.'
when 2 then 'Fin.dlv.' end LEGEXR0, 
gen.M_CURRENCY0 CUR0,
case ins.M_INSTR_TYPE
when 0 then
   case ind0.M_RESET
   when 0 then 'SPT'
   when 2 then 'CMP'
   when 3 then 'AVG'
   when 4 then 'BSK' 
   else null end
when  1 then 'CUR'
else null end INDTYP0,
case ins.M_INSTR_TYPE
when 0 then rtrim(ind0.M_IND_LAB)
when 1 then rtrim(gen.M_CURRENCY0)
when 2 then rtrim(ind0.M_IND_LAB)
else null end INDLAB0, 
rtrim(und0.M_IND_LAB) UNDLAB0,
rtrim(gen.M_ECP0) SCH0,
case sch0.M_DEF_UNIT
when 0 then 'Open day'
when 1 then 'Day' 
when 2 then 'Week'
when 3 then 'Month'
when 4 then 'Quarter'
when 5 then 'Semester'
when 6 then 'Year'
when 7 then 'Intraday' else null end SCHTEN0,
sch0.M_DEF_FREQ SCHFRQ0,
case
when gen.M_RATE_TYPE1 = 0 then 'Fix'
when gen.M_RATE_TYPE1 = 1 then 'Flt' end LEGNAT1,
case
when gen.M_SETTLE1 = 0 then 'Cash'
when gen.M_SETTLE1 = 1 then 'Fys.dlv.'
when gen.M_SETTLE1 = 2 then 'Fin.dlv.' end LEGEXR1,
gen.M_CURRENCY1 CUR1,
case ind1.M_RESET
when 0 then 'SPT'
when 2 then 'CMP'
when 3 then 'AVG'
when 4 then 'BSK' else null end INDTYP1,
rtrim(ind1.M_IND_LAB) as INDLAB1, 
rtrim(und1.M_IND_LAB) as UNDLAB1, 
rtrim(gen.M_ECP1) SCH1,
case sch1.M_DEF_UNIT
when 0 then 'Open day'
when 1 then 'Day' 
when 2 then 'Week'
when 3 then 'Month'
when 4 then 'Quarter'
when 5 then 'Semester'
when 6 then 'Year'
when 7 then 'Intraday' else null end SCHTEN1,
sch0.M_DEF_FREQ  SCHFRQ1,
ind0.M_INDEX     INDNDX0,
ind0.M_REFERENCE INDUID0,
ind1.M_INDEX     INDNDX1,
ind1.M_REFERENCE INDUID1,
gen.M_GEN_NUM GENUID

from RT_LNGN_DBF gen
left join RT_INSGN_DBF ins on gen.M_GEN_NUM = ins.M_GEN_NUM
left join RT_INDEX_DBF ind0 on gen.M_INDEX0 = ind0.M_INDEX
left join RT_INDEX_DBF und0 on ind0.M_UNDRL = und0.M_INDEX
left join DAT_ECH_DBF  sch0 on gen.M_ECP0 = sch0.M_LABEL
left join RT_INDEX_DBF ind1 on gen.M_INDEX1 = ind1.M_INDEX
left join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join DAT_ECH_DBF  sch1 on gen.M_ECP1 = sch1.M_LABEL
left join LST_PREFV_DBF prfpli on rtrim(ins.M_INSTR) = rtrim(prfpli.M_VALUE) and prfpli.M_INDEX2 = 174
left join LST_PREFH_DBF prflst on prfpli.M_INDEX2 = prflst.M_INDEX

where 1 = 1
and ins.M_INSTR_TYPE in (0,1,2,3) 
and ins.M_CREAT_MODE = 0
and rtrim(prfpli.M_VALUE) is not null

order by ins.M_INSTR_TYPE, ins.M_INSTR