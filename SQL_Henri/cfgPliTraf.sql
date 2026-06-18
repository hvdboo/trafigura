/*
select PLITYP, PLILAB, CRVICM, count(*)
from
(
*/

select 
pli.M_FINASS FINASS,
pli.M_COMATP COMATP,
pli.M_COMASS COMASS,
pli.M_PHYLAB PHYLAB,
pli.M_PLITYP PLITYP,
pli.M_PLILAB PLILAB,
coalesce(pli.M_PLIDES, pli.M_BDYDES) PLIDES,
pli.M_PUBLAB PUBLAB,
pli.M_PUBCAL PUBCAL,
pli.M_PUBMIC PUBMIC,
pli.M_CNTSYM CNTSYM,
-- pli.M_CNTURL CNTURL,
-- null         CNTHYP,
-- case when pli.M_CNTURL is not null then '=HYPERLINK("'||pli.M_CNTURL||'","'||pli.M_CNTSYM||'")' else null end CNTURL,
-- pli.M_CNTCOD CNTCOD,
pli.M_LSTOTC  LSTOTC,
pli.M_MULCUR  MULCUR,
PLI.M_CUR     CUR, 
case when pli.M_FMLUID in (32,16384) then fcmudf.M_CURFCT else 1 end CURFCT,
PLI.M_UOQ     UOQ,
PLI.M_UOD     UOD,
PLI.M_LOTSIZ  LOTSIZ,
pli.M_OPTSTY  OPTSTY,
pli.M_PRMSTY  PRMSTY,
pli.M_EXRMOD  EXRMOD,
pli.M_OBS     OBS,
pli.M_MATCAS  MATCAST,
pli.M_LEGPAT  LEGPAT,
pli.M_INDTYP0 INDTYP0,
pli.M_INDLAB0 INDLAB0,
pli.M_INDARC0 INDARC0,
pli.M_INDCAL0 INDCAL0,
case pli.M_INDTYP0
when 'SPT' then pli.M_UNDHSR0
when 'NBY' then pli.M_UNDHSR0
when 'AVG' then pli.M_UNDHSR0
when 'BSK' then pli.M_BSKINDHSR01 else null end HSR0,
case pli.M_INDTYP0
when 'SPT' then pli.M_RNDRUL0
when 'NBY' then pli.M_RNDRUL0
when 'AVG' then pli.M_RNDRUL0
when 'BSK' then pli.M_BSKRNDRUL01 else null end RNDRUL0,
case pli.M_INDTYP0
when 'SPT' then pli.M_RNDDEC0
when 'NBY' then pli.M_RNDDEC0
when 'AVG' then pli.M_RNDDEC0
when 'BSK' then pli.M_BSKRNDDEC01 else null end RNDDEC0,
pli.M_UNDTYP0,
pli.M_UNDLAB0,
pli.M_INDTYP1 INDTYP1,
pli.M_INDLAB1 INDLAB1,
pli.M_INDARC1 INDARC1,
pli.M_INDCAL1 INDCAL1,
case 
when pli.M_INDTYP0 = 'BSK' then pli.M_BSKINDHSR02
when pli.M_INDTYP1 = 'SPT' then pli.M_UNDHSR1
when pli.M_INDTYP1 = 'NBY' then pli.M_UNDHSR1
when pli.M_INDTYP1 = 'AVG' then pli.M_UNDHSR1 else null end HSR1,
case 
when pli.M_INDTYP0 = 'BSK' then pli.M_BSKRNDRUL02
when pli.M_INDTYP1 = 'SPT' then pli.M_RNDRUL1
when pli.M_INDTYP1 = 'NBY' then pli.M_RNDRUL1
when pli.M_INDTYP1 = 'AVG' then pli.M_RNDRUL1 else null end RNDRUL1,
case 
when pli.M_INDTYP0 = 'BSK' then pli.M_BSKRNDDEC02
when pli.M_INDTYP1 = 'SPT' then pli.M_RNDDEC1
when pli.M_INDTYP1 = 'NBY' then pli.M_RNDDEC1
when pli.M_INDTYP1 = 'AVG' then pli.M_RNDDEC1 else null end RNDDEC1,
pli.M_UNDTYP1,
pli.M_UNDLAB1,
pli.M_CRVICM0 CRVICM0,
pli.M_CRVQOT0 CRVQOT0,
pli.M_CRVPUB0 CRVPUB0,
pli.M_CRVSYM0 CRVSYM0,
pli.M_CRVHSR0 CRVHSR0,
pli.M_CRVCAL0 CRVCAL0,
pli.M_CRVICM1 CRVICM1,
pli.M_CRVQOT1 CRVQOT1,
pli.M_CRVPUB1 CRVPUB1,
pli.M_CRVSYM1 CRVSYM1,
pli.M_CRVHSR1 CRVHSR1,
pli.M_CRVCAL1 CRVCAL1,
-- TRAFIGURA
-- MARKET DATA SOURCING
-- Marketview
rtrim(mvhisfcm.M_MVSYMBOL) MV_HISFUT,
coalesce(rtrim(mvhisnby0.M_MVSYMBOL),rtrim(mvhisicm0.M_MVSYMBOL),rtrim(mvhisfcm0.M_MVSYMBOL),rtrim(mvhisfwd0.M_MVSYMBOL)) MV_HISIND0,
coalesce(rtrim(mvhisnby1.M_MVSYMBOL),rtrim(mvhisicm1.M_MVSYMBOL),rtrim(mvhisfcm1.M_MVSYMBOL)) MV_HISIND1,
/*
case 
when pli.M_PLITYP in ('CMFUT','CMFWD','COMOFT','CMOAP') then rtrim(mvhisfcm1.M_MVSYMBOL)
when pli.M_PLITYP in ('CMSWP','CMOAS','CMSWD') then 
   case when pli.M_UNDTYP1 = 'NBY' then rtrim(mvhisnby1.M_MVSYMBOL) else rtrim(mvhisicm1.M_MVSYMBOL) end
else null end MV_HISIND1,
coalesce(rtrim(mvfwdfcm0.MV_CRVSYM), rtrim(mvfwdicm0.MV_CRVSYM)) MV_CRV0,
coalesce(rtrim(mvfwdfcm1.MV_CRVSYM), rtrim(mvfwdicm1.MV_CRVSYM)) MV_CRV1,
*/
-- SRD
case
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS') then rtrim(altgenins.M_OBJ_ALT)
when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','OAP') then rtrim(altfutins.M_OBJ_ALT) 
else null end SRDINS,
coalesce( 
case
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS') then rtrim(altgenmkt.M_OBJ_ALT)
when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','CMOAP') then rtrim(altfutmkt.M_OBJ_ALT) 
else null end, rtrim(altpubsrd.M_OBJ_ALT)) SRDMKT,
coalesce( 
case
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS') then rtrim(altgencom.M_OBJ_ALT)
when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','CMOAP') then rtrim(altfutcom.M_OBJ_ALT) 
else null end, rtrim(phyudf.M_SRDGUID)) SRDCOM,
case 
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS') then rtrim(altgentit.M_OBJ_ALBL)
when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','CMOAP') then rtrim(altfuttit.M_OBJ_ALBL) else null end QUOTMAP,
case
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS') then rtrim(altgenplu.M_OBJ_ALBL)
when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','CMOAP') then rtrim(altfutplu.M_OBJ_ALBL) 
else null end PLUTO,
-- PLUTO2,
-- PLUTO3,
-- PLUTO4,
-- PLUTO5,
-- case when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','CMOAP') then rtrim(altfutplu.M_OBJ_ALT) else null end PLUTODES,
case 
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS') then rtrim(altgentit.M_OBJ_ALT)
when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOFW','CMOAP') then rtrim(altfuttit.M_OBJ_ALT) else null   end TITAN,
case when pli.M_INDTYP0 in ('AVG','SPT') then rtrim(altundeai.M_OBJ_ALBL) else rtrim(altindeai.M_OBJ_ALBL) end EAICOD,
case when pli.M_INDTYP0 in ('AVG','SPT') then rtrim(altundeai.M_OBJ_ALT)  else rtrim(altindeai.M_OBJ_ALT)  end EAILAB,
-- UID
pli.M_PLIUID  PLIUID,
pli.M_BDYUID  BDYUID,
--pli.M_
to_char(SYSDATE,'YYYY-MM-DD') SYSDAT

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
-- PLUTO, TITAN, EAI
left join KEYMAP_STC_DBF altfutplu on fcm.M_REFERENCE = altfutplu.M_OBJ_ID and rtrim(altfutplu.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutplu.M_OBJ_ASYS,1,5)) = 'PLUTO'
left join KEYMAP_STC_DBF altgenplu on gin.M_GEN_NUM   = altgenplu.M_OBJ_ID and rtrim(altgenplu.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgenplu.M_OBJ_ASYS,1,5)) = 'PLUTO'
left join KEYMAP_STC_DBF altfuttit on fcm.M_REFERENCE = altfuttit.M_OBJ_ID and rtrim(altfuttit.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(altfuttit.M_OBJ_ASYS) = 'TITAN'
left join KEYMAP_STC_DBF altgentit on gin.M_GEN_NUM   = altgentit.M_OBJ_ID and rtrim(altgentit.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(altgentit.M_OBJ_ASYS) = 'TITAN'
left join KEYMAP_STC_DBF altindeai on to_char(pli.M_INDUID0) = rtrim(altindeai.M_OBJ_DESC) and rtrim(altindeai.M_OBJ_CLASS) in ('MnXbT37735', 'MwOJI56899') and rtrim(substr(altindeai.M_OBJ_ASYS,1,3)) = 'EAI'
left join KEYMAP_STC_DBF altundeai on rtrim(undviw.M_INDNDX) = rtrim(altundeai.M_OBJ_DESC) and rtrim(altundeai.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altundeai.M_OBJ_ASYS,1,3)) = 'EAI'
-- SRD
left join KEYMAP_STC_DBF altfutcom on fcm.M_REFERENCE = altfutcom.M_OBJ_ID and rtrim(altfutcom.M_OBJ_CLASS) in ('MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutcom.M_OBJ_ASYS,1,9)) = 'COMMODITY'
left join KEYMAP_STC_DBF altgencom on gin.M_GEN_NUM   = altgencom.M_OBJ_ID and rtrim(altgencom.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgencom.M_OBJ_ASYS,1,9)) = 'COMMODITY'
left join KEYMAP_STC_DBF altfutmkt on fcm.M_REFERENCE = altfutmkt.M_OBJ_ID and rtrim(altfutmkt.M_OBJ_CLASS) in ('MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutmkt.M_OBJ_ASYS,1,6)) = 'MARKET'
left join KEYMAP_STC_DBF altgenmkt on gin.M_GEN_NUM   = altgenmkt.M_OBJ_ID and rtrim(altgenmkt.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgenmkt.M_OBJ_ASYS,1,6)) = 'MARKET'
left join KEYMAP_STC_DBF altpubsrd on pli.M_PUBUID    = altpubsrd.M_OBJ_ID and rtrim(altpubsrd.M_OBJ_CLASS) in ('MnVuQ71331') and rtrim(substr(altpubsrd.M_OBJ_ASYS,1,3)) = 'SRD'  
left join KEYMAP_STC_DBF altfutins on fcm.M_REFERENCE = altfutins.M_OBJ_ID and rtrim(altfutins.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutins.M_OBJ_ASYS,1,10)) = 'INSTRUMENT'
left join KEYMAP_STC_DBF altgenins on gin.M_GEN_NUM   = altgenins.M_OBJ_ID and rtrim(altgenins.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgenins.M_OBJ_ASYS,1,10)) = 'INSTRUMENT'
-- MARKETVIEW
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_FUT_FIXING','COM_FUTLO_FIXING')) mvhisfcm on rtrim(pli.M_PLILAB) = rtrim(mvhisfcm.M_MXLABEL)
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_FUT_FIXING','COM_FUTLO_FIXING') and rtrim(M_MXPUBLICAT) not in ('LBMA_FUT','LPPM_FUT')) mvhisfcm0 on rtrim(pli.M_CRVICM0) = rtrim(mvhisfcm0.M_MXLABEL)
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_FUT_FIXING','COM_FUTLO_FIXING') and rtrim(M_MXPUBLICAT) not in ('LBMA_FUT','LPPM_FUT')) mvhisfwd0 on rtrim(pli.M_CRVFWD0) = rtrim(mvhisfwd0.M_MXLABEL)
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_SIND_FIXING') and substr(M_MXPUBLICAT,6,2) not in ('AM','PM')) mvhisicm0 on rtrim(pli.M_CRVICM0) = rtrim(mvhisicm0.M_MXLABEL) and rtrim(pli.M_CRVQOT0) = rtrim(mvhisicm0.M_MXQLABEL)
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_CIND_FIXING')) mvhisnby0 on rtrim(pli.M_UNDLAB0) = rtrim(mvhisnby0.M_MXLABEL)
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_FUT_FIXING','COM_FUTLO_FIXING') and rtrim(M_MXPUBLICAT) not in ('LBMA_FUT','LPPM_FUT')) mvhisfcm1 on rtrim(pli.M_CRVICM1) = rtrim(mvhisfcm1.M_MXLABEL)
--left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_FUT_FIXING','COM_FUTLO_FIXING') and rtrim(M_MXPUBLICAT) not in ('LBMA_FUT','LPPM_FUT')) mvhisfwd1 on rtrim(pli.M_CRVFWD1) = rtrim(mvhisfwd1.M_MXLABEL)
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_SIND_FIXING') and substr(M_MXPUBLICAT,6,2) not in ('AM','PM')) mvhisicm1 on rtrim(pli.M_CRVICM1) = rtrim(mvhisicm1.M_MXLABEL) and rtrim(pli.M_CRVQOT1) = rtrim(mvhisicm1.M_MXQLABEL)
left join (select * from UDTB344_DBF where M_MXPTYPE in ('COM_CIND_FIXING')) mvhisnby1 on rtrim(pli.M_UNDLAB1) = rtrim(mvhisnby1.M_MXLABEL) 
/*
left join implut mvfwdfcm0 on rtrim(pli.M_CRVICM0) = rtrim(mvfwdfcm0.MX_FWDGRP) and rtrim(mvfwdfcm0.MX_CRVTYP) in ('COM_FUT')  --and rtrim(mvfwdfcm0.MX_VINTAGE) = rtrim(fcmudf.M_VINTAGE)
left join implut mvfwdicm0 on rtrim(pli.M_CRVICM0) = rtrim(mvfwdicm0.MX_INDLAB) and rtrim(mvfwdicm0.MX_CRVTYP) in ('COM_SWAP') 
left join implut mvfwdfcm1 on rtrim(pli.M_CRVICM1) = rtrim(mvfwdfcm1.MX_FWDGRP) and rtrim(mvfwdfcm1.MX_CRVTYP) in ('COM_FUT')
left join implut mvfwdicm1 on rtrim(pli.M_CRVICM1) = rtrim(mvfwdicm1.MX_INDLAB) and rtrim(mvfwdicm1.MX_CRVTYP) in ('COM_SWAP')
*/
where 1 = 1 
and pli.M_FINASS = 'COM'
--and (rtrim(mvfwdicm0.MX_TENOR) is null or rtrim(mvfwdicm0.MX_TENOR) = 'Spot')
--and (rtrim(mvfwdicm1.MX_TENOR) is null or rtrim(mvfwdicm1.MX_TENOR) = 'Spot')
--and pli.M_COMATP <> 'METL'
--and pli.COMASS in ('OIL')

order by phyudf.M_SEQ, locudf.M_SEQ, M_PLILAB

/*
)
group by PLITYP, PLILAB, CRVICM
*/

