select 	
ctp.M_ID ID,
rtrim(ctp.M_DSP_LABEL) as NAME, rtrim(ctp.M_NAME) as DESCR, 
rtrim(ctp.M_LEI) as LEI, 
-- rtrim(ctp.M_PARENT_CPY) as PARENT, 
-- rtrim(ctp.M_COMMENT0) as COMMENT_,
rtrim(ctp.M_CODE) COD,
null X1,
rtrim(ctp.M_ADDRESS0) as ADDR0, rtrim(ctp.M_ADDRESS1) as ADDR1, 
rtrim(ctp.M_ADDRESS2) as ADDR2, rtrim(ctp.M_ADDRESS3) as ADDR3, 
rtrim(ctp.M_CITY) as CITY, rtrim(ctp.M_POSTCODE) as ZIP, rtrim(cou.M_DESC) as COUNTRY,
null X2,
rtrim(ctp.M_TEL) as PHONE, rtrim(ctp.M_EMAIL) as MAIL, rtrim(ctp.M_SFT) as SWIFT,
null X3,
rtrim(udf.M_RED_ID) as RED_ID,
null X4,
case ctp.M_STATUS
when 0 then 'Live'
when 1 then 'Suspend'
when 2 then 'Dead' end as STATUS,
ctp.M_REVISION as REVIS, 
ctp.M_ID ID
from TRN_CPDF_DBF ctp
left join FISC_CAT_DBF fisc on ctp.M_FISC_CAT = fisc.M_REFERENCE
left join CR_CTRY_DBF cou on ctp.M_COUNTRY = cou.M_REFERENCE
left join CSF_FOLDER_DBF sec on ctp.M_SECTOR = sec.M_REFERENCE
left join TABLE#DATA#COUNTERP_DBF udf on ctp.M_LABEL = udf.M_LABEL
left join LEI_DBF lei on ctp.M_ID = lei.M_REFERENCE
-- where ctp.M_STATUS < 2 and ctp.M_STATE = 'N' and ctp.M_OTHER = 'N'
order by ctp.M_STATUS, ctp.M_DSP_LABEL