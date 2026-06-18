set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 4227;
set pagesize 2048;

select TT1.M_LABEL as CreditIndexName, 
case when (TT9.M_TYPE=0) then 'Bond'
	when (TT9.M_TYPE=1) then 'Issuer'
	when (TT9.M_TYPE=2) then 'Basket'
end as Type,
case when ( TT3.M_SE_D_LABEL is NULL) then ' ' else TT3.M_SE_D_LABEL end as SecurityName,  
case  when ( TT4.M_DSP_LABEL is NULL) then ' 'else TT4.M_DSP_LABEL end as Issuer, 
------
------
------
/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* DefaultDetails*/
T0.M_DFLT_DEF2 as DefaultDetails,
case when (T0.M_ISDA_VER = 0 ) then 'ISDA 99' 
  when (T0.M_ISDA_VER = 1 ) then 'ISDA 03' 
  when (T0.M_ISDA_VER = 2 ) then 'ISDA not applicable'
  when (T0.M_ISDA_VER = 3 ) then 'ISDA 04'
  when (T0.M_ISDA_VER = 4 ) then 'PayAsYouGo'
  when (T0.M_ISDA_VER = 5 ) then 'cash settle'
end as ISDAVersion,
case when (T6.M_DSP_LABEL is null) then ' ' else T6.M_DSP_LABEL end as ReferenceEntity,
case when T19.M_SE_D_LABEL is null then ' ' else T19.M_SE_D_LABEL end as ReferenceObligations,
case when (T1.M_CALC_AGSEL = 0 ) then 'Buyer' 
  when (T1.M_CALC_AGSEL = 1 ) then 'Buyer or Seller' 
  when (T1.M_CALC_AGSEL = 2 ) then 'Seller' 
  when (T1.M_CALC_AGSEL = 3 ) then 'Third part' else ' ' end as AgentName ,
case when (T7.M_DSP_LABEL is null) then ' ' else T7.M_DSP_LABEL end as CalcAgentCounterpart, 
case when (T10.M_CR_CITY is null) then ' ' else T10.M_CR_CITY end as AgentCity, 
case when (T0.M_ISDA_VER = 0 ) then ' ' 
  when ((T0.M_ISDA_VER <> 0) and (T1.M_ALL_GUAR = 0 )) then 'Not Applicable' 
  when ((T0.M_ISDA_VER <> 0 ) and (T1.M_ALL_GUAR = 1 )) then 'Applicable' end as AllGuarantees,
T1.M_C_AG_CITY as CalcAgentCitiesComment ,
T1.M_E_LGL_TR as ReferenceEntitiesComment, 
T1.M_O_LGL_TR as ReferenceObligationsComment,
case when (T2.M_CRDEVTNTC = 1 ) then 'CHECKED' else 'UNCHECKED' end as CrdEvtNotice,
case when (T2.M_SELLER = 0 ) and ( T2.M_CRDEVTNTC = 1) then 'Buyer' 
  when (T2.M_SELLER = 1 ) then 'Buyer or Seller' 
  when (T2.M_SELLER = 2 ) then 'Seller' 
  when (T2.M_SELLER = 3 ) then 'Third part' 
else ' ' end as NotifyingParty,
case when (T20.M_DSP_LABEL is null) then ' ' else T20.M_DSP_LABEL end as NotifyingPartyCounterpart,
case when (T2.M_NOTPHSET = 0) then 'UNCHECKED' else 'CHECKED' end as NoticeIntendedPhysSettl,
case when (T2.M_NOTPUBINFO = 0) then 'UNCHECKED' when (T2.M_NOTPUBINFO = 1) then 'CHECKED' end as NoticePubAvailableInfo,
case when (T11.M_SOURCES is null) then ' ' else T11.M_SOURCES end as PublicSource, 
case when (T2.M_NOTPUBINFO = 0) then 0 else T2.M_SPEC_NUM end as SpecifiedNumber,
------
------
to_char(T2.M_CRDT_EVT) as CreditEvents,
/* T2.M_CRDT_EVT is used for all the flags that are under "Credit terms\Credit events flags"*/
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable'
		/* T2.M_CRDT_EVT  bit number 0 is set  ------- Logical and */
  when ((MOD(T2.M_CRDT_EVT,1) < 1) and (MOD(T2.M_CRDT_EVT, 2) >= 1)) then 'CHECKED' else 'UNCHECKED' 
