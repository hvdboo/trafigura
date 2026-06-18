select es.M_LABEL ENT_SET, pc.M_LABEL PC,
es.M_ACCBYENT ACCOUNTING,
ent.M_LABEL CLS_ENTITY
from TRN_ENTS_DBF es
left join TRN_PC_DBF pc on es.M_PC = pc.M_REFERENCE
left join TRN_ENTDL_DBF enl on (es.M_ENTITIES = enl.M_CTN and enl.M_REF <> 0)
left join TRN_ENTD_DBF ent on enl.M_REF = ent.M_REF
where es.M_PC > 0