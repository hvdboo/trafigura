select  
rtrim(ent.M_LABEL) ENTITY, 
rtrim(ent.M_DESC) DES,  
rtrim(ent.M_EOD_SHIFT) EOD_SHIFT, 
rtrim(ent.M_CALENDAR) CAL, 
rtrim(mds.M_LABEL) CLOSING, 
rtrim(fix.M_LABEL) FIXING,
ent.M_CURRENCY CUR, 
rtrim(ctp.M_DSP_LABEL) LEGAL,
rtrim(tmz.M_LABEL) TMZ,
case ent.M_TA_MODE
when  0 then 'Manual'
when  1 then 'Implicit' end TRD_ACCEPT,
rtrim(rep.M_LABEL) REP_TMPL, 
rtrim(acc.M_LABEL) ACC_TMPL, 
rtrim(ent.M_ACC_CUR) ACC_CUR 

from TRN_ENTD_DBF ent
left join TRN_CPDF_DBF ctp on ent.M_CTP = ctp.M_ID
-- left join TRN_ENTDL_DBF lnk on ent.M_REF = lnk.M_REF
-- left join TRN_ENTS_DBF es on lnk.M_CTN = es.M_ENTITIES
left join TRN_MDS_DBF mds on ent.M_CLOSINGSET = mds.M_REFERENCE
left join TRN_IFS_DBF fix on ent.M_INTFIXSET = fix.M_REFERENCE
left join DAT_TZONE_DBF tmz on ent.M_TIMEZONE = tmz.M_REFERENCE
left join ACC_CLCTPL_DBF acc on ent.M_ACCTPL = acc.M_REFERENCE
left join ACC_CLCTPL_DBF rep on ent.M_REPTPL = rep.M_REFERENCE

order by ent.M_LABEL