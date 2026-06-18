select 
case cmfut.M_LISTED
when  1 then 'Fut'
when  2 then 'Fwd'
when 16 then 'Clr.Swap'
when 32 then 'Clr.Asian'
when 64 then 'Lst.Opt' end OBJ_TYP,
rtrim(cmfut.M_LABEL) OBJ_LAB,
-- rtrim(altid.M_OBJ_ASYS) ALT_SYS,
max(case when altid.M_OBJ_ASYS = 'COMMODITY' then coalesce(rtrim(phy.M_LABEL),rtrim(phy0.M_LABEL)) else null end) CMD_MX,
max(case when altid.M_OBJ_ASYS = 'COMMODITY' then  rtrim(altid.M_OBJ_ALT) else null end) CMD_ALT,
max(case when altid.M_OBJ_ASYS = 'MARKET' then  rtrim(pub.M_LABEL) else null end) MKT_MX,
max(case when altid.M_OBJ_ASYS = 'MARKET' then  rtrim(altid.M_OBJ_ALT) else null end) MKT_ALT,
max(case when altid.M_OBJ_ASYS = 'INSTRUMENT' then
(case cmfut.M_INS_MODE 
when 1 then rtrim(cmfut.M_LABEL)
when 0 then rtrim(ins.M_INSTR) else null end)
else null end) INS_MX,
max(case when altid.M_OBJ_ASYS = 'INSTRUMENT' then  rtrim(altid.M_OBJ_ALT) else null end) INS_ALT
from CM_FUT_DBF cmfut
left join CMC_QUOT_DBF qotf on cmfut.M_QUOT_FWD = qotf.M_REFERENCE
left join CM_MKT_DBF pub on qotf.M_PUBLI= pub.M_REFERENCE
left join CMC_MGEN_DBF mgen on cmfut.M_CM_INSTR = mgen.M_REFERENCE
left join RT_INDEX_DBF ind on mgen.M_INDEX = ind.M_INDEX
left join CM_INDEX_DBF indcm on ind.M_COM_IND = indcm.M_REFERENCE
left join CM_PHYS_DBF  phy on indcm.M_PHYSICAL = phy.M_REFERENCE
left join RT_INSGN_DBF ins on cmfut.M_CM_INSTR = ins.M_GEN_NUM
left join RT_LNGN_DBF gen on ins.M_GEN_NUM = gen.M_GEN_NUM
left join RT_INDEX_DBF ind0 on gen.M_INDEX0 = ind0.M_INDEX
left join RT_INDEX_DBF und0 on ind0.M_UNDRL = und0.M_INDEX
left join CM_INDEX_DBF indcm0 on und0.M_COM_IND = indcm0.M_REFERENCE
left join CM_PHYS_DBF  phy0 on indcm0.M_PHYSICAL = phy0.M_REFERENCE
left join KEYMAP_STC_DBF altid on (cmfut.M_REFERENCE = altid.M_OBJ_ID and altid.M_OBJ_CLASS = 'MwOJI56899')
where
cmfut.M_LISTED not in (16)
and coalesce(trim(cmfut.M_COMMENT4),'Y') = 'Y'
group by 
case cmfut.M_LISTED
when  1 then 'Fut'
when  2 then 'Fwd'
when 16 then 'Clr.Swap'
when 32 then 'Clr.Asian'
when 64 then 'Lst.Opt' end,
cmfut.M_LABEL
order by OBJ_LAB