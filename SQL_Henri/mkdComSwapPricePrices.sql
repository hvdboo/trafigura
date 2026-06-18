select 
to_char(swpprc.M__DATE_,'YYYYMMDD') DAT,
rtrim(swpprc.M__ALIAS_) MDS,
rtrim(grp.M_LABEL) GRP,
-- coalesce(rtrim(genind.M_IND_LAB), rtrim(indind.M_IND_LAB)) IND,
coalesce(rtrim(gencmi.M_LABEL),rtrim(indcmi.M_LABEL)) CMI,
-- rtrim(pilset.M_LABEL) PILSET,
mat.M_LABEL PILLAB,
case mat.M_BLK_TYPE
when -1 then 'Floating'
when  0 then 'Open'
when  1 then 'Day'
when  2 then 'Week'
when  3 then 'Month'
when  4 then 'Quarter'
when  5 then 'Season'
when  6 then 'Year'
when  7 then 'Week-end'
when  8 then 'Weekdays'
when  9 then 'Balmo' 
when 15 then 'Month 2nd BD'
else '' end PILTEN,
to_char(mat.M_QT_END,'YYYYMMDD') QOTLST,
to_char(mat.M_ST_START,'YYYY-MM-DD') DLVFST,
to_char(mat.M_ST_END,'YYYY-MM-DD') DLVLST,
case swpprc.M_GEN_MODE 
when 1 then 'Price'
when 2 then 'Forward rate' else null end QOTTYP,
case swpprc.M_GEN_MODE
when 1 then round(swpprc.M_PRC_RF0,genqot.M_PRC_DEC) 
when 2 then round(swpprc.M_PRC_RF0,indqot.M_PRC_DEC) else null end PRCBID,
case swpprc.M_GEN_MODE
when 1 then round(swpprc.M_PRC_RF1,genqot.M_PRC_DEC) 
when 2 then round(swpprc.M_PRC_RF1,indqot.M_PRC_DEC) else null end PRCASK,
swpprc.M_SELECTED SEL

from CMG_INDP_DBF swpprc
left join TRN_PC_DBF pc on  1 = 1
left join CMG_GRPI_DBF grpi on (swpprc.M_INSTR_GEN = grpi.M_INSTR_GEN and grpi.M_GTYPE = 256 and rtrim(swpprc.M__ALIAS_) = rtrim(grpi.M__ALIAS_) and swpprc.M__DATE_ = grpi.M__DATE_)
left join CMG_GRP_dbf grp on (grpi.M_GROUP = grp.M_REFERENCE and rtrim(grpi.M__ALIAS_) = rtrim(grp.M__ALIAS_) and grpi.M__DATE_ = grp.M__DATE_)
left join CMC_MGEN_DBF mgen on (swpprc.M_INSTR_GEN = mgen.M_REFERENCE and swpprc.M_GEN_MODE = 1)
left join RT_INDEX_DBF genind on mgen.M_INDEX = genind.M_INDEX
left join CM_INDEX_DBF gencmi on genind.M_COM_IND = gencmi.M_REFERENCE
left join CMC_QUOT_DBF genqot on genind.M_COM_QUOT = genqot.M_REFERENCE
left join RT_INDEX_DBF indind on (swpprc.M_INSTR_GEN = indind.M_COM_IND and swpprc.M_GEN_MODE = 2)
left join CM_INDEX_DBF indcmi on indind.M_COM_IND = indcmi.M_REFERENCE
left join CMC_QUOT_DBF indqot on indind.M_COM_QUOT = indqot.M_REFERENCE
left join CMG_GRPP_DBF pil on (swpprc.M_PILLAR = pil.M_PILLAR and swpprc.M__DATE_ = pil.M__DATE_)
left join CM_PLST_DBF pilset on pil.M_PIL_SET = pilset.M_REFERENCE
left join CM_FMAT1_DBF mat on pil.M_MAT_CODE = mat.M_REFERENCE

where 1 = 1
and swpprc.M__DATE_ = pc.M_DATE
and swpprc.M__ALIAS_ = 'RT'
-- and M_INSTR_GEN = 611
and gencmi.M_REFERENCE = 1221

order by DAT, MDS, GRP, CMI, DLVLST
