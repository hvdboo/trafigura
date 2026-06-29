
select distinct
-- CATEGORIZATION
rtrim(pli.M_FMLY_LBL) PLIFML,
case pli.M_FAMILY
when     1 then 
   'SC '||rtrim(seh.M_SE_GROUP)||
   case 
   when rtrim(seh.M_SE_CATE) is not null then ', '||rtrim(seh.M_SE_CATE)   
   else rtrim('') end
when     2 then 
   case gin.M_INSTR_TYPE
   when  0 then case when rtrim(gin.M_SING_CURR) is null then 'IR Swap XCUR' else 'IR Swap' end   
   when  1 then 'IR Bond'
   when  2 then 'IR Cap/Floor'
   when  3 then 'IR Loan'
   when  4 then 'IR FRA'
   when  7 then 'IR Asset swap' 
   when  8 then 'FI Call depo'
   when  9 then 'CR CDS'
   when 12 then 'CM Asian' 
   when 13 then 'CM Swap'
   when 14 then 'CR TRS'
   when 15 then 'IR Inflation' 
   when 16 then 'CR RTRS'
   when 17 then 'CM Fut' 
   when 18 then 'CM Fut'
   when 19 then 'EDS'
   when 20 then 'CM SptFwd'
   when 21 then 'FI Repo'
   when 22 then 'FI BSB'
   when 23 then 'FI Sto'
   when 26 then 'IR Return swap' 
   when 27 then 'CM Phys.Fwd' 
   when 28 then 'CM Opt.Phys'
   when 29 then 'FI Credit line' 
   when 30 then 'CM Fwd' 
   else null end
when     4 then 'CR Reference entity'
when    16 then 
   case rtrim(fxc.M_TYPE)
   when 'OTC'   then 'FX Pair'
   when 'OMFUT' then 'FX Future' else null end
when    32 then 
   case fcm.M_LISTED
   when   1 then 'CM Future'
   when   2 then 'CM Forward'
   when  16 then 'CM Clr.Swap' else null end
when    64 then 'Currency'
when   256 then
   case ind.M_CATEGORY
   when 0 then 'Rate'
   when 1 then 'Equity' 
   when 2 then 'Bond'
   when 3 then 'Inflation' 
   when 4 then 'FX Spot'
   when 5 then 'Mortgage'
   when 6 then 'Generic'
   when 7 then 'Formula' 
   when 8 then 
      case  ind.M_RESET
      when 0 then 'CM Spot'
      when 3 then 'CM Average'
      when 4 then 'CM Basket'
      when 6 then 'CM Nearby' end 
 when 9 then 'CM Forward' else null end
when   512 then 'CM Asian'
when  2048 then 'CM Physical' 
when 16384 then
   case fcm.M_LISTED
   when  32 then 'CM Clr.Asian'
   when  64 then 'CM Option LST' else null end
else null end SUBFML,
-- ASSET
case pli.M_FAMILY
when     1 then 
   case 
   when rtrim(seh.M_SE_GROUP) = 'Bond'   then 'SEC'
   when rtrim(seh.M_SE_GROUP) = 'Equity' then 'EQD'
   when rtrim(seh.M_SE_CATE)  = 'Bond'   then 'SEC'
   when rtrim(seh.M_SE_CATE)  = 'Equity' then 'EQD'
   when rtrim(seh.M_SE_CATE)  = 'Rate'   then 'IRD' 
   when rtrim(seh.M_SE_CATE)  = 'Volatility' then 'VOL'
   else null end
when     2 then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2,3)     then 'IRD'
   when gin.M_INSTR_TYPE in (9)           then 'CRD'   
   when gin.M_INSTR_TYPE in (12,13,27,28) then 'COM' 
   else null end
when     4 then 'CRD'
when    16 then 'FXD'
when    32 then 'COM'
when    64 then 'FXD' 
when   256 then 
  case
  when ind.M_CATEGORY in (0,2,3,5) then 'IRD'                                                  
  when ind.M_CATEGORY = 1 then 'EQD'
  when ind.M_CATEGORY = 4 then 'FXD'
  when ind.M_CATEGORY in (6,7) then 'CROSS'
  when ind.M_CATEGORY in (8,9) then 'COM' else null end
when   512 then 'COM'
when  2048 then 'COM'
when 16384 then 'COM' 
else null end FINASS,
case 
when pli.M_FAMILY =     2 and gin.M_INSTR_TYPE in (13, 27) then rtrim(genatp.M_LABEL)
when pli.M_FAMILY =    32 then rtrim(fcmatp.M_LABEL)
when pli.M_FAMILY =   256 and ind.M_CATEGORY = 8 then
   case 
   when ind.M_RESET = 0 then rtrim(icmatp.M_LABEL)
   when ind.M_RESET in (3,4,6) then rtrim(indatp.M_LABEL) else null end 
when pli.M_FAMILY =   512 then rtrim(genatp.M_LABEL)
when pli.M_FAMILY =  2048 then rtrim(phyatp.M_LABEL)
when pli.M_FAMILY = 16384 then rtrim(fcmatp.M_LABEL) 
else null end COMATP,
case 
when pli.M_FAMILY =     2 and gin.M_INSTR_TYPE in (13, 27) then rtrim(genass.M_LABEL)
when pli.M_FAMILY =    32 then rtrim(fcmass.M_LABEL)
when pli.M_FAMILY =   256 and ind.M_CATEGORY = 8 then
   case 
   when ind.M_RESET = 0 then rtrim(icmass.M_LABEL)
   when ind.M_RESET in (3,4,6) then rtrim(indass.M_LABEL) else null end 