end as Bankruptcy,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable'
		/* T2.M_CRDT_EVT  bit number 2 is set  ------- Logical and */
  when ((MOD(T2.M_CRDT_EVT,4) < 4) and (MOD(T2.M_CRDT_EVT,8) >= 4)) then 'CHECKED' else 'UNCHECKED'
end as FailuretoPay,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable'
		/* T2.M_CRDT_EVT  bit number 3 is set  ------- Logical and */
  when ((MOD(T2.M_CRDT_EVT,8) < 8) and (MOD(T2.M_CRDT_EVT,16) >= 8)) then 'CHECKED' else 'UNCHECKED'
end as ObligationDefault,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' 
		/* T2.M_CRDT_EVT  bit number 4 is set  ------- Logical and */
  when ((MOD(T2.M_CRDT_EVT,16) < 16) and (MOD(T2.M_CRDT_EVT,32) >= 16)) then 'CHECKED' else 'UNCHECKED'
end as ObligationAcceleration,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable'
		/* T2.M_CRDT_EVT  bit number 5 is set  ------- Logical and */
  when ((MOD(T2.M_CRDT_EVT,32) < 32) and (MOD(T2.M_CRDT_EVT,64) >= 32)) then 'CHECKED' else 'UNCHECKED'
end as RepudiationMoratorium,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' 
		/* T2.M_CRDT_EVT  bit number 6 is set  ------- Logical and */
  when ((MOD(T2.M_CRDT_EVT,64) < 64) and (MOD(T2.M_CRDT_EVT,128) >= 64)) then 'CHECKED' else 'UNCHECKED'
end as Restructuring,
case when (T0.M_ISDA_VER = 4 or T0.M_ISDA_VER = 5 ) then 'Not Applicable'
  when ((T0.M_ISDA_VER <> 0) and (T2.M_CRDT_EVT >= 128 or T2.M_CR_EVTLBL0 = ' ')) then 'Not Applicable'
		/* T2.M_CRDT_EVT  bit number 1 is set  ------- Logical and */
  when ((MOD(T2.M_CRDT_EVT,2) < 2) and (MOD(T2.M_CRDT_EVT,4) >= 2)) then 'CHECKED' else 'UNCHECKED'
end as Downgrade,
------
T2.M_PAY_RQ as FailPayRequirAmount,
CAST(T2.M_PAY_RQ_C AS VARCHAR2(23)) as FailurePaymentCurrency,
------
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable'
  when (T2.M_GRC_PR_D = 0) then 'Business days' 
  when (T2.M_GRC_PR_D = 1) then 'Calendar days' 
end as GracePeriodExtensionUnit,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' else to_char(T2.M_GRC_PR) end as GracePeriodExtMult,
------
------
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' when (T2.M_MAT_LIMIT = 0) then 'UNCHEKED' else 'CHECKED' end as MaturityLimitation ,
T2.M_MAT_LIMITL as MaturityLabel , 
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' when (T2.M_MAT_LIMITD is null) then ' ' else to_char(T2.M_MAT_LIMITD, 'DD/MM/YY') end as Maturity,
------
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' when ((T0.M_ISDA_VER = 1 ) and (T2.M_CON_TRAN = 1)) then 'CHECKED' else 'UNCHECKED' end as ConditionallyTransferable,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' when (T2.M_MUL_HOLD = 0) then 'UNCHECKED' else 'CHECKED' end as MultipleHolder,
------
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' 
  when ((MOD(T2.M_CRDT_EVT, 8) < 8) and (MOD(T2.M_CRDT_EVT, 16) >= 8)) then to_char(T2.M_DFLT_RQ) 
  when ((MOD(T2.M_CRDT_EVT, 16) < 16) and (MOD(T2.M_CRDT_EVT, 32) >= 16)) then to_char(T2.M_DFLT_RQ)  
  when ((MOD(T2.M_CRDT_EVT, 32) < 32) and (MOD(T2.M_CRDT_EVT, 64) >= 32)) then to_char(T2.M_DFLT_RQ)  
  when ((MOD(T2.M_CRDT_EVT, 64) < 64) and (MOD(T2.M_CRDT_EVT, 128) >= 64)) then to_char(T2.M_DFLT_RQ)  
