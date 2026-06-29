/*
select PLITYP, PLILAB, CRVICM, count(*)
from
(
*/
--select distinct * from (

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
case when pli.M_FMLUID in (32,16384) then rtrim(pliotc.M_DSP_LABEL) else null end OTCEQV,
pli.M_MULCUR  MULCUR,
pli.M_CUR     CUR, 
case when pli.M_FMLUID in (32,16384) then fcmudf.M_CURFCT else 1 end CURFCT,
PLI.M_UOQ     UOQ,
PLI.M_UOD     UOD,
PLI.M_LOTSIZ  LOTSIZ,
pli.M_OPTSTY  OPTSTY,
pli.M_PRMSTY  PRMSTY,
pli.M_EXRMOD  EXRMOD,
pli.M_OBS     OBS,
pli.M_MATCAS  MATCAST,
pli.M_VIN     VIN,
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
pli.M_UNDTYP0 UNDTYP0,
pli.M_UNDLAB0 UNDLAB0,
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
pli.M_UNDTYP1 UNDTYP1,
pli.M_UNDLAB1 UNDLAB1,
-- ROOTS
pli.M_ROTICM0 ROTICM0,
pli.M_ROTQOT0 ROTQOT0,
pli.M_ROTPUB0 ROTPUB0,
pli.M_ROTSYM0 ROTSYM0,
pli.M_ROTHSR0 ROTHSR0,
pli.M_ROTCAL0 ROTCAL0,
pli.M_ROTICM1 ROTICM1,
pli.M_ROTQOT1 ROTQOT1,
pli.M_ROTPUB1 ROTPUB1,
pli.M_ROTSYM1 ROTSYM1,
pli.M_ROTHSR1 ROTHSR1,
pli.M_ROTCAL1 ROTCAL1,
-- CURVE
rtrim(crv.M_CRVTYP) CRVTYP0,
rtrim(crv.M_CRVMOD) CRVMOD0,
rtrim(crv.M_CRVLAB) CRVLAB0,
rtrim(crv.M_CRVOBJ) CRVOBJ0,
rtrim(crv.M_CRVVIN) CRVVIN0,
-- TRAFIGURA
-- MARKET DATA SOURCING
-- Marketview
/*
case 
when pli.M_PLITYP in ('CMFUT','CMFWD','CMOFT','CMOAP') then 
   case 
   when pli.M_EXRMOD in ('Cash','Phy.dlv') then rtrim(mvhisfcmfwd0.M_MVSYMBOL)
   when pli.M_EXRMOD in ('Fin.dlv') then coalesce(rtrim(mvhisfcmfwd0.M_MVSYMBOL),rtrim(mvhisnby0.M_MVSYMBOL),rtrim(mvhisicm0.M_MVSYMBOL))
   else null end
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS','CMPHY') then coalesce(rtrim(mvhisfcmfwd0.M_MVSYMBOL),rtrim(mvhisnby0.M_MVSYMBOL),rtrim(mvhisicm0.M_MVSYMBOL))
else null end M_HISJUP,
*/ 
rtrim(mvhisfcm.M_MVSYMBOL)  MV_HISFUT,
coalesce(rtrim(mvhisfcmfwd0.M_MVSYMBOL), rtrim(mvhisnby0.M_MVSYMBOL),rtrim(mvhisicm0.M_MVSYMBOL),rtrim(mvhisfcmicm0.M_MVSYMBOL)) MV_HISIND0,
coalesce(rtrim(mvhisnby1.M_MVSYMBOL),rtrim(mvhisicm1.M_MVSYMBOL),rtrim(mvhisfcmicm1.M_MVSYMBOL)) MV_HISIND1,
coalesce(rtrim(mvfwdfcm0.M_MVSYMBOL), rtrim(mvfwdicm0.M_MVSYMBOL)) MV_FWD0,
coalesce(rtrim(mvfwdfcm1.M_MVSYMBOL), rtrim(mvfwdicm1.M_MVSYMBOL)) MV_FWD1,
-- SRD
case
when pli.M_PLITYP in ('CMSWP','CMSWD','CMOAS') then rtrim(altgenpli.M_OBJ_ALT)
when pli.M_PLITYP in ('CMFUT') then rtrim(substr(altfutpli.M_OBJ_ALT,1,32))
when pli.M_PLITYP in ('CMFWD') then rtrim(substr(altfwdpli.M_OBJ_ALT,1,32)) 
when pli.M_PLITYP in ('CMOFT','CMOFW') then rtrim(substr(altoftpli.M_OBJ_ALT,1,32))
when pli.M_PLITYP in ('CMOAP') then rtrim(substr(altfutpli.M_OBJ_ALT,1,32))  
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
left join VIW_FCM_DBF  fcm on pli.M_BDYUID = fcm.M_FCMUID and pli.M_FMLUID in (32, 16384)
left join VIW_ICMCRV_DBF crv on rtrim(pli.M_ROTICM0) = rtrim(crv.M_UNDLAB) and rtrim(pli.M_VIN) = rtrim(crv.M_CRVVIN)
left join VIW_ICMALL_DBF indviw on pli.M_INDUID0 = indviw.M_INDUID
left join VIW_ICMALL_DBF undviw on pli.M_UNDUID0 = undviw.M_INDUID
left join VIW_ICMBSK_DBF bskviw on indviw.M_INDUID = bskviw.M_INDUID
left join TABLE#DATA#PRODUCTS_DBF phyudf on pli.M_PHYUID = phyudf.M_REFERENCE
left join TABLE#DATA#LOCATION_DBF locudf on pli.M_LOCUID = locudf.M_REFERENCE
left join TABLE#DATA#COMMODIT_DBF fcmudf on fcm.M_FCMUID = fcmudf.M_REFERENCE
left join TRN_PLIN_DBF pliotc on fcmudf.M_OTCEQV = to_char(pliotc.M_REFERENCE)
-- PLUTO, TITAN, EAI
left join KEYMAP_STC_DBF altfutplu on fcm.M_FCMUID  = altfutplu.M_OBJ_ID and rtrim(altfutplu.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutplu.M_OBJ_ASYS,1,5)) = 'PLUTO'
left join KEYMAP_STC_DBF altgenplu on gin.M_GEN_NUM = altgenplu.M_OBJ_ID and rtrim(altgenplu.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgenplu.M_OBJ_ASYS,1,5)) = 'PLUTO'
left join KEYMAP_STC_DBF altfuttit on fcm.M_FCMUID  = altfuttit.M_OBJ_ID and rtrim(altfuttit.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(altfuttit.M_OBJ_ASYS) = 'TITAN'
left join KEYMAP_STC_DBF altgentit on gin.M_GEN_NUM = altgentit.M_OBJ_ID and rtrim(altgentit.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(altgentit.M_OBJ_ASYS) = 'TITAN'
left join KEYMAP_STC_DBF altindeai on to_char(pli.M_INDUID0) = rtrim(altindeai.M_OBJ_DESC) and rtrim(altindeai.M_OBJ_CLASS) in ('MnXbT37735', 'MwOJI56899') and rtrim(substr(altindeai.M_OBJ_ASYS,1,3)) = 'EAI'
left join KEYMAP_STC_DBF altundeai on rtrim(undviw.M_INDNDX) = rtrim(altundeai.M_OBJ_DESC) and rtrim(altundeai.M_OBJ_CLASS) in ('MnXbT37735') and rtrim(substr(altundeai.M_OBJ_ASYS,1,3)) = 'EAI'
-- SRD
left join KEYMAP_STC_DBF altfutcom on fcm.M_FCMUID  = altfutcom.M_OBJ_ID and rtrim(altfutcom.M_OBJ_CLASS) in ('MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutcom.M_OBJ_ASYS,1,9)) = 'COMMODITY'
left join KEYMAP_STC_DBF altgencom on gin.M_GEN_NUM = altgencom.M_OBJ_ID and rtrim(altgencom.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgencom.M_OBJ_ASYS,1,9)) = 'COMMODITY'
left join KEYMAP_STC_DBF altfutmkt on fcm.M_FCMUID  = altfutmkt.M_OBJ_ID and rtrim(altfutmkt.M_OBJ_CLASS) in ('MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altfutmkt.M_OBJ_ASYS,1,6)) = 'MARKET'
left join KEYMAP_STC_DBF altgenmkt on gin.M_GEN_NUM = altgenmkt.M_OBJ_ID and rtrim(altgenmkt.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(substr(altgenmkt.M_OBJ_ASYS,1,6)) = 'MARKET'
left join KEYMAP_STC_DBF altpubsrd on pli.M_PUBUID  = altpubsrd.M_OBJ_ID and rtrim(altpubsrd.M_OBJ_CLASS) in ('MnVuQ71331') and rtrim(substr(altpubsrd.M_OBJ_ASYS,1,3)) = 'SRD'  
left join KEYMAP_STC_DBF altfutpli on fcm.M_FCMUID  = altfutpli.M_OBJ_ID and rtrim(altfutpli.M_OBJ_CLASS) in ('MwOJI56899') and rtrim(altfutpli.M_OBJ_ASYS) = 'INSTRUMENT'
left join KEYMAP_STC_DBF altfwdpli on fcm.M_FCMUID  = altfutpli.M_OBJ_ID and rtrim(altfutpli.M_OBJ_CLASS) in ('MfHrf56898') and rtrim(altfutpli.M_OBJ_ASYS) in ('INSTRUMENT','INSTRUMENT_FWD')
left join KEYMAP_STC_DBF altoftpli on fcm.M_FCMUID  = altfutpli.M_OBJ_ID and rtrim(altfutpli.M_OBJ_CLASS) in ('MpHvX56898') and rtrim(altfutpli.M_OBJ_ASYS) in ('INSTRUMENT','INSTRUMENT_OFUT')
left join KEYMAP_STC_DBF altoappli on fcm.M_FCMUID  = altfutpli.M_OBJ_ID and rtrim(altfutpli.M_OBJ_CLASS) in ('McPlm56897') and rtrim(altfutpli.M_OBJ_ASYS) = 'INSTRUMENT'
left join KEYMAP_STC_DBF altgenpli on gin.M_GEN_NUM = altgenpli.M_OBJ_ID and rtrim(altgenpli.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(altgenpli.M_OBJ_ASYS) = 'INSTRUMENT'
-- MARKETVIEW
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,7) in ('COM_FUT')  and M_MXHSR not in ('LDM','SGM','TAM','TAPS','TAS') and M_MXDFL <> 'Dep') mvhisfcm  on rtrim(pli.M_PLILAB)  = rtrim(mvhisfcm.M_MXLABEL)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,7) in ('COM_FUT')  and M_MXHSR not in ('LDM','SGM','TAM','TAPS','TAS') and M_MXDFL <> 'Dep') mvhisfcmfwd0 on rtrim(crv.M_CRVOBJ)  = rtrim(mvhisfcmfwd0.M_MXLABEL)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,7) in ('COM_FUT')  and M_MXHSR not in ('LDM','SGM','TAM','TAPS','TAS') and M_MXDFL <> 'Dep') mvhisfcmicm0 on rtrim(pli.M_ROTICM0) = rtrim(mvhisfcmicm0.M_MXLABEL) and rtrim(pli.M_VIN) = rtrim(mvhisfcmicm0.M_MXVIN)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,7) in ('COM_FUT')  and M_MXHSR not in ('LDM','SGM','TAM','TAPS','TAS') and M_MXDFL <> 'Dep') mvhisfcmicm1 on rtrim(pli.M_ROTICM1) = rtrim(mvhisfcmicm1.M_MXLABEL)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,8) in ('COM_SIND') and rtrim(M_MXHSR) not in (' ','PM') and M_MXDFL <> 'Dep') mvhisicm0 on rtrim(pli.M_ROTICM0) = rtrim(mvhisicm0.M_MXLABEL) and rtrim(pli.M_ROTQOT0) = rtrim(mvhisicm0.M_MXQLABEL) and rtrim(pli.M_VIN) = rtrim(mvhisicm0.M_MXVIN)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,8) in ('COM_SIND') and rtrim(M_MXHSR) not in (' ','PM') and M_MXDFL <> 'Dep') mvhisicm1 on rtrim(pli.M_ROTICM1) = rtrim(mvhisicm1.M_MXLABEL) and rtrim(pli.M_ROTQOT1) = rtrim(mvhisicm1.M_MXQLABEL)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,8) in ('COM_CIND')) mvhisnby0 on rtrim(pli.M_UNDLAB0) = rtrim(mvhisnby0.M_MXLABEL)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXLABEL,  M_MXQLABEL, M_MXVIN, M_MXHSR, M_MVSYMBOL from UDTB344_DBF where substr(M_MXPTYPE,1,8) in ('COM_CIND')) mvhisnby1 on rtrim(pli.M_UNDLAB1) = rtrim(mvhisnby1.M_MXLABEL) 
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXCRVUND, M_MXQLABEL, M_MXVIN, M_MVSYMBOL from UDTB343_DBF where rtrim(M_MXPTYPE) in ('COM_ADJ_FUT','COM_ADJ_FUT1','COM_FUT','COM_FUT_3M')) mvfwdfcm0 on rtrim(pli.M_ROTICM0) = rtrim(mvfwdfcm0.M_MXCRVUND) and rtrim(mvfwdfcm0.M_MXVIN) = rtrim(pli.M_VIN)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXCRVUND, M_MXQLABEL, M_MXVIN, M_MVSYMBOL from UDTB343_DBF where rtrim(M_MXPTYPE) in ('COM_ADJ_FUT','COM_ADJ_FUT1','COM_FUT','COM_FUT_3M')) mvfwdfcm1 on rtrim(pli.M_ROTICM1) = rtrim(mvfwdfcm1.M_MXCRVUND) and rtrim(mvfwdfcm1.M_MXVIN) = rtrim(pli.M_VIN)
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXCRVUND, M_MXQLABEL, M_MXVIN, M_MVSYMBOL from UDTB343_DBF where rtrim(M_MXPTYPE) in ('COM_ADJ_SWAP','COM_ADJ_SWAP1','COM_SWAP') and (rtrim(M_MXTENOR) is null or rtrim(M_MXTENOR) = 'Spot') and M_MXDFL <> 'Dep') mvfwdicm0 on rtrim(pli.M_ROTICM0) = rtrim(mvfwdicm0.M_MXCRVUND) and rtrim(pli.M_ROTQOT0) = rtrim(mvfwdicm0.M_MXQLABEL) 
left join (select distinct M_MXPTYPE, M_MXPUB, M_MXCRVUND, M_MXQLABEL, M_MXVIN, M_MVSYMBOL from UDTB343_DBF where rtrim(M_MXPTYPE) in ('COM_ADJ_SWAP','COM_ADJ_SWAP1','COM_SWAP') and (rtrim(M_MXTENOR) is null or rtrim(M_MXTENOR) = 'Spot') and M_MXDFL <> 'Dep') mvfwdicm1 on rtrim(pli.M_ROTICM1) = rtrim(mvfwdicm1.M_MXCRVUND) and rtrim(pli.M_ROTQOT1) = rtrim(mvfwdicm1.M_MXQLABEL) 

--where 1 = 1 
--and pli.M_FINASS = 'COM'
--and pli.M_COMATP <> 'METL'
--and pli.COMASS in ('OIL')

order by phyudf.M_SEQ, locudf.M_SEQ, PLILAB


--)

--group by PLITYP, PLILAB, CRVICM
--*/