when pli.M_FAMILY =   512 then rtrim(genass.M_LABEL)
when pli.M_FAMILY =  2048 then rtrim(phyudf.M_ASSET)
when pli.M_FAMILY = 16384 then rtrim(fcmass.M_LABEL) 
else null end COMASS,
case 
when pli.M_FAMILY =  1 and rtrim(seh.M_SE_GROUP) = 'Bond'   then 'SCBND'
when pli.M_FAMILY =  1 and rtrim(seh.M_SE_GROUP) = 'Equity' then 'SCEQT'
when pli.M_FAMILY =  1 and rtrim(seh.M_SE_GROUP) = 'Future' and rtrim(seh.M_SE_CATE) = 'Equity' then 'EQFUT'
when pli.M_FAMILY =  1 and rtrim(seh.M_SE_GROUP) = 'Future' and rtrim(seh.M_SE_CATE) = 'Bond'   then 'SCFTL'
when pli.M_FAMILY =  1 and rtrim(seh.M_SE_GROUP) = 'Future' and rtrim(seh.M_SE_CATE) = 'Rate'   then 'IRFTS'
when pli.M_FAMILY =  1 and rtrim(seh.M_SE_GROUP) = 'Future' and rtrim(seh.M_SE_CATE) = 'Volatility' then 'VOFTV'
when pli.M_FAMILY =  2 and gin.M_INSTR_TYPE =  0 then case when rtrim(gin.M_SING_CURR) is null then 'IRXCY' else 'IRSWP' end
when pli.M_FAMILY =  2 and gin.M_INSTR_TYPE =  1 then 'IRBND'
when pli.M_FAMILY =  2 and gin.M_INSTR_TYPE =  2 then 'IROCF'
when pli.M_FAMILY =  2 and gin.M_INSTR_TYPE =  9 then 'CRCDS'
when pli.M_FAMILY =  2 and gin.M_INSTR_TYPE = 12 then 'CMOAS'
when pli.M_FAMILY =  2 and gin.M_INSTR_TYPE = 13 then 'CMSWP'
when pli.M_FAMILY =  2 and gin.M_INSTR_TYPE = 27 then 'CMSWD'
when pli.M_FAMILY = 16 and rtrim(fxc.M_TYPE) = 'OTC'   then 'FXSPT'
when pli.M_FAMILY = 16 and rtrim(fxc.M_TYPE) = 'OMFUT' then 'FXFUT'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 1 then 'CMFUT'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 1 and fcm.M_LOOKALIKE_ENABLED = 1 then 'CMFUT,CMFWD'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 2 then  'CMFWD'
when pli.M_FAMILY = 32 and fcm.M_LISTED = 64 then 'CMOFW'
when pli.M_FAMILY = 32 and fcm.M_LOOKALIKE_ENABLED = 0 then 'CMFUT'
when pli.M_FAMILY =   512 then 'CMOAS'
when pli.M_FAMILY =  2048 then 'CMPHY'
when pli.M_FAMILY = 16384 and fcm.M_LISTED = 32 then 'CMOAP'
when pli.M_FAMILY = 16384 and fcm.M_LISTED = 64 then 'CMOFT'
else null end PLITYP,
-- INSTRUMENT
rtrim(pli.M_DSP_LABEL) PLILAB,
rtrim(pli.M_DESC) PLIDES,
case pli.M_FAMILY 
when   2 then gin.M_SING_CURR 
when 512 then gin.M_SING_CURR
else pli.M_CURRENCY end PLICUR,
case pli.M_FAMILY
when     1 then rtrim(seh.M_SE_D_LABEL)
when     2 then rtrim(gin.M_INSTR)
when    16 then rtrim(fxc.M_LABEL)
when    32 then rtrim(fcm.M_LABEL)
when    64 then rtrim(cur.M_LABEL)
when   256 then rtrim(ind.M_IND_LAB)
when   512 then rtrim(gin.M_INSTR)
when  2048 then rtrim(phy.M_LABEL)
when 16384 then rtrim(fcm.M_LABEL)
else null end BDYLAB,
case pli.M_FAMILY
when     1 then rtrim(seh.M_SE_D_LABEL)
when     2 then rtrim(gin.M_INSTR_DESC)
when    16 then rtrim(fxc.M_LABEL)
when    32 then rtrim(fcm.M_DESC)
when    64 then rtrim(cur.M_FULL_NAME)
when   256 then rtrim(ind.M_IND_LAB)
when   512 then rtrim(gin.M_INSTR_DESC)
when  2048 then rtrim(phy.M_DESC)
when 16384 then rtrim(fcm.M_DESC)
else null end BDYDES,
case 
when pli.M_FAMILY in (1)        then rtrim(ser.M_SE_MARKET)
when pli.M_FAMILY in (16)       then rtrim(fxc.M_MARKET)
when pli.M_FAMILY in (32,16384) then rtrim(fcmpub.M_LABEL)
when pli.M_FAMILY in (256)      then ivw.M_INDPUB
else 'OTC' end PUBLAB,
case
when pli.M_FAMILY in (1)        then rtrim(sm1.M_SE_CALEND)
when pli.M_FAMILY in (2, 512)   then rtrim(gencom.M_FIX_CLN0)
when pli.M_FAMILY in (16)       then rtrim(fxc.M_CALENDAR1)
when pli.M_FAMILY in (64)       then rtrim(cur.M_HOLCLN0)
when pli.M_FAMILY in (32,16384) then rtrim(fcmpub.M_CALENDAR)
when pli.M_FAMILY in (256)      then ivw.M_INDCAL
else null end PUBCAL,
case
when pli.M_FAMILY in (2, 512)   then rtrim(gencom.M_PAY_CLN0)
when pli.M_FAMILY in (16)       then rtrim(fxc.M_CALENDAR0)
when pli.M_FAMILY in (32,16384) then rtrim(fcmpub.M_CALENDAR)
else null end PAYCAL,
case 
when pli.M_FAMILY in (1)        then rtrim(udfmkt.M_MIC)
when pli.M_FAMILY in (2, 512)   then rtrim(altetdeqv.M_OBJ_ALBL)
when pli.M_FAMILY in (16)       then rtrim(altfxc.M_OBJ_ALBL)
when pli.M_FAMILY in (32,16384) then rtrim(altpub.M_OBJ_ALBL)
else 'OTC' end PUBMIC,
case 
when pli.M_FAMILY in (32,16384)  then rtrim(fcmorg.M_LEI)
else null end PUBLEI,
case 
when pli.M_FAMILY in (1)        then rtrim(seh.M_SE_CODE)
when pli.M_FAMILY in (2, 512)   then rtrim(altetdeqv.M_OBJ_ALT)
when pli.M_FAMILY in (16)       then rtrim(altfxc.M_OBJ_ALT)
when pli.M_FAMILY in (32,16384) then rtrim(fcmqot.M_TRAD_SMB)
else null end CNTSYM,
case
when pli.M_FAMILY in (1)        then rtrim(seh.M_SE_ISIN)
when pli.M_FAMILY in (32,16384) then rtrim(altcomurl.M_OBJ_ALBL) 
else null end CNTCOD,
case
when pli.M_FAMILY in (1) and rtrim(seh.M_SE_GROUP) ='Future' then 'LST'
when pli.M_FAMILY in (32, 16384) and fcm.M_LISTED in (1, 16, 32, 64) then 'LST'
when pli.M_FAMILY in (16) and rtrim(fxc.M_TYPE) = 'OMFUT' then 'LST'
when pli.M_FAMILY in (256) then null
else 'OTC' end LSTOTC,
case when pli.M_FAMILY in (512, 16384) then 'OPT' else 'LIN' end OPTLIN,
case
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2,9)  then case when rtrim(genswp.M_CUR0) <> rtrim(genswp.M_CUR1) then rtrim(genswp.M_CUR0)||'-'||rtrim(genswp.M_CUR1) else null end
   when gin.M_INSTR_TYPE in (12,13,27) then  
      case 
      when rtrim(pli.M_DSP_LABEL) like '%FXAVG' then 'FXAVG'
      when rtrim(gencom.M_CURRENCY0) <> rtrim(gencom.M_CURRENCY1) then rtrim(gencom.M_CURRENCY0)||'-'||rtrim(gencom.M_CURRENCY1) 
      else null end
   else null end
when pli.M_FAMILY in (16)   then rtrim(fxc.M_BASE)||'-'||rtrim(fxc.M_UNDERLNG)
when pli.M_FAMILY in (512)  then null
else null end MULCUR,
case
when pli.M_FAMILY in (1) then   null
when pli.M_FAMILY in (2,512)    then genivw0.M_UNDQOT
when pli.M_FAMILY in (16)       then rtrim(fxc.M_QUOTMODE0)
when pli.M_FAMILY in (32,16384) then rtrim(fcmqot.M_LABEL)
when pli.M_FAMILY in (256)      then ivw.M_UNDQOT
else null end PLIQOT,
case
when pli.M_FAMILY in (1)        then rtrim(ser.M_SE_CUR)
when pli.M_FAMILY in (2,512)    then rtrim(gin.M_SING_CURR)
when pli.M_FAMILY in (16)       then rtrim(fxc.M_UNDERLNG)
when pli.M_FAMILY in (32,16384) then rtrim(fcmqot.M_CURR)
when pli.M_FAMILY in (256)      then ivw.M_INDCUR
else null end CUR,
case
when pli.M_FAMILY in (1)        then null
when pli.M_FAMILY in (2,512)    then genivw0.M_INDUOQ
when pli.M_FAMILY in (16)       then rtrim(fxc.M_BASE)
when pli.M_FAMILY in (32,16384) then rtrim(fcmuoq.M_LABEL)
when pli.M_FAMILY in (256)      then ivw.M_INDUOQ
else null end UOQ,
case
when pli.M_FAMILY in (1)        then null
when pli.M_FAMILY in (2,512)    then genivw0.M_INDUOD
when pli.M_FAMILY in (16)       then rtrim(fxc.M_BASE)
when pli.M_FAMILY in (32,16384) then rtrim(fcmuod.M_LABEL)
when pli.M_FAMILY in (256)      then ivw.M_INDUOD
else null end UOD,
case
when pli.M_FAMILY in (1)        then ser.M_SE_SEC_LS0
when pli.M_FAMILY in (2,512)    then genivw0.M_LOTSIZ
when pli.M_FAMILY in (16)       then fxc.M_CNTSIZE0
when pli.M_FAMILY in (32,16384) then fcm.M_QTY
when pli.M_FAMILY in (256)      then ivw.M_LOTSIZ
else null end LOTSIZ,
case 
when pli.M_FAMILY in (32) and fcm.M_LISTED = 64 then
   case fcm.M_OEXR_STYLE
   when 0 then 'EUR'
   when 1 then 'AMR' else null end
