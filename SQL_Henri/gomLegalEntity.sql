select 	
rtrim(ctp.M_DSP_LABEL) NAME, 
rtrim(ctp.M_NAME)      DESCR,
rtrim(ctp.M_LEI)       LEI, 
rtrim(cou.M_DESC)      COUNTRY,
ctp.M_LABEL ID

from TRN_CPDF_DBF ctp
left join FISC_CAT_DBF fisc on ctp.M_FISC_CAT = fisc.M_REFERENCE
left join CR_CTRY_DBF cou on ctp.M_COUNTRY = cou.M_REFERENCE
left join CSF_FOLDER_DBF sec on ctp.M_SECTOR = sec.M_REFERENCE
left join TABLE#DATA#COUNTERP_DBF udf on ctp.M_LABEL = udf.M_LABEL
left join CTP_TYPES_DBF t16 on ctp.M_ID = t16.M_CTN and t16.M_REF = 16

where ctp.M_STATUS < 2 and t16.M_REF = 16
order by ctp.M_STATUS, ctp.M_DSP_LABEL