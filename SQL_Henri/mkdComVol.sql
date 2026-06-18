select distinct 
trim(grp.M_LABEL) GRP,
case grp.M_GTYPE
when 1024 then 'CM_FUT'
when 2048 then 'CM_INDEX' else null end TYP,
case grp.M_GTYPE
when 1024 then trim(fcm.M_LABEL)
when 2048 then trim(icm.M_LABEL) else null end INSLAB,
trim(gri.M_CURR) CUR,
case grp.M_GTYPE
when 1024 then trim(fcm.M_DESC)
when 2048 then trim(icm.M_DESC) else null end INSDES

from CMG_GRP_DBF grp 
left join TRN_PC_DBF pc on 1 = 1
left join CMG_GRPI_DBF gri on grp.M_REFERENCE = gri.M_GROUP  and grp.M_GTYPE = gri.M_GTYPE
left join CM_FUT_DBF fcm on (gri.M_FUTURE = fcm.M_REFERENCE  and gri.M_GTYPE = 1024) 
left join CM_INDEX_DBF icm on (gri.M_INDEX = icm.M_REFERENCE and gri.M_GTYPE = 2048)

where 1 = 1
and grp.M_GTYPE in (1024, 2048, 8192)
and grp.M__DATE_ = pc.M_DATE
-- and trim(grp.M__DATE_) = to_date(20181011,'YYYYMMDD')
-- and trim(grp.M_LABEL) in ('AL LME','CU CMX')

order by GRP, TYP, INSLAB;