else '0' end as DefaultRequirementAmount,
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' 
  when ((MOD(T2.M_CRDT_EVT, 8) < 8) and (MOD(T2.M_CRDT_EVT, 16) >= 8)) then T2.M_DFLT_RQ_C
  when ((MOD(T2.M_CRDT_EVT, 16) < 16) and (MOD(T2.M_CRDT_EVT, 32) >= 16)) then T2.M_DFLT_RQ_C
  when ((MOD(T2.M_CRDT_EVT, 32) < 32) and (MOD(T2.M_CRDT_EVT, 64) >= 32)) then T2.M_DFLT_RQ_C
  when ((MOD(T2.M_CRDT_EVT, 64) < 64) and (MOD(T2.M_CRDT_EVT, 128) >= 64)) then T2.M_DFLT_RQ_C 
else ' ' end as DefaultRequirementcurrency,
------
case 
  when (T2.M_CRDT_EVT >= 128) then 'CHECKED'
else 'None'
end as UDCreditEvtLabel,
------
T2.M_CR_EVTLBL0 as CreditEventLabel0, T2.M_CR_EVTLBL1 as CreditEventLabel1, T2.M_CR_EVTLBL2 as CreditEventLabel2, 
T2.M_CR_EVTLBL3 as CreditEventLabel3, T2.M_CR_EVTLBL4 as CreditEventLabel4, 
T2.M_RAT_AGNCY as DowngradeRatingAgency, T2.M_RAT_TRIG as DowngradeRating ,
/* The following has been removed for the above paragraph */
case when (T0.M_ISDA_VER = 4 ) then 'Not Applicable' when (T0.M_ISDA_VER = 0 and T2.M_RSTR_SUP = 1) then 'CHECKED' else 'UNCHECKED' end as SupplementNotAvailable, 
------
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_ACT_WD = 0 then 'UNCHECKED' 
  when T26.M_ACT_WD = 1 then 'CHECKED' 
end as ActualWriteDown,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_PDL = 0 then 'UNCHECKED' 
  when T26.M_PDL = 1 then 'CHECKED' 
end as PrincipalDeficiencyLedger,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_IMPL_WD = 0 then 'UNCHECKED' 
  when T26.M_IMPL_WD = 1 then 'CHECKED' 
end as ImpliedWriteDown,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_ISHORTVAR = 0 then 'Fixed cap' 
  when T26.M_ISHORTVAR = 1 then 'Variable cap' 
  when T26.M_ISHORTVAR = 2 then 'No cap applicable' 
end as InterestShortfallVariant,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_PIK = 0 then 'UNCHECKED' 
  when T26.M_PIK = 1 then 'CHECKED' 
end as PaymentInKind,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_AFC = 0 then 'UNCHECKED' 
  when T26.M_AFC = 1 then 'CHECKED' 
end as AvailableFundsCap,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_FAIL_PP = 0 then 'UNCHECKED' 
  when T26.M_FAIL_PP = 1 then 'CHECKED' 
end as FailurePayPrincipal,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T25.M_RAT_DOWN = 0 then 'UNCHECKED' 
  when T25.M_RAT_DOWN = 1 then 'CHECKED' 
end as DistressedRatingsDwngrade,
case when (T0.M_ISDA_VER <> 4 ) then 'Not Applicable' 
  when T26.M_MAT_EXT = 0 then 'UNCHECKED' 
  when T26.M_MAT_EXT = 1 then 'CHECKED' 
end as MaturityExtension,
------
------
case when (T5.M_ST_DOBL = 0 ) then 'None' 
  when (T5.M_ST_DOBL = 1) then 'Payment' 
  when (T5.M_ST_DOBL = 2 ) then 'Borrowed money' 
  when (T5.M_ST_DOBL = 4 ) then 'Reference Obligations Only' 
  when (T5.M_ST_DOBL = 8 ) then 'Bond' 
  when (T5.M_ST_DOBL = 16 ) then 'Loan' 
  when (T5.M_ST_DOBL = 32 ) then 'Bond or Loan' 
