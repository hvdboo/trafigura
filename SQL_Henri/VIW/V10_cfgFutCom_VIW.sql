drop view FUTCOM_VIW;
create view FUTCOM_VIW
(
M_ASSTYP,
M_ASSLAB,
M_FCMTYP,
M_FCMLAB,
M_FCMDES,
M_QOT,
M_PUB,
M_PUBMIC,
M_PUBCAL,
M_SYM,
M_CUR,
M_CURFCT,
M_FCTUDF,
M_UOQ,
M_UOD,
M_HSR,
M_LOTSIZ,
M_CFGMOD,
M_INSTRUMENT,
M_SPRMOD,
M_OPTSTY,
M_OPTEXR,
M_EXR,
M_EXRUDF,
M_EVAL,
M_PRC_DISCOVERY,
M_FX_FIXING,
M_MC,
M_MC_DISC,
M_IGN_DISC,
M_NETTING,
M_SPLIT,
M_PAYSHF,
M_OBS,
M_MATSET,
M_MATCAS,
M_VINSET,
M_VINFLT,
M_FWDQOT,
M_STKSET,
M_STKRUL,
M_STKCEN,
M_STKSTP,
M_STKPTS,
M_STKMIN,
M_STKMAX,
M_INDTYP,
M_INDLAB,
M_UNDTYP,
M_UNDLAB,
M_UNDVIN,
M_UNDHSR,
M_CRVICM,
M_PHYLAB,
M_LOCLAB,
M_OTCEQV,
M_HISHDR,
M_HISBDY,
M_HISCAL,
M_PLILAB,
M_FCMUID,
M_QOTUID,
M_PLIUID,
M_INSUID,
M_INDUID,
M_ICMUID,
M_EXCCD2,
M_EXCCD3,
M_EXCURL
)

as 

