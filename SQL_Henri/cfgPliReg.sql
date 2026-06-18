select 
pli.M_FINASS FINASS,
pli.M_COMATP COMATP,
pli.M_COMASS COMASS,
pli.M_PHYLAB PHYLAB,
pli.M_LSTOTC LSTOTC,
pli.M_MULCUR MULCUR,
pli.M_PLITYP PLITYP,
pli.M_PLILAB PLILAB,
pli.M_PLIDES PLIDES,
pli.M_PUBLAB PUBLAB,
pli.M_PUBCAL PUBCAL,
pli.M_PUBMIC PUBMIC,
pli.M_CNTSYM CNTSYM,
pli.M_CNTURL CNTURL,
null         CNTHYP,
--case when pli.M_CNTURL is not null then '=HYPERLINK("'||pli.M_CNTURL||'","'||pli.M_CNTSYM||'")' else null end CNTURL,
pli.M_CNTCOD CNTCOD,
pli.M_OBS    OBS,
pli.M_MATCAS MATCAST,
pli.M_OPTSTY OPTSTY,
pli.M_PRMSTY PRMSTY,
pli.M_EXRMOD EXRMOD,
PLI.M_CUR    CUR, 
case when pli.M_FMLUID in (32,16384) then fcmudf.M_CURFCT else 1 end CURFCT,
PLI.M_UOQ    UOQ,
PLI.M_UOD    UOD,
PLI.M_LOTSIZ LOTSIZ,
fcmqot.M_TIC TIC,
/*
case 
when pli.M_FMLUID in (32,16384) then fcmqot.M_PRC_DEC QOTDEC,
when pli.M_FMLUID in (2,512)
*/
-- TAS_TAM
-- ICEECONFIRM
-- OTCEQV
pli.M_INDTYP0   INDTYP0,
pli.M_INDLAB0   INDLAB0,
pli.M_INDPUB0   INDPUB0,
pli.M_INDCAL0   INDCAL0,
pli.M_UNDTYP0   UNDTYP0,
pli.M_UNDLAB0   UNDLAB0,
pli.M_UNDCAL0   UNDCAL0,
undviw.M_INDSYM UNDSYM0,
-- INDEXSERIE
-- C_U
pli.M_CRVICM  CRVICM,
-- REGULATORY
substr(pli.M_FINASS,1,2) EMIR_ASSET,
rtrim(phyudf.M_EMR_CM1)  EMIR_PRDBAS,
rtrim(phyudf.M_EMR_CM2)  EMIR_PRDSUB,
case pli.M_PHYLAB
when 'CRUDE' then
   case 
   when substr(pli.M_PLILAB,1,2) = 'BR'   then 'BRNT'
   when substr(pli.M_PLILAB,4,2) = 'BR'   then 'BRNT'
   when substr(pli.M_PLILAB,1,3) = 'BDT'  then 'BRNT'
   when substr(pli.M_PLILAB,4,3) = 'BDT'  then 'BRNT'
   when substr(pli.M_PLILAB,1,3) = 'CPC'  then 'BRNT'
   when substr(pli.M_PLILAB,4,3) = 'CPC'  then 'BRNT'
   when substr(pli.M_PLILAB,4,4) = 'BFOE' then 'BRNT'
   when substr(pli.M_PLILAB,1,6) = 'BR NDX' then 'BRNX'
   when substr(pli.M_PLILAB,1,3) = 'DUB'  then 'DUBA'
   when substr(pli.M_PLILAB,4,3) = 'DUB'  then 'DUBA'
   when substr(pli.M_PLILAB,1,4) = 'ESPO' then 'ESPO'
   when substr(pli.M_PLILAB,4,4) = 'ESPO' then 'ESPO'
   when substr(pli.M_PLILAB,1,3) = 'URA'  then 'URAL'
   when substr(pli.M_PLILAB,4,3) = 'URA'  then 'URAL'
   when substr(pli.M_PLILAB,1,3) = 'LLS'  then 'LLSO'
   when substr(pli.M_PLILAB,4,3) = 'LLS'  then 'LLSO'
   when substr(pli.M_PLILAB,1,3) = 'WCS'  then 'CNDA'
   when substr(pli.M_PLILAB,4,3) in ('EDM','HDY','WCS') then 'CNDA'
   when substr(pli.M_PLILAB,1,3) = 'JCC'  then 'WTIO'
   when substr(pli.M_PLILAB,4,3) = 'JCC'  then 'WTIO'
   when substr(pli.M_PLILAB,1,4) = 'MURB' then 'WTIO'
   when substr(pli.M_PLILAB,4,4) = 'MURB' then 'WTIO'
   when substr(pli.M_PLILAB,1,4) = 'OMAN' then 'WTIO'
   when substr(pli.M_PLILAB,4,4) = 'OMAN' then 'WTIO'
   when substr(pli.M_PLILAB,1,3) in ('ASC','BON','HLS','MAR','WTL') then 'WTIO'
   when substr(pli.M_PLILAB,4,3) in ('ASC','BON','HLS','MAR','POS','THU','WTL') then 'WTIO'
   when substr(pli.M_PLILAB,1,3) = 'WTI' then 'WTIO'
   when substr(pli.M_PLILAB,4,3) = 'WTI' then 'WTIO'
   when substr(pli.M_PLILAB,1,3) = 'STO' then null end
