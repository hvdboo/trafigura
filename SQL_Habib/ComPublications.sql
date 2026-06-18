set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 285;
set pagesize 2048;
select  T1.M_LABEL as Publications, T1.M_DESC as Description, 
NVL(T5.M_DSP_LABEL,' ') as Publisher, T1.M_URL as Website, T1.M_CALENDAR as Calendar,
NVL (T3.M_LABEL,' ')  as TimeZone,
T1.M_FREQUENCY as Frequency,
case when T6.M_NULLFIX = 0 then 'Unchecked'
	when T6.M_NULLFIX = 1 then 'Checked'
end as AllowNullFixings,
T2.M_LABEL as Series,T2.M_IDENTITY- (select min(S2.M_IDENTITY) from CM_MKT_DBF S1, CM_MKTSR_DBF S2  where S1.M_LABEL=T1.M_LABEL and S1.M_REFERENCE=S2.M_REFERENCE (+))+1 as Ranking
-------
from 	CM_MKT_DBF T1, CM_MKTSR_DBF T2,
DAT_TZONE_DBF T3 , TRN_CPDF_DBF T5, RT_GROUP_DBF T6
-------
where	T1.M_REFERENCE=T2.M_REFERENCE (+)
and T1.M_TIME_ZONE = T3.M_REFERENCE (+)
and T1.M_PUBLISHER = T5.M_ID (+)
and to_char(T1.M_REFERENCE) = RTRIM(LTRIM(T6.M_GRP_CATEG))
and T6.M_GRP_DESC = 'Commodity publication'
and T6.M_IDENTITY in
(select min(M_IDENTITY) from RT_GROUP_DBF group by M_GRP_CATEG)
-------
order by T1.M_LABEL,Ranking;
quit;
SPOOL OFF;