when pli.M_FAMILY in (512) then 'ASN'
when pli.M_FAMILY in (16384) then
   case fcm.M_LISTED
   when  32 then 'ASN'
   when  64 then 
      case fcm.M_OEXR_STYLE
      when 0 then 'EUR'
      when 1 then 'AMR' else null end    
   else null end 
else null end OPTSTY,
case
when fcm.M_LISTED = 64 then
   case fcm.M_OP_OTCZDAT
   when 0 then 'EQT'
   when 1 then 'FUT' end 
else null end PRMSTY, 
case
when pli.M_FAMILY in (1) then rtrim(sen.M_LABEL)
when pli.M_FAMILY in (2, 512) then
   case
   when gencom.M_SETTLE0 = 0 then 'Cash'
   when gencom.M_SETTLE0 = 1 then 'Phy.dlv'
   when gencom.M_SETTLE0 = 2 then 'Fin.dlv' else null end
when pli.M_FAMILY in (32, 16384) then fcmviw.M_EXR
else null end EXRMOD,
case when pli.M_FAMILY in (32, 16384) then rtrim(fcmudf.M_EXRMOD) else null end EXRMKT,
case 
when pli.M_FAMILY in (32, 16384) then fcmviw.M_MC else null end MC,
-- Underlying instrument
case
when pli.M_FAMILY in (1) then
   case rtrim(seh.M_SE_GROUP)
   when 'Bond' then 'Generator'
   when 'Future' then
      case rtrim(seh.M_SE_CATE)
      when 'Bond' then 'Bond'
      when 'Rate' then 
         case feq.M_FU_MODE 
         when 0 then 'Index'
         when 1 then 'Generator'
         when 2 then 'Generator'
         else null end
      when 'Equity' then 'Equity'
      when 'Volatility' then 'Volatility'
      else null end
   when 'Equity' then 'Equity'
   else null end
when pli.M_FAMILY in  (2) then 
   case gin.M_INSTR_TYPE
   when  0 then 'Index'
   when  1 then 'Bond'
   when  2 then 'Index'
   when 12 then 'Index'
   when 13 then 'Index'
   when 27 then 'Physical'
   else null end
when pli.M_FAMILY in (16) then 'Currency' 
when pli.M_FAMILY in (32) then 
   case fcmviw.M_CFGMOD
   when 'Simple' then 'Index'
   when 'Custom' then 'Generator' 
   else null end
when pli.M_FAMILY in   (256) then 'Index'
when pli.M_FAMILY in   (512) then 'Index'
when pli.M_FAMILY in  (2048) then 'Physical'
when pli.M_FAMILY in (16384) then
   case fcm.M_LISTED
   when  32 then 'Generator'
   when  64 then 'Future' 
   else null end
else null end PLUNAT,
case
when pli.M_FAMILY in  (2, 512) then 
   case 
   when gin.M_INSTR_TYPE in (0,2) then 'IRI'
   when gin.M_INSTR_TYPE in (12,13) then
      case genind0.M_RESET
      when 0 then 'SPT'
      when 3 then 'AVG'
      when 4 then 'BSK'
      when 6 then 'NBY'
      else null end 
   else null end
when pli.M_FAMILY in (32) then 
   case when fcmviw.M_CFGMOD = 'Simple' then
      case fcsgenind.M_RESET
      when 0 then 'SPT'
      when 3 then 'AVG'
      when 4 then 'BSK'
      when 6 then 'NBY'
      else null end 
   else null end
else null end PLUITP,
case
when pli.M_FAMILY in (1) then
   case rtrim(seh.M_SE_GROUP)
   when 'Bond' then rtrim(ginbnd.M_INSTR)
   when 'Future' then
      case rtrim(seh.M_SE_CATE)
      when 'Bond' then rtrim(ginfeqbnd.M_INSTR)
      when 'Rate' then 
         case feq.M_FU_MODE 
         when 0 then rtrim(feq.M_FU_UNDERL)
         when 1 then rtrim(ginfeqswp.M_INSTR)
         when 2 then rtrim(ginfeqswp.M_INSTR)
         else null end
      when'Equity' then rtrim(feqund.M_SE_D_LABEL)
      else null end
   else null end
when pli.M_FAMILY in (32, 16384) then fcmviw.M_INSTRUMENT
else null end PLUPLI,
case
when pli.M_FAMILY in (1) then coalesce(rtrim(genbnd.M_SCH0), rtrim(genfeqbnd.M_SCH0), rtrim(genfeqswp.M_SCH0))
when pli.M_FAMILY in (2,512)    then rtrim(genswp.M_SCH0) 
when pli.M_FAMILY in (32,16384) then rtrim(fcmudf.M_OBS) 
else null end OBS,
case
when pli.M_FAMILY in (1) and rtrim(seh.M_SE_CATE) = 'Bond' then to_char(feq.M_FU_LEN)
when pli.M_FAMILY in (1) and rtrim(seh.M_SE_CATE) = 'Swap' then substr(feq.M_FU_SWAP_MATURITY,1,2)
when pli.M_FAMILY in (1) and rtrim(seh.M_SE_CATE) = 'Rate' then to_char(feqsch.M_DEF_FREQ)
when pli.M_FAMILY in (32,16384) then rtrim(fcmudf.M_MATCAST) 
else null end MATCAS,
case when pli.M_FAMILY in (32,16384) then coalesce(rtrim(fcmviw.M_VINFLT),'.') else '.' end VIN,
-- Indices
case pli.M_FAMILY
when     1 then coalesce(rtrim(genbnd.M_LEGPAT), rtrim(genfeqbnd.M_LEGPAT), rtrim(genfeqswp.M_LEGPAT), 'Fix')
when     2 then rtrim(genswp.M_LEGPAT)
when     4 then null
when    16 then 'Flt-Flt'
when    32 then 'Flt-Fix'
when    64 then null
when   256 then 'Flt'
when   512 then 'Flt-Fix'
when  2048 then 'Flt'
when 16384 then 'Flt-Fix' 
else null end as LEGPAT,
-- LEG 0
-- Currency
case
when pli.M_FAMILY in (1) then rtrim(ser.M_SE_CUR)
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then rtrim(genswp.M_CUR0)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(gencom.M_CURRENCY0)
   else null end
when pli.M_FAMILY in (16)   then rtrim(fxc.M_UNDERLNG)
when pli.M_FAMILY in (32, 16384) then rtrim(fcmqot.M_CURR)
when pli.M_FAMILY in (256)  then rtrim(ivw.M_INDCUR)
when pli.M_FAMILY in (512)  then rtrim(gencom.M_CURRENCY0)
when pli.M_FAMILY in (2048) then rtrim(phyivw.M_INDCUR)
else null end LEGCUR0,
-- Index
case
when pli.M_FAMILY in (1) then
   case 
   when rtrim(seh.M_SE_CATE) = 'Bond' then rtrim(genfeqbnd.M_INDTYP0)
   when rtrim(seh.M_SE_CATE) = 'Rate' then 
      case feq.M_FU_MODE 
      when 0 then 
         case indfeqswp.M_RESET
         when 0 then 'SPT'
         when 1 then 'CMP'
         else null end
      when 1 then rtrim(genfeqswp.M_INDTYP0)
      else null end
   else null end
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2) then rtrim(genswp.M_INDTYP0)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw0.M_INDTYP)
   else null end
when pli.M_FAMILY in (32)    then coalesce(rtrim(fccgenivw.M_INDTYP),rtrim(fcsgenivw.M_INDTYP))
when pli.M_FAMILY in (256)   then rtrim(ivw.M_INDTYP)
when pli.M_FAMILY in (512)   then rtrim(genivw0.M_INDTYP)
when pli.M_FAMILY in (2048)  then 'PHY'
when pli.M_FAMILY in (16384) then coalesce(rtrim(fccgenivw.M_INDTYP),rtrim(ofcfccgenivw.M_INDTYP),rtrim(ofcfcsgenivw.M_INDTYP))
else null end INDTYP0,
case
when pli.M_FAMILY in (1) then 
   case 
   when rtrim(seh.M_SE_CATE) = 'Bond' then rtrim(genfeqbnd.M_INDLAB0)
   when rtrim(seh.M_SE_CATE) = 'Rate' then 
      case feq.M_FU_MODE 
      when 0 then rtrim(indfeqswp.M_IND_LAB)
      when 1 then rtrim(genfeqswp.M_INDLAB0)
      else null end
   else null end
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2) then rtrim(genswp.M_INDLAB0)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw0.M_INDLAB)
   else null end
