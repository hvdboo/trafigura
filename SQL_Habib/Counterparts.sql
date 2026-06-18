set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 3150;
set pagesize 3500;
set feedback off;

select 	T1.M_DSP_LABEL as Counterpart, T1.M_NAME as Description, 
	T1.M_CODE as Code, M_PARENT_CPY as ParentCompany,
	T1.M_LEG_ENT as LegalEntity, 
	case when T10.M_CATEGORY0 is null then ' ' else T10.M_CATEGORY0 end as Category, 
	case when T11.M_LABEL is null then ' ' else T11.M_LABEL end as FiscalCategory,
	case when T11.M_DESC is null then ' ' else T11.M_DESC  end as FiscalCategoryDesc,
	-------
	case when T1.M_WEBENABLED = 0 then 'Unchecked' 
	when T1.M_WEBENABLED = 1 then 'Checked' 
	else ' ' end as WebEnabled,
	case when T1.M_STATUS = 0 then 'Live' 
	when T1.M_STATUS = 1 then 'Suspend' 
	when T1.M_STATUS = 2 then 'Dead'
	end as Status,
-------
-------
	-------
	case when T1.M_OPT_CMMSTL = 0 then 'OD'
		when T1.M_OPT_CMMSTL = 1 then 'Basket'
		when T1.M_OPT_CMMSTL = 2 then 'By Currency'
	end as CmmSiPref, 
	-------
	case when T16.M_ORIGCUR is null then ' ' else T16.M_ORIGCUR end as OriginalCurrency,
	case when T16.M_SETTLCUR is null then ' ' else T16.M_SETTLCUR end as SettlementCurrency,
	case when T16.M_VALDATE is null then ' ' else to_char(T16.M_VALDATE) end as ValidityDate,
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
	case when  (T3.M_LABEL is null) then ' ' else T3.M_LABEL end as Sector, 
-------
	case when T1.M_CONFIRM = 0 then 'Unchecked' when T1.M_CONFIRM = 1 then 'Checked' else ' ' end as SendConfirmation,
	case when T1.M_PAY_NET = 0 then 'Unchecked' when T1.M_PAY_NET = 1 then 'Checked' else ' ' end as PaymentNetting,
	case when T1.M_NOT_FIX = 0 then 'Unchecked' when T1.M_NOT_FIX = 1 then 'Checked' else ' ' end as NotifyingFixing,
	case when T1.M_COL_AGR = 0 then 'Unchecked' when T1.M_COL_AGR = 1 then 'Checked' else ' ' end as CollateralAgreement,
-------	
        T7.M_LABEL as typeLabel, T7.M_DESCRIPTION as typeDescription,
-------
-------
	T1.M_ADDRESS0 as Street1,
	T1.M_ADDRESS1 as Street2,
	T1.M_ADDRESS2 as Street3,
	T1.M_ADDRESS3 as Street4,
	T1.M_CITY as City, T1.M_POSTCODE as PostCode,
	case when T2.M_COUNTRY is null then  ' ' else T2.M_COUNTRY end  as Country,
-------
	T1.M_TEL as Tel, 
	T1.M_FAX as Fax,
	T1.M_TLX as Telex, 
	T1.M_SFT as Swift, 
	T1.M_EMAIL as Email,
-------
-------
	case when T12.M_LABEL is null then ' ' else T12.M_LABEL end as AddType,
	case when T4.M_ADDRESS0 is null then ' ' else T4.M_ADDRESS0 end as AddStreet1, 
	case when T4.M_ADDRESS1 is null then ' ' else T4.M_ADDRESS1 end as AddStreet2,
	case when T4.M_ADDRESS2 is null then ' ' else T4.M_ADDRESS2 end as AddStreet3, 
	case when T4.M_ADDRESS3 is null then ' ' else T4.M_ADDRESS3 end as AddStreet4, 
	case when T4.M_CITY is null then ' ' else T4.M_CITY end as AddCity,
	case when T4.M_POSTCODE is null then ' ' else T4.M_POSTCODE end as AddPostCode,
	case when T5.M_COUNTRY is null then  ' ' else T5.M_COUNTRY end  as AddCountry,
	case when T4.M_TEL  is null then ' ' else T4.M_TEL end as AddTel,
	case when T4.M_FAX is null then ' ' else T4.M_FAX end as AddFax,
	case when T4.M_TLX is null then ' ' else T4.M_TLX end as AddTelex,
	case when T4.M_SFT is null then ' ' else T4.M_SFT end as AddSwift,
	case when T4.M_EMAIL is null then ' ' else T4.M_EMAIL end as AddEmail,
	case when T4.M_ACTIVE is null then ' '
	when T4.M_ACTIVE=0 then 'Disabled'
	when T4.M_ACTIVE=1 then 'Enabled'
	end as AddStatus,
