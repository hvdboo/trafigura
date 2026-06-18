select 
rep.M_DEALUNIQU        RECUID,
-- rep.CNT                CNT,
cast(rep.M_TRADE_ID as INTEGER) TRN,
rep.M_TRADE_DAT        TRNDAT,
rtrim(rep.M_STATUS)    TRNSTAT,
null                   USRGRP,
rtrim(rep.M_TRADER)    USR,
case when rtrim(rep.M_INTERNAL) = 'YES' then 'I' else 'E' end TRN_IE,
rtrim(ctp.M_RELIE)     CTP_IE,
rtrim(rep.M_LEG_ENTIT) LE,
rtrim(rep.M_PORTFOLIO) PFL,
rtrim(rep.M_COUNTERPA) CTP,
case when rtrim(rep.M_FAMILY) = 'CURR' then 'FXD' else rtrim(rep.M_FAMILY) end FINASS,
rtrim(rep.M_LO)        LO,
rtrim(rep.M_OPT)       OPT,
cast(rep.M_FGT as INTEGER) FGT,
rtrim(rep.M_FAMILY)    FML,
rtrim(fgt.GRP)         GRP,
rtrim(fgt.TYP)         TYP,
rtrim(rep.M_TYPOLOGY)  TYPO,
rtrim(rep.M_ACCSEC)    SEC,
rtrim(rep.M_STRATEGY)  STG,
rtrim(rep.M_INSTRUMEN) PLILAB,
rtrim(rep.M_CUR_PNL)   PLICUR,
rtrim(substr(rep.M_QOT_FX,5,3)) CUR,
rtrim(substr(rep.M_QOT_FX,1,3)) UOQ,
rep.M_LOTSIZE          LOTSIZ,
rep.M_START_DAT        EFF,
rep.M_MATDAT           MATDAT0,
rep.M_MATDAT           STL,
rep.M_C_P              RGT,
case when rep.M_FGT = 84 then rep.M_STRIKE else rep.M_PRICE end STK,
case when rep.M_FGT = 84 then null else rep.M_PRICE end PRC,
case when rep.M_FGT = 84 then rep.M_PRICE else null end PRM,
rep.M_DIR              DIR,
case 
when rep.M_FGT = 84 then
   case 
   when rep.M_DIR = 'Buy'  and rtrim(substr(rep.M_C_P,1,4)) = 'call' then 'Rec'
   when rep.M_DIR = 'Buy'  and rtrim(substr(rep.M_C_P,1,4)) = 'put'  then 'Pay'
   when rep.M_DIR = 'Sell' and rtrim(substr(rep.M_C_P,1,4)) = 'call' then 'Pay'
   when rep.M_DIR = 'Sell' and rtrim(substr(rep.M_C_P,1,4)) = 'put'  then 'Rec'
   else null end      
else substr(rep.M_DIR1,1,3) end PR0,
cast(rep.M_NOM1 as DOUBLE)      NOM0,
cast(rep.M_AMTFX1 as DOUBLE)    QTY0,
rtrim(rep.M_CUR_FX1)            UOM0,
case 
when rep.M_FGT = 84 then
   case 
   when rep.M_DIR = 'Buy'  and rtrim(substr(rep.M_C_P,1,4)) = 'call' then 'Pay'
   when rep.M_DIR = 'Buy'  and rtrim(substr(rep.M_C_P,1,4)) = 'put'  then 'Rec'
   when rep.M_DIR = 'Sell' and rtrim(substr(rep.M_C_P,1,4)) = 'call' then 'Rec'
   when rep.M_DIR = 'Sell' and rtrim(substr(rep.M_C_P,1,4)) = 'put'  then 'Pay'
   else null end      
else substr(rep.M_DIR2,1,3) end PR1,
rep.M_NOM2                      NOM1,
cast(rep.M_AMTFX2 as DOUBLE)    QTY1,
rtrim(rep.M_CUR_FX2)            UOM1,
cast(M_PL_ACC as DOUBLE)   PL_ACC,
cast(M_PL_MV_FI as DOUBLE) PL_MV_DIS,
cast(M_PL_CS_FI as DOUBLE) PL_PC_FIN,
rtrim(pfl.M_PC)            PFL_LE,
rtrim(pfl.M_DIVC)          PFL_DIV,
rtrim(pfl.M_DIVISION)      PFL_DIVISION,
rtrim(pfl.M_STR)           PFL_STR,
rtrim(pfl.M_STREAM)        PFL_STREAM,
rtrim(pfl.M_MAS)           PFL_MAS,
rtrim(pfl.M_MASTER)        PFL_MASTER,
rtrim(pfl.M_OWNC)          PFL_OWN,
rtrim(pfl.M_OWNER)         PFL_OWNER,
rtrim(pfl.M_CAT)           PFL_CAT,
rtrim(pfl.M_CATEGORY)      PFL_CATEGORY, 
rtrim(pfl.M_MKT)           PFL_MKT, 
rtrim(pfl.M_MARKET)        PFL_MARKET, 
rtrim(pfl.M_STG)           PFL_STG,
rtrim(pfl.M_STRATEGY)      PFL_STRATEGY,
rtrim(pfl.M_BSL)           PFL_BSL,
rtrim(pfl.M_TITBSL)        PFL_TITBSL,
rtrim(pfl.M_TITELG)        PFL_TITELG,
rtrim(pfl.M_RMDCOD)        PFL_SEC,
rtrim(pfl.M_RMDLAB)        PFL_SECTION,
rtrim(pfl.M_SRDUID)        PFL_SRDUID,
cast(pfl.M_ID as INTEGER)  PFL_UID

from REPPNL rep
left join CTP ctp on rtrim(rep.M_COUNTERPA) = rtrim(ctp.M_LABDSP)
left join FGT fgt on rep.M_FGT = fgt.FGT
left join PFL pfl on rtrim(rep.M_PORTFOLIO) = rtrim(pfl.M_LAB)