when pli.M_FAMILY in (32)    then 
   case fcm.M_INS_MODE
   when 0 then rtrim(fccgenivw.M_INDLAB)
   when 1 then rtrim(fcsgenivw.M_INDLAB) else null end
when pli.M_FAMILY in   (256) then rtrim(ivw.M_INDLAB)
when pli.M_FAMILY in   (512) then rtrim(genivw0.M_INDLAB)
when pli.M_FAMILY in  (2048) then rtrim(phyivw.M_INDLAB)
when pli.M_FAMILY in (16384) then 
   case fcm.M_LISTED
   when 32 then rtrim(fccgenivw.M_INDLAB)
   when 64 then coalesce(rtrim(ofcfccgenivw.M_INDLAB), rtrim(ofcfcsgenivw.M_INDLAB)) else null end
else null end INDLAB0,
case
when pli.M_FAMILY in (1)     then rtrim(iss.M_DSP_LABEL)
when pli.M_FAMILY in (2,512) then rtrim(genivw0.M_INDPUB)
when pli.M_FAMILY in (32)    then coalesce(rtrim(fccgenivw.M_INDPUB), rtrim(fcsgenivw.M_INDPUB))
when pli.M_FAMILY in (256)   then rtrim(ivw.M_INDPUB)
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_INDPUB)
when pli.M_FAMILY in (16384) then coalesce(rtrim(fccgenivw.M_INDPUB), rtrim(ofcfccgenivw.M_INDPUB), rtrim(ofcfcsgenivw.M_INDPUB))
else null end INDARC0,
case
when pli.M_FAMILY in (2,512) then rtrim(genivw0.M_INDCAL)
when pli.M_FAMILY in (32)    then coalesce(rtrim(fccgenivw.M_INDCAL), rtrim(fcsgenivw.M_INDCAL))
when pli.M_FAMILY in (256)   then rtrim(ivw.M_INDCAL)
when pli.M_FAMILY in (16384) then coalesce(rtrim(fccgenivw.M_INDCAL), rtrim(ofcfccgenivw.M_INDCAL), rtrim(ofcfcsgenivw.M_INDCAL))
else null end INDCAL0,
case
when pli.M_FAMILY in (2,512) then rtrim(genivw0.M_OBSFRQ)
when pli.M_FAMILY in (32)    then coalesce(rtrim(fccgenivw.M_OBSFRQ), rtrim(fcsgenivw.M_OBSFRQ))
when pli.M_FAMILY in (256)   then rtrim(ivw.M_OBSFRQ)
when pli.M_FAMILY in (16384) then coalesce(rtrim(fccgenivw.M_OBSFRQ), rtrim(ofcfccgenivw.M_OBSFRQ), rtrim(ofcfcsgenivw.M_OBSFRQ))
else null end OBSFRQ0,
case
when pli.M_FAMILY in (2,512) then rtrim(genivw0.M_OBSCAL)
when pli.M_FAMILY in (32)    then coalesce(rtrim(fccgenivw.M_OBSCAL), rtrim(fcsgenivw.M_OBSCAL))
when pli.M_FAMILY in (256)   then rtrim(ivw.M_OBSCAL)
when pli.M_FAMILY in (16384) then coalesce(rtrim(fccgenivw.M_OBSCAL), rtrim(ofcfccgenivw.M_OBSCAL), rtrim(ofcfcsgenivw.M_OBSCAL))
else null end OBSCAL0,
case
when pli.M_FAMILY in (2,512) then rtrim(genivw0.M_RNDRUL)
when pli.M_FAMILY in (32)    then coalesce(rtrim(fccgenivw.M_RNDRUL), rtrim(fcsgenivw.M_RNDRUL))
when pli.M_FAMILY in (256)   then rtrim(ivw.M_RNDRUL)
when pli.M_FAMILY in (16384) then coalesce(rtrim(fccgenivw.M_RNDRUL), rtrim(ofcfccgenivw.M_RNDRUL), rtrim(ofcfcsgenivw.M_RNDRUL))
else null end RNDRUL0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_RNDDEC
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_RNDDEC, fcsgenivw.M_RNDDEC)
when pli.M_FAMILY in (256)   then ivw.M_RNDDEC
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_RNDDEC, ofcfccgenivw.M_RNDDEC, ofcfcsgenivw.M_RNDDEC)
else null end RNDDEC0,
-- Underlying
case
when pli.M_FAMILY in (2,512) then genivw0.M_UNDTYP
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_UNDTYP, fcsgenivw.M_UNDTYP)
when pli.M_FAMILY in (256)   then ivw.M_UNDTYP
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDTYP, ofcfccgenivw.M_UNDTYP, ofcfcsgenivw.M_UNDTYP)
else null end UNDTYP0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_UNDLAB
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_UNDLAB, fcsgenivw.M_UNDLAB)
when pli.M_FAMILY in (256)   then ivw.M_UNDLAB
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDLAB, ofcfccgenivw.M_UNDLAB, ofcfcsgenivw.M_UNDLAB)
else null end UNDLAB0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_UNDQOT
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_UNDQOT, fcsgenivw.M_UNDQOT)
when pli.M_FAMILY in (256)   then ivw.M_UNDQOT
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDQOT, ofcfccgenivw.M_UNDQOT, ofcfcsgenivw.M_UNDQOT)
else null end UNDQOT0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_UNDPUB
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_UNDPUB, fcsgenivw.M_UNDPUB)
when pli.M_FAMILY in (256)   then ivw.M_UNDPUB
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDPUB, ofcfccgenivw.M_UNDPUB, ofcfcsgenivw.M_UNDPUB)
else null end UNDARC0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_UNDCAL
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_UNDCAL, fcsgenivw.M_UNDCAL)
when pli.M_FAMILY in (256)   then ivw.M_UNDCAL
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDCAL, ofcfccgenivw.M_UNDCAL, ofcfcsgenivw.M_UNDCAL)
else null end UNDCAL0,
case
when pli.M_FAMILY in (2,512) then coalesce(rtrim(genhsr0.M_LABEL), genivw0.M_UNDHSR)
when pli.M_FAMILY in (32)    then coalesce(fcmviw.M_UNDHSR, fccgenivw.M_UNDHSR, fcsgenivw.M_UNDHSR)
when pli.M_FAMILY in (256)   then ivw.M_UNDHSR
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDHSR, ofcfccgenivw.M_UNDHSR, ofcfcsgenivw.M_UNDHSR)
else null end UNDHSR0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKINDLAB1
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKINDLAB1, fcsgenivw.M_BSKINDLAB1)
when pli.M_FAMILY in (256)   then ivw.M_BSKINDLAB1
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKINDLAB1, ofcfccgenivw.M_BSKINDLAB1, ofcfcsgenivw.M_BSKINDLAB1)
else null end BSKINDLAB01,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKINDHSR1
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKINDHSR1, fcsgenivw.M_BSKINDHSR1)
when pli.M_FAMILY in (256)   then ivw.M_BSKINDHSR1
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKINDHSR1, ofcfccgenivw.M_BSKINDHSR1, ofcfcsgenivw.M_BSKINDHSR1)
else null end BSKINDHSR01,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKRNDRUL1
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKRNDRUL1, fcsgenivw.M_BSKRNDRUL1)
when pli.M_FAMILY in (256)   then ivw.M_BSKRNDRUL1
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKRNDRUL1, ofcfccgenivw.M_BSKRNDRUL1, ofcfcsgenivw.M_BSKRNDRUL1)
else null end BSKRNDRUL01,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKRNDDEC1
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKRNDDEC1, fcsgenivw.M_BSKRNDDEC1)
when pli.M_FAMILY in (256)   then ivw.M_BSKRNDDEC1
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKRNDDEC1, ofcfccgenivw.M_BSKRNDDEC1, ofcfcsgenivw.M_BSKRNDDEC1)
else null end BSKRNDDEC01,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKINDLAB2
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKINDLAB2, fcsgenivw.M_BSKINDLAB2)
when pli.M_FAMILY in (256)   then ivw.M_BSKINDLAB2
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKINDLAB2, ofcfccgenivw.M_BSKINDLAB2, ofcfcsgenivw.M_BSKINDLAB2)
else null end BSKINDLAB02,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKINDHSR2
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKINDHSR2, fcsgenivw.M_BSKINDHSR2)
when pli.M_FAMILY in (256)   then ivw.M_BSKINDHSR2
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKINDHSR2, ofcfccgenivw.M_BSKINDHSR2, ofcfcsgenivw.M_BSKINDHSR2)
else null end BSKINDHSR02,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKRNDRUL2
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKRNDRUL2, fcsgenivw.M_BSKRNDRUL2)
when pli.M_FAMILY in (256)   then ivw.M_BSKRNDRUL2
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKRNDRUL2, ofcfccgenivw.M_BSKRNDRUL2, ofcfcsgenivw.M_BSKRNDRUL2)
else null end BSKRNDRUL02,
case
when pli.M_FAMILY in (2,512) then genivw0.M_BSKRNDDEC2
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_BSKRNDDEC2, fcsgenivw.M_BSKRNDDEC2)
when pli.M_FAMILY in (256)   then ivw.M_BSKRNDDEC2
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_BSKRNDDEC2, ofcfccgenivw.M_BSKRNDDEC2, ofcfcsgenivw.M_BSKRNDDEC2)
else null end BSKRNDDEC02,
-- LEG 1 (float-float)
-- Currency
case
when pli.M_FAMILY in (1) then rtrim(ser.M_SE_CUR)
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then rtrim(genswp.M_CUR1)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(gencom.M_CURRENCY1)
   else null end
