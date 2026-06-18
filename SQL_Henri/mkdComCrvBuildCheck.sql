select distinct
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
to_char(crv.M__DATE_,'YYYY-MM-DD') MKDDAT,
rtrim(crv.M__ALIAS_) MDS,
--ind.M_INDEX IND,
--ind.M_REFERENCE INDREF,
--icm.M_REFERENCE ICMREF,
--qot.M_REFERENCE QOTREF,
--mgnspt.M_REFERENCE MGNSPTREF,
--mgnsav.M_REFERENCE MGNAVGREF,
--fcmssp.M_REFERENCE FCMSSPREF,
--fcmsav.M_REFERENCE FCMSAVREF,
--fcmcsp.M_REFERENCE FCMCSPREF,
--fcmcav.M_REFERENCE FCMCAVREF,
--grp.M_REFERENCE GRPREF,
--prcswp.M_REFERENCE PRCSWPREF,
--prcfwd.M_REFERENCE PRCFWDREF,
--crv.M_REFERENCE CRVREF,
--crvgri.M_REFERENCE CRVGRIREF,
-- Underlying
rtrim(ass.M_LABEL) ASS,
rtrim(ind.M_IND_LAB) INDLAB,
rtrim(icm.M_LABEL) ICMLAB,
rtrim(pub.M_LABEL) ICMPUB,
rtrim(qot.M_TRAD_SMB) ICMSYM,
--coalesce(rtrim(fcmssp.M_LABEL), rtrim(fcmsav.M_LABEL), rtrim(fcmcsp.M_LABEL), rtrim(fcmcav.M_LABEL)) FCMLAB,
-- Quotes
case 
when prcswp.M_VAL_TYPE = 4 then 'Index' 
when prcswp.M_VAL_TYPE = 5 then 'Fwd.rate'
when prcfwd.M_VAL_TYPE = 4 then 'Index' 
when prcfwd.M_VAL_TYPE = 5 then 'Fwd.rate'
when coalesce(crvfcs.M_LABEL,'X') <> 'X' then 'Future'
else null end QOTTYP,
case 
when prcswp.M_GTYPE = 256 and prcswp.M_GEN_MODE = 1 then rtrim(grpswp.M_LABEL)
when prcfwd.M_GTYPE = 256 and prcfwd.M_GEN_MODE = 2 then rtrim(grpfwd.M_LABEL)
else coalesce(rtrim(crvfcs.M_LABEL), rtrim(fcmssp.M_LABEL))end QOTGRP,
case 
when prcswp.M_GTYPE = 256 and prcswp.M_GEN_MODE = 1 then rtrim(pilswp.M_LABEL)
when prcfwd.M_GTYPE = 256 and prcfwd.M_GEN_MODE = 2 then rtrim(pilfwd.M_LABEL)
else rtrim(fcmsspmatset.M_LABEL) end QOTPIL,
/*
case prcswp.M_GEN_MODE
when 1 then 'Simple'
when 2 then 'Custom' else null end QOTMOD,
*/
-- Curve
concat(rtrim(crvund.M_LABEL),substr(crv.M_KEY,21,5)) CRV,
case 
when crvgrc.M_GEN_MODE = 0 then
   case
   when crvgrc.M_FUTURE > 0 then 'Future'
   when crvgrc.M_INSTR_GEN > 0 then
     case crvinc.M_INSTR_TYPE
     when  3 then 'IR Loan'
     when 13 then 'CM Swap' 
     when 13 then 'CM Future'
     when 21 then 'Repo'   else null end
   else null end  
when crvgri.M_FUTURE > 0 then 'Future'
when crvgri.M_GEN_MODE = prcswp.M_GEN_MODE then 'Index'
when crvgrf.M_GEN_MODE = prcfwd.M_GEN_MODE then 
    case crvgrf.M_VAL_TYPE
    when 0 then 'Lease Metal'
    when 2 then 'Lease Cash'
    when 4 then 'Index' -- Fwd.Price
    when 5 then 'Fwd.Rate' else null end
else null end CRVTYP,
case
when crvgrc.M_GEN_MODE = 0 then 'Custom'
when crvgri.M_FUTURE > 0 then
    case crvgri.M_GEN_MODE
    when 0 then 'Custom'
    when 1 then 'Simple' else null end
when crvgri.M_GEN_MODE = prcswp.M_GEN_MODE then
    case crvgri.M_GEN_MODE
    when 0 then 'Custom'
    when 1 then 'Simple' else null end
when crvgrf.M_GEN_MODE = prcfwd.M_GEN_MODE then 
    case crvgrf.M_GEN_MODE
    when 0 then 'Custom'
    when 1 then 'Simple'
    when 2 then 'CM Index' else null end
else null end CRVMOD,
case 
when crvgrc.M_GEN_MODE = 0 then
  case when crvinc.M_INSTR_TYPE = 13 then rtrim(crvinc.M_INSTR) else rtrim(crvfcc.M_LABEL) end