else to_char(T5.M_ST_DOBL) 
end as DelivObligationsCategory,
------
to_char( T5.M_ST_DOBLC) as DlvObligChar,
------
case when (T0.M_ISDA_VER = 0 ) then 'Not Applicable'
		/* T5.M_ST_DOBLC  bit number 18 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 262144) < 262144) and (MOD(T5.M_ST_DOBLC, 524288) >= 262144)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliNotSubordinated,
------
case /* T5.M_ST_DOBLC  bit number 17 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 131072) < 131072) and (MOD(T5.M_ST_DOBLC, 262144) >= 131072)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliStdSpcfCur,
------
case /* T5.M_ST_DOBLC  bit number 1 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 2) < 2) and (MOD(T5.M_ST_DOBLC, 4) >= 2)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliSpcfCur,
------
case /* T5.M_ST_DOBLC  bit number 2 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 4) < 4) and (MOD(T5.M_ST_DOBLC, 8) >= 4)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliNotSovLender,
------
case /* T5.M_ST_DOBLC  bit number 3 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 8) < 8) and (MOD(T5.M_ST_DOBLC, 16) >= 8)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliNotDomCur,
------
case /* T5.M_ST_DOBLC  bit number 4 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 16) < 16) and (MOD(T5.M_ST_DOBLC, 32) >= 16)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliNotDomLaw,
------
case /* T5.M_ST_DOBLC  bit number 5 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 32) < 32) and (MOD(T5.M_ST_DOBLC, 64) >= 32)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliListed,
------
case /* T5.M_ST_DOBLC  bit number 6 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 64) < 64) and (MOD(T5.M_ST_DOBLC, 128) >= 64)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliNotContingent,
------
case /* T5.M_ST_DOBLC  bit number 7 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 128) < 128) and (MOD(T5.M_ST_DOBLC, 256) >= 128)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliNotDomesticIssuance,
------
case /* T5.M_ST_DOBLC  bit number 8 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 256) < 256) and (MOD(T5.M_ST_DOBLC, 512) >= 256)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliAssignableLoan,
------
case /* T5.M_ST_DOBLC  bit number 9 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 512) < 512) and (MOD(T5.M_ST_DOBLC, 1024) >= 512)) then 'CHECKED' else 'UNCHECKED'
end as ConsentRequiredLoan,
------
case /* T5.M_ST_DOBLC  bit number 10 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 1024) < 1024) and (MOD(T5.M_ST_DOBLC, 2048) >= 1024)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliDirectLoanPart,
------
case /* T5.M_ST_DOBLC  bit number 12 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 4096) < 4096) and (MOD(T5.M_ST_DOBLC, 8192) >= 4096)) then 'CHECKED' else 'UNCHECKED'
end as Transferable,
------
case /* T5.M_ST_DOBLC  bit number 13 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 8192) < 8192) and (MOD(T5.M_ST_DOBLC, 16384) >= 8192)) then 'CHECKED' else 'UNCHECKED'
end as MaximumMaturity,
------
T5.M_STDO_MAT as MaxMaturity,
------
case /* T5.M_ST_DOBLC  bit number 14 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 16384) < 16384) and (MOD(T5.M_ST_DOBLC, 32768) >= 16384)) then 'CHECKED' else 'UNCHECKED'
end as DlvObliAccOrMatured,
------
case /* T5.M_ST_DOBLC  bit number 15 is set  ------- Logical and */
  when ((MOD(T5.M_ST_DOBLC, 32768) < 32768) and (MOD(T5.M_ST_DOBLC, 65536) >= 32768)) then 'CHECKED' else 'UNCHECKED'
end as NotBearer,
------
case when (T3.M_OBLG_CAT = 0 ) then 'None' 
  when (T3.M_OBLG_CAT = 1) then 'Payment' 
  when (T3.M_OBLG_CAT = 2) then 'Borrowed money' 
  when (T3.M_OBLG_CAT = 4 ) then 'Reference Obligations Only' 
  when (T3.M_OBLG_CAT = 8 ) then 'Loan' 
  when (T3.M_OBLG_CAT = 16 ) then 'Bond' 
  when (T3.M_OBLG_CAT = 32 ) then 'Bond or Loan' 
