set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 2000;
set pagesize 2048;
select 	T1.M_DSP_LABEL as "Issuer", T1.M_NAME as Description, 
	T1.M_CODE as Code, T1.M_EMAIL as Email, 
	case when (T2.M_COUNTRY is null) then  ' ' else T2.M_COUNTRY end  as Country,
	T1.M_CITY as City, 
	T1.M_PARENT_CPY as ParentCompany, T1.M_ADDRESS0 as Street1,T1.M_ADDRESS1 as Street2,
	T1.M_TEL as Tel, T1.M_FAX as Fax,
-------
	case when T4.M_ADDRESS0 is null then ' ' else T4.M_ADDRESS0 end as AddStreet1, 
	case when T4.M_ADDRESS1 is null then ' ' else T4.M_ADDRESS1 end as AddStreet2, 
	case when T4.M_CITY is null then ' ' else T4.M_CITY end as AddCity,
	case when T4.M_TEL  is null then ' ' else T4.M_TEL end as AddTel,
	case when T4.M_FAX is null then ' ' else T4.M_FAX end as AddFax,
	case when T4.M_ACTIVE is null then ' '
	when T4.M_ACTIVE=0 then 'Disabled'
	when T4.M_ACTIVE=1 then 'Enabled'
	end as AddStatus,
	case when (T5.M_COUNTRY is null) then  ' ' else T5.M_COUNTRY end  as AddCountry,
	-------
	T1.M_COMMENT0 as Comment1, T1.M_COMMENT1 as Comment2, 
	T1.M_COMMENT2 as Comment3, T1.M_COMMENT3 as Comment4, 
	T1.M_COMMENT4 as Comment5, T1.M_COMMENT5 as Comment6,
	case when  (T3.M_LABEL is null) then ' ' else T3.M_LABEL end as Sector,
	T1.M_ISS_CAT as Category,
-------
	case when T1.M_OPT_CMMSTL = 0 then 'OD'
		when T1.M_OPT_CMMSTL = 1 then 'Basket'
		when T1.M_OPT_CMMSTL = 2 then 'By Currency'
	end as CmmSiPref, 
-------
	case when T1.M_SI_MODE = 0 then 'Full Definition'
		when T1.M_SI_MODE = 1 then 'Selection Only'
		when T1.M_SI_MODE = 2 then 'Default Only'
	end  as SIMode, 
-------
	case when T1.M_CI_MODE = 0 then 'Specific and Common'
		when T1.M_CI_MODE = 1 then 'Specific Only'
		when T1.M_CI_MODE = 2 then 'Common Only'
	end as CIMode, 
-------
	case when T1.M_WEBENABLED = 0 then 'Unchecked' when T1.M_WEBENABLED = 1 then 'Checked' else ' ' end as WebEnabled,
	case when T1.M_PAY_NET = 0 then 'Unchecked' when T1.M_PAY_NET = 1 then 'Checked' else ' ' end as PaymentNetting,
-------
        T7.M_LABEL as typeLabel, T7.M_DESCRIPTION as typeDescription
-------
from TRN_CPDF_DBF T1
-------
left outer join CR_CTRY_DBF T2 on T1.M_COUNTRY=T2.M_REFERENCE 
left outer join  CSF_FOLDER_DBF T3 on T1.M_SECTOR=T3.M_REFERENCE
left outer join CTP#CTP_ADDR_DBF T4 on T1.M_LABEL = T4.M_CTRP
left outer join CR_CTRY_DBF T5 on T4.M_COUNTRY = T5.M_REFERENCE
left outer join CTP_TYPES_DBF T6 on T6.M_CTN = T1.M_ID 
left outer join PARTY_TYPE_DBF T7 on T6.M_REF = T7.M_REFERENCE
where T1.M_DSP_LABEL
 in (
select T1.M_DSP_LABEL from TRN_CPDF_DBF T1
left outer join CTP_TYPES_DBF T6 on T6.M_CTN = T1.M_ID 
left outer join PARTY_TYPE_DBF T7 on T6.M_REF = T7.M_REFERENCE
where T7.M_LABEL = 'ISSUER'
)
-------
order by T1.M_DSP_LABEL;
quit;