when crvgri.M_FUTURE > 0 then rtrim(crvfcs.M_LABEL)  
when crvgri.M_GEN_MODE = prcswp.M_GEN_MODE then rtrim(mgnind.M_IND_LAB)
when crvgrf.M_GEN_MODE = prcfwd.M_GEN_MODE then rtrim(crvicm.M_LABEL)
else null end CRVINS,
case
when crvgrc.M_GEN_MODE = 0 then rtrim(crvpic.M_LABEL)
when crvgri.M_FUTURE > 0 then rtrim(crvpii.M_LABEL)
when crvgri.M_GEN_MODE = prcswp.M_GEN_MODE then rtrim(crvpii.M_LABEL)
when crvgrf.M_GEN_MODE = prcfwd.M_GEN_MODE then rtrim(crvpif.M_LABEL)
else null end CRVPIL,
coalesce(rtrim(lutfwdswp.M_DGMODEL), rtrim(lutfwdfut.M_DGMODEL)) LUTFWD,
coalesce(rtrim(luthisspt.M_DGMODEL), rtrim(luthisfut.M_DGMODEL)) LUSTHIS
--rtrim(altfwd.M_OBJ_ALT) ALTFWD


from RT_INDEX_DBF ind
left join TRN_PC_DBF pc on  1 = 1
left join CM_INDEX_DBF icm on ind.M_COM_IND = icm.M_REFERENCE
left join CMC_QUOT_DBF qot on icm.M_QUOT_FWD = qot.M_REFERENCE
left join CM_MKT_DBF   pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_ASSET_DBF ass on icm.M_ASSET = ass.M_REFERENCE
left join CMC_MGEN_DBF mgnspt on ind.M_INDEX = mgnspt.M_INDEX
left join CM_FUT_DBF   fcmssp on (mgnspt.M_REFERENCE = fcmssp.M_CM_INSTR and fcmssp.M_LISTED in (1,2) and fcmssp.M_INS_MODE = 1)
left join RT_INDEX_DBF indavg on (ind.M_INDEX = indavg.M_UNDRL and indavg.M_RESET = 3)
left join CMC_MGEN_DBF mgnavg on indavg.M_INDEX = mgnavg.M_INDEX
left join CM_FUT_DBF   fcmsav on (mgnavg.M_REFERENCE = fcmsav.M_CM_INSTR and fcmsav.M_LISTED in (1,2) and fcmsav.M_INS_MODE = 1)
left join RT_LNGN_DBF  genspt on ind.M_INDEX = genspt.M_INDEX0
left join CM_FUT_DBF   fcmcsp on (genspt.M_GEN_NUM = fcmcsp.M_CM_INSTR and fcmcsp.M_LISTED in (1,2) and fcmcsp.M_INS_MODE = 0)
left join RT_LNGN_DBF  genavg on indavg.M_INDEX = genavg.M_INDEX0
left join CM_FUT_DBF   fcmcav on (genavg.M_GEN_NUM = fcmcav.M_CM_INSTR and fcmcav.M_LISTED in (1,2) and fcmcav.M_INS_MODE = 0)
left join CMG_GRPI_DBF prcswp on (mgnspt.M_REFERENCE = prcswp.M_INSTR_GEN and prcswp.M_GTYPE = 256 and prcswp.M_GEN_MODE = 1 and prcswp.M__DATE_ = pc.M_DATE and prcswp.M__ALIAS_ = 'RT')
left join CMG_GRPI_DBF prcfwd on (icm.M_REFERENCE = prcfwd.M_INSTR_GEN and prcfwd.M_GTYPE = 256 and prcfwd.M_GEN_MODE = 2 and prcfwd.M__DATE_ = pc.M_DATE and prcfwd.M__ALIAS_ = 'RT')
left join CMG_GRP_DBF  grpswp on (prcswp.M_GROUP = grpswp.M_REFERENCE and prcswp.M_GTYPE = grpswp.M_GTYPE and prcswp.M__DATE_ = grpswp.M__DATE_ and prcswp.M__ALIAS_ = grpswp.M__ALIAS_)
left join CMG_GRP_DBF  grpfwd on (prcfwd.M_GROUP = grpfwd.M_REFERENCE and prcfwd.M_GTYPE = grpfwd.M_GTYPE and prcfwd.M__DATE_ = grpfwd.M__DATE_ and prcfwd.M__ALIAS_ = grpfwd.M__ALIAS_)
left join CM_PLST_DBF  pilswp on grpswp.M_PILSET = pilswp.M_REFERENCE
left join CM_PLST_DBF  pilfwd on grpfwd.M_PILSET = pilfwd.M_REFERENCE
left join CM_FMAT_DBF  fcmsspmatset on fcmssp.M_FUT_MAT = fcmsspmatset.M_REFERENCE
left join CMK_SCCF_DBF crv on (icm.M_REFERENCE = to_number(substr(crv.M_KEY,1,10)) and crv.M__DATE_ = pc.M_DATE and crv.M__ALIAS_ = 'RT')
left join CM_INDEX_DBF crvund on to_number(substr(crv.M_KEY,1,10)) = crvund.M_REFERENCE
left join CMG_GRPI_DBF crvgrc on (crv.M_OBJ_PIL = crvgrc.M_GROUP and crvgrc.M_GTYPE = 512 and crvgrc.M_GEN_MODE = 0 and crv.M__DATE_ = crvgrc.M__DATE_ and crv.M__ALIAS_ = crvgrc.M__ALIAS_)
left join CMG_GRPI_DBF crvgri on (crv.M_OBJ_PIL = crvgri.M_GROUP and crvgri.M_GTYPE = 512 and crvgri.M_GEN_MODE = 1 and crv.M__DATE_ = crvgri.M__DATE_ and crv.M__ALIAS_ = crvgri.M__ALIAS_)
left join CMG_GRPI_DBF crvgrf on (crv.M_OBJ_PIL = crvgrf.M_GROUP and crvgrf.M_GTYPE = 512 and crvgrf.M_GEN_MODE = 2 and crv.M__DATE_ = crvgrf.M__DATE_ and crv.M__ALIAS_ = crvgrf.M__ALIAS_)
left join CMC_MGEN_DBF crvmgn on crvgri.M_INSTR_GEN = crvmgn.M_REFERENCE and crvgri.M_GEN_MODE = 1
left join CM_INDEX_DBF crvicm on crvgrf.M_INDEX = crvicm.M_REFERENCE and crvgrf.M_GEN_MODE = 2
left join RT_INDEX_DBF mgnind on crvmgn.M_INDEX = mgnind.M_INDEX
left join RT_INSGN_DBF crvinc on crvgrc.M_INSTR_GEN = crvinc.M_GEN_NUM
left join RT_INSGN_DBF crvins on crvgri.M_INSTR_GEN = crvins.M_GEN_NUM
left join CM_FUT_DBF   crvfcc on crvgrc.M_FUTURE = crvfcc.M_REFERENCE
left join CM_FUT_DBF   crvfcs on crvgri.M_FUTURE = crvfcs.M_REFERENCE
left join CM_PLST_DBF  crvpic on crvgrc.M_PILSET = crvpic.M_REFERENCE
left join CM_PLST_DBF  crvpii on crvgri.M_PILSET = crvpii.M_REFERENCE
left join CM_PLST_DBF  crvpif on crvgrf.M_PILSET = crvpif.M_REFERENCE
left join UDTB237_DBF lutfwdswp on (rtrim(grpswp.M_LABEL) = rtrim(lutfwdswp.M_DGMXLABEL) and rtrim(mgnind.M_IND_LAB) = rtrim(lutfwdswp.M_DGGENERAT) and rtrim(lutfwdswp.M_DGPTYPE) in ('COM_SWAP'))
left join UDTB237_DBF lutfwdfut on (rtrim(crvfcs.M_LABEL) = rtrim(lutfwdfut.M_DGMXLABEL) and rtrim(lutfwdfut.M_DGPTYPE) in ('COM_FUT','COM_ADJ_FUT'))
left join KEYMAP_STC_DBF altfwd on ind.M_INDEX = altfwd.M_OBJ_DESC and rtrim(altfwd.M_OBJ_CLASS) ='MnXbT37735' and rtrim(altfwd.M_OBJ_ASYS) = 'DG_FWD'
left join UDTB274_DBF luthisspt on (rtrim(pub.M_LABEL) = rtrim(luthisspt.M_DGPUBLICAT) and rtrim(icm.M_LABEL) = rtrim(luthisspt.M_DGMXLABEL) and rtrim(luthisspt.M_DGPTYPE) in ('COM_SIND_FIXING','COM_SIND_FIXING1'))
left join UDTB274_DBF luthisfut on (rtrim(pub.M_LABEL) = rtrim(luthisfut.M_DGPUBLICAT) and rtrim(crvfcs.M_LABEL) = rtrim(luthisfut.M_DGMXLABEL) and rtrim(luthisfut.M_DGPTYPE) in ('COM_FUT_FIXING'))
--left join KEYMAP_STC_DBF althis on ind.M_INDEX = althis.M_OBJ_DESC and rtrim(althis.M_OBJ_CLASS) ='MnXbT37735' and rtrim(althis.M_OBJ_ASYS) = 'DG_HIS'

where 1 = 1
and ind.M_CATEGORY = 8  
and ind.M_RESET = 0
and ind.M_COM_QUOT = icm.M_QUOT_FWD
and icm.M_COMMENT4 <> 'OOS'
and 
(prcswp.M_REFERENCE > 0 or 
(fcmssp.M_REFERENCE > 0 and fcmssp.M_REFERENCE in (select distinct M_FUTURE from CMK_FUTP_DBF)) or 
(fcmcsp.M_REFERENCE > 0 and fcmcsp.M_REFERENCE in (select distinct M_FUTURE from CMK_FUTP_DBF)) or
(fcmcav.M_REFERENCE > 0 and fcmcav.M_REFERENCE in (select distinct M_FUTURE from CMK_FUTP_DBF)) )

order by INDLAB