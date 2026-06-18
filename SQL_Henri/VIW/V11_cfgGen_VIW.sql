drop view GEN_VIW;
create view GEN_VIW 
(
M_GENTYP,
M_PLILAB,
M_PLIDES,
M_CUR,
M_LEGOCC,
M_LEGPAT,
M_LEGNAT0,
M_LEGEXR0,
M_CUR0,
M_INDTYP0,
M_INDLAB0,
M_UNDLAB0,
M_SCHLAB0,
M_SCHTEN0,
M_SCHFRQ0,
M_SCH0,
M_LEGNAT1,
M_LEGEXR1,
M_CUR1,
M_INDTYP1,
M_INDLAB1,
M_UNDLAB1,
M_SCHLAB1,
M_SCHTEN1,
M_SCHFRQ1,
M_SCH1,
M_GENUID,
M_INDNDX0,
M_INDUID0,
M_UNDNDX0,
M_UNDUID0,
M_INDNDX1,
M_INDUID1,
M_UNDNDX1,
M_UNDUID1

)

as

(
select 
case gin.M_INSTR_TYPE
when  0 then
   case when rtrim(gin.M_SING_CURR) is null then 'IR Swap XCUR' else 'IR Swap' end
when  1 then 'SC Bond'
when  2 then 'IR Cap/Floor'
when  3 then 'IR Loan'
when  4 then 'IR FRA'
when  7 then 'IR Asset swap' 
when  8 then 'FI Call depo'
when  9 then 'CR CDS'
when 12 then 'CM Asian' 
when 13 then 'CM Swap'
when 14 then 'CR TRS'
when 15 then 'IR Inflation' 
when 16 then 'CR RTRS'
when 17 then 'CM Fut' 
when 18 then 'CM Fut'
when 19 then 'EDS'
when 20 then 'CM SptFwd'
when 21 then 'FI Repo'
when 22 then 'FI BSB'
when 23 then 'FI Sto'
when 26 then 'IR Return swap' 
when 27 then 'CM Phys.Fwd' 
when 28 then 'CM Opt.Phys'
when 29 then 'FI Credit line' 
when 30 then 'CM Fwd' 
else null end GENTYP,
rtrim(gin.M_INSTR)      PLILAB, 
rtrim(gin.M_INSTR_DESC) PLIDES, 
rtrim(gin.M_SING_CURR)  CUR,
gin.M_NB_LEG LEGOCC,
case gen.M_RATE_TYPE0 when 0 then 'Fix' else 'Flt' end ||'-'||case gen.M_RATE_TYPE1 when 0 then 'Fix' else 'Flt' end LEGPAT,
case
when gen.M_RATE_TYPE0 = 0 then 'Fix'
when gen.M_RATE_TYPE0 = 1 then 'Flt' end LEGNAT0,
case gen.M_SETTLE0
when 0 then 'Cash'
when 1 then 'Fys.dlv.'
when 2 then 'Fin.dlv.' end LEGEXR0, 
rtrim(gen.M_CURRENCY0) CUR0,
case 
when gin.M_INSTR_TYPE in (0,2) then
   case gen.M_RATE_TYPE0 
   when 0 then 'CUR'
   when 1 then
      case ind0.M_RESET 
      when 0 then 'PUB' 
      when 2 then 'CMP' 
      when 3 then 'AVG' else null end
   else null end
when gin.M_INSTR_TYPE in (1,9) then 'CUR'
when gin.M_INSTR_TYPE in (12,13,27) then
   case ind0.M_RESET
   when 0 then 'SPT'
   when 2 then 'CMP'
   when 3 then 'AVG'
   when 4 then 'BSK' else null end
else null end INDTYP0,
case 
when gin.M_INSTR_TYPE in (0,2) then
   case gen.M_RATE_TYPE0 
   when 0 then rtrim(gen.M_CURRENCY0)
   when 1 then rtrim(ind0.M_IND_LAB)
   else null end
when gin.M_INSTR_TYPE in (1,9) then rtrim(gen.M_CURRENCY0)
when gin.M_INSTR_TYPE in (12,13,27) then rtrim(ind0.M_IND_LAB)
else null end INDLAB0, 
rtrim(und0.M_IND_LAB) UNDLAB0,
rtrim(gen.M_ECP0) SCHLAB0,
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
case sch0.M_DEF_UNIT
when 1 then 'Daily'
when 3 then
   case sch0.M_DEF_FREQ
   when  1 then 'Monthly'
   when  3 then 'Quarterly'
   when  6 then 'Semesterly'
   when 12 then 'Yearly' 
   else null end
when 5 then 'Quarterly'
when 5 then 'Semesterly'
when 6 then 'Yearly' 
else null end SCH0,     
case
when gen.M_RATE_TYPE1 = 0 then 'Fix'
when gen.M_RATE_TYPE1 = 1 then 'Flt' end LEGNAT1,
case
when gen.M_SETTLE1 = 0 then 'Cash'
when gen.M_SETTLE1 = 1 then 'Fys.dlv.'
when gen.M_SETTLE1 = 2 then 'Fin.dlv.' end LEGEXR1,
gen.M_CURRENCY1 CUR1,
case 
when gin.M_INSTR_TYPE in (0,2) then
   case gen.M_RATE_TYPE1 
   when 0 then 'CUR'
   when 1 then
      case ind1.M_RESET 
      when 0 then 'PUB' 
      when 2 then 'CMP' 
      when 3 then 'AVG' else null end
   else null end
when gin.M_INSTR_TYPE in (12,13,27) then
   case ind1.M_RESET
   when 0 then 'SPT'
   when 2 then 'CMP'
   when 3 then 'AVG'
   when 4 then 'BSK' else null end
else null end INDTYP1,
case 
when gin.M_INSTR_TYPE in (0,2) then
   case gen.M_RATE_TYPE1 
   when 0 then rtrim(gen.M_CURRENCY1)
   when 1 then rtrim(ind1.M_IND_LAB)
   else null end
when gin.M_INSTR_TYPE in (1,9) then rtrim(gen.M_CURRENCY1)
when gin.M_INSTR_TYPE in (12,13,27) then rtrim(ind1.M_IND_LAB)
else null end INDLAB1,
rtrim(und1.M_IND_LAB) UNDLAB1, 
rtrim(gen.M_ECP1)     SCHLAB1,
case sch1.M_DEF_UNIT
when 0 then 'Open day'
when 1 then 'Day' 
when 2 then 'Week'
when 3 then 'Month'
when 4 then 'Quarter'
when 5 then 'Semester'
when 6 then 'Year'
when 7 then 'Intraday' else null end SCHTEN1,
sch1.M_DEF_FREQ  SCHFRQ1,
case sch1.M_DEF_UNIT
when 1 then 'Daily'
when 3 then
   case sch1.M_DEF_FREQ
   when  1 then 'Monthly'
   when  3 then 'Quarterly'
   when  6 then 'Semesterly'
   when 12 then 'Yearly' 
   else null end
when 5 then 'Quarterly'
when 5 then 'Semesterly'
when 6 then 'Yearly' 
else null end SCH1, 
gen.M_GEN_NUM    GENUID,
ind0.M_INDEX     INDNDX0,
ind0.M_REFERENCE INDUID0,
und0.M_INDEX     UNDNDX0,
und0.M_REFERENCE UNDUID0,
ind1.M_INDEX     INDNDX1,
ind1.M_REFERENCE INDUID1,
und1.M_INDEX     UNDNDX1,
und1.M_REFERENCE UNDUID1

from RT_LNGN_DBF gen
left join RT_INSGN_DBF gin  on gen.M_GEN_NUM = gin.M_GEN_NUM
left join RT_INDEX_DBF ind0 on rtrim(gen.M_INDEX0) = rtrim(ind0.M_INDEX)
left join RT_INDEX_DBF und0 on ind0.M_UNDRL = und0.M_INDEX
left join DAT_ECH_DBF  sch0 on gen.M_ECP0 = sch0.M_LABEL
left join RT_INDEX_DBF ind1 on gen.M_INDEX1 = ind1.M_INDEX
left join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join DAT_ECH_DBF  sch1 on gen.M_ECP1 = sch1.M_LABEL
left join LST_PREFV_DBF prfpli on rtrim(gin.M_INSTR) = rtrim(prfpli.M_VALUE) and prfpli.M_INDEX2 in
(
142, --TRAF_INCL_OIL  [6]
145, --TRAF_INCL_GAS  [3,4,20]
151, --TRAF_INCL_COAL [17]
152, --TRAF_INCL_CHE  [21]
160, --TRAF_INCL_EMI  [13]
161, --TRAF_INCL_PMT  [11]
162, --TRAF_INCL_FMT  [19]
163, --TRAF_INCL_BMT  [2]
164, --TRAF_INCL_AGS  [14]
170, --TRAF_INCL_FRW  [22]
171, --TRAF_INCL_FRB  [12]
173, --TRAF_INCL_EQD  [EQD]
174, --TRAF_INCL_IRD  [IRD]
191, --TRAF_INCL_RFC  [23]
195, --TRAF_INCL_FXD  [CURR|FUT]
196, --TRAF_INCL_FXC  [CURR|FXD]
200, --TRAF_INCL_CRD  [CDS]
201  --TRAF_INCL_BND  [BND]
)
left join LST_PREFH_DBF prflst on prfpli.M_INDEX2 = prflst.M_INDEX

where 1 = 1
and gin.M_INSTR_TYPE in (0,1,2,3,9,12,13,20,27,28) 
and gin.M_CREAT_MODE = 0
and rtrim(prfpli.M_VALUE) is not null

);

drop table VIW_GEN_DBF;
create table VIW_GEN_DBF as (select * from GEN_VIW);