else to_char( T3.M_OBLG_CAT) 
end as RefObligCat,
------
to_char(T3.M_OBLG_CHR) as RefObligChars,
------
case when (T0.M_ISDA_VER = 0 ) then 'Not Applicable'
		/* T3.M_OBLG_CHR  bit number 18 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,262144) < 262144) and (MOD(T3.M_OBLG_CHR,524288) >= 262144)) then 'CHECKED' else 'UNCHECKED'
end as NotSubordinated,
------
case when (T0.M_ISDA_VER <> 0 ) then 'Not Applicable'
	 	/* T3.M_OBLG_CHR  bit number 0 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,1) < 1) and (MOD(T3.M_OBLG_CHR,2) >= 1)) then 'CHECKED' else 'UNCHECKED'
end as PariPassuRanking,
------
case /* T3.M_OBLG_CHR  bit number 17 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,131072) < 131072) and (MOD(T3.M_OBLG_CHR,262144) >= 131072)) then 'CHECKED' else 'UNCHECKED'
end as StdSpecifiedCurr,
------
case /* T3.M_OBLG_CHR  bit number 1 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,2) < 2) and (MOD(T3.M_OBLG_CHR,4) >= 2)) then 'CHECKED' else 'UNCHECKED'
end as SpecifiedCurrencies,
------
case /* T3.M_OBLG_CHR  bit number 2 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,4) < 4) and (MOD(T3.M_OBLG_CHR,8) >= 4)) then 'CHECKED' else 'UNCHECKED'
end as NotSovereignLender,
------
case /* T3.M_OBLG_CHR  bit number 3 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,8) < 8) and (MOD(T3.M_OBLG_CHR,16) >= 8)) then 'CHECKED' else 'UNCHECKED'
end as NotDomesticCurrency,
------
case /* T3.M_OBLG_CHR  bit number 4 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,16) < 16) and (MOD(T3.M_OBLG_CHR,32) >= 16)) then 'CHECKED' else 'UNCHECKED'
end as NotDomesticLaw,
------
case /* T3.M_OBLG_CHR  bit number 5 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,32) < 32) and (MOD(T3.M_OBLG_CHR,64) >= 32)) then 'CHECKED' else 'UNCHECKED'
end as Listed,
------
case when (T0.M_ISDA_VER <> 0) then 'Not Applicable'
	 	/* T3.M_OBLG_CHR  bit number 6 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,64) < 64) and (MOD(T3.M_OBLG_CHR,128) >= 64)) then 'CHECKED' else 'UNCHECKED'
end as NotContingent,
------
case /* T3.M_OBLG_CHR  bit number 7 is set  ------- Logical and */
  when ((MOD(T3.M_OBLG_CHR,128) < 128) and (MOD(T3.M_OBLG_CHR,256) >= 128)) then 'CHECKED' else 'UNCHECKED'
end as NotDomesticIssuance,
------
------
CAST(T3.M_DOM_CURR AS VARCHAR2(11)) as RefDomCurr, 
case when T13.M_SPCURR is null then ' ' else T13.M_SPCURR end as RefSpecCurr,
case when T21.M_SE_D_LABEL is null then ' ' else T21.M_SE_D_LABEL end as RefOtherOblig,
case when T22.M_SE_D_LABEL is null then ' ' else T22.M_SE_D_LABEL end as RefExcludOblig,
	 /* Specify Obligation */
T3.M_S_LGL_TR1 as RefOtherObligComment,
T3.M_E_LGL_TR1 as RefExcludedObligComment,
CAST(T5.M_DDOM_CURR AS VARCHAR2(17)) as DomesticCurrency,
------
case when (T4.M_DFLT_SETTL = 0 ) then 'Cash' 
  when (T4.M_DFLT_SETTL = 1 ) then 'Delivery' 
  when (T4.M_DFLT_SETTL = 2 ) then 'Cash or delivery' 
end as ProtectionSettlementMode,
------
case when (T4.M_DFLT_SETTL = 0) then ' ' 
  when (T4.M_ST_PRD_TP = 0) then 'Business days' 
  when (T4.M_ST_PRD_TP = 1) then 'Calendar days' end as PhysicalSettlementUnit,
------
case when (T4.M_DFLT_SETTL = 0) then 0 else T4.M_ST_PRD end as PhysicalSettlementPeriod ,
------
case when (T4.M_DFLT_SETTL = 0) then ' '
  when (T4.M_CUSTOM_S = 0) then 'UNCHECKED' else 'CHECKED' end as CustomaryS8_5,
