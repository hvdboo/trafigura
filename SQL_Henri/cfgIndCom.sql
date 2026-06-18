select 
rtrim(ast.M_LABEL) ASSTYP,
rtrim(ass.M_LABEL) ASSLAB,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then 'Spot'
when 3 then 'Average' 
when 4 then 'Basket'
when 6 then 'Nearby' end 
when 9 then 'Forward' end INDTYP,
rtrim(ind.M_IND_LAB) INDLAB,
-- rtrim(fmt.M_LABEL) INDMAT,
rtrim(ind.M_IND_DESC) INDDES,
-- CUR
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then qot.M_CURR
when 3 then coalesce(rtrim(uqt.M_CURR), rtrim(und.M_CURRENCY))
when 4 then rtrim(ind.M_CURRENCY)
when 6 then rtrim(ind.M_COM_CUR) end 
when 9 then rtrim(ind.M_COM_CUR) end CUR,
-- UOM
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(qotuom.M_LABEL)
when 3 then coalesce(rtrim(uqtuom.M_LABEL), rtrim(unduom.M_LABEL))
when 4 then rtrim(uom.M_LABEL)
when 6 then rtrim(qotuom.M_LABEL) end 
when 9 then rtrim(qotuom.M_LABEL) end UOM,
-- PUBLICATION
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(pub.M_LABEL)
when 3 then rtrim(grp.M_GRP_DESC) 
when 4 then rtrim(grp.M_GRP_DESC)
when 6 then rtrim(pub.M_LABEL) end 
when 9 then rtrim(pub.M_LABEL) end INDPUB,
-- CALENDAR
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(pub.M_CALENDAR)
when 3 then rtrim(grp.M_CALENDAR) 
when 4 then rtrim(grp.M_CALENDAR)
when 6 then rtrim(pub.M_CALENDAR) end 
when 9 then rtrim(pub.M_CALENDAR) end INDCAL,
-- DEPTH
case ind.M_CATEGORY
when 8 then 
   case ind.M_RESET
   when 0 then 0
   when 3 then 
      case und.M_RESET
      when 0 then 1
      when 4 then 100
      when 6 then 3  
      else null end
   when 4 then 
      case when bskgrp.BSKELT > 1 then 100 else
         case 
         when bskind0.M_RESET = 0 then 2
         when bskind0.M_RESET = 6 then 3
         else null end
      end 
   when 6 then 2 
   else null end 
when 9 then 0 
else null end INDDEP,
-- BSK ELEMENTS
(bskgrp.BSKELT)+1 BSKELT,
-- OBSERVATION FORMULA
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then 'Spot'
when 3 then 
   case ind.M_MEAN_TYPE
   when 0 then 'Simple'
   when 1 then 'Built on weighting schedule'
   when 2 then 'Manually weighted'
   when 3 then 'Automatically weighted'
   when 4 then 'Sum'
   when 5 then 'Min'
   when 6 then 'Max'
   when 7 then 'Variance' else null end 
when 4 then 
   case ind.M_BSK_MODE
   when 0 then 'Weighted Average' 
   when 1 then 'Sum'
   when 2 then 'Multiplication'
   when 3 then 'Max'
   when 4 then 'Min'
   when 5 then 'Ratio'
   when 6 then 'Inverse' else null end
when 6 then  
   case ind.M_COM_NBY_T
   when 0 then 'Future'
   when 1 then 'Floating'
   when 2 then 'Index' else null end end 