when pli.M_FAMILY in (16)   then rtrim(fxc.M_BASE)
when pli.M_FAMILY in (512)  then rtrim(gencom.M_CURRENCY1)
else null end LEGCUR1,
-- Index
case
when pli.M_FAMILY in (1) then
   case 
   when rtrim(seh.M_SE_CATE) = 'Bond' then rtrim(genfeqbnd.M_INDTYP1)
   when rtrim(seh.M_SE_CATE) = 'Rate' then rtrim(genfeqswp.M_INDTYP1)
   else null end
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2) then rtrim(genswp.M_INDTYP1)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw1.M_INDTYP)
   else null end
else null end INDTYP1,
case
when pli.M_FAMILY in (1) then
   case 
   when rtrim(seh.M_SE_CATE) = 'Bond' then rtrim(genfeqbnd.M_INDLAB1)
   when rtrim(seh.M_SE_CATE) = 'Rate' then rtrim(genfeqswp.M_INDLAB1)
   else null end
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2) then rtrim(genswp.M_INDLAB1)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw1.M_INDLAB)
   else null end
else null end INDLAB1,
case
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2) then null
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw1.M_INDPUB)
   else null end
else null end INDARC1,
case
when pli.M_FAMILY in (2) then 
   case 
   when gin.M_INSTR_TYPE in (0,1,2) then null
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw1.M_INDCAL)
   else null end
else null end INDCAL1,
case when pli.M_FAMILY in (2) then rtrim(genivw1.M_OBSFRQ) else null end OBSFRQ1,
case when pli.M_FAMILY in (2) then rtrim(genivw1.M_OBSCAL) else null end OBSCAL1,
case when pli.M_FAMILY in (2) then rtrim(genivw1.M_RNDRUL) else null end RNDRUL1,
case when pli.M_FAMILY in (2) then genivw1.M_RNDDEC        else null end RNDDEC1,
-- Underlying
case when pli.M_FAMILY in (2) and gin.M_INSTR_TYPE in (13,27) then rtrim(genivw1.M_UNDTYP) else null end UNDTYP1,
case when pli.M_FAMILY in (2) and gin.M_INSTR_TYPE in (13,27) then rtrim(genivw1.M_UNDLAB) else null end UNDLAB1,
case when pli.M_FAMILY in (2) and gin.M_INSTR_TYPE in (13,27) then rtrim(genivw1.M_UNDQOT) else null end UNDQOT1,
case when pli.M_FAMILY in (2) and gin.M_INSTR_TYPE in (13,27) then rtrim(genivw1.M_UNDPUB) else null end UNDARC1,
case when pli.M_FAMILY in (2) and gin.M_INSTR_TYPE in (13,27) then rtrim(genivw1.M_UNDCAL) else null end UNDCAL1,
case when pli.M_FAMILY in (2) and gin.M_INSTR_TYPE in (13,27) then rtrim(genivw1.M_UNDHSR) else null end UNDHSR1,
-- ROOTS
case
when pli.M_FAMILY in (2,512) then genivw0.M_ROTICM0
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTICM0, fcsgenivw.M_ROTICM0)
when pli.M_FAMILY in (256)   then ivw.M_ROTICM0
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTICM0)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTICM0, ofcfccgenivw.M_ROTICM0, ofcfcsgenivw.M_ROTICM0)
else null end ROTICM0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_ROTQOT0
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTQOT0, fcsgenivw.M_ROTQOT0)
when pli.M_FAMILY in (256)   then ivw.M_ROTQOT0
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTQOT0)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTQOT0, ofcfccgenivw.M_ROTQOT0, ofcfcsgenivw.M_ROTQOT0)
else null end ROTQOT0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_ROTPUB0
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTPUB0, fcsgenivw.M_ROTPUB0)
when pli.M_FAMILY in (256)   then ivw.M_ROTPUB0
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTPUB0)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTPUB0, ofcfccgenivw.M_ROTPUB0, ofcfcsgenivw.M_ROTPUB0)
else null end ROTPUB0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_ROTSYM0
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTSYM0, fcsgenivw.M_ROTSYM0)
when pli.M_FAMILY in (256)   then ivw.M_ROTSYM0
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTSYM0)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTSYM0, ofcfccgenivw.M_ROTSYM0, ofcfcsgenivw.M_ROTSYM0)
else null end ROTSYM0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_ROTHSR0
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTHSR0, fcsgenivw.M_ROTHSR0)
when pli.M_FAMILY in (256)   then ivw.M_ROTHSR0
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTHSR0)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTHSR0, ofcfccgenivw.M_ROTHSR0, ofcfcsgenivw.M_ROTHSR0)
else null end ROTHSR0,
case
when pli.M_FAMILY in (2,512) then genivw0.M_ROTCAL0
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTCAL0, fcsgenivw.M_ROTCAL0)
when pli.M_FAMILY in (256)   then ivw.M_ROTCAL0
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTCAL0)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTCAL0, ofcfccgenivw.M_ROTCAL0, ofcfcsgenivw.M_ROTCAL0)
else null end ROTCAL0,
case
when pli.M_FAMILY in (2,512) then coalesce(rtrim(genivw0.M_ROTICM1), rtrim(genivw1.M_ROTICM0))
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTICM1, fcsgenivw.M_ROTICM1)
when pli.M_FAMILY in (256)   then ivw.M_ROTICM1
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTICM1)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTICM1, ofcfccgenivw.M_ROTICM1, ofcfcsgenivw.M_ROTICM1)
else null end ROTICM1,
case
when pli.M_FAMILY in (2,512) then coalesce(rtrim(genivw0.M_ROTQOT1), rtrim(genivw1.M_ROTQOT0))
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTQOT1, fcsgenivw.M_ROTQOT1)
when pli.M_FAMILY in (256)   then ivw.M_ROTQOT1
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTQOT1)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTQOT1, ofcfccgenivw.M_ROTQOT1, ofcfcsgenivw.M_ROTQOT1)
else null end ROTQOT1,
case
when pli.M_FAMILY in (2,512) then coalesce(rtrim(genivw0.M_ROTPUB1), rtrim(genivw1.M_ROTPUB0))
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTPUB1, fcsgenivw.M_ROTPUB1)
when pli.M_FAMILY in (256)   then ivw.M_ROTPUB1
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTPUB1)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTPUB1, ofcfccgenivw.M_ROTPUB1, ofcfcsgenivw.M_ROTPUB1)
else null end ROTPUB1,
case
when pli.M_FAMILY in (2,512) then coalesce(rtrim(genivw1.M_ROTSYM0),rtrim(genivw0.M_ROTSYM1))
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTSYM1, fcsgenivw.M_ROTSYM1)
when pli.M_FAMILY in (256)   then ivw.M_ROTSYM1
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTSYM1)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTSYM1, ofcfccgenivw.M_ROTSYM1, ofcfcsgenivw.M_ROTSYM1)
else null end ROTSYM1,
case
when pli.M_FAMILY in (2,512) then coalesce(rtrim(genivw1.M_ROTHSR0),rtrim(genivw0.M_ROTHSR1))
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTHSR1, fcsgenivw.M_ROTHSR1)
when pli.M_FAMILY in (256)   then ivw.M_ROTHSR1
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTHSR1)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTHSR1, ofcfccgenivw.M_ROTHSR1, ofcfcsgenivw.M_ROTHSR1)
else null end ROTHSR1,
case
when pli.M_FAMILY in (2,512) then coalesce(rtrim(genivw1.M_ROTCAL0),rtrim(genivw0.M_ROTCAL1))
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_ROTCAL1, fcsgenivw.M_ROTCAL1)
when pli.M_FAMILY in (256)   then ivw.M_ROTCAL1
when pli.M_FAMILY in (2048)  then rtrim(phyivw.M_ROTCAL1)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_ROTCAL1, ofcfccgenivw.M_ROTCAL1, ofcfcsgenivw.M_ROTCAL1)
else null end ROTCAL1,
-- DELIVERY
case
when pli.M_FAMILY in (1)     then rtrim(sct.M_LABEL)
when pli.M_FAMILY in (2,512) then genivw0.M_PHYLAB
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_PHYLAB, fcsgenivw.M_PHYLAB)
when pli.M_FAMILY in (256)   then ivw.M_PHYLAB
when pli.M_FAMILY in (2048)  then rtrim(phy.M_LABEL)
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_PHYLAB, ofcfccgenivw.M_PHYLAB, ofcfcsgenivw.M_PHYLAB)
else null end PHYLAB,
case
when pli.M_FAMILY in (1)     then rtrim(cou.M_COUNTRY)
when pli.M_FAMILY in (2,512) then genivw0.M_LOCLAB
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_LOCLAB, fcsgenivw.M_LOCLAB)
when pli.M_FAMILY in (256)   then ivw.M_LOCLAB
when pli.M_FAMILY in (2048)  then phyivw.M_LOCLAB
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_LOCLAB, ofcfccgenivw.M_LOCLAB, ofcfcsgenivw.M_LOCLAB)
else null end LOCLAB,
rtrim(prflst.M_LABEL) PRFLST,
-- UID
pli.M_REFERENCE PLIREF,
pli.M_FAMILY    FMLUID,
pli.M_ID        PLIUID,
case pli.M_FAMILY
when     1 then ser.M_REFERENCE
when     2 then gin.M_GEN_NUM
when     4 then null
when    16 then fxc.M_ID
when    32 then fcm.M_REFERENCE
when    64 then cur.M_REFERENCE
when   256 then ind.M_REFERENCE
when   512 then gin.M_GEN_NUM
when  2048 then phy.M_REFERENCE
when 16384 then fcm.M_REFERENCE else null end BDYUID,
case 
when pli.M_FAMILY in (1)        then ser.M_REFERENCE
when pli.M_FAMILY in (16)       then fxc.M_ID
when pli.M_FAMILY in (32,16384) then fcmpub.M_REFERENCE
when pli.M_FAMILY in (256)      then 
   case 
   when ind.M_CATEGORY = 8 and ind.M_RESET in (0,6) then indpub.M_REFERENCE
   when ind.M_CATEGORY = 8 and ind.M_RESET in (3,4) then indpub.M_REFERENCE else null end
