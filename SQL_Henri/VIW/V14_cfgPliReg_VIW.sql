drop view PLIREG_VIW;
create view PLIREG_VIW
(
M_FINASS,
M_COMATP,
M_COMASS,
M_PLITYP,
M_PLILAB,
M_PLIDES,
M_PUBLAB,
M_PUBCAL,
M_PUBMIC,
M_CNTSYM,
M_CNTCOD,
M_LSTOTC,
M_OPTSTY,
M_PRMSTY,
M_EXRMOD,
M_OBS,
M_MATCAST,
M_LEGPAT,
M_MULCUR,
M_CUR,
M_CURFCT,
M_UOQ,
M_UOD,
M_LOTSIZ,
M_TIC,
M_PHYLAB,
M_VIN,
M_LEGCUR0,
M_INDTYP0,
M_INDLAB0,
M_INDARC0,
M_INDCAL0,
M_UNDTYP0,
M_UNDLAB0,
M_UNDCAL0,
M_UNDSYM0,
M_CRVICM0,
M_LEGCUR1,
M_INDTYP1,
M_INDLAB1,
M_INDARC1,
M_INDCAL1,
M_UNDTYP1,
M_UNDLAB1,
M_EMIR_UNDASS,
M_EMIR_PRDBAS,
M_EMIR_PRDSUB,
M_EMIR_PRDFUR,
M_EMIR_ASSET,
M_EMIR_PAYOUT,
M_REFRTE,
M_CNTURL,
M_PLIUID,
M_INDNDX0,
M_INDUID0,
M_UNDNDX0,
M_UNDUID0,
M_INDNDX1,
M_INDUID1,
M_UNDNDX1,
M_UNDUID1,
M_SRCDAT
)

