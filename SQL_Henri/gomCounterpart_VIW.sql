DROP VIEW CTP_VIW;
CREATE VIEW CTP_VIW
(
M_LABDSP, 
M_NAME, 
M_LEI, 
M_RELIE,
M_RELICL,
M_RELIGR,
M_TYPBNK, 
M_TYPBRK,
M_TYPCLR,
M_TYPCLI,
M_TYPLEN,
M_TYPMGT,
M_TYPPRO,
M_TYPICL,
M_TYPRPT,
M_TYPOTH,
M_TYPFIC,
M_PARLAB,
M_PARTRE,
M_JURDES,
M_JURROL,
M_JURSUP,
M_JURREG,
M_ACCID,
M_ACCCLR,
M_PAYNET,
M_COUCOD,
M_COUNTRY,
M_ADDR0, 
M_ADDR1, 
M_ADDR2, 
M_ADDR3, 
M_CITY, 
M_ZIP, 
M_PHONE, 
M_MAIL, 
M_SWIFT,
M_STATUS,
M_REVIS, 
M_SRD,
M_LAB,
M_ID
)

AS

(
select 
rtrim(ctp.M_DSP_LABEL) LABDSP, 
rtrim(ctp.M_NAME) NAME, 
rtrim(ctp.M_LEI) LEI,
-- RELATION
case when typpro.M_REF IS NULL then 'E' else 'I' end  REL_IE,
case when typicl.M_REF IS NULL then 'E' else 'I' end  REL_ICL, 
rtrim(udf.M_INTRAGRP) REL_IGR,
-- TYPE
case when typbnk.M_REF IS NULL then NULL else 'Y' end  TYPBNK, --BANK
case when typbrk.M_REF IS NULL then NULL else 'Y' end  TYPBRK, --BROKER
case when typclr.M_REF IS NULL then NULL else 'Y' end  TYPCLR, --CLEARER
case when typcli.M_REF IS NULL then NULL else 'Y' end  TYPCLI, --CLIENT
case when typlen.M_REF IS NULL then NULL else 'Y' end  TYPLEN, --LEGAL ENTITY
case when typlen.M_REF IS NULL then NULL else 'Y' end  TYPMGT, --MANAGEMENT COMPANY
case when typpro.M_REF IS NULL then NULL else 'Y' end  TYPPRO, --PROCESSING AREA
case when typicl.M_REF IS NULL then NULL else 'Y' end  TYPICL, --INTERNAL CLIENT
case when typrpt.M_REF IS NULL then NULL else 'Y' end  TYPRPT, --RELATED PARTY
case when typoth.M_REF IS NULL then NULL else 'Y' end  TYPOTH, --OTHER
case when typfic.M_REF IS NULL then NULL else 'Y' end  TYPFIC, --FICTIVE
rtrim(ctp.M_PARENT_CPY) PARLAB,
rtrim(par.M_DSP_LABEL) PARTRE, 
-- rtrim(ctp.M_COMMENT0) as COMMENT_,
-- Jurisdiction
rtrim(jurref.M_DESC) as JUR_DESC,
rtrim(jurreg.M_LABEL) as JUR_REGIME,
rtrim(jursup.M_LABEL) as JUR_SUPERVISOR,
rtrim(jurrol.M_LABEL) as JUR_ROLE,
-- Accounts
rtrim(acc.M_OBJ_ALT) ACC_ID,
rtrim(udf.M_CLR_ACC_ID) ACC_CLR,
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
left join FISC_CAT_DBF fisc on ctp.M_FISC_CAT = fisc.M_REFERENCE
left join CR_CTRY_DBF cou on ctp.M_COUNTRY = cou.M_REFERENCE
left join CSF_FOLDER_DBF sec on ctp.M_SECTOR = sec.M_REFERENCE
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
left join CTP_JUR_DBF ctpjur on ctp.M_ID = ctpjur.M_CTP_REF
left join JURISDICTION_DBF jurref on ctpjur.M_JUR_REF = jurref.M_REFERENCE
left join JUR_ROLE_DBF jurrol on jurref.M_ROLE = jurrol.M_REFERENCE
left join JUR_SUP_BODY_DBF jursup on jurref.M_SUP_BODY = jursup.M_REFERENCE
left join JUR_REGIME_DBF jurreg on jurref.M_REGIME = jurreg.M_REFERENCE
left join KEYMAP_STC_DBF srd on (to_char(ctp.M_ID) = rtrim(srd.M_OBJ_DESC) and rtrim(srd.M_OBJ_CLASS) = 'MvRWS58256' and rtrim(srd.M_OBJ_ASYS) = 'SRD')
left join KEYMAP_STC_DBF acc on (to_char(ctp.M_ID) = rtrim(acc.M_OBJ_DESC) and rtrim(acc.M_OBJ_CLASS) = 'MvRWS58256' and rtrim(acc.M_OBJ_ASYS) = 'ACC_ID')

where 1 = 1
and typfic.M_REF IS NULL
);

drop table VIW_CTP_DBF;
create table VIW_CTP_DBF as (select * from CTP_VIW);
