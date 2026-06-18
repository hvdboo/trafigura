DROP VIEW TRNSTGRMD;
CREATE VIEW TRNSTGRMD 
( 
TRN,
FML, 
INS, 
PHY, 
PHYTYP, 
PHYRMD, 
IE, 
BS, 
SRC_PFL, 
DST_PFL, 
CTP,
B_PFLNAT, 
B_PFLCAT, 
B_PFLLAB, 
B_RMDCOD, 
B_RMDLAB, 
B_RMDFLG, 
S_PFLNAT, 
S_PFLCAT, 
S_PFLLAB, 
S_RMDCOD, 
S_RMDLAB, 
S_RMDFLG, 
B_ASG, 
BA_RMDLAB, 
S_ASG, 
SA_RMDLAB,
TRN_NB,
TRN_BRMDLAB,
TRN_BRMDCOD,
TRN_SRMDLAB,
TRN_SRMDCOD
) 

AS
(
select
trn.M_NB                TRN,
rtrim(trn.M_TRN_FMLY)   FML,
rtrim(plin.M_DSP_LABEL) INS,
rtrim(phy.M_LABEL)      PHY,
rtrim(phytyp.M_LABEL)   PHYTYP,
rtrim(phylut.M_PHYLAB)  PHYRMD,
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
rtrim(trn.M_COMMENT_BS) BS,
rtrim(pflsrc.M_LABEL)   SRC_PFL,
rtrim(pfldst.M_LABEL)   DST_PFL,
rtrim(ctp.M_DSP_LABEL)  CTP,
case when trn.M_BINTERNAL = 'Y' then 'PFL' else 'CTP' end B_PFLNAT,
rtrim(udfb.M_PTFCAT) B_PFLCAT,
rtrim(trn.M_BPFOLIO) B_PFLLAB,
rtrim(udfb.M_RMDCOD) B_RMDCOD,
rtrim(udfb.M_RMDLAB) B_RMDLAB,
rtrim(udfb.M_RMDFLG) B_RMDFLG,
case when trn.M_SINTERNAL = 'Y' then 'PFL' else 'CTP' end S_PFLNAT,
rtrim(udfs.M_PTFCAT) S_PFLCAT,
rtrim(trn.M_SPFOLIO) S_PFLLAB,
rtrim(udfs.M_RMDCOD) S_RMDCOD,
rtrim(udfs.M_RMDLAB) S_RMDLAB,
rtrim(udfs.M_RMDFLG) S_RMDFLG,
case when trn.M_COMMENT_BS = 'B' then udf.M_PL_ASSIG else udf.M_PL_ASSIG2 end B_ASG,
-- Revised PLASG, Buy
case when trn.M_COMMENT_BS = 'B'
then
    case rtrim(udf.M_PL_ASSIG)
    when 'ALUMINIUM' then 'Aluminium (RM)'
    when 'BITUMEN' then 'Bitumen'
    when 'COPPER' then 'Copper (RM)'
    when 'copper' then 'Copper (RM)'
    when 'FX' then 'CED FX Trading'
    when 'IRON ORE' then 'Iron Ore'
    when 'LEAD' then 'Lead (RM)'
    when 'NICKEL' then 'Nickel (RM)'
    when 'SILVER' then 'Silver (RM)'
    when 'ZINC' then 'Zinc (RM)'
    when 'zinc' then 'Zinc (RM)'
    else ' ' end
else
	case rtrim(udf.M_PL_ASSIG2)
	when 'ALUMINIUM' then 'Aluminium (RM)'
	when 'BITUMEN' then 'Bitumen'
	when 'COPPER' then 'Copper (RM)'
	when 'copper' then 'Copper (RM)'
	when 'FX' then 'CED FX Trading'
	when 'IRON ORE' then 'Iron Ore'
	when 'LEAD' then 'Lead (RM)'
	when 'NICKEL' then 'Nickel (RM)'
	when 'SILVER' then 'Silver (RM)'
	when 'ZINC' then 'Zinc (RM)'
	when 'zinc' then 'Zinc (RM)'
	else ' '  end
end BA_RMDLAB,
case when trn.M_COMMENT_BS = 'B' then udf.M_PL_ASSIG2 else udf.M_PL_ASSIG end S_ASG,
case
when trn.M_COMMENT_BS = 'B'
then
	case rtrim(udf.M_PL_ASSIG2)
	when 'ALUMINIUM' then 'Aluminium (RM)'
	when 'BITUMEN' then 'Bitumen'
	when 'COPPER' then 'Copper (RM)'
	when 'copper' then 'Copper (RM)'
	when 'FX' then 'CED FX Trading'
	when 'IRON ORE' then 'Iron Ore'
	when 'LEAD' then 'Lead (RM)'
	when 'NICKEL' then 'Nickel (RM)'
	when 'SILVER' then 'Silver (RM)'
	when 'ZINC' then 'Zinc (RM)'
	when 'zinc' then 'Zinc (RM)'
	else ' ' end
else
	case rtrim(udf.M_PL_ASSIG)
	when 'ALUMINIUM' then 'Aluminium (RM)'
	when 'BITUMEN' then 'Bitumen'
	when 'COPPER' then 'Copper (RM)'
	when 'copper' then 'Copper (RM)'
	when 'FX' then 'CED FX Trading'
	when 'IRON ORE' then 'Iron Ore'
	when 'LEAD' then 'Lead (RM)'
	when 'NICKEL' then 'Nickel (RM)'
	when 'SILVER' then 'Silver (RM)'
	when 'ZINC' then 'Zinc (RM)'
	when 'zinc'	then 'Zinc (RM)'
	else ' ' end
end SA_RMDLAB,
trn.M_NB TRN_NB,
rtrim(trn.M_BSTRATEGY) TRN_BRMDLAB,
rtrim(stgb.M_COMMENT0) TRN_BRMDCOD,
rtrim(trn.M_SSTRATEGY) TRN_SRMDLAB,
rtrim(stgs.M_COMMENT0) TRN_SRMDCOD

from TRN_HDR_DBF trn
left join TRN_PFLD_DBF pflb on rtrim(trn.M_BPFOLIO) = rtrim(pflb.M_LABEL)
left join TRN_PFLD_DBF pfls on rtrim(trn.M_SPFOLIO) = rtrim(pfls.M_LABEL)
left join TRN_PFLD_DBF pflsrc on trn.M_SRC_PFOLIO = pflsrc.M_REF
left join TRN_PFLD_DBF pfldst on trn.M_DST_PFOLIO = pfldst.M_REF
left join TRN_CPDF_DBF ctp on trn.M_COUNTRPART = ctp.M_ID
left join TABLE#DATA#PORTFOLI_DBF udfb on rtrim(pflb.M_LABEL) = rtrim(udfb.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF udfs on rtrim(pfls.M_LABEL) = rtrim(udfs.M_LABEL)
join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TRN_EXT_DBF ext on (trn.M_NB = ext.M_TRADE_REF and trn.M_TRN_FMLY = 'CURR' and cnt.M_VERSION = ext.M_VERSION)
left join TABLE#DATA#DEALCURR_DBF udf on ext.M_UDF_REF = udf.M_NB
left join TRN_PLIN_DBF plin on rtrim(trn.M_INSTRUMENT) = rtrim(plin.M_REFERENCE)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_PHYS_DBF phy on plk.M_PRODUCT = phy.M_REFERENCE
left join CM_PTYPE_DBF phytyp on phy.M_TYPE = phytyp.M_REFERENCE
left join UDTB289_DBF phylut on rtrim(phy.M_LABEL) = rtrim(phylut.M_PHYSICAL)
left join TRN_STGD_DBF stgb on rtrim(trn.M_BSTRATEGY) = rtrim(stgb.M_LABEL)
left join TRN_STGD_DBF stgs on rtrim(trn.M_SSTRATEGY) = rtrim(stgs.M_LABEL)

where 1 = 1
and trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_TRN_FMLY in ('COM','CURR','IRD','SCF')
and (rtrim(udfb.M_PTFCAT) in ('H','P','F','S') or  rtrim(udfs.M_PTFCAT) in ('H','P','F','S') )
/*
and trn.M_NB in 
(
10749904,
10764661,
10050175,
15029401
)
*/

);
  