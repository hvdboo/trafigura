select 
to_char(aud.M_DATE_CMP, 'yyyy-mm-dd') DAT_CMP, 
to_char(floor(aud.M_TIME_CMP/3600),'09')||':'||
to_char(floor(mod(aud.M_TIME_CMP,3600)/60),'09')||':'||
to_char(mod(mod(aud.M_TIME_CMP,3600),60),'09') TIM_CMP,
aud.M_TIME_ELAP ELAPS,
to_char(aud.M_DATE_SYS, 'yyyy-mm-dd') DAT_SYS,
rtrim(aud.M_DESK) DSK, rtrim(aud.M_GROUP) GRP, rtrim(aud.M_USER) USR,
rtrim(aud.M_COMMENT) STEP,
rtrim(aud.M_SCRPT_NAME) SCR, rtrim(aud.M_UNIT_NAME) UNIT,
rtrim(aud.M_START_END) SE
from TRN_EODA_DBF aud
where to_char(aud.M_DATE_CMP,'yyyymmdd') = '20140806'
order by aud.M_REFERENCE