else 659 end PUBUID,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then rtrim(genswp.M_INDNDX0)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw0.M_INDNDX)
   else null end
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_INDNDX, fcsgenivw.M_INDNDX)
when pli.M_FAMILY in (256)   then ivw.M_INDNDX
when pli.M_FAMILY in (512)   then genivw0.M_INDNDX
when pli.M_FAMILY in (2048)  then phyivw.M_INDNDX
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_INDNDX, ofcfccgenivw.M_INDNDX, ofcfcsgenivw.M_INDNDX)
else null end INDNDX0,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then genswp.M_INDUID0
   when gin.M_INSTR_TYPE in (12,13,27) then genivw0.M_INDUID
   else null end
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_INDUID, fcsgenivw.M_INDUID)
when pli.M_FAMILY in (256)   then ivw.M_INDUID
when pli.M_FAMILY in (512)   then genivw0.M_INDUID
when pli.M_FAMILY in (2048)  then phyivw.M_INDUID
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_INDUID, ofcfccgenivw.M_INDUID, ofcfcsgenivw.M_INDUID)
else null end INDUID0,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then rtrim(genswp.M_INDNDX0)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw0.M_UNDNDX)
   else null end
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_UNDNDX, fcsgenivw.M_UNDNDX)
when pli.M_FAMILY in (256)   then ivw.M_UNDNDX
when pli.M_FAMILY in (512)   then genivw0.M_UNDNDX
when pli.M_FAMILY in (2048)  then phyivw.M_INDNDX
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDNDX, ofcfccgenivw.M_UNDNDX, ofcfcsgenivw.M_UNDNDX)
else null end UNDNDX0,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then genswp.M_INDUID0
   when gin.M_INSTR_TYPE in (12,13,27) then genivw0.M_UNDUID
   else null end
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_UNDUID, fcsgenivw.M_UNDUID)
when pli.M_FAMILY in (256)   then ivw.M_UNDUID
when pli.M_FAMILY in (512)   then genivw0.M_UNDUID
when pli.M_FAMILY in (2048)  then phyivw.M_INDUID
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_UNDUID, ofcfccgenivw.M_UNDUID, ofcfcsgenivw.M_UNDUID)
else null end UNDUID0,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then rtrim(genswp.M_INDNDX1)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw1.M_INDNDX)
   else null end
else null end INDNDX1,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then genswp.M_INDUID1
   when gin.M_INSTR_TYPE in (12,13,27) then genivw1.M_INDUID
   else null end
else null end INDUID1,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then rtrim(genswp.M_UNDNDX1)
   when gin.M_INSTR_TYPE in (12,13,27) then rtrim(genivw1.M_UNDNDX)
   else null end
when pli.M_FAMILY in (512)   then genivw1.M_UNDNDX
else null end UNDNDX1,
case
when pli.M_FAMILY in (2) then
   case 
   when gin.M_INSTR_TYPE in (0,1,2)    then genswp.M_UNDUID1
   when gin.M_INSTR_TYPE in (12,13,27) then genivw1.M_UNDUID
   else null end
when pli.M_FAMILY in (512)   then genivw1.M_UNDUID
else null end UNDUID1,
case
when pli.M_FAMILY in (1)     then sct.M_REFERENCE
when pli.M_FAMILY in (2,512) then genivw0.M_PHYUID
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_PHYUID, fcsgenivw.M_PHYUID)
when pli.M_FAMILY in (256)   then ivw.M_PHYUID
when pli.M_FAMILY in (2048)  then phy.M_REFERENCE
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_PHYUID, ofcfccgenivw.M_PHYUID, ofcfcsgenivw.M_PHYUID)
else null end PHYUID,
case
when pli.M_FAMILY in (1)     then cou.M_REFERENCE
when pli.M_FAMILY in (2,512) then genivw0.M_LOCUID
when pli.M_FAMILY in (32)    then coalesce(fccgenivw.M_LOCUID, fcsgenivw.M_LOCUID)
when pli.M_FAMILY in (256)   then ivw.M_LOCUID
when pli.M_FAMILY in (16384) then coalesce(fccgenivw.M_LOCUID, ofcfccgenivw.M_LOCUID, ofcfcsgenivw.M_LOCUID)
else null end LOCUID,
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
case
when pli.M_FAMILY in (1)     then coalesce(rtrim(seh.M_SE_T_SH), rtrim(altsecurl.M_OBJ_ALT))
when pli.M_FAMILY in (16) and rtrim(fxc.M_TYPE) = 'OMFUT' then rtrim(altfxdurl.M_OBJ_ALT)
when pli.M_FAMILY in (32)    then rtrim(altcomurl.M_OBJ_ALT)
when pli.M_FAMILY in (16384) then rtrim(altcomurl.M_OBJ_ALT)
else null end CNTURL