------
case when (T4.M_DFLT_SETTL = 0) then ' ' 
  when (T4.M_ST_CAP = 0) then 'UNCHECKED' else 'CHECKED' end as Capped , 
------
case when (T4.M_DFLT_SETTL = 0) then 0 
  when (T4.M_ST_CAP = 0) then 0 else T4.M_ST_CAP_NB end as CappedSettPeriod, 
------
case when (T4.M_DFLT_SETTL = 0) then ' ' 
  when (T4.M_ST_CAP = 0) then ' ' 
  when (T4.M_ST_CAP_TP = 0) then 'Business days' 
  when (T4.M_ST_CAP_TP = 1) then 'Calendar days' end as CappedSettUnit, 
------
case when (T4.M_DFLT_SETTL = 0) then ' ' when (T4.M_APP_ACC_P = 0) then 'Include Accrued Interest' 
else 'Exclude Accrued Interest' end as PhysExcludeAccInt,
------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' 
  when (T4.M_ST_DATTYPE = 0 ) then 'Single' 
  when (T4.M_ST_DATTYPE = 1) then 'Multiple' 
end as ValuationDateType,
------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' 
  when (T4.M_ST_VD_TP = 0) then 'Business days' 
  when (T4.M_ST_VD_TP = 1) then 'Calendar days'
end as CashSettValLagUnit, 
------
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_SVD end as SingCashSetValMult,
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_MVD end as MultipleValMult,
------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' 
  when ((T4.M_ST_DATTYPE = 1) and (T4.M_ST_MVD_TP = 0)) then 'Business days thereafter' 
  when ((T4.M_ST_DATTYPE = 1) and (T4.M_ST_MVD_TP = 1)) then 'Calendar days thereafter' 
else ' ' end as ValuationStepUnit ,
------
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_MVDN end as ValuationStepMultiplier,
------
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_MVDI end as NumberValuationDates,
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_VTIM end as ValuationTime, 

case when (T4.M_DFLT_SETTL = 1 ) then '' 
	when T27.M_CR_CITY is null then '' 
	else T27.M_CR_CITY end as ValuationCity,

------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' 
  when (T4.M_ST_QMET = 0 ) then 'Bid' 
  when (T4.M_ST_QMET = 1 ) then 'Offer' 
  when (T4.M_ST_QMET = 2 ) then 'Mid-market' end as QuotationMethod, 
------
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_QAMT end as QuotationAmount , 
case when (T4.M_DFLT_SETTL = 1 ) then ' ' else T4.M_ST_QAMT_C end as Quotationcurrency,
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_MQAMT end as MinimumQuotationAmount,
case when (T4.M_DFLT_SETTL = 1 ) then ' ' else T4.M_ST_MQAMT_C end as MinimumQuotationcurrency, 
------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' 
  when T12.M_DEALER is null then ' ' else T12.M_DEALER end as Dealer, 
case when (T4.M_DFLT_SETTL = 1 ) then ' ' 
  when (T4.M_APP_ACC = 0) then 'Include Accrued Interest' 
else 'Exclude Accrued Interest' 
end as CashExcAccInt,
------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' when (T4.M_VAL_MET = 0 ) then 'Average blended highest' 
  when (T4.M_VAL_MET = 1 ) then 'Average highest' 
  when (T4.M_VAL_MET = 2 ) then 'Average blended market' 
  when (T4.M_VAL_MET = 3 ) then 'Average market'
  when (T4.M_VAL_MET = 4 ) then 'Blended highest' 
  when (T4.M_VAL_MET = 5 ) then 'Blended market' 
  when (T4.M_VAL_MET = 6 ) then 'Highest' 
  when (T4.M_VAL_MET = 7 ) then 'Market' end as ValuationMethod,
------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' else T4.M_ST_CURR end as ProtectionSettCurr,
------
case when (T4.M_DFLT_SETTL = 1 ) then ' ' 
  when (T4.M_ST_CSHD_TP = 0) then 'Business days' 
  when (T4.M_ST_CSHD_TP = 1) then 'Calendar days' end as CashSettlementUnit,