(

select distinct
rtrim(ast.M_LABEL) ASSTYP,
rtrim(ass.M_LABEL) ASSLAB,
case fcm.M_LISTED 
when 1 then 
    case fcm.M_LOOKALIKE_ENABLED
    when  0 then 'Listed'
    when  1 then 'Listed & Lookalike' end
when  2 then 'OTC'
when 16 then 'Cleared Swap'
when 32 then 'Cleared Asian'
when 64 then 'Listed options' end FCMTYP,
rtrim(fcm.M_LABEL)       FCMLAB, 
rtrim(fcm.M_DESC)        FCMDES,
rtrim(qot.M_LABEL)       QOT,
rtrim(pub.M_LABEL)       PUB,
rtrim(altmic.M_OBJ_ALBL) PUBMIC,
rtrim(pub.M_CALENDAR)    PUBCAL,
rtrim(qot.M_TRAD_SMB)    SYM,
-- rtrim(alturl.M_OBJ_ALT) SYMEXT,
rtrim(qot.M_CURR)     CUR,
qot.M_PRC_FACT        CURFCT,
udf.M_CURFCT          FCTUDF, 
rtrim(qotuoq.M_LABEL) UOQ, 
rtrim(qotuod.M_LABEL) UOD,
coalesce(rtrim(fcshsr.M_LABEL), rtrim(fcchsr.M_LABEL)) HSR,
fcm.M_QTY             LOTSIZ,
-- INSTRUMENT
case 
when fcm.M_LISTED in (1,2,16) then  
    case fcm.M_INS_MODE
    when 0 then 'Custom'
    when 1 then 'Simple' else null end 
when fcm.M_LISTED in (64) then 
    case fcm.M_OSPRD_TYP
    when 0 then 'Simple'
    when 1 then 'Product spread' 
    when 2 then 'Time spread' else null end 
when fcm.M_LISTED in (32) then 'Custom'
else null end as CFGMOD,
case
when fcm.M_LISTED in (1,2,16,32) then 
    case fcm.M_INS_MODE
    when 0 then rtrim(fccins.M_INSTR)
    when 1 then rtrim(fcsind.M_IND_LAB) else null end
when fcm.M_LISTED in (64) then rtrim(ofcfcm.M_LABEL)
else null end INSTRUMENT,
case
when fcm.M_LISTED in (64) then
    case fcm.M_OSPRD_TYP
    when 1 then rtrim(ofcfcm2.M_LABEL)
    when 2 then
        case fcm.M_BENCHMARK
        when 0 then 'Near - Far, Shift: '||to_char(fcm.M_MAT_SPRD)
        when 1 then 'Far - Near, Shift: '||to_char(fcm.M_MAT_SPRD) else null end
    else null end    
else null end SPRMOD,
case  
when fcm.M_LISTED in (1,2) then
   case when fcm.M_OPT_MAT > 0 then
      case fcm.M_OEXR_STYLE
      when 0 then 'European'
      when 1 then 'American' else null end
   else null end        
when fcm.M_LISTED = 32 then 'Asian'
when fcm.M_LISTED = 64 then 
   case fcm.M_OEXR_STYLE
   when 0 then 'European'
   when 1 then 'American' else null end 
else null end OPTSTY,
case
when fcm.M_LISTED in (1,2) then
   case when fcm.M_OPT_MAT > 0 then
      case fcm.M_OEXR_MODE
      when 0 then 'Cash'
      when 1 then 'Delivery' else null end
   else null end        
when fcm.M_LISTED = 32 then 'Cash'
when fcm.M_LISTED = 64 then 
   case fcm.M_EXR_MODE
   when 0 then 'Cash'
   when 1 then 'Delivery' else null end 
else null end OPTEXR,
case fcm.M_EXR_MODE
when 0 then 'Cash' 
when 1 then 
   case fcm.M_INS_MODE
   when 0 then 'Fin.dlv'
   when 1 then
      case fcsgen.M_EXR_MODE
      when 0 then 'Fin.dlv'
      when 1 then 'Phy.dlv' else null end
   else null end
else null end EXR,
rtrim(udf.M_EXRMOD) EXRUDF,
case fcm.M_PRC_EVAL        
when 0 then 'Mtm'
when 1 then 'Theo' end EVAL,
case fcm.M_PRC_DISC
when 0 then 'Quotation end' 
when 1 then 'Delivery period' 
when 2 then 'Delivery start'
when 3 then 'Delivery end'
when 4 then 'Notification start'
when 5 then 'Notification end' end PRC_DISCOVERY,
case fcm.M_FX_FIXDATE   
when 0 then 'Quotation end'
when 1 then 'Delivery start' 
when 2 then 'Spot date' end FX_FIXING,
case fcm.M_MCALL_SYS    
when 1 then 'Yes'
when 0 then 'No' end  MC,
case fcm.M_MCALL_DSC
when 0 then 'No'
when 1 then 'Yes' end MC_DISC,
case fcm.M_IGN_DISC
when 0 then 'No'
when 1 then 'Yes' end IGN_DISC,
case fcm.M_NETTING_ALLOWED
when 0 then 'No'
when 1 then 'Yes' end NETTING,
case fcm.M_SPLT_RULE    
when 0 then 'None'
when 1 then 'Quotation end' 
when 2 then 'Trade date' end SPLIT,
rtrim(fcsgen.M_PAYMENT) PAYSHF,
rtrim(udf.M_OBS)        OBS,
case 
when fcm.M_LISTED in (1,2,16,32) then rtrim(fcmmat.M_LABEL)
when fcm.M_LISTED in (64) then rtrim(ofcmat.M_LABEL) else null end MATSET,
rtrim(udf.M_MATCAST)   MATCAS,
rtrim(vinset.M_LABEL)  VINSET,
rtrim(vin.M_LABEL)     VINFLT,


rtrim(qotfwd.M_LABEL)  FWDQOT,
/*
fcm.M_QUOT_SET QOTSET, 
case qot.M__TYPE_
when  1 then 'Index stock'
when  2 then 'Future stock'
when  4 then 'Dlv.flow'
when  5 then 'Index flow'
when  6 then 'Future flow'
when  8 then 'Spread'
when 14 then 'Spread fut.flow' 
when 16 then 'Opt.Listed' else null end QOTTYP,
*/
rtrim(stkset.M_LABEL) STKSET,
rtrim(stkrul.M_LABEL) STKRUL,
stkdef.M_CVALUE       STKCEN,
stkdef.M_STEP         STKSTP,
stkdef.M_PTS          STKPTS,
(stkdef.M_CVALUE - (stkdef.M_PTS * stkdef.M_STEP))     STKMIN,
(stkdef.M_CVALUE + (stkdef.M_PTS * stkdef.M_STEP))     STKMAX,
-- INDEX
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(fccidt.M_INDTYP, fcsidt.M_INDTYP)
when fcm.M_LISTED in (64) then coalesce(ofcfccidt.M_INDTYP, ofcfcsidt.M_INDTYP)
else null end INDTYP,
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(fccidt.M_INDLAB, fcsidt.M_INDLAB)
when fcm.M_LISTED in (64) then coalesce(ofcfccidt.M_INDLAB, ofcfcsidt.M_INDLAB)   
else null end INDLAB,
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(fccidt.M_UNDTYP, fcsidt.M_UNDTYP)
when fcm.M_LISTED in (64) then coalesce(ofcfccidt.M_UNDTYP, ofcfcsidt.M_UNDTYP)
else null end UNDTYP,
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(fccidt.M_UNDLAB, fcsidt.M_UNDLAB)
when fcm.M_LISTED in (64) then coalesce(ofcfccidt.M_UNDLAB, ofcfcsidt.M_UNDLAB)
else null end UNDLAB,
to_char(vinper.M_START_DATE,'YYYY') UNDVIN,
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(rtrim(fcchsr.M_LABEL), rtrim(fcshsr.M_LABEL)) else null end UNDHSR,
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(fccidt.M_CRVICM0, fcsidt.M_CRVICM0)
when fcm.M_LISTED in (64) then coalesce(ofcfccidt.M_CRVICM0, ofcfcsidt.M_CRVICM0)
else null end CRVICM,
-- DELIVERY
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(fccidt.M_PHYLAB, fcsidt.M_PHYLAB)
when fcm.M_LISTED in (64) then coalesce(ofcfccidt.M_PHYLAB, ofcfcsidt.M_PHYLAB)
else null end PHYLAB,
case
when fcm.M_LISTED in (1,2,16,32) then coalesce(fccidt.M_LOCLAB, fcsidt.M_LOCLAB)
when fcm.M_LISTED in (64) then coalesce(ofcfccidt.M_LOCLAB, ofcfcsidt.M_LOCLAB)
else null end LOCLAB,
-- OTC EQV
rtrim(pliotc.M_DSP_LABEL)         OTCEQV,
-- HIS
'H'||rtrim(grp.M_HISFILE)||'_H1S' HISHDR,
'B'||rtrim(grp.M_HISFILE)||'_HBS' HISBDY,
rtrim(grp.M_CALENDAR)             HISCAL,
-- UID
rtrim(pli.M_DSP_LABEL)   PLILAB,
fcm.M_REFERENCE          FCMUID, 
qot.M_REFERENCE          QOTUID,
-- rtrim(grp.M_GRP_DESC) GRP_ID,
pli.M_REFERENCE          PLIUID,
case
when fcm.M_LISTED in (1,2,16,32) then 
   case fcm.M_INS_MODE
   when 0 then fccins.M_GEN_NUM
   when 1 then fcsgen.M_REFERENCE else null end
when fcm.M_LISTED in (64) then ofcfcm.M_REFERENCE
else null end INSUID,
coalesce(fccidt.M_INDUID, fcsidt.M_INDUID, ofcfccidt.M_INDUID, ofcfcsidt.M_INDUID) INDUID,
coalesce(fccidt.M_ICMUID, fcsidt.M_ICMUID, ofcfccidt.M_ICMUID, ofcfcsidt.M_ICMUID) ICMUID,
rtrim(fcm.M_REALTIME)    EXCCD2,
rtrim(alturl.M_OBJ_ALBL) EXCCD3,
rtrim(alturl.M_OBJ_ALT)  EXCURL

from CM_FUT_DBF fcm
left join CM_ASSET_DBF ass on fcm.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_FMAT_DBF  fcmmat on fcm.M_FUT_MAT = fcmmat.M_REFERENCE
left join CM_VINTAGESET_DBF vinset on fcmmat.M_VINTAGE_SET = vinset.M_REFERENCE
left join CM_VINTAGE_DBF vin on fcm.M_VINTAGE_FILTER = vin.M_REFERENCE
left join CM_VINTAGE_PERIOD_DBF vinper on vin.M_REFERENCE = vinper.M_VINTAGE_REF
left join CMC_QUOT_DBF qotfwd on fcm.M_QUOT_FWD = qotfwd.M_REFERENCE
left join CMC_QUOT_DBF qot on fcm.M_QUOT_SET = qot.M_SET
left join CM_MKT_DBF   pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_UNIT_DBF  qotuoq on qot.M_UNIT = qotuoq.M_REFERENCE
left join CM_UNIT_DBF  qotuod on qot.M_QTY_UNIT = qotuod.M_REFERENCE
left join TABLE#DATA#COMMODIT_DBF udf on fcm.M_REFERENCE = udf.M_REFERENCE
left join TRN_PLIN_DBF pliotc on udf.M_OTCEQV = pliotc.M_REFERENCE
-- Option
left join CM_FUT_DBF  ofcfcm  on fcm.M_CM_INSTR  = ofcfcm.M_REFERENCE  and fcm.M_LISTED in (64)
left join CM_FUT_DBF  ofcfcm2 on fcm.M_CONTRACT2 = ofcfcm2.M_REFERENCE and fcm.M_LISTED in (64)
left join CM_OMAT_DBF ofcmat on fcm.M_OPT_MAT = ofcmat.M_REFERENCE
-- Future index
left join RT_INSGN_DBF fccins on (fcm.M_CM_INSTR = fccins.M_GEN_NUM and fcm.M_INS_MODE = 0)
left join RT_LNGN_DBF  fccgen on (fcm.M_CM_INSTR = fccgen.M_GEN_NUM and fcm.M_LISTED in (1,2,16,32) and fcm.M_INS_MODE = 0)
left join CM_PHYS_DBF  fccgenphy0 on fccgen.M_DEL_FYS0 = fccgenphy0.M_REFERENCE
left join CM_LOCAT_DBF fccgenloc0 on fccgen.M_DEL_LOC0 = fccgenloc0.M_REFERENCE
left join RT_INDEX_DBF fccind on fccgen.M_INDEX0 = fccind.M_INDEX
left join VIW_ICMALL_DBF fccidt on fccind.M_REFERENCE = fccidt.M_INDUID
left join CM_MKTSR_DBF fcchsr on rtrim(substr(fccgen.M_FORMULA0,2,10)) = rtrim(to_char(fcchsr.M_SERIE))
left join CMC_MGEN_DBF fcsgen on (fcm.M_CM_INSTR = fcsgen.M_REFERENCE and fcm.M_LISTED in (1,2,16) and fcm.M_INS_MODE = 1)
left join CM_MKTSR_DBF fcshsr on fcsgen.M_SERIES = fcshsr.M_SERIE
left join RT_INDEX_DBF fcsind on fcsgen.M_INDEX = fcsind.M_INDEX
left join VIW_ICMALL_DBF fcsidt on fcsind.M_REFERENCE = fcsidt.M_INDUID
-- Option index
left join CMC_MGEN_DBF ofcfcsgen on (ofcfcm.M_CM_INSTR = ofcfcsgen.M_REFERENCE and ofcfcm.M_LISTED in (1,2,16,32) and ofcfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF ofcfcsind on ofcfcsgen.M_INDEX = ofcfcsind.M_INDEX
left join VIW_ICMALL_DBF ofcfcsidt on ofcfcsind.M_REFERENCE = ofcfcsidt.M_INDUID
left join RT_INSGN_DBF ofcfccins on (ofcfcm.M_CM_INSTR = ofcfccins.M_GEN_NUM and ofcfcm.M_LISTED in (1,2,16,32) and ofcfcm.M_INS_MODE = 0)
left join RT_LNGN_DBF  ofcfccgen on (ofcfcm.M_CM_INSTR = ofcfccgen.M_GEN_NUM and ofcfcm.M_INS_MODE = 0)
left join RT_INDEX_DBF ofcfccind on rtrim(ofcfccgen.M_INDEX0) = rtrim(ofcfccind.M_INDEX)
left join VIW_ICMALL_DBF ofcfccidt on ofcfccind.M_REFERENCE = ofcfccidt.M_INDUID
-- Varia
left join CM_STKSET_DBF stkset on qot.M_STRIKES = stkset.M_REFERENCE
left join CMC_BKT_DBF   stkrul on stkset.M_RULES = stkrul.M_REFERENCE
left join CMC_BSTG_DBF  stkdef on stkrul.M_REFERENCE = stkdef.M_B_REF
left join RT_GROUP_DBF grp on (to_char(fcm.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15))) and to_char(pub.M_REFERENCE) = trim(grp.M_GRP_CATEG)
left join TRN_PLIN_DBF pli on (fcm.M_REFERENCE = to_number(substr(pli.M_LABEL,9,10)) and pli.M_FAMILY in (32, 16384))
left join KEYMAP_STC_DBF altmic on pub.M_REFERENCE = altmic.M_OBJ_ID and altmic.M_OBJ_CLASS in ('MnVuQ71331') and rtrim(substr(altmic.M_OBJ_ASYS,1,3)) = 'MIC'
left join KEYMAP_STC_DBF alturl on (fcm.M_REFERENCE = alturl.M_OBJ_ID and alturl.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(alturl.M_OBJ_ASYS,1,3)) = 'URL')

where 1 = 1 
and fcm.M_LISTED in (1, 2, 32, 64)
and fcm.M_QUOT_FWD = qot.M_REFERENCE
and fcm.M_COMMENT4 <> 'OOS'
-- substr(fcm.M_LABEL,1,3) = 'FRT'
-- and fcm.M_REFERENCE = 549

);

drop table VIW_FCM_DBF;
create table VIW_FCM_DBF as (select * from FUTCOM_VIW);


