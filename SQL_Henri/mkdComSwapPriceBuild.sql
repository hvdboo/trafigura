select 
to_char(grpi.M__DATE_,'YYYY-MM-DD') DAT,
rtrim(grpi.M__ALIAS_) MDS,
case grpi.M_GTYPE
when  256 then 'Index PRC'
when  512 then 'Curve'
when 1024 then 'Future VOL'
when 2048 then 'Index VOL'
when 4096 then 'Volume bucket'
when 8192 then 'Future VOL' else null end OBJ,
-- grpi.M_GROUP,
rtrim(grp.M_LABEL) GRP, 
rtrim(pils.M_LABEL) PILSET,
case grpi.M_VAL_TYPE
when 4 then 'Index' 
when 5 then 'Forward rate' else null end TYP,
case grpi.M_GEN_MODE
when 1 then 'Simple'
when 2 then '' else null end MOD_,
-- mgen.M_REFERENCE,
case grpi.M_VAL_TYPE
when 4 then rtrim(insind.M_IND_LAB)  
when 5 then rtrim(inscmi.M_LABEL) else null end INS,
coalesce(rtrim(ndxcmi.M_LABEL), rtrim(inscmi.M_LABEL)) IND

from CMG_GRPI_DBF grpi
left join TRN_PC_DBF pc on  1 = 1
left join CMG_GRP_DBF grp on (grpi.M_GROUP = grp.M_REFERENCE and grpi.M_GTYPE = grp.M_GTYPE and grpi.M__DATE_ = grp.M__DATE_ and grpi.M__ALIAS_ = grp.M__ALIAS_)
left join CM_PLST_DBF pils on grp.M_PILSET = pils.M_REFERENCE
left join CMC_MGEN_DBF ins on grpi.M_INSTR_GEN = ins.M_REFERENCE
left join RT_INDEX_DBF insind on (ins.M_INDEX = insind.M_INDEX and grpi.M_VAL_TYPE = 4)
left join CM_INDEX_DBF inscmi on (grpi.M_INSTR_GEN = inscmi.M_REFERENCE and grpi.M_VAL_TYPE = 5)
left join CM_INDEX_DBF ndxcmi on insind.M_COM_IND = ndxcmi.M_REFERENCE

where 1 = 1
and grpi.M__DATE_ = pc.M_DATE 
and grpi.M__ALIAS_ = 'RT'
and grpi.M_GTYPE in (256)
--and ndxcmi.M_REFERENCE = 1221

order by  DAT, OBJ, GRP, INS, IND, MDS
