select distinct
rtrim(atp.M_LABEL) ASSTYP, 
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
rtrim(fcm.M_LABEL) FCMLAB, 
rtrim(fcm.M_DESC)  FCMDES,
rtrim(qot.M_LABEL) QOT,
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
else null end CFGMOD,
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
case fcm.M_PRC_EVAL	
when 0 then 'Marked to market'
when 1 then 'Theoretical' end EVAL,
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
case fcm.M_EXR_MODE
when 0 then 'Cash' 
when 1 then 
   case fcm.M_INS_MODE
   when 0 then 'Fin.dlv'
   when 1 then
      case fcsgen.M_EXR_MODE
      when 0 then 'Fin.dlv'
      when 1 then 'Phy.dlv'
      else null end
   else null end   
else null end EXR,
rtrim(udf.M_EXRMOD) EXRUDF,
case fcm.M_SPLT_RULE	
when 0 then 'None'
when 1 then 'Quotation end' 
when 2 then 'Trade date' end SPLIT,
fcm.M_QTY as LOTSIZ,
case 
when fcm.M_LISTED in (1,2,16,32) then rtrim(fcmmat.M_LABEL)
when fcm.M_LISTED in (64) then rtrim(ofcmat.M_LABEL) else null end MATSET,
rtrim(fcm.M_COMMENT1)  MAT,
rtrim(fcm.M_COMMENT0)  OBS,
rtrim(qotfwd.M_LABEL)  FWDQOT,
/*
fcm.M_QUOT_SET QOTSET, 
case qot.M__TYPE_
when  1 then 'Index'
when  2 then 'Future'
when  4 then 'Dlv.flow'
when  8 then 'Spread'
when  5 then 'Index flow'
when  6 then 'Future flow'
when 14 then 'Spread fcm.flow' 
when 16 then 'Listed option' else null end QOTTYP,
*/
rtrim(pub.M_LABEL)          PUB, 
rtrim(altmktmic.M_OBJ_ALBL) PUBMIC,
rtrim(pub.M_CALENDAR)       PUBCAL,
rtrim(qot.M_TRAD_SMB)       SYM,
qot.M_CURR            CUR, 
qot.M_PRC_FACT        CURFCT,
udf.M_CURFCT          FCTUDF, 
rtrim(qotuoq.M_LABEL)   UOQ, 
rtrim(qotuod.M_LABEL)   UOD,
rtrim(stkset.M_LABEL) STKSET,
rtrim(stkrul.M_LABEL) STKRUL,
stkdef.M_CVALUE       STKCEN,
stkdef.M_STEP         STKSTP,
stkdef.M_PTS          STKPTS,
(stkdef.M_CVALUE - (stkdef.M_PTS * stkdef.M_STEP))     STKMIN,
(stkdef.M_CVALUE + (stkdef.M_PTS * stkdef.M_STEP))     STKMAX,
-- DELIVERY
coalesce(rtrim(fcsidt.M_PHY), rtrim(fccidt.M_PHY), rtrim(ofcfcsidt.M_PHY), rtrim(ofcfccidt.M_PHY)) PHY,
coalesce(rtrim(fcsidt.M_LOC), rtrim(fccidt.M_LOC), rtrim(ofcfcsidt.M_LOC), rtrim(ofcfccidt.M_LOC)) LOC,
'H'||rtrim(grp.M_HISFILE)||'_H1S' HISHDR,
'B'||rtrim(grp.M_HISFILE)||'_HBS' HISBDY,
rtrim(grp.M_CALENDAR)    HISCAL,
rtrim(pli.M_DSP_LABEL)   PLILAB,
fcm.M_REFERENCE          FCMUID, 
qot.M_REFERENCE          QOTUID,
-- rtrim(grp.M_GRP_DESC) GRP_ID,
pli.M_REFERENCE          PLIUID,
rtrim(fcm.M_COMMENT2)    CMT2,
rtrim(alturl.M_OBJ_ALBL) EXCCOD,
rtrim(alturl.M_OBJ_ALT)  EXCURL