as
(

select distinct
pli.M_FINASS  FINASS,
pli.M_COMATP  COMATP,
pli.M_COMASS  COMASS,
pli.M_PLITYP  PLITYP,
pli.M_PLILAB  PLILAB,
pli.M_PLIDES  PLIDES,
pli.M_PUBLAB  PUBLAB,
pli.M_PUBCAL  PUBCAL,
pli.M_PUBMIC  PUBMIC,
pli.M_CNTSYM  CNTSYM,
pli.M_CNTCOD  CNTCOD,
pli.M_LSTOTC  LSTOTC,
pli.M_OPTSTY  OPTSTY,
pli.M_PRMSTY  PRMSTY,
pli.M_EXRMOD  EXRMOD,
pli.M_OBS     OBS,
pli.M_MATCAS  MATCAST,
pli.M_LEGPAT  LEGPAT,
pli.M_MULCUR  MULCUR,
PLI.M_CUR     CUR, 
case when pli.M_FMLUID in (32,16384) then fcmudf.M_CURFCT else 1 end CURFCT,
PLI.M_UOQ     UOQ,
PLI.M_UOD     UOD,
PLI.M_LOTSIZ  LOTSIZ,
fcmqot.M_TIC  TIC,
pli.M_PHYLAB  PHYLAB,
pli.M_VIN     VIN,
/*
case 
when pli.M_FMLUID in (32,16384) then fcmqot.M_PRC_DEC QOTDEC,
when pli.M_FMLUID in (2,512)
*/
-- TAS_TAM
-- ICEECONFIRM
-- OTCEQV
pli.M_LEGCUR0   LEGCUR0,
pli.M_INDTYP0   INDTYP0,
pli.M_INDLAB0   INDLAB0,
pli.M_INDARC0   INDARC0,
pli.M_INDCAL0   INDCAL0,
pli.M_UNDTYP0   UNDTYP0,
pli.M_UNDLAB0   UNDLAB0,
pli.M_UNDCAL0   UNDCAL0,
undviw.M_INDSYM UNDSYM0,
pli.M_CRVICM0   CRVICM0,
pli.M_LEGCUR1   LEGCUR1,
pli.M_INDTYP1   INDTYP1,
pli.M_INDLAB1   INDLAB1,
pli.M_INDARC1   INDARC1,
pli.M_INDCAL1   INDCAL1,
pli.M_UNDTYP1   UNDTYP1,
pli.M_UNDLAB1   UNDLAB1,
-- REGULATORY
substr(pli.M_FINASS,1,2) EMIR_UNDASS,
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
when pli.M_PLITYP in ('CMFUT','CMFWD','CMPHY','CMSWD') then 'Forward'
when pli.M_PLITYP in ('CMOAP','CMOAS','CMOFT') then 'Option'
when pli.M_PLITYP in ('CMSWP') then case when pli.M_BSKINDLAB01 <> pli.M_BSKINDLAB02 then 'Basis_Swap' else 'Swap' end
when pli.M_PLITYP in ('SCFTL','IRFTS','SCBND') then 'Debt'
when pli.M_PLITYP in ('IRSWP') then 'Fixed_Float'||case when (pli.M_INDTYP0 = 'CMP' or pli.M_INDTYP1='CMP') then '_OIS' else '' end
when pli.M_PLITYP in ('IRXCY') then 'Cross_Currency_'||case when rtrim(pli.M_LEGPAT) = 'Flt-Flt' then 'Basis' when rtrim(pli.M_LEGPAT) = 'Fix-Fix' then 'Fixed_Fixed' else 'Fixed_Float' end
when pli.M_PLITYP in ('IROCF') then 'CapFloor'
else null end EMIR_ASSET,
case
when pli.M_PLITYP in ('CMFUT','CMFWD','CMPHY','CMSWD') then 'Forward'
when pli.M_PLITYP in ('CMOAP','CMOAS') then 'Asian'
when pli.M_PLITYP in ('CMOFT') then 'Vanilla'
when pli.M_PLITYP in ('CMSWP') then 'CFD'
else null end EMIR_PAYOUT,
coalesce(rtrim(altcrpind0.M_OBJ_ALT), rtrim(altcrpund0.M_OBJ_ALT), rtrim(altcrpind1.M_OBJ_ALT), rtrim(altcrpund1.M_OBJ_ALT)) REFRTE,
pli.M_CNTURL  CNTURL,
-- case when pli.M_CNTURL is not null then '=HYPERLINK("'||pli.M_CNTURL||'","'||pli.M_CNTSYM||'")' else null end CNTHYP,
pli.M_PLIUID  PLIUID,
pli.M_INDNDX0 INDNDX0,
pli.M_INDUID0 INDUID0,
pli.M_UNDNDX0 UNDNDX0,
pli.M_UNDUID0 UNDUID0,
pli.M_INDNDX1 INDNDX1,
pli.M_INDUID1 INDUID1,
pli.M_UNDNDX1 UNDNDX1,
pli.M_UNDUID1 UNDUID1,
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
left join KEYMAP_STC_DBF altcrpind0 on rtrim(pli.M_INDNDX0) = rtrim(altcrpind0.M_OBJ_DESC) and rtrim(altcrpind0.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altcrpind0.M_OBJ_ASYS,1,3)) = 'CRP'
left join KEYMAP_STC_DBF altcrpund0 on rtrim(pli.M_UNDNDX0) = rtrim(altcrpund0.M_OBJ_DESC) and rtrim(altcrpund0.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altcrpund0.M_OBJ_ASYS,1,3)) = 'CRP'
left join KEYMAP_STC_DBF altcrpind1 on rtrim(pli.M_INDNDX1) = rtrim(altcrpind1.M_OBJ_DESC) and rtrim(altcrpind1.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altcrpind1.M_OBJ_ASYS,1,3)) = 'CRP'
left join KEYMAP_STC_DBF altcrpund1 on rtrim(pli.M_UNDNDX1) = rtrim(altcrpund1.M_OBJ_DESC) and rtrim(altcrpund1.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altcrpund1.M_OBJ_ASYS,1,3)) = 'CRP'

);

drop table VIW_PLIREG_DBF;
create table VIW_PLIREG_DBF as (select * from PLIREG_VIW);