------
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_CSHD end as CashSettlementMultiplier,
case when (T4.M_DFLT_SETTL = 1 ) then 0 else T4.M_ST_CSHA end as CashSettlementAmount , 
case when (T4.M_DFLT_SETTL = 1 ) then ' ' else T4.M_ST_CSHA_C end as CashSettlementCurrency,
------
case when (T5.M_ST_EAPP = 0) then 'UNCHECKED' else 'CHECKED' end as Escrow 
/* DefaultDetails End*/
/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
------
------
------
from CR_BSKH_DBF TT1, CR_BSKB_DBF TT2 , SE_HEAD_DBF TT3, TRN_CPDF_DBF TT4,
CR_BSK_DD_DBF TT5, CR_DD_DBF TT6 ,
CR_ENTITY_DBF TT9,
------
/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* DefaultDetails*/
CR_DD_DBF T0, CR_DD1_DBF T1, CR_DD2_DBF T2, CR_DD3_DBF T3, 
CR_DD4_DBF T4, CR_DD5_DBF T5, TRN_CPDF_DBF T6,
TRN_CPDF_DBF T7, CR_OBLG_DBF T8, CR_CITS_DBF T9, 
CR_CITY_DBF T10, CR_SELS_DBF T11, CR_DLERS_DBF T12, 
CR_SCUR_DBF T13, CR_OBLG_DBF T14, CR_OBLG_DBF T15,
CR_SCUR_DBF T16, CR_OBLG_DBF T17, CR_OBLG_DBF T18,
SE_HEAD_DBF T19, TRN_CPDF_DBF T20, SE_HEAD_DBF T21,
SE_HEAD_DBF T22, SE_HEAD_DBF T23, SE_HEAD_DBF T24,
CR_ABS_DD_DBF T25, CR_PAUG_DBF T26,  CR_CITY_DBF T27
/* DefaultDetails End*/
/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
------
where TT1.M__INDEX_= TT2.M__INDEX_  
and TT1.M_B_NATURE=1  
and TT9.M_SECURITY = TT3.M_SE_D_LABEL (+)  
and TT9.M_ISSUER = TT4.M_LABEL (+)
and TT2.M_B_ENT_UID = TT5.M_B_ENT_UID
and TT2.M_B_ENT_UID = TT9.M_B_ENT_UID (+)
and TT5.M_DFLTD_UID = TT6.M_UID (+)
and  TT1.M__INDEX_ = TT5.M_BSK_UID
and TT5.M_DFLT_UID=0
------
/* Link between the two queries */
and TT6.M_UID = T0.M_UID (+)
------
/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* DefaultDetails*/
and T0.M_DD1 = T1.M_UID (+)
and T0.M_DD2 = T2.M_UID (+)
and T0.M_DD3 = T3.M_UID (+)
and T0.M_DD4 = T4.M_UID (+)
and T0.M_DD5 = T5.M_UID (+)
and T1.M_REF_ENT = T6.M_LABEL (+)
and T1.M_CALC_ACTRP = T7.M_LABEL (+)
and T1.M_OBL_REF = T8.M_CODE (+)
and T9.M_CR_CID = T10.M_CR_CID (+)
and T1.M_AGC_REF = T9.M_CODE (+) 
and T2.M_SRC_REF = T11.M_CODE (+)
and T4.M_DLERS_REF = T12.M_CODE (+)
and T3.M_SCUR_REF = T13.M_NUMBER (+)
and T3.M_OOBL_REF = T14.M_CODE (+)
and T3.M_EOBL_REF = T15.M_CODE (+)
and T5.M_SCUR_REF = T16.M_NUMBER (+)
and T5.M_OOBL_REF = T17.M_CODE (+)
and T5.M_EOBL_REF = T18.M_CODE (+)
and T8.M_OBLIGN = T19.M_SE_LABEL (+)
and T2.M_CNTPART_D = T20.M_LABEL (+)
and T14.M_OBLIGN = T21.M_SE_LABEL (+)
and T15.M_OBLIGN = T22.M_SE_LABEL (+)
and T17.M_OBLIGN = T23.M_SE_LABEL (+)
and T18.M_OBLIGN = T24.M_SE_LABEL (+)
and T0.M_ABS_DD = T25.M_REFERENCE (+)
and T25.M_REFERENCE = T26.M_REFERENCE (+)
and T4.M_ST_VALCITY = T27.M_CR_CID (+)
/* DefaultDetails End*/
/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
------
order by TT1.M_LABEL, TT4.M_DSP_LABEL, TT3.M_SE_D_LABEL;
------
quit;
SPOOL OFF;