from TRN_PLIN_DBF pli
cross join (select M_DATE from TRN_PC_DBF where ROWNUM = 1) pc
-- Equity
left join SE_ROOT_DBF  ser on rtrim(pli.M_LABEL) = rtrim(ser.M_SE_LABEL) and pli.M_FAMILY in (1) and ser.M_SE_DE <> 'Y'
left join SE_HEAD_DBF  seh on rtrim(ser.M_SE_LABEL) = rtrim(seh.M_SE_LABEL)
left join TRN_CPDF_DBF iss on to_number(rtrim(seh.M_SE_ISS)) = iss.M_ID
left join CSF_FOLDER_DBF sct on seh.M_SE_SECTOR = sct.M_REFERENCE
left join CR_CTRY_DBF  cou on seh.M_SE_COUNTRY = cou.M_REFERENCE
left join RT_SEN_DBF   sen on seh.M_SE_SEN = sen.M_REFERENCE
left join SE_MKTOP_DBF sem on ser.M_SE_LABEL = sem.M_SE_LABEL
left join SE_MKT1_DBF  sm1 on ser.M_SE_MARKET = sm1.M_SE_MARKET
left join TABLE#DATA#MARKET_DBF udfmkt on rtrim(sm1.M_SE_MARKET) = rtrim(udfmkt.M_SE_MARKET)
left join BD_BOND_DBF  bnd on sem.M_SE_INUM = bnd.M_BD_INUM
left join RT_INSGN_DBF ginbnd on bnd.M_BD_GEN = ginbnd.M_GEN_NUM
left join VIW_GEN_DBF  genbnd on ginbnd.M_GEN_NUM = genbnd.M_GENUID
left join FU_FUT_DBF   feq on sem.M_SE_INUM = feq.M_FU_INUM
left join DAT_ECH_DBF  feqsch on feq.M_FU_PERIOD = feqsch.M_LABEL
left join SE_HEAD_DBF  feqund on feq.M_FU_UNDERL = feqund.M_SE_LABEL
left join RT_INSGN_DBF ginfeqbnd on feq.M_FU_BD_GEN = ginfeqbnd.M_GEN_NUM
left join VIW_GEN_DBF  genfeqbnd on ginfeqbnd.M_GEN_NUM = genfeqbnd.M_GENUID
left join RT_INSGN_DBF ginfeqswp on feq.M_FU_GEN = ginfeqswp.M_GEN_NUM
left join VIW_GEN_DBF  genfeqswp on ginfeqswp.M_GEN_NUM = genfeqswp.M_GENUID and feq.M_FU_MODE in (1,2)
left join RT_INDEX_DBF indfeqswp on rtrim(feq.M_FU_UNDERL) = rtrim(indfeqswp.M_INDEX) and feq.M_FU_MODE = 0
-- Swap
left join RT_INSGN_DBF gin on rtrim(pli.M_LABEL) = to_char(gin.M_GEN_NUM) and pli.M_FAMILY in (2,512)
left join VIW_GEN_DBF  genswp on gin.M_GEN_NUM = genswp.M_GENUID
-- Forex
left join FX_CNT_DBF   fxc on rtrim(pli.M_LABEL) = rtrim(fxc.M_LABEL) and pli.M_FAMILY in (16)
left join FX_CURR_DBF  cur on rtrim(pli.M_LABEL) = rtrim(cur.M_LABEL) and pli.M_FAMILY in (64)
-- CM Generator
left join RT_LNGN_DBF  gencom on gin.M_GEN_NUM = gencom.M_GEN_NUM
left join RT_INDEX_DBF genind0 on rtrim(gencom.M_INDEX0) = rtrim(genind0.M_INDEX)
left join CM_ASSET_DBF genass on to_number(ltrim(genind0.M_RT_SELAB)) = genass.M_REFERENCE
left join CM_ATYPE_DBF genatp on genass.M_TYPE = genatp.M_REFERENCE
left join VIW_ICMALL_DBF genivw0 on genind0.M_REFERENCE = genivw0.M_INDUID 
left join TABLE#DATA#INDEXES_DBF genindudf0 on (genind0.M_INDEX = genindudf0.M_INDEX and genindudf0.M_LOT <> 0)
left join CM_MKTSR_DBF genhsr0 on rtrim(substr(gencom.M_FORMULA0,2,10)) = rtrim(to_char(genhsr0.M_SERIE))
left join RT_INDEX_DBF genind1 on rtrim(gencom.M_INDEX1) = rtrim(genind1.M_INDEX)
left join VIW_ICMALL_DBF genivw1 on genind1.M_REFERENCE = genivw1.M_INDUID
-- CM Listed contracts
left join CM_FUT_DBF   fcm on (rtrim(substr(pli.M_LABEL,9,4)) = to_char(fcm.M_REFERENCE) and pli.M_FAMILY in (32, 16384))
left join CMC_QUOT_DBF fcmqot on fcm.M_QUOT_FWD = fcmqot.M_REFERENCE
left join CM_MKT_DBF   fcmpub on fcmqot.M_PUBLI = fcmpub.M_REFERENCE
left join TRN_CPDF_DBF fcmorg on fcmpub.M_PUBLISHER = fcmorg.M_ID
left join CM_UNIT_DBF  fcmuoq on fcmqot.M_UNIT = fcmuoq.M_REFERENCE
left join CM_UNIT_DBF  fcmuod on fcmqot.M_QTY_UNIT = fcmuod.M_REFERENCE
left join CM_ASSET_DBF fcmass on fcm.M_ASSET = fcmass.M_REFERENCE
left join CM_ATYPE_DBF fcmatp on fcmass.M_TYPE = fcmatp.M_REFERENCE
left join TABLE#DATA#COMMODIT_DBF fcmudf on fcm.M_REFERENCE = fcmudf.M_REFERENCE
left join CM_FUT_DBF   ofcfcm on fcm.M_CM_INSTR  = ofcfcm.M_REFERENCE and fcm.M_LISTED in (64)
left join CM_FUT_DBF   ofcfc2 on fcm.M_CONTRACT2 = ofcfc2.M_REFERENCE and fcm.M_LISTED in (64)
left join VIW_FCM_DBF  fcmviw on fcm.M_REFERENCE = fcmviw.M_FCMUID
-- CM Future
left join CMC_MGEN_DBF   fcsgen     on fcm.M_CM_INSTR = fcsgen.M_REFERENCE and fcm.M_LISTED in (1,2,16,32) and fcm.M_INS_MODE = 1
left join RT_INDEX_DBF   fcsgenind  on fcsgen.M_INDEX = fcsgenind.M_INDEX 
left join VIW_ICMALL_DBF fcsgenivw  on fcsgenind.M_REFERENCE = fcsgenivw.M_INDUID
left join RT_INSGN_DBF   fccgen     on (fcm.M_CM_INSTR = fccgen.M_GEN_NUM and fcm.M_LISTED in (1,2,16,32) and fcm.M_INS_MODE = 0)
left join RT_LNGN_DBF    fccgencom  on (fcm.M_CM_INSTR = fccgencom.M_GEN_NUM and fcm.M_INS_MODE = 0)
left join RT_INDEX_DBF   fccgenind  on rtrim(fccgencom.M_INDEX0) = rtrim(fccgenind.M_INDEX)
left join VIW_ICMALL_DBF fccgenivw  on fccgenind.M_REFERENCE = fccgenivw.M_INDUID  
-- CM Option on Future
left join CMC_MGEN_DBF   ofcfcsgen    on (ofcfcm.M_CM_INSTR = ofcfcsgen.M_REFERENCE and ofcfcm.M_LISTED in (1,2,16,32) and ofcfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF   ofcfcsgenind on ofcfcsgen.M_INDEX = ofcfcsgenind.M_INDEX
left join VIW_ICMALL_DBF ofcfcsgenivw on ofcfcsgenind.M_REFERENCE = ofcfcsgenivw.M_INDUID
left join RT_INSGN_DBF   ofcfccgen    on (ofcfcm.M_CM_INSTR = ofcfccgen.M_GEN_NUM and ofcfcm.M_LISTED in (1,2,16,32) and ofcfcm.M_INS_MODE = 0)
left join RT_LNGN_DBF    ofcfccgencom on (ofcfcm.M_CM_INSTR = ofcfccgencom.M_GEN_NUM and ofcfcm.M_INS_MODE = 0)
left join RT_INDEX_DBF   ofcfccgenind on rtrim(ofcfccgencom.M_INDEX0) = rtrim(ofcfccgenind.M_INDEX)
left join VIW_ICMALL_DBF ofcfccgenivw on ofcfccgenind.M_REFERENCE = ofcfccgenivw.M_INDUID
-- Indices
left join RT_INDEX_DBF ind    on pli.M_LABEL = ind.M_INDEX and pli.M_FAMILY in (256)
left join CM_INDEX_DBF icm    on ind.M_COM_IND = icm.M_REFERENCE
left join CM_ASSET_DBF indass on to_number(ltrim(ind.M_RT_SELAB)) = indass.M_REFERENCE
left join CM_ATYPE_DBF indatp on indass.M_TYPE = indatp.M_REFERENCE
left join CM_ASSET_DBF icmass on icm.M_ASSET = icmass.M_REFERENCE
left join CM_ATYPE_DBF icmatp on icmass.M_TYPE = icmatp.M_REFERENCE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT = indqot.M_REFERENCE
left join CM_MKT_DBF   indpub on indqot.M_PUBLI = indpub.M_REFERENCE
left join VIW_ICMALL_DBF ivw  on ind.M_REFERENCE = ivw.M_INDUID
-- Physical product
left join CM_PHYS_DBF  phy on rtrim(pli.M_LABEL) = rtrim(phy.M_LABEL) and pli.M_FAMILY in (2048)
left join TABLE#DATA#PRODUCTS_DBF phyudf on phy.M_REFERENCE = phyudf.M_REFERENCE
left join CM_ASSET_DBF phyass on rtrim(phyudf.M_ASSET) = rtrim(phyass.M_LABEL)
left join CM_ATYPE_DBF phyatp on phyass.M_TYPE = phyatp.M_REFERENCE
left join ASGPRDH_DBF  asgh on pc.M_DATE = asgh.M__DATE_ and rtrim(asgh.M_LABEL) = 'PRODUCT'
left join ASGPRDB_DBF  asgb on (asgh.M__INDEX_ = asgb.M__INDEX_ and phy.M_REFERENCE = asgb.M_PRODUCT and asgb.M_QUALITY = 0 and asgb.M_LOCATION = 0)
left join VIW_ICMALL_DBF phyivw on rtrim(asgb.M_INDEX) = rtrim(phyivw.M_INDNDX)
-- Alternate IDs for Listed
left join KEYMAP_STC_DBF altcomurl on fcm.M_REFERENCE = altcomurl.M_OBJ_ID and rtrim(altcomurl.M_OBJ_CLASS) in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(altcomurl.M_OBJ_ASYS,1,3)) = 'URL'
left join KEYMAP_STC_DBF altsecurl on (rtrim(ser.M_SE_MARKET)||';'||rtrim(seh.M_SE_LABEL)) = rtrim(altsecurl.M_OBJ_DESC) and rtrim(altsecurl.M_OBJ_CLASS) in ('MpKoh64522') and rtrim(substr(altsecurl.M_OBJ_ASYS,1,3)) = 'URL'
left join KEYMAP_STC_DBF altfxdurl on rtrim(fxc.M_LABEL) = rtrim(altfxdurl.M_OBJ_DESC) and rtrim(altfxdurl.M_OBJ_CLASS) in ('MCfNG53244') and rtrim(substr(altfxdurl.M_OBJ_ASYS,1,3)) = 'URL'
left join KEYMAP_STC_DBF altpub on fcmpub.M_REFERENCE = altpub.M_OBJ_ID and rtrim(altpub.M_OBJ_CLASS)  in ('MnVuQ71331') and rtrim(altpub.M_OBJ_ASYS) = 'MIC'
left join KEYMAP_STC_DBF altfxc on rtrim(fxc.M_LABEL) = rtrim(altfxc.M_OBJ_DESC) and rtrim(altfxc.M_OBJ_CLASS) in ('MCfNG53244') and rtrim(altfxc.M_OBJ_ASYS) = 'MIC'
left join KEYMAP_STC_DBF altsec on (rtrim(ser.M_SE_MARKET)||';'||rtrim(seh.M_SE_LABEL) ) = rtrim(altsec.M_OBJ_DESC) and rtrim(altsec.M_OBJ_CLASS) in ('MpKoh64522') and rtrim(altsec.M_OBJ_ASYS) = 'MIC'
left join KEYMAP_STC_DBF altetdeqv on rtrim(pli.M_LABEL) = to_char(altetdeqv.M_OBJ_ID) and pli.M_FAMILY in (2,512) and rtrim(altetdeqv.M_OBJ_CLASS) in ('MTqCB77870') and rtrim(altetdeqv.M_OBJ_ASYS) = 'ETD_EQV'
-- Preference list
left join LST_PREFV_DBF prfpli on rtrim(pli.M_DSP_LABEL) = rtrim(prfpli.M_VALUE) and prfpli.M_INDEX2 in 
(
142, --TRAF_INCL_OIL  [6]
145, --TRAF_INCL_GAS  [3,4,20]
151, --TRAF_INCL_COAL [17]
152, --TRAF_INCL_CHE  [21]
160, --TRAF_INCL_EMI  [13]
161, --TRAF_INCL_PMT  [11]
162, --TRAF_INCL_FMT  [19]
163, --TRAF_INCL_BMT  [2]
164, --TRAF_INCL_AGS  [14]
170, --TRAF_INCL_FRW  [22]
171, --TRAF_INCL_FRB  [12]
173, --TRAF_INCL_EQD  [EQD]
174, --TRAF_INCL_IRD  [IRD]
191, --TRAF_INCL_RFC  [23]
195, --TRAF_INCL_FXD  [CURR|FUT]
196, --TRAF_INCL_FXC  [CURR|FXD]
197, --TRAF_INCL_REC  [26]
201, --TRAF_INCL_CRD  [CDS]
202  --TRAF_INCL_BND  [BND]
)
left join LST_PREFH_DBF prflst on prfpli.M_INDEX2 = prflst.M_INDEX

where 1 = 1
and 
(
   pli.M_FAMILY  = 1
or (pli.M_FAMILY = 2 and gin.M_INSTR_TYPE in (0, 1, 2, 9, 12, 13, 17, 18, 20, 27)) 
or pli.M_FAMILY  = 32
or pli.M_FAMILY  = 16
-- or pli.M_FAMILY = 64
-- or (pli.M_FAMILY =  256 and ind.M_CATEGORY is not null)
or (pli.M_FAMILY =   512 and gin.M_CREAT_MODE = 0)
or (pli.M_FAMILY =  2048 and phy.M_REFERENCE is not null)
or pli.M_FAMILY  = 16384
)
and rtrim(prfpli.M_VALUE) is not null
-- and rtrim(prfpli.M_INDEX2) in (142, 145, 151, 152, 160, 161, 162, 163, 164, 170, 171, 173, 174, 191, 195, 196, 200)
-- and pli.M_REFERENCE in (select distinct trn.M_INSTRUMENT from TRN_HDR_DBF trn)
-- and rtrim(plin.M_DSP_LABEL) in ('AL EPDP CME')

order by FINASS, COMASS, PLILAB, SUBFML