when 'NATGAS' then 
   case 
   when substr(pli.M_PLILAB,4,2) = 'DE' then 'NCGG'
   when substr(pli.M_PLILAB,4,2) = 'NL' then 'TTFG'
   when substr(pli.M_PLILAB,4,2) = 'UK' then 'NBPG' else 'OTHR' end        
else rtrim(phyudf.M_EMR_CM3) end EMIR_PRDFUR,
case 
when pli.M_INDLAB0 = 'EUR' then 'EUR-EURIBOR'
when pli.M_INDLAB0 = 'USD' then 'USD-SOFR CME Term'
else coalesce(rtrim(altund0crp.M_OBJ_ALT), rtrim(altind1crp.M_OBJ_ALT), rtrim(altind0crp.M_OBJ_ALT)) end CRP,
case
when pli.M_PLITYP in ('CMFUT','CMFWD','CMPHY','CMSWD') then 'Forward'
when pli.M_PLITYP in ('CMOAP','CMOAS','CMOFT') then 'Option'
when pli.M_PLITYP in ('CMSWP') then case when pli.M_BSKELT00 <> pli.M_BSKELT01 then 'Basis_Swap' else 'Swap' end
when pli.M_PLITYP in ('SCFTL','IRFTS','SCBND') then 'Debt'
when pli.M_PLITYP in ('IRSWP') then
   case
   when pli.M_MULCUR is not null then 'Cross_Currency_'||case when substr(pli.M_LEGPAT,1,3) = 'Flt' then 'Float_' else 'Fixed_' end||case when substr(pli.M_LEGPAT,5,3) = 'Flt' then 'Float' else 'Fixed' end
   when pli.M_MULCUR is null then 'Fixed_Float'||case when (pli.M_INDTYP0 = 'CMP' or pli.M_INDTYP1='CMP') then '_OIS' else '' end
   else null end
when pli.M_PLITYP in ('IROCF') then 'CapFloor'
else null end EMIR_ASSSET,
case
when pli.M_PLITYP in ('CMFUT','CMFWD','CMPHY','CMSWD') then 'Forward'
when pli.M_PLITYP in ('CMOAP','CMOAS') then 'Asian'
when pli.M_PLITYP in ('CMOFT') then 'Vanilla'
when pli.M_PLITYP in ('CMSWP') then 'CFD'
else null end EMIR_PAYOUT,
-- case when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','CMOAP') then rtrim(altfuttit.M_OBJ_ALBL) else null end CFI,
pli.M_PLIUID  PLIUID,
to_char(SYSDATE,'YYYY-MM-DD') SRCDAT

from VIW_PLI_DBF pli
left join RT_INSGN_DBF gin on pli.M_BDYUID = gin.M_GEN_NUM and pli.M_FMLUID in (2,512)
left join CM_FUT_DBF   fcm on pli.M_BDYUID = fcm.M_REFERENCE and pli.M_FMLUID in (32, 16384)
left join CMC_QUOT_DBF fcmqot on fcm.M_QUOT_FWD = fcmqot.M_REFERENCE
left join TABLE#DATA#COMMODIT_DBF fcmudf on fcm.M_REFERENCE = fcmudf.M_REFERENCE
left join VIW_ICMALL_DBF indviw on pli.M_INDUID0 = indviw.M_INDUID
left join VIW_ICMALL_DBF undviw on pli.M_UNDUID0 = undviw.M_INDUID
left join VIW_ICMBSK_DBF bskviw on indviw.M_INDUID = bskviw.M_INDUID 
left join TABLE#DATA#PRODUCTS_DBF phyudf on pli.M_PHYUID = phyudf.M_REFERENCE
left join TABLE#DATA#LOCATION_DBF locudf on pli.M_LOCUID = locudf.M_REFERENCE
left join KEYMAP_STC_DBF altund0crp on rtrim(pli.M_UNDNDX0) = rtrim(altund0crp.M_OBJ_DESC) and rtrim(altund0crp.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altund0crp.M_OBJ_ASYS,1,3)) = 'CRP' and pli.M_FINASS = 'COM'
left join KEYMAP_STC_DBF altind0crp on rtrim(pli.M_INDNDX0) = rtrim(altind0crp.M_OBJ_DESC) and rtrim(altind0crp.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altind0crp.M_OBJ_ASYS,1,3)) = 'CRP' and pli.M_FINASS = 'IRD'
left join KEYMAP_STC_DBF altind1crp on rtrim(pli.M_INDNDX1) = rtrim(altind1crp.M_OBJ_DESC) and rtrim(altind1crp.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altind1crp.M_OBJ_ASYS,1,3)) = 'CRP' and pli.M_FINASS = 'IRD'

-- where pli.M_FINASS = 'COM'
order by FINASS, COMATP, COMASS, PHYLAB, PLILAB
