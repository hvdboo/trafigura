select 
case
when ins.M_INSTR_TYPE = 12 then 'Asian'
when ins.M_INSTR_TYPE = 13 then 'Swap' end as TYPE, 
rtrim(ins.M_INSTR) as INSTRUMENT, rtrim(ins.M_INSTR_DESC) as DESCRIPTION, ins.M_SING_CURR as CURRENCY,
case
when ins.M_INSTR_TYPE = 13 and ins.M_RAT_DISP = 0 then 'Fix'
when ins.M_INSTR_TYPE = 13 and ins.M_RAT_DISP = 1 then 'Flt-Fix'
when ins.M_INSTR_TYPE = 13 and ins.M_RAT_DISP = 4 then 'Flt-Flt' else 'Flt-Fix' end as NATURE,
ins.M_NB_PHASE as PHASES, ins.M_NB_LEG as LEGS, 
case
when ins.M_FLAGS =   0 then 'Independent'
when ins.M_FLAGS =   1 then 'Common'
when ins.M_FLAGS =   4 then 'Common diff.frequency'
when ins.M_FLAGS = 513 then 'Ignore discounting' end as AL_SCHED,
case
when ins.M_DLV_ConD = 0 then 'Independent'
when ins.M_DLV_ConD = 1 then 'Common' end as AL_DLV,
case
when ins.M_LEG_PROF = 0 then 'Independent'
when ins.M_LEG_PROF = 1 then 'Common' end as AL_PRF,
case
when gen.M_ECP_TYPE0 = 0 then 'Driving'
when gen.M_ECP_TYPE0 = 1 then 'Equal to'
when gen.M_ECP_TYPE0 = 2 then 'Deduced from' end as CALF_TYP0,
case
when gen.M_ECP_TYPE0 = 0 and gen.M_ECP_UNDRL0 = -1  then 'Itself'
when gen.M_ECP_UNDRL0 = -1 then 'Single period'
when gen.M_ECP_UNDRL0 = 0  then 'Payment'
when gen.M_ECP_UNDRL0 = 1  then 'Calc.first'
when gen.M_ECP_UNDRL0 = 2  then 'Fixing'
when gen.M_ECP_UNDRL0 = 7  then 'Calc.last' end as CALF_UND0,
rtrim(gen.M_ECP0) as CALF_SCH0,
case
when gen.M_ECPE_TYPE0 = 0 then 'Driving'
when gen.M_ECPE_TYPE0 = 1 then 'Equal to'
when gen.M_ECPE_TYPE0 = 2 then 'Deduced from' end as CALL_TYP0,
case
when gen.M_ECPE_UNDR0 = -1 then 'Single period'
when gen.M_ECPE_UNDR0 = 0  then 'Payment'
when gen.M_ECPE_UNDR0 = 1  then 'Calc.first'
when gen.M_ECPE_UNDR0 = 2  then 'Fixing'
when gen.M_ECPE_UNDR0 = 7  then 'Calc.last' end as CALL_UND0,
rtrim(gen.M_ECPE0) as CALL_SCH0,
case
when gen.M_EI_TYPE0 = 0 then 'Driving'
when gen.M_EI_TYPE0 = 1 then 'Equal to'
when gen.M_EI_TYPE0 = 2 then 'Deduced from' end as FIX_TYP0,
case
when gen.M_EI_UNDRL0 = -1 then 'Single period'
when gen.M_EI_UNDRL0 = 0  then 'Payment'
when gen.M_EI_UNDRL0 = 1  then 'Calc.first'
when gen.M_EI_UNDRL0 = 2  then 'Fixing'
when gen.M_EI_UNDRL0 = 7  then 'Calc.last' end as FIX_UND0,
rtrim(gen.M_EI0) as FIX_SCH0, rtrim(gen.M_FIX_CLN0) as FIX_CAL,
case
when gen.M_EP_TYPE0 = 0 then 'Driving'
when gen.M_EP_TYPE0 = 1 then 'Equal to'
when gen.M_EP_TYPE0 = 2 then 'Deduced from' end as PAY_TYP0,
case
when gen.M_EP_UNDRL0 = -1 then 'Single period'
when gen.M_EP_UNDRL0 = 0  then 'Payment'
when gen.M_EP_UNDRL0 = 1  then 'Calc.first'
when gen.M_EP_UNDRL0 = 2  then 'Fixing'
when gen.M_EP_UNDRL0 = 7  then 'Calc.last' end as PAY_UND0,
rtrim(gen.M_EP0) as PAY_SCH0, gen.M_PAY_CLN0 as PAY_CAL0,
case
when gen.M_DLV_TYPE0 = 1 then 'Equal to'
when gen.M_DLV_TYPE0 = 4 then 'Sub schedule' end as DLV_TYP0,
case
when gen.M_DLV_UNDR0 = -1 then sch.M_LABEL
when gen.M_DLV_UNDR0 = 0  then 'Payment'
when gen.M_DLV_UNDR0 = 1  then 'Calc.first'
when gen.M_DLV_UNDR0 = 2  then 'Fixing'
when gen.M_DLV_UNDR0 = 7  then 'Calc.last' end as DLV_UND0,
case
when gen.M_RATE_TYPE0 = 0 then 'Fix'
when gen.M_RATE_TYPE0 = 1 then 'Flt' end as LEG_NAT0,
case
when gen.M_SETTLE0 = 0 then 'Cash'
when gen.M_SETTLE0 = 1 then 'Fys.dlv.'
when gen.M_SETTLE0 = 2 then 'Fin.dlv.' end as LEG_EXR0, 
rtrim(ndx0.M_IND_LAB) as INDEX0, rtrim(und0.M_IND_LAB) as UNDERL0, rtrim(hsr0.M_LABEL) as SERIE0, --ppr0.M_LABEL as PRC_PRF0, 
rtrim(fys0.M_LABEL) as DLV_FYS0, rtrim(loc0.M_LABEL) as DLV_LOC0,  rtrim(dpr0.M_LABEL) as DLV_PRF0,
case
when gen.M_RATE_TYPE1 = 0 then 'Fix'
when gen.M_RATE_TYPE1 = 1 then 'Flt' end as LEG_NAT1,
case
when gen.M_SETTLE1 = 0 then 'Cash'
when gen.M_SETTLE1 = 1 then 'Fys.dlv.'
when gen.M_SETTLE1 = 2 then 'Fin.dlv.' end as LEG_EXR1,
rtrim(ndx1.M_IND_LAB) as INDEX1, rtrim(und1.M_IND_LAB) as UNDRL1, rtrim(hsr1.M_LABEL) as SERIE1, --ppr1.M_LABEL as PRC_PRF1, 
rtrim(fys1.M_LABEL) as DLV_FYS1, rtrim(loc1.M_LABEL) as DLV_LOC1, rtrim(dpr1.M_LABEL) as DLV_PRF1,
case
when ins.M_CREAT_MODE = 0 then 'Template'
when ins.M_CREAT_MODE = 1 then 'Copy'
when ins.M_CREAT_MODE = 2 then 'XX' end as CREATIon,
ins.M_TEMPL_NUM as ORIGINAL, gen.M_GEN_NUM as GEN_NUM
from RT_LNGN_DBF gen
left join RT_INSGN_DBF ins on gen.M_GEN_NUM=ins.M_GEN_NUM
left join DLV_SCHED_DBF sch on gen.M_DLV_SUB0=sch.M_REFERENCE
left join RT_INDEX_DBF ndx0 on gen.M_INDEX0=ndx0.M_INDEX
left join RT_INDEX_DBF ndx1 on gen.M_INDEX1=ndx1.M_INDEX
left join RT_INDEX_DBF und0 on ndx0.M_UNDRL=und0.M_INDEX
left join RT_INDEX_DBF und1 on ndx1.M_UNDRL=und1.M_INDEX
left join CM_MKTSR_DBF hsr0 on RTRIM(substr(gen.M_FORMULA0,2,10))=LTRIM(TO_CHAR(hsr0.M_SERIE))
left join CM_MKTSR_DBF hsr1 on RTRIM(substr(gen.M_FORMULA1,2,10))=LTRIM(TO_CHAR(hsr1.M_SERIE))
left join CM_PROFH_DBF ppr0 on gen.M_FORMULA0=TO_CHAR(ppr0.M_REFERENCE)
left join CM_PROFH_DBF ppr1 on gen.M_FORMULA1=TO_CHAR(ppr1.M_REFERENCE)
left join CM_PHYS_DBF fys0 on gen.M_DEL_FYS0=fys0.M_REFERENCE
left join CM_PHYS_DBF fys1 on gen.M_DEL_FYS1=fys1.M_REFERENCE
left join CM_LOCAT_DBF loc0 on gen.M_DEL_LOC0=loc0.M_REFERENCE
left join CM_LOCAT_DBF loc1 on gen.M_DEL_LOC1=loc1.M_REFERENCE
left join CM_PROFH_DBF dpr0 on gen.M_PROFILE0=dpr0.M_REFERENCE
left join CM_PROFH_DBF dpr1 on gen.M_PROFILE1=dpr1.M_REFERENCE
where (ins.M_INSTR_TYPE=12 or ins.M_INSTR_TYPE=13) and ins.M_CREAT_MODE = 0
order by ins.M_INSTR_TYPE, ins.M_INSTR