select 
crv.M_REFERENCE CRVREF, 
crv.M_KEY CRVKEY, 
rtrim(icm.M_LABEL) ICM,
case grp.M_VAL_TYPE
when 0 then 'Lease Metal Rate'
when 2 then 'Lease Cash Rate'
when 4 then 
   case when rtrim(crvfcm.M_LABEL) is not null then 'Future' else 'Index' end
when 5 then 'Forward Rate' else null end CRVVAL,
case grp.M_GEN_MODE
when 0 then 'Custom'
when 1 then 'Simple'
when 2 then 'Yield' else null end CRVMOD,
case 
when rtrim(crvfcm.M_LABEL) is not null then rtrim(crvfcm.M_LABEL) 
when rtrim(genind.M_IND_LAB) is not null then rtrim(genind.M_IND_LAB)
when rtrim(crvicm.M_LABEL) is not null then rtrim(crvicm.M_LABEL)
else null end CRVOBJ,
/*
rtrim(crvfcm.M_LABEL) CRVFCM,
rtrim(crvicm.M_LABEL) CRVICM,
rtrim(genind.M_IND_LAB) GENIND,
*/
rtrim(pilset.M_LABEL) PILSET,
grp.*
--crvgen.*

from CMK_SCCF_DBF crv
cross join (select M_DATE from TRN_PC_DBF where ROWNUM = 1) pc
left join CM_INDEX_DBF icm on to_number(substr(crv.M_KEY,1,10)) = icm.M_REFERENCE
left join CMG_GRPI_DBF grp on (crv.M__ALIAS_ = grp.M__ALIAS_ and crv.M__DATE_ = grp.M__DATE_ and crv.M_OBJ_PIL = grp.M_GROUP and grp.M_GTYPE = 512)
left join CM_FUT_DBF   crvfcm on grp.M_FUTURE = crvfcm.M_REFERENCE
left join CMC_MGEN_DBF crvgen on grp.M_INSTR_GEN = crvgen.M_REFERENCE and grp.M_GEN_MODE = 1
left join CM_INDEX_DBF crvicm on grp.M_INDEX = crvicm.M_REFERENCE and grp.M_GEN_MODE = 2
left join RT_INDEX_DBF genind on crvgen.M_INDEX = genind.M_INDEX
left join CM_PLST_DBF  pilset on grp.M_PILSET = pilset.M_REFERENCE

where 1 = 1
and crv.M__DATE_ = pc.M_DATE
and crv.M__ALIAS_ = 'RT'
and crv.M_REFERENCE in (16, 17,66,842)


