select 
rtrim(mds.M_LABEL) LABEL, 
rtrim(mds.M_DESC) DESCRIPTION, 
rtrim(mds.M_ALIAS) ALIAS, 
case mds.M_TYPE
when 0 then 'Standard'
when 1 then 'Realtime' else '' end TYP,
rtrim(mds.M_RTCTASG) RTC_ASG,
rtrim(mds.M_CACASG) COL_ASG

from TRN_MDS_DBF mds
order by mds.M_LABEL