------- 
-------
	case when T13.M_NAME is null then ' ' else  T13.M_NAME end as MAlabel,
	case when T13.M_DESC is null then ' '  else  T13.M_DESC  end as MAdesc,
	case when T13.M_PATH is null then ' '  else  T13.M_PATH  end as MApath,
	case when T13.M_START_DATE is null then ' '  else  to_char(T13.M_START_DATE) end as MAstartValidity,
	case when T13.M_END_DATE is null then ' '  else  to_char(T13.M_END_DATE)  end as MAendValidity,
	case when T13.M_STATUS is null then ' '  else  T13.M_STATUS  end as MAstatus,
	case when T13.M_INT_SIG is null then ' '  else   T13.M_INT_SIG  end as MAintSig,
	case when T13.M_INT_SIG_DT is null then ' ' else  to_char(T13.M_INT_SIG_DT)  end as MAintSigDate,
	case when T13.M_EXT_SIG is null then ' '  else  T13.M_EXT_SIG  end as MAextSig,
	case when T13.M_EXT_SIG_DT is null then ' '  else  to_char(T13.M_EXT_SIG_DT)  end as MAextSigDate,
	case when T14.M_LABEL is null then ' '  else  T14.M_LABEL end as MAtype,
	case when T15.M_NAME is null then ' '  else  T15.M_NAME  end as MAdocumentType,
	case when T13.M_INS_DATE is null then ' '  else  to_char(T13.M_INS_DATE)  end as MAinsDate,
	case when T13.M_MOD_DATE is null then ' '  else  to_char(T13.M_MOD_DATE)  end as MAmodDate,
-------
-------
-------
-------
	T1.M_COMMENT0 as Comment1, T1.M_COMMENT1 as Comment2, 
	T1.M_COMMENT2 as Comment3, T1.M_COMMENT3 as Comment4, 
	T1.M_COMMENT4 as Comment5, T1.M_COMMENT5 as Comment6,
-------
-------
	case when T17.M_ID is null then 'Empty' else 'Used' end as ConfirmationInstruction,
	case when T18.M_LABEL is null then 'Empty' else 'Used' end as SIRule
-------
-------
from TRN_CPDF_DBF T1
-------
left outer join CR_CTRY_DBF T2 on T1.M_COUNTRY=T2.M_REFERENCE 
left outer join  CSF_FOLDER_DBF T3 on T1.M_SECTOR=T3.M_REFERENCE
left outer join CTP#CTP_ADDR_DBF T4 on T1.M_LABEL = T4.M_CTRP
left outer join CR_CTRY_DBF T5 on T4.M_COUNTRY = T5.M_REFERENCE
left outer join CTP_TYPES_DBF T6 on T6.M_CTN = T1.M_ID
left outer join CR_CAT_DBF T10 on T1.M_ISS_CAT = T10.M_CATEGORY0
left outer join FISC_CAT_DBF T11 on T1.M_FISC_CAT = T11.M_REFERENCE
left outer join CTP#ADR_TYPE_DBF T12 on T4.M_TYPE = T12.M_REFERENCE
left outer join CTP_MAGR_DBF T13 on T1.M_ID = T13.M_CTP_ID
left outer join CTP#MA_TYPE_DBF T14 on T13.M_MA_TYPE = T14.M_REFERENCE
left outer join CTP_DOCT_DBF T15 on T13.M_DOCTYPE_ID = T15.M_ID
left outer join CTP#CTP_SPRF_DBF T16 on to_char(T1.M_ID) = T16.M_CTRP
-------
left outer join CTP_CI_DBF T17 on T1.M_ID = T17.M_ID
left outer join SI_KEY_DBF T18 on to_char(T1.M_ID) = T18.M_LABEL
-------
left outer join PARTY_TYPE_DBF T7 on T6.M_REF = T7.M_REFERENCE
-------
where T1.M_AMD_DATE >= '19000101'
-------
order by T1.M_DSP_LABEL, T7.M_LABEL;
quit;
SPOOL OFF;