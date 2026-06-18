select 
lev.M_NB LEV, 
case when lev.M_TYPE = 0 then rtrim(def.M_LABEL) else 'Default' end TYP,
rtrim(lev.M_LABEL) LEV_LAB, rtrim(lev.M_DESC) LEV_DESC, 
case 
when lev.M_NB = 2 then rtrim(pc.M_LABEL)
when lev.M_NB = 3 then rtrim(es.M_LABEL)
when lev.M_NB = 4 then rtrim(ce.M_LABEL)
when lev.M_NB > 4 then rtrim(val.M_LABEL) end VAL_LAB, 
case 
when lev.M_NB = 2 then rtrim(pc.M_DESC)
when lev.M_NB = 4 then rtrim(ce.M_DESC)
when lev.M_NB > 4 then rtrim(val.M_DESC) end VAL_DESC
 
from MUB#MUB_LEV_DBF lev
left join MUB#LEV_DEF_DBF def on lev.M_NB + 1 = def.M_REFERENCE
left join TRN_PC_DBF pc on 1 = 1
left join TRN_ENTS_DBF es on (pc.M_REFERENCE = es.M_PC and lev.M_NB < 5)
left join TRN_ENTDL_DBF sle on (es.M_ENTITIES = sle.M_CTN and sle.M_REF > 0)
left join TRN_ENTD_DBF ce on (sle.M_REF = ce.M_REF and lev.M_NB = 4)
left join TRN_CPUB_DBF val on rtrim(lev.M_LABEL) = rtrim(val.M_USR_VAL) and rtrim(val.M_CLASS) = 'SPB_MUB'

group by
lev.M_NB, 
case when lev.M_TYPE = 0 then rtrim(def.M_LABEL) else 'Default' end,
rtrim(lev.M_LABEL), 
rtrim(lev.M_DESC), 
case 
when lev.M_NB = 2 then rtrim(pc.M_LABEL)
when lev.M_NB = 3 then rtrim(es.M_LABEL)
when lev.M_NB = 4 then rtrim(ce.M_LABEL)
when lev.M_NB > 4 then rtrim(val.M_LABEL) end, 
case 
when lev.M_NB = 2 then rtrim(pc.M_DESC)
when lev.M_NB = 4 then rtrim(ce.M_DESC)
when lev.M_NB > 4 then rtrim(val.M_DESC) end

order by LEV, LEV_LAB, VAL_LAB