from CM_FUT_DBF fcm
left join CM_ASSET_DBF ass on fcm.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE
left join CM_FMAT_DBF  fcmmat on fcm.M_FUT_MAT = fcmmat.M_REFERENCE
left join CM_OMAT_DBF  ofcmat on fcm.M_OPT_MAT = ofcmat.M_REFERENCE
left join CM_FUT_DBF   ofcfcm  on fcm.M_CM_INSTR  = ofcfcm.M_REFERENCE  and fcm.M_LISTED in (64)
left join CM_FUT_DBF   ofcfcm2 on fcm.M_CONTRACT2 = ofcfcm2.M_REFERENCE and fcm.M_LISTED in (64)
left join CMC_QUOT_DBF qotfwd on fcm.M_QUOT_FWD = qotfwd.M_REFERENCE
left join CMC_QUOT_DBF qot on fcm.M_QUOT_SET = qot.M_SET
left join CM_UNIT_DBF  qotuoq on qot.M_UNIT = qotuoq.M_REFERENCE
left join CM_UNIT_DBF  qotuod on qot.M_QTY_UNIT = qotuod.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI= pub.M_REFERENCE
left join CMC_MGEN_DBF fcsgen on (fcm.M_CM_INSTR = fcsgen.M_REFERENCE and fcm.M_LISTED in (1,2,16,32) and fcm.M_INS_MODE = 1)
left join RT_INDEX_DBF fcsind on fcsgen.M_INDEX = fcsind.M_INDEX
left join VIW_ICMALL_DBF fcsidt on fcsind.M_REFERENCE = fcsidt.M_INDUID
left join RT_INSGN_DBF fccins on (fcm.M_CM_INSTR = fccins.M_GEN_NUM and fcm.M_INS_MODE = 0 and fccins.M_CREAT_MODE = 0)
left join RT_LNGN_DBF  fccgen on fccins.M_GEN_NUM = fccgen.M_GEN_NUM 
left join RT_INDEX_DBF fccind on rtrim(fccgen.M_INDEX0) = rtrim(fccind.M_INDEX)
left join VIW_ICMALL_DBF fccidt on fccind.M_REFERENCE = fccidt.M_INDUID
left join CMC_MGEN_DBF ofcfcsgen on (ofcfcm.M_CM_INSTR = ofcfcsgen.M_REFERENCE and ofcfcm.M_LISTED in (1,2,16,32) and ofcfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF ofcfcsind on ofcfcsgen.M_INDEX = ofcfcsind.M_INDEX
left join VIW_ICMALL_DBF ofcfcsidt on ofcfcsind.M_REFERENCE = ofcfcsidt.M_INDUID
left join RT_INSGN_DBF ofcfccins on (ofcfcm.M_CM_INSTR = ofcfccins.M_GEN_NUM and ofcfcm.M_LISTED in (1,2,16,32) and ofcfcm.M_INS_MODE = 0)
left join RT_LNGN_DBF  ofcfccgen on (ofcfcm.M_CM_INSTR = ofcfccgen.M_GEN_NUM and ofcfcm.M_INS_MODE = 0)
left join RT_INDEX_DBF ofcfccind on rtrim(ofcfccgen.M_INDEX0) = rtrim(ofcfccind.M_INDEX)
left join VIW_ICMALL_DBF ofcfccidt on ofcfccind.M_REFERENCE = ofcfccidt.M_INDUID
left join CM_STKSET_DBF stkset on qot.M_STRIKES = stkset.M_REFERENCE
left join CMC_BKT_DBF   stkrul on stkset.M_RULES = stkrul.M_REFERENCE
left join CMC_BSTG_DBF  stkdef on stkrul.M_REFERENCE = stkdef.M_B_REF
left join RT_GROUP_DBF grp on (to_char(fcm.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15))) and to_char(pub.M_REFERENCE) = trim(grp.M_GRP_CATEG)
left join TRN_PLIN_DBF pli on rtrim(fcm.M_LABEL) = rtrim(pli.M_DSP_LABEL)
left join TABLE#DATA#COMMODIT_DBF udf on fcm.M_REFERENCE = udf.M_REFERENCE
left join KEYMAP_STC_DBF altmktmic on pub.M_REFERENCE = altmktmic.M_OBJ_ID and altmktmic.M_OBJ_CLASS in ('MnVuQ71331') and rtrim(substr(altmktmic.M_OBJ_ASYS,1,10)) = 'MIC'
left join KEYMAP_STC_DBF alturl on fcm.M_REFERENCE = alturl.M_OBJ_ID and alturl.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(alturl.M_OBJ_ASYS,1,3)) = 'URL'

where 1 = 1 
and fcm.M_COMMENT4 <> 'OOS'
and fcm.M_LISTED in (1, 32, 64)
-- and fcsind.M_COM_QUOT in (718, 720, 721, 729, 730)
-- substr(fcm.M_LABEL,1,3) = 'FRT'
-- and fcm.M_REFERENCE = 549

order by FCMLAB