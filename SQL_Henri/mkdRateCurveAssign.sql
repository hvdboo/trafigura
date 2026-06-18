select 
to_char(asx.M__DATE_,'yyyy-mm-dd') DAT,
rtrim(asx.M_LABEL) ASGSET,
rtrim(cur.M_FULL_NAME) CURR,
rtrim(asy.M_CUR) CUR,
coalesce(rtrim(asy.M_INST),' ')     INSTYP,
coalesce(rtrim(asy.M_CALC),' ')     CALC,
coalesce(rtrim(asy.M_SEC_MKT),' ')  MKT,
coalesce(rtrim(ind.M_IND_LAB),' ')  IND,
case asy.M_CURVETYPE
when 1 then 'Rate'
when 6 then 'Inflation'
else ' ' end                        CRVTYP,
coalesce(rtrim(gen.M_INSTR),' ')    GEN,
coalesce(rtrim(coll.M_LABEL),' ')   COLLAT,
/*
rtrim(asy.M_CONTRACT)           SECCNT_05,
rtrim(arc.M_GRP_DESC)           ARC_06,
rtrim(asy.M_UNDERLYING)         UND_08,
rtrim(gen.M_INSTR)              GEN_09,
rtrim(asy.M_ISSUE)              ISS_nn,
rtrim(asy.M_CNTRPART)           CTP_11,
rtrim(asy.M_CATEGORY)           CAT_12,
rtrim(asy.M_USER)               USR_13,
rtrim(asy.M_DESK)               DSK_14,
rtrim(asy.M_SPBGROUP)           GRP_15,
rtrim(typo.M_LABEL)             TYPO_17,
rtrim(usg.M_LABEL)              USG_18,
case asy.M_CURVETYPE
when 1 then 'Rate'
when 6 then 'Inflation'
else null end                   CRVTYP_19,
rtrim(asy.M_ENV)                ENV_20,
case asy.M_ONFSHORE    
when 0 then 'None'
when 1 then 'Onshore'
when 2 then 'Offshore'
else null end                   ONOFF_nn,
case asy.M_SHORTTERM   
when 1 then 'No'
when 2 then 'Yes'
else null end                   SHTRM_nn,
rtrim(sectyp.M_DESCRIPTION)     SECTYP_22,
rtrim(sen.M_LABEL)              SEN_23,
rtrim(sect.M_LABEL)             SECT_24,
rtrim(asy.M_RATING)             RATNG_25,
rtrim(isda.M_DFLT_DEF2)         ISDA_26,
rtrim(cou.M_COUNTRY)            COU_27,
*/
case 
when asy.M_CHLD_PRMT = 0 then rtrim(crv.M_DLABEL)
when asy.M_CHLD_PRMT > 0 then '> '||rtrim(asy.M_CHLD_PRMT)
else null end CURVE
from MPY_ASGRC_DBF asy 
left join MPX_ASGRC_DBF asx on asy.M__INDEX_ = asx.M__INDEX_
left join TRN_PC_DBF pc on asx.M__DATE_ = pc.M_DATE
left join FX_CURR_DBF cur on asy.M_CUR = cur.M_LABEL
left join RT_INDEX_DBF ind on asy.M_INDEX = ind.M_INDEX
left join RT_GROUP_DBF arc on asy.M_ARCHGRP = arc.M_HISFILE
left join RT_INSGN_DBF gen on asy.M_GENERATOR = gen.M_GEN_NUM
left join TYPOLOGY_DBF typo on asy.M_TYPOLOGY = typo.M_REFERENCE
left join USAGE_DBF usg on asy.M_USAGE = usg.M_REFERENCE
left join COLL_AGR_CAT_DBF coll on asy.M_COLLATERAL = coll.M_REFERENCE
left join STYPO_RTG_DBF sectyp on asy.M_STYPO = sectyp.M_REFERENCE
left join RT_SEN_DBF sen on asy.M_SENIORITY = sen.M_REFERENCE
left join CSF_FOLDER_DBF sect on asy.M_SECTOR = sect.M_REFERENCE
left join CR_DD_DBF isda on asy.M_DFLT_TEMP = isda.M_UID
left join CR_CTRY_DBF cou on asy.M_COUNTRY = cou.M_REFERENCE
left join RT_CT_DBF crv on asy.M_CURVE = crv.M_LABEL
where asx.M__DATE_ = pc.M_DATE
order by ASGSET, CUR, INSTYP asc, CALC, IND, asy.M_CHLD_PRMT desc, MKT, COLLAT asc