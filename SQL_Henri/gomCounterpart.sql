select 
rtrim(ctp.M_DSP_LABEL) NAME, 
rtrim(ctp.M_NAME) DES, 
rtrim(ctp.M_LEI) LEI, 
-- TYPE
case when typbnk.M_REF IS NULL then NULL else 'X' end  TYPBNK, --BANK
case when typbrk.M_REF IS NULL then NULL else 'X' end  TYPBRK, --BROKER
case when typclr.M_REF IS NULL then NULL else 'X' end  TYPCLR, --CLEARER
case when typcli.M_REF IS NULL then NULL else 'X' end  TYPCLI, --CLIENT
case when typlen.M_REF IS NULL then NULL else 'X' end  TYPLEN, --LEGAL ENTITY
case when typlen.M_REF IS NULL then NULL else 'X' end  TYPMGT, --MANAGEMENT COMPANY
case when typpro.M_REF IS NULL then NULL else 'X' end  TYPPRO, --PROCESSING AREA
case when typicl.M_REF IS NULL then NULL else 'X' end  TYPICL, --INTERNAL CLIENT
case when typrpt.M_REF IS NULL then NULL else 'X' end  TYPRPT, --RELATED PARTY
case when typoth.M_REF IS NULL then NULL else 'X' end  TYPOTH, --OTHER
case when typfic.M_REF IS NULL then NULL else 'X' end  TYPFIC, --FICTIVE
rtrim(udf.M_INTRAGRP) INTGRP,
-- rtrim(ctp.M_PARENT_CPY) PARENT,
rtrim(ctp.M_PARENT_CPY) PARLAB,
rtrim(par.M_DSP_LABEL) PARTRE, 
-- rtrim(ctp.M_COMMENT0) as COMMENT_,
rtrim(ctp.M_ISS_CAT) CRDCAT,
rtrim(fiscal.M_LABEL) FISCAL,
rtrim(sec.M_LABEL) SEC,
-- ALT ID
(acc.M_OBJ_ALT) ACC,
-- UDF
rtrim(udf.M_CLR_ACC_ID) CLR_ACC,
case when ctp.M_PAY_NET = 1 then 'Y' else 'N' end as PAYNET,
-- ADDRESS
rtrim(cou.M_COUNTRY) as COUCOD,
rtrim(cou.M_DESC) as COUNTRY,
rtrim(ctp.M_ADDRESS0) as ADDR0, 
rtrim(ctp.M_ADDRESS1) as ADDR1, 
rtrim(ctp.M_ADDRESS2) as ADDR2, 
rtrim(ctp.M_ADDRESS3) as ADDR3, 
rtrim(ctp.M_CITY) as CITY, 
rtrim(ctp.M_POSTCODE) as ZIP, 
-- PING
rtrim(ctp.M_TEL) as PHONE, 
rtrim(ctp.M_EMAIL) as MAIL, 
rtrim(ctp.M_SFT) as SWIFT,
-- STATUS
case ctp.M_STATUS
when 0 then 'Live'
when 1 then 'Suspend'
when 2 then 'Dead' end as STATUS,
ctp.M_REVISION as REVIS, 
(srd.M_OBJ_ALT) SRD,
ctp.M_LABEL LAB,
ctp.M_ID ID

from TRN_CPDF_DBF ctp
left join CR_CTRY_DBF cou on ctp.M_COUNTRY = cou.M_REFERENCE
left join CR_CAT_DBF crdcat on rtrim(ctp.M_ISS_CAT) = rtrim(crdcat.M_CATEGORY0)
left join FISC_CAT_DBF fiscal on ctp.M_FISC_CAT = fiscal.M_REFERENCE
left join TRN_SECTOR_DBF sec on ctp.M_SECTOR = sec.M_REFERENCE
left join LEI_DBF lei on ctp.M_ID = lei.M_REFERENCE
left join CTP_TYPES_DBF typbnk on (ctp.M_ID = typbnk.M_CTN and typbnk.M_REF =    1) --BANK
left join CTP_TYPES_DBF typbrk on (ctp.M_ID = typbrk.M_CTN and typbrk.M_REF =    2) --BROKER
left join CTP_TYPES_DBF typfic on (ctp.M_ID = typfic.M_CTN and typfic.M_REF =    4) --FICTIVE
left join CTP_TYPES_DBF typoth on (ctp.M_ID = typoth.M_CTN and typoth.M_REF =    6) --OTHER
left join CTP_TYPES_DBF typclr on (ctp.M_ID = typclr.M_CTN and typclr.M_REF =   12) --CLEARER
left join CTP_TYPES_DBF typcli on (ctp.M_ID = typcli.M_CTN and typcli.M_REF =   13) --CLIENT
left join CTP_TYPES_DBF typlen on (ctp.M_ID = typlen.M_CTN and typlen.M_REF =   16) --LEGAL ENTITY
left join CTP_TYPES_DBF typmgt on (ctp.M_ID = typmgt.M_CTN and typmgt.M_REF =   25) --MANAGEMENT COMPANY
left join CTP_TYPES_DBF typpro on (ctp.M_ID = typpro.M_CTN and typpro.M_REF =   27) --PROCESSING AREA
left join CTP_TYPES_DBF typicl on (ctp.M_ID = typicl.M_CTN and typicl.M_REF = 1001) --INTERNAL CLIENT
left join CTP_TYPES_DBF typrpt on (ctp.M_ID = typrpt.M_CTN and typrpt.M_REF = 1002) --RELATED PARTY
left join TRN_CPDF_DBF par on rtrim(ctp.M_PARENT) = rtrim(par.M_LABEL)
left join TABLE#DATA#COUNTERP_DBF udf on ctp.M_LABEL = udf.M_LABEL
left join KEYMAP_STC_DBF srd on (to_char(ctp.M_ID) = rtrim(srd.M_OBJ_DESC) and rtrim(srd.M_OBJ_CLASS) = 'MvRWS58256' and rtrim(srd.M_OBJ_ASYS) = 'SRD')
left join KEYMAP_STC_DBF acc on (to_char(ctp.M_ID) = rtrim(acc.M_OBJ_DESC) and rtrim(acc.M_OBJ_CLASS) = 'MvRWS58256' and rtrim(acc.M_OBJ_ASYS) = 'ACC_ID')

where 1 = 1
-- and ctp.M_STATUS < 2 and ctp.M_STATE = 'N' and ctp.M_OTHER = 'N'
-- and rtrim(ctp.M_DSP_LABEL) in ('CHB','CLC','NTT','TEZ','TNJ','TTH','TTS','TTY')
-- and ctp.M_ID in (1595,1608,1155,1560,1312,1625,1204,1206)
-- and ctp.M_LABEL in ('1204') or ctp.M_PARENT in ('1204')

order by ctp.M_DSP_LABEL