when 9 then 'Forward' end OBSFRM,
-- OBSERVATION FREQUENCY
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then null
when 3 then rtrim(ind.M_UEI)
when 4 then rtrim(ind.M_UEI)
when 6 then 
to_char(ind.M_COM_NBY_O)||'L_'||
case ind.M_COM_NBY_R 
when 0 then 'QOTLST'
when 1 then 'NOTFST'
when 2 then 'NOTLST' 
when 3 then 'DLVFST'else null end||'_'||rtrim(ind.M_UECF) end 
when 9 then null end OBSFRQ,
-- UNDERLYING
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(icm.M_LABEL)
when 3 then coalesce(rtrim(ucm.M_LABEL), rtrim(undfccgenicm.M_LABEL), rtrim(undfcsgenicm.M_LABEL), (undfcsgenucm.M_LABEL))  
when 4 then coalesce(rtrim(bskicm0.M_LABEL), rtrim(bskucm0.M_LABEL), rtrim(bskfccgenicm0.M_LABEL), rtrim(bskfccgenucm0.M_LABEL), rtrim(bskfcsgenicm0.M_LABEL), rtrim(bskfccgenucm0.M_LABEL))
when 6 then coalesce(rtrim(fccgenicm.M_LABEL), rtrim(fcsgenicm.M_LABEL), (fcsgenucm.M_LABEL)) end 
when 9 then rtrim(fcm.M_LABEL) end UNDLAB0,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(qot.M_LABEL)
when 3 then coalesce(rtrim(uqt.M_LABEL), rtrim(undfccgenqot.M_LABEL), rtrim(undfcsgenqot.M_LABEL), rtrim(undfcsgenuqt.M_LABEL))  
when 4 then coalesce(rtrim(bskqot0.M_LABEL), rtrim(bskuqt0.M_LABEL), rtrim(bskfccgenqot0.M_LABEL), rtrim(bskfccgenuqt0.M_LABEL), rtrim(bskfcsgenqot0.M_LABEL), rtrim(bskfccgenuqt0.M_LABEL))
when 6 then coalesce(rtrim(fccgenqot.M_LABEL), rtrim(fcsgenqot.M_LABEL), (fcsgenuqt.M_LABEL)) end 
when 9 then rtrim(qot.M_LABEL) end UNDQOT0,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(qot.M_CURR)
when 3 then coalesce(rtrim(uqt.M_CURR), rtrim(undfccgenqot.M_CURR), rtrim(undfcsgenqot.M_CURR), rtrim(undfcsgenuqt.M_CURR))  
when 4 then coalesce(rtrim(bskqot0.M_CURR), rtrim(bskuqt0.M_CURR), rtrim(bskfccgenqot0.M_CURR), rtrim(bskfccgenuqt0.M_CURR), rtrim(bskfcsgenqot0.M_CURR), rtrim(bskfccgenuqt0.M_CURR))
when 6 then coalesce(rtrim(fccgenqot.M_CURR), rtrim(fcsgenqot.M_CURR), (fcsgenuqt.M_CURR)) end 
when 9 then rtrim(qot.M_CURR) end UNDCUR0,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(qotuom.M_LABEL)
when 3 then coalesce(rtrim(uqtuom.M_LABEL), rtrim(undfccgenqotuom.M_LABEL), rtrim(undfcsgenqotuom.M_LABEL), rtrim(undfcsgenuqtuom.M_LABEL))  
when 4 then coalesce(rtrim(bskqotuom0.M_LABEL), rtrim(bskuqtuom0.M_LABEL), rtrim(bskfccgenqotuom0.M_LABEL), rtrim(bskfccgenuqtuom0.M_LABEL), rtrim(bskfcsgenqotuom0.M_LABEL), rtrim(bskfccgenuqtuom0.M_LABEL))
when 6 then coalesce(rtrim(fccgenqotuom.M_LABEL), rtrim(fcsgenqotuom.M_LABEL), (fcsgenuqtuom.M_LABEL)) end 
when 9 then (qotuom.M_LABEL) end UNDUOM0,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then icm.M_LOTSIZE
when 3 then coalesce(ucm.M_LOTSIZE, undfccgenicm.M_LOTSIZE, undfcsgenicm.M_LOTSIZE, undfcsgenucm.M_LOTSIZE)  
when 4 then coalesce(bskicm0.M_LOTSIZE, bskucm0.M_LOTSIZE, bskfccgenicm0.M_LOTSIZE, bskfccgenucm0.M_LOTSIZE, bskfcsgenicm0.M_LOTSIZE, bskfccgenucm0.M_LOTSIZE)
when 6 then coalesce(fccgenicm.M_LOTSIZE, fcsgenicm.M_LOTSIZE, fcsgenucm.M_LOTSIZE) end 
when 9 then fcm.M_QTY end UNDSIZ0,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(pub.M_LABEL)
when 3 then coalesce(rtrim(uqtpub.M_LABEL), rtrim(undfccgenqotpub.M_LABEL), rtrim(undfcsgenqotpub.M_LABEL), rtrim(undfccgenuqtpub.M_LABEL), rtrim(undfcsgenuqtpub.M_LABEL))  
when 4 then coalesce(rtrim(bskqotpub0.M_LABEL), rtrim(bskuqtpub0.M_LABEL))
when 6 then coalesce(rtrim(fccgenqotpub.M_LABEL), rtrim(fcsgenqotpub.M_LABEL), (fcsgenuqtpub.M_LABEL)) end 
when 9 then rtrim(pub.M_LABEL) end UNDPUB0,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(pub.M_CALENDAR)
when 3 then coalesce(rtrim(uqtpub.M_CALENDAR), rtrim(undfccgenqotpub.M_CALENDAR), rtrim(undfcsgenqotpub.M_CALENDAR), rtrim(undfccgenuqtpub.M_CALENDAR), rtrim(undfcsgenuqtpub.M_CALENDAR))  
when 4 then coalesce(rtrim(bskqotpub0.M_CALENDAR), rtrim(bskuqtpub0.M_CALENDAR))
when 6 then coalesce(rtrim(fccgenqotpub.M_CALENDAR), rtrim(fcsgenqotpub.M_CALENDAR), (fcsgenuqtpub.M_CALENDAR)) end 
when 9 then rtrim(pub.M_CALENDAR) end UNDCAL0,
case when ind.M_CATEGORY = 8 and ind.M_RESET = 4 then
coalesce(rtrim(bskicm1.M_LABEL), rtrim(bskucm1.M_LABEL), rtrim(bskfccgenicm1.M_LABEL), rtrim(bskfccgenucm1.M_LABEL), rtrim(bskfcsgenicm1.M_LABEL), rtrim(bskfccgenucm1.M_LABEL))
else null end UNDLAB1,
-- DELIVERY
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(icmphy.M_LABEL)
when 3 then coalesce(rtrim(ucmphy.M_LABEL), rtrim(undfccgenicmphy.M_LABEL), rtrim(undfcsgenicmphy.M_LABEL), rtrim(undfccgenucmphy.M_LABEL))  
when 4 then coalesce(rtrim(bskicmphy0.M_LABEL), rtrim(bskucmphy0.M_LABEL), rtrim(bskfccgenicmphy0.M_LABEL), rtrim(bskfcsgenicmphy0.M_LABEL), rtrim(bskfccgenucmphy0.M_LABEL))
when 6 then coalesce(rtrim(fccgenicmphy.M_LABEL), rtrim(fcsgenicmphy.M_LABEL), (fcsgenucmphy.M_LABEL)) end 
when 9 then coalesce(rtrim(fccgenicmphy.M_LABEL), rtrim(fcsgenicmphy.M_LABEL), (fcsgenucmphy.M_LABEL), rtrim(fccgenphy.M_LABEL), rtrim(fcsgenundfcsicmphy.M_LABEL), rtrim(fcsgenindbskicmphy0.M_LABEL), rtrim(fcsgenindbskucmphy0.M_LABEL)) 
end PHY,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then rtrim(icmloc.M_LABEL)
when 3 then coalesce(rtrim(ucmloc.M_LABEL), rtrim(undfccgenicmloc.M_LABEL), rtrim(undfcsgenicmloc.M_LABEL), rtrim(undfccgenucmloc.M_LABEL))  
when 4 then coalesce(rtrim(bskicmloc0.M_LABEL), rtrim(bskucmloc0.M_LABEL), rtrim(bskfccgenicmloc0.M_LABEL), rtrim(bskfcsgenicmloc0.M_LABEL), rtrim(bskfccgenucmloc0.M_LABEL))
when 6 then coalesce(rtrim(fccgenicmloc.M_LABEL), rtrim(fcsgenicmloc.M_LABEL), (fcsgenucmloc.M_LABEL)) end 
when 9 then coalesce(rtrim(fccgenicmloc.M_LABEL), rtrim(fcsgenicmloc.M_LABEL), (fcsgenucmloc.M_LABEL), rtrim(fccgenloc.M_LABEL), rtrim(fcsgenundfcsicmloc.M_LABEL), rtrim(fcsgenindbskicmloc0.M_LABEL), rtrim(fcsgenindbskucmloc0.M_LABEL)) 
end LOC,
-- UID
rtrim(ind.M_INDEX) INDIND,
ind.M_REFERENCE INDUID,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then (icm.M_REFERENCE) 
when 3 then coalesce(ucm.M_REFERENCE, undfccgenicm.M_REFERENCE, undfcsgenicm.M_REFERENCE, undfcsgenucm.M_REFERENCE) 
when 4 then coalesce(bskicm0.M_REFERENCE, bskucm0.M_REFERENCE, bskfccgenicm0.M_REFERENCE, bskfccgenucm0.M_REFERENCE, bskfcsgenicm0.M_REFERENCE, bskfcsgenucm0.M_REFERENCE) 
when 6 then coalesce(fccgenicm.M_REFERENCE, fcsgenicm.M_REFERENCE, fcsgenucm.M_REFERENCE) end 
when 9 then (fcm.M_REFERENCE) 
end UNDUID0,
case ind.M_CATEGORY
when 8 then 
case ind.M_RESET
when 0 then (qot.M_REFERENCE) 
when 3 then coalesce(uqt.M_REFERENCE, undfccgenqot.M_REFERENCE, undfcsgenqot.M_REFERENCE, undfcsgenuqt.M_REFERENCE) 
when 4 then coalesce(bskqot0.M_REFERENCE, bskuqt0.M_REFERENCE, bskfccgenqot0.M_REFERENCE, bskfccgenuqt0.M_REFERENCE, bskfcsgenqot0.M_REFERENCE, bskfcsgenuqt0.M_REFERENCE) 
when 6 then coalesce(fccgenqot.M_REFERENCE, fcsgenqot.M_REFERENCE, fcsgenuqt.M_REFERENCE) end 
when 9 then (qot.M_REFERENCE) 
end UQTUID0

