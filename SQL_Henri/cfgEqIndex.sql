select 
-- sh.M_SE_GROUP GRP, sh.M_SE_TYPE TYP,
rtrim(sr.M_SE_MARKET) MKT, coalesce(rtrim(sr.M_SE_CUR),rtrim(sm1.M_SE_CUR)) CUR,
rtrim(sh.M_SE_D_LABEL) SEC, rtrim(sh.M_SE_F_NAME) NAME, rtrim(sh.M_SE_CODE) CODE, 
rtrim(sh.M_SE_RTF0) RIC,
rtrim(eq.M_EQ_BASKET) BSK,
case eq.M_EQ_D_R_F
when 0 then 'Detached'
when 1 then 'Net amount reinvested'
when 2 then 'Gross amount reinvested' else null end DIV,
rtrim(eq.M_EQ_HBASKET) HDG,
rtrim(sr.M_SE_ARCHGRP) ARC,
rtrim(sr.M_SE_LABEL)

from SE_ROOT_DBF sr
left join SE_HEAD_DBF sh on sr.M_SE_LABEL = sh.M_SE_LABEL
left join SE_MKT1_DBF sm1 on sr.M_SE_MARKET = sm1.M_SE_MARKET 
left join SE_MKTOP_DBF smo on sh.M_SE_LABEL = smo.M_SE_LABEL
left join EQ_SE_DBF eq on smo.M_SE_INUM = eq.M_EQ_INUM
left join TRN_CPDF_DBF ctp on to_number(rtrim(sh.M_SE_ISS)) = ctp.M_ID 
left join CR_CTRY_DBF cou on sh.M_SE_COUNTRY = cou.M_REFERENCE 
left join CSF_FOLDER_DBF sct on sh.M_SE_SECTOR = sct.M_REFERENCE 
--left join TABLE#DATA#SECURITI_DBF udf on sh.M_SE_LABEL = udf.M_SE_LABEL

where sh.M_SE_GROUP = 'Equity' and sh.M_SE_TYPE = 'Index'
order by sr.M_SE_MARKET, sh.M_SE_D_LABEL