from RT_INDEX_DBF ind
left join CM_ASSET_DBF ass on to_number(ltrim(ind.M_RT_SELAB))= ass.M_REFERENCE
left join CM_ATYPE_DBF ast on ass.M_TYPE = ast.M_REFERENCE
left join CM_UNIT_DBF  uom on ind.M_UNIT_REF0 = uom.M_REFERENCE
left join RT_GROUP_DBF grp on ind.M_HISFILE = grp.M_HISFILE
left join CM_INDEX_DBF icm on ind.M_COM_IND = icm.M_REFERENCE
left join CM_PHYS_DBF  icmphy on icm.M_PHYSICAL = icmphy.M_REFERENCE
left join CM_LOCAT_DBF icmloc on icm.M_LOCATION = icmloc.M_REFERENCE
left join CM_FUT_DBF   fcm on ind.M_COM_FUT = fcm.M_REFERENCE
left join CM_FMAT1_DBF fmt on ind.M_COM_MAT = fmt.M_REFERENCE
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_UNIT_DBF  qotuom on qot.M_UNIT = qotuom.M_REFERENCE
-- Nearby
left join RT_LNGN_DBF  fccgen on (fcm.M_CM_INSTR = fccgen.M_GEN_NUM and fcm.M_LISTED in (1,2,16,32) and fcm.M_INS_MODE = 0)
left join RT_INDEX_DBF fccgenind on rtrim(fccgen.M_INDEX0) = rtrim(fccgenind.M_INDEX)
left join CM_INDEX_DBF fccgenicm on fccgenind.M_COM_IND = fccgenicm.M_REFERENCE
left join CM_PHYS_DBF  fccgenicmphy on fccgenicm.M_PHYSICAL = fccgenicmphy.M_REFERENCE
left join CM_LOCAT_DBF fccgenicmloc on fccgenicm.M_LOCATION = fccgenicmloc.M_REFERENCE
left join CMC_QUOT_DBF fccgenqot on fccgenind.M_COM_QUOT = fccgenqot.M_REFERENCE
left join CM_MKT_DBF   fccgenqotpub on fccgenqot.M_PUBLI = fccgenqotpub.M_REFERENCE
left join CM_UNIT_DBF  fccgenqotuom on fccgenqot.M_UNIT  = fccgenqotuom.M_REFERENCE
left join RT_INDEX_DBF fccgenund on fccgenind.M_UNDRL = fccgenund.M_INDEX
left join CM_INDEX_DBF fccgenucm on fccgenund.M_COM_IND = fccgenucm.M_REFERENCE
left join CMC_QUOT_DBF fccgenuqt on fccgenund.M_COM_QUOT = fccgenuqt.M_REFERENCE
left join CM_MKT_DBF   fccgenuqtpub on fccgenuqt.M_PUBLI = fccgenuqtpub.M_REFERENCE
left join CM_UNIT_DBF  fccgenuqtuom on fccgenuqt.M_UNIT  = fccgenuqtuom.M_REFERENCE
left join CMC_MGEN_DBF fcsgen on (fcm.M_CM_INSTR = fcsgen.M_REFERENCE and fcm.M_LISTED in (1,2,16,32) and fcm.M_INS_MODE = 1)
left join RT_INDEX_DBF fcsgenind on fcsgen.M_INDEX = fcsgenind.M_INDEX
left join CM_INDEX_DBF fcsgenicm on fcsgenind.M_COM_IND = fcsgenicm.M_REFERENCE
left join CM_PHYS_DBF  fcsgenicmphy on fcsgenicm.M_PHYSICAL = fcsgenicmphy.M_REFERENCE
left join CM_LOCAT_DBF fcsgenicmloc on fcsgenicm.M_LOCATION = fcsgenicmloc.M_REFERENCE
left join CMC_QUOT_DBF fcsgenqot on fcsgenind.M_COM_QUOT = fcsgenqot.M_REFERENCE
left join CM_MKT_DBF   fcsgenqotpub on fcsgenqot.M_PUBLI = fcsgenqotpub.M_REFERENCE
left join CM_UNIT_DBF  fcsgenqotuom on fcsgenqot.M_UNIT  = fcsgenqotuom.M_REFERENCE
left join RT_INDEX_DBF fcsgenund on fcsgenind.M_UNDRL = fcsgenund.M_INDEX
left join CM_INDEX_DBF fcsgenucm on fcsgenund.M_COM_IND = fcsgenucm.M_REFERENCE
left join CM_PHYS_DBF  fcsgenucmphy on fcsgenucm.M_PHYSICAL = fcsgenucmphy.M_REFERENCE
left join CM_LOCAT_DBF fcsgenucmloc on fcsgenucm.M_LOCATION = fcsgenucmloc.M_REFERENCE
left join CMC_QUOT_DBF fcsgenuqt on fcsgenund.M_COM_QUOT = fcsgenuqt.M_REFERENCE
left join CM_MKT_DBF   fcsgenuqtpub on fcsgenuqt.M_PUBLI = fcsgenuqtpub.M_REFERENCE
left join CM_UNIT_DBF  fcsgenuqtuom on fcsgenuqt.M_UNIT  = fcsgenuqtuom.M_REFERENCE
-- Basket
 left join (select bsk.M_BASKET_REFERENCE BSKREF, max(bsk.M_ORDER) BSKELT from RT_INDBK_COMPONENT_DBF bsk group by bsk.M_BASKET_REFERENCE) bskgrp on ind.M_REFERENCE = bskgrp.BSKREF
-- Bsk.Element 0
left join RT_INDBK_COMPONENT_DBF bsk0 on (ind.M_REFERENCE = bsk0.M_BASKET_REFERENCE and ind.M_RESET = 4 and bsk0.M_ORDER = 0)
left join RT_INDEX_DBF bskind0 on bsk0.M_INDEX = bskind0.M_INDEX
left join CM_INDEX_DBF bskicm0 on bskind0.M_COM_IND = bskicm0.M_REFERENCE
left join CM_PHYS_DBF  bskicmphy0 on bskicm0.M_PHYSICAL = bskicmphy0.M_REFERENCE
left join CM_LOCAT_DBF bskicmloc0 on bskicm0.M_LOCATION = bskicmloc0.M_REFERENCE
left join CMC_QUOT_DBF bskqot0 on bskind0.M_COM_QUOT = bskqot0.M_REFERENCE
left join CM_MKT_DBF   bskqotpub0 on bskqot0.M_PUBLI = bskqotpub0.M_REFERENCE
left join CM_UNIT_DBF  bskqotuom0 on bskqot0.M_UNIT  = bskqotuom0.M_REFERENCE
left join RT_INDEX_DBF bskund0 on bskind0.M_UNDRL = bskund0.M_INDEX
left join CM_INDEX_DBF bskucm0 on bskund0.M_COM_IND = bskucm0.M_REFERENCE
left join CM_PHYS_DBF  bskucmphy0 on bskucm0.M_PHYSICAL = bskucmphy0.M_REFERENCE
left join CM_LOCAT_DBF bskucmloc0 on bskucm0.M_LOCATION = bskucmloc0.M_REFERENCE
left join CMC_QUOT_DBF bskuqt0 on bskund0.M_COM_QUOT = bskuqt0.M_REFERENCE
left join CM_MKT_DBF   bskuqtpub0 on bskuqt0.M_PUBLI = bskuqtpub0.M_REFERENCE
left join CM_UNIT_DBF  bskuqtuom0 on bskuqt0.M_UNIT  = bskuqtuom0.M_REFERENCE
left join CM_FUT_DBF   bskfcm0 on bskind0.M_COM_FUT = bskfcm0.M_REFERENCE
left join RT_LNGN_DBF  bskfccgen0 on (bskfcm0.M_CM_INSTR = bskfccgen0.M_GEN_NUM and bskfcm0.M_LISTED in (1,2,16,32) and bskfcm0.M_INS_MODE = 0)
left join RT_INDEX_DBF bskfccgenind0 on rtrim(bskfccgen0.M_INDEX0) = rtrim(bskfccgenind0.M_INDEX)
left join CM_INDEX_DBF bskfccgenicm0 on bskfccgenind0.M_COM_IND = bskfccgenicm0.M_REFERENCE
left join CM_PHYS_DBF  bskfccgenicmphy0 on bskfccgenicm0.M_PHYSICAL = bskfccgenicmphy0.M_REFERENCE
left join CM_LOCAT_DBF bskfccgenicmloc0 on bskfccgenicm0.M_LOCATION = bskfccgenicmloc0.M_REFERENCE
left join CMC_QUOT_DBF bskfccgenqot0 on bskfccgenind0.M_COM_QUOT = bskfccgenqot0.M_REFERENCE
left join CM_MKT_DBF   bskfccgenqotpub0 on bskfccgenqot0.M_PUBLI = bskfccgenqotpub0.M_REFERENCE
left join CM_UNIT_DBF  bskfccgenqotuom0 on bskfccgenqot0.M_UNIT  = bskfccgenqotuom0.M_REFERENCE
left join RT_INDEX_DBF bskfccgenund0 on bskfccgenind0.M_UNDRL = bskfccgenund0.M_INDEX
left join CM_INDEX_DBF bskfccgenucm0 on bskfccgenund0.M_COM_IND = bskfccgenucm0.M_REFERENCE
left join CM_PHYS_DBF  bskfccgenucmphy0 on bskfccgenucm0.M_PHYSICAL = bskfccgenucmphy0.M_REFERENCE
left join CM_LOCAT_DBF bskfccgenucmloc0 on bskfccgenucm0.M_LOCATION = bskfccgenucmloc0.M_REFERENCE
left join CMC_QUOT_DBF bskfccgenuqt0 on bskfccgenund0.M_COM_QUOT = bskfccgenuqt0.M_REFERENCE
left join CM_MKT_DBF   bskfccgenuqtpub0 on bskfccgenuqt0.M_PUBLI = bskfccgenuqtpub0.M_REFERENCE
left join CM_UNIT_DBF  bskfccgenuqtuom0 on bskfccgenuqt0.M_UNIT  = bskfccgenuqtuom0.M_REFERENCE
left join CMC_MGEN_DBF bskfcsgen0 on (bskfcm0.M_CM_INSTR = bskfcsgen0.M_REFERENCE and bskfcm0.M_LISTED in (1,2,16,32) and bskfcm0.M_INS_MODE = 1)
left join RT_INDEX_DBF bskfcsgenind0 on bskfcsgen0.M_INDEX = bskfcsgenind0.M_INDEX
left join CM_INDEX_DBF bskfcsgenicm0 on bskfcsgenind0.M_COM_IND = bskfcsgenicm0.M_REFERENCE
left join CM_PHYS_DBF  bskfcsgenicmphy0 on bskfcsgenicm0.M_PHYSICAL = bskfcsgenicmphy0.M_REFERENCE
left join CM_LOCAT_DBF bskfcsgenicmloc0 on bskfcsgenicm0.M_LOCATION = bskfcsgenicmloc0.M_REFERENCE
left join CMC_QUOT_DBF bskfcsgenqot0 on bskfcsgenind0.M_COM_QUOT = bskfcsgenqot0.M_REFERENCE
left join CM_MKT_DBF   bskfcsgenqotpub0 on bskfcsgenqot0.M_PUBLI = bskfcsgenqotpub0.M_REFERENCE
left join CM_UNIT_DBF  bskfcsgenqotuom0 on bskfcsgenqot0.M_UNIT  = bskfcsgenqotuom0.M_REFERENCE
left join RT_INDEX_DBF bskfcsgenund0 on bskfcsgenind0.M_UNDRL = bskfcsgenund0.M_INDEX
left join CM_INDEX_DBF bskfcsgenucm0 on bskfcsgenund0.M_COM_IND = bskfcsgenucm0.M_REFERENCE
left join CM_PHYS_DBF  bskfcsgenucmphy0 on bskfcsgenucm0.M_PHYSICAL = bskfcsgenucmphy0.M_REFERENCE
left join CM_LOCAT_DBF bskfcsgenucmloc0 on bskfcsgenucm0.M_LOCATION = bskfcsgenucmloc0.M_REFERENCE
left join CMC_QUOT_DBF bskfcsgenuqt0 on bskfcsgenund0.M_COM_QUOT = bskfcsgenuqt0.M_REFERENCE
left join CM_MKT_DBF   bskfcsgenuqtpub0 on bskfcsgenuqt0.M_PUBLI = bskfcsgenuqtpub0.M_REFERENCE
left join CM_UNIT_DBF  bskfcsgenuqtuom0 on bskfcsgenuqt0.M_UNIT  = bskfcsgenuqtuom0.M_REFERENCE
-- Bsk.Element 1
left join RT_INDBK_COMPONENT_DBF bsk1 on (ind.M_REFERENCE = bsk1.M_BASKET_REFERENCE and ind.M_RESET = 4 and bsk1.M_ORDER = 1)
left join RT_INDEX_DBF bskind1 on bsk1.M_INDEX = bskind1.M_INDEX
left join CM_INDEX_DBF bskicm1 on bskind1.M_COM_IND = bskicm1.M_REFERENCE
left join CM_PHYS_DBF  bskicmphy1 on bskicm1.M_PHYSICAL = bskicmphy1.M_REFERENCE
left join CM_LOCAT_DBF bskicmloc1 on bskicm1.M_LOCATION = bskicmloc1.M_REFERENCE
left join CMC_QUOT_DBF bskqot1 on bskind1.M_COM_QUOT = bskqot1.M_REFERENCE
left join CM_MKT_DBF   bskqotpub1 on bskqot1.M_PUBLI = bskqotpub1.M_REFERENCE
left join CM_UNIT_DBF  bskqotuom1 on bskqot1.M_UNIT  = bskqotuom1.M_REFERENCE
left join RT_INDEX_DBF bskund1 on bskind1.M_UNDRL = bskund1.M_INDEX
left join CM_INDEX_DBF bskucm1 on bskund1.M_COM_IND = bskucm1.M_REFERENCE
left join CM_PHYS_DBF  bskucmphy1 on bskucm1.M_PHYSICAL = bskucmphy1.M_REFERENCE
left join CM_LOCAT_DBF bskucmloc1 on bskucm1.M_LOCATION = bskucmloc1.M_REFERENCE
left join CMC_QUOT_DBF bskuqt1 on bskund1.M_COM_QUOT = bskuqt1.M_REFERENCE
left join CM_MKT_DBF   bskuqtpub1 on bskuqt1.M_PUBLI = bskuqtpub1.M_REFERENCE
left join CM_UNIT_DBF  bskuqtuom1 on bskuqt1.M_UNIT  = bskuqtuom1.M_REFERENCE
left join CM_FUT_DBF   bskfcm1 on bskind1.M_COM_FUT = bskfcm1.M_REFERENCE
left join RT_LNGN_DBF  bskfccgen1 on (bskfcm1.M_CM_INSTR = bskfccgen1.M_GEN_NUM and bskfcm1.M_LISTED in (1,2,16,32) and bskfcm1.M_INS_MODE = 0)
left join RT_INDEX_DBF bskfccgenind1 on rtrim(bskfccgen1.M_INDEX0) = rtrim(bskfccgenind1.M_INDEX)
left join CM_INDEX_DBF bskfccgenicm1 on bskfccgenind1.M_COM_IND = bskfccgenicm1.M_REFERENCE
left join CM_PHYS_DBF  bskfccgenicmphy1 on bskfccgenicm1.M_PHYSICAL = bskfccgenicmphy1.M_REFERENCE
left join CM_LOCAT_DBF bskfccgenicmloc1 on bskfccgenicm1.M_LOCATION = bskfccgenicmloc1.M_REFERENCE
left join CMC_QUOT_DBF bskfccgenqot1 on bskfccgenind1.M_COM_QUOT = bskfccgenqot1.M_REFERENCE
left join CM_MKT_DBF   bskfccgenqotpub1 on bskfccgenqot1.M_PUBLI = bskfccgenqotpub1.M_REFERENCE
left join CM_UNIT_DBF  bskfccgenqotuom1 on bskfccgenqot1.M_UNIT  = bskfccgenqotuom1.M_REFERENCE
left join RT_INDEX_DBF bskfccgenund1 on bskfccgenind1.M_UNDRL = bskfccgenund1.M_INDEX
left join CM_INDEX_DBF bskfccgenucm1 on bskfccgenund1.M_COM_IND = bskfccgenucm1.M_REFERENCE
left join CM_PHYS_DBF  bskfccgenucmphy1 on bskfccgenucm1.M_PHYSICAL = bskfccgenucmphy1.M_REFERENCE
left join CM_LOCAT_DBF bskfccgenucmloc1 on bskfccgenucm1.M_LOCATION = bskfccgenucmloc1.M_REFERENCE
left join CMC_QUOT_DBF bskfccgenuqt1 on bskfccgenund1.M_COM_QUOT = bskfccgenuqt1.M_REFERENCE
left join CM_MKT_DBF   bskfccgenuqtpub1 on bskfccgenuqt1.M_PUBLI = bskfccgenuqtpub1.M_REFERENCE
left join CM_UNIT_DBF  bskfccgenuqtuom1 on bskfccgenuqt1.M_UNIT  = bskfccgenuqtuom1.M_REFERENCE
left join CMC_MGEN_DBF bskfcsgen1 on (bskfcm1.M_CM_INSTR = bskfcsgen1.M_REFERENCE and bskfcm1.M_LISTED in (1,2,16,32) and bskfcm1.M_INS_MODE = 1)
left join RT_INDEX_DBF bskfcsgenind1 on bskfcsgen1.M_INDEX = bskfcsgenind1.M_INDEX
left join CM_INDEX_DBF bskfcsgenicm1 on bskfcsgenind1.M_COM_IND = bskfcsgenicm1.M_REFERENCE
left join CM_PHYS_DBF  bskfcsgenicmphy1 on bskfcsgenicm1.M_PHYSICAL = bskfcsgenicmphy1.M_REFERENCE
left join CM_LOCAT_DBF bskfcsgenicmloc1 on bskfcsgenicm1.M_LOCATION = bskfcsgenicmloc1.M_REFERENCE
left join CMC_QUOT_DBF bskfcsgenqot1 on bskfcsgenind0.M_COM_QUOT = bskfcsgenqot1.M_REFERENCE
left join CM_MKT_DBF   bskfcsgenqotpub1 on bskfcsgenqot0.M_PUBLI = bskfcsgenqotpub1.M_REFERENCE
left join CM_UNIT_DBF  bskfcsgenqotuom1 on bskfcsgenqot1.M_UNIT  = bskfcsgenqotuom1.M_REFERENCE
left join RT_INDEX_DBF bskfcsgenund1 on bskfcsgenind1.M_UNDRL = bskfcsgenund1.M_INDEX
left join CM_INDEX_DBF bskfcsgenucm1 on bskfcsgenund1.M_COM_IND = bskfcsgenucm1.M_REFERENCE
left join CM_PHYS_DBF  bskfcsgenucmphy1 on bskfcsgenucm1.M_PHYSICAL = bskfcsgenucmphy1.M_REFERENCE
left join CM_LOCAT_DBF bskfcsgenucmloc1 on bskfcsgenucm1.M_LOCATION = bskfcsgenucmloc1.M_REFERENCE
left join CMC_QUOT_DBF bskfcsgenuqt1 on bskfcsgenund1.M_COM_QUOT = bskfcsgenuqt1.M_REFERENCE
left join CM_MKT_DBF   bskfcsgenuqtpub1 on bskfcsgenuqt1.M_PUBLI = bskfcsgenuqtpub1.M_REFERENCE
left join CM_UNIT_DBF  bskfcsgenuqtuom1 on bskfcsgenuqt1.M_UNIT  = bskfcsgenuqtuom0.M_REFERENCE
-- Average
left join RT_INDEX_DBF und on ind.M_UNDRL = und.M_INDEX
left join CM_UNIT_DBF  unduom on und.M_UNIT_REF0 = unduom.M_REFERENCE
left join CM_INDEX_DBF ucm on und.M_COM_IND = ucm.M_REFERENCE
left join CM_PHYS_DBF  ucmphy on ucm.M_PHYSICAL = ucmphy.M_REFERENCE
left join CM_LOCAT_DBF ucmloc on ucm.M_LOCATION = ucmloc.M_REFERENCE
left join CMC_QUOT_DBF uqt on und.M_COM_QUOT = uqt.M_REFERENCE
left join CM_MKT_DBF   uqtpub on uqt.M_PUBLI = uqtpub.M_REFERENCE
left join CM_UNIT_DBF  uqtuom on uqt.M_UNIT = uqtuom.M_REFERENCE
left join CM_FUT_DBF   undfcm on und.M_COM_FUT = undfcm.M_REFERENCE
left join RT_LNGN_DBF  undfccgen on (undfcm.M_CM_INSTR = undfccgen.M_GEN_NUM and undfcm.M_LISTED in (1,2,16,32) and undfcm.M_INS_MODE = 0)
left join RT_INDEX_DBF undfccgenind on rtrim(undfccgen.M_INDEX0) = rtrim(undfccgenind.M_INDEX)
left join CM_INDEX_DBF undfccgenicm on undfccgenind.M_COM_IND = undfccgenicm.M_REFERENCE
left join CM_PHYS_DBF  undfccgenicmphy on undfccgenicm.M_PHYSICAL = undfccgenicmphy.M_REFERENCE
left join CM_LOCAT_DBF undfccgenicmloc on undfccgenicm.M_LOCATION = undfccgenicmloc.M_REFERENCE
left join CMC_QUOT_DBF undfccgenqot on undfccgenind.M_COM_QUOT = undfccgenqot.M_REFERENCE
left join CM_MKT_DBF   undfccgenqotpub on undfccgenqot.M_PUBLI = undfccgenqotpub.M_REFERENCE
left join CM_UNIT_DBF  undfccgenqotuom on undfccgenqot.M_UNIT  = undfccgenqotuom.M_REFERENCE
left join RT_INDEX_DBF undfccgenund on undfccgenind.M_UNDRL = undfccgenund.M_INDEX
left join CM_INDEX_DBF undfccgenucm on undfccgenund.M_COM_IND = undfccgenucm.M_REFERENCE
left join CM_PHYS_DBF  undfccgenucmphy on undfccgenucm.M_PHYSICAL = undfccgenucmphy.M_REFERENCE
left join CM_LOCAT_DBF undfccgenucmloc on undfccgenucm.M_LOCATION = undfccgenucmloc.M_REFERENCE
left join CMC_QUOT_DBF undfccgenuqt on undfccgenund.M_COM_QUOT = undfccgenuqt.M_REFERENCE
left join CM_MKT_DBF   undfccgenuqtpub on undfccgenuqt.M_PUBLI = undfccgenuqtpub.M_REFERENCE
left join CM_UNIT_DBF  undfccgenuqtuom on undfccgenuqt.M_UNIT  = undfccgenuqtuom.M_REFERENCE
left join CMC_MGEN_DBF undfcsgen on (undfcm.M_CM_INSTR = undfcsgen.M_REFERENCE and undfcm.M_LISTED in (1,2,16,32) and undfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF undfcsgenind on undfcsgen.M_INDEX = undfcsgenind.M_INDEX
left join CM_INDEX_DBF undfcsgenicm on undfcsgenind.M_COM_IND = undfcsgenicm.M_REFERENCE
left join CM_PHYS_DBF  undfcsgenicmphy on undfcsgenicm.M_PHYSICAL = undfcsgenicmphy.M_REFERENCE
left join CM_LOCAT_DBF undfcsgenicmloc on undfcsgenicm.M_LOCATION = undfcsgenicmloc.M_REFERENCE
left join CMC_QUOT_DBF undfcsgenqot on undfcsgenind.M_COM_QUOT = undfcsgenqot.M_REFERENCE
left join CM_MKT_DBF   undfcsgenqotpub on undfcsgenqot.M_PUBLI = undfcsgenqotpub.M_REFERENCE
left join CM_UNIT_DBF  undfcsgenqotuom on undfcsgenqot.M_UNIT  = undfcsgenqotuom.M_REFERENCE
left join RT_INDEX_DBF undfcsgenund on undfcsgenind.M_UNDRL = undfcsgenund.M_INDEX
left join CM_INDEX_DBF undfcsgenucm on undfcsgenund.M_COM_IND = undfcsgenucm.M_REFERENCE
left join CMC_QUOT_DBF undfcsgenuqt on undfcsgenund.M_COM_QUOT = undfcsgenuqt.M_REFERENCE
left join CM_MKT_DBF   undfcsgenuqtpub on undfcsgenuqt.M_PUBLI = undfcsgenuqtpub.M_REFERENCE
left join CM_UNIT_DBF  undfcsgenuqtuom on undfcsgenuqt.M_UNIT  = undfcsgenuqtuom.M_REFERENCE
left join RT_INDBK_COMPONENT_DBF undbsk0 on (und.M_REFERENCE = undbsk0.M_BASKET_REFERENCE and und.M_RESET = 4 and undbsk0.M_ORDER = 0)


-- Forward
left join CM_PHYS_DBF  fccgenphy on fccgen.M_DEL_FYS0 = fccgenphy.M_REFERENCE
left join CM_LOCAT_DBF fccgenloc on fccgen.M_DEL_LOC0 = fccgenloc.M_REFERENCE
left join CM_FUT_DBF   fcsgenundfcm on fcsgenund.M_COM_FUT = fcsgenundfcm.M_REFERENCE 
left join CMC_MGEN_DBF fcsgenundfcs on (fcsgenundfcm.M_CM_INSTR = fcsgenundfcs.M_REFERENCE and fcsgenundfcm.M_LISTED in (1,2,16,32) and fcsgenundfcm.M_INS_MODE = 1)
left join RT_INDEX_DBF fcsgenundfcsind on fcsgenundfcs.M_INDEX = fcsgenundfcsind.M_INDEX
left join CM_INDEX_DBF fcsgenundfcsicm on fcsgenundfcsind.M_COM_IND = fcsgenundfcsicm.M_REFERENCE
left join CM_PHYS_DBF  fcsgenundfcsicmphy on fcsgenundfcsicm.M_PHYSICAL = fcsgenundfcsicmphy.M_REFERENCE
left join CM_LOCAT_DBF fcsgenundfcsicmloc on fcsgenundfcsicm.M_LOCATION = fcsgenundfcsicmloc.M_REFERENCE
left join RT_INDBK_COMPONENT_DBF fcsgenindbsk0 on (fcsgenind.M_REFERENCE = fcsgenindbsk0.M_BASKET_REFERENCE and fcsgenind.M_RESET = 4 and fcsgenindbsk0.M_ORDER = 0)
left join RT_INDEX_DBF fcsgenindbskind0 on fcsgenindbsk0.M_INDEX = fcsgenindbskind0.M_INDEX
left join CM_INDEX_DBF fcsgenindbskicm0 on fcsgenindbskind0.M_COM_IND = fcsgenindbskicm0.M_REFERENCE
left join CM_PHYS_DBF  fcsgenindbskicmphy0 on fcsgenindbskicm0.M_PHYSICAL = fcsgenindbskicmphy0.M_REFERENCE
left join CM_LOCAT_DBF fcsgenindbskicmloc0 on fcsgenindbskicm0.M_LOCATION = fcsgenindbskicmloc0.M_REFERENCE
left join RT_INDEX_DBF fcsgenindbskund0 on fcsgenindbskind0.M_UNDRL = fcsgenindbskund0.M_INDEX
left join CM_INDEX_DBF fcsgenindbskucm0 on fcsgenindbskund0.M_COM_IND = fcsgenindbskucm0.M_REFERENCE
left join CM_PHYS_DBF  fcsgenindbskucmphy0 on fcsgenindbskucm0.M_PHYSICAL = fcsgenindbskucmphy0.M_REFERENCE
left join CM_LOCAT_DBF fcsgenindbskucmloc0 on fcsgenindbskucm0.M_LOCATION = fcsgenindbskucmloc0.M_REFERENCE

where 1 = 1
and ind.M_CATEGORY in (8)
and ass.M_LABEL not in ('_ASSET')
and ind.M_REFERENCE not in 
(
1967,
2044,
2618,
2619,
2620,
2621,
2622,
2623
)
-- and ind.M_REFERENCE  in (3268)