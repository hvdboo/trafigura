select 
fut.M_REFERENCE FUT_ID,
qotf.M_REFERENCE QOTF_ID,
qot.M_REFERENCE QOT_ID,
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
-- rtrim(atp.M_LABEL) ATYP, 
rtrim(ass.M_LABEL) ASSET,
coalesce(rtrim(indphy.M_LABEL), rtrim(undphy.M_LABEL), rtrim(undphy0.M_LABEL)) PHYS,
case fut.M_LISTED
when  1 then 
(case fut.M_LOOKALIKE_ENABLED
when  0 then 'Future'
when  1 then 'Fut, Fwd' end)
when  2 then 'Forward'
when 16 then 'Cleared Swap'
when 32 then 'Cleared Asian'
when 64 then 'Listed option' end NATURE,
rtrim(fut.M_LABEL) LABEL, 
rtrim(fut.M_DESC) DESCRIPTION,
rtrim(pub.M_LABEL) as PUBLICATION, 
rtrim(qot.M_TRAD_SMB) as SYM, 
rtrim(alturl.M_OBJ_ALBL) EXCCOD,
rtrim(alturl.M_OBJ_ALT) URL,
/*
case fut.M_LISTED 
when 1 then 
case fut.M_LOOKALIKE_ENABLED
when  0 then 'Listed'
when  1 then 'Listed & Lookalike' end
when  2 then 'OTC' 
when 64 then 'Listed options' end CNT_TYP,
case fut.M_PRC_EVAL	
when 0 then 'Marked to market'
when 1 then 'Theoretical' end as EVAL,
case fut.M_PRC_DISC
when 0 then 'Quotation end' 
when 1 then 'Delivery period' 
when 2 then 'Delivery start'
when 3 then 'Delivery end'
when 4 then 'Notification start'
when 5 then 'Notification end' end PRC_DISCOVERY,
case fut.M_FX_FIXDATE	
when 0 then 'Quotation end'
when 1 then 'Delivery start' 
when 2 then 'Spot date' end as FX_FIXING,
case fut.M_MCALL_SYS	
when 1 then 'Yes'
when 0 then 'No' end as MC,
case fut.M_MCALL_DSC
when 0 then 'No'
when 1 then 'Yes' end MC_DISC,
case fut.M_IGN_DISC
when 0 then 'No'
when 1 then 'Yes' end IGN_DISC,
case fut.M_NETTING_ALLOWED
when 0 then 'No'
when 1 then 'Yes' end NETTING,
*/
case fut.M_EXR_MODE
when 0 then 'Cash settled' 
when 1 then 'Phys.delivery'
when 2 then 'Fin.delivery'  end as EXERCISE,
/*
case fut.M_SPLT_RULE	
when 0 then 'None'
when 1 then 'Quotation end' 
when 2 then 'Trade date' end as SPLIT,
rtrim(fmat.M_LABEL) as MAT_SET,
*/
fut.M_QTY as LOTSIZE,
rtrim(qotf.M_LABEL) FWD_QUOTE,
rtrim(qot.M_LABEL) as QUOTATION,
/*
case qot.M__TYPE_
when  1 then 'Index'
when  2 then 'Future'
when  4 then 'Dlv.flow'
when  8 then 'Spread'
when  5 then 'Index flow'
when  6 then 'Future flow'
when 14 then 'Spread fut.flow' else null end QUOT_TYP,
*/
qot.M_CURR as CUR, qot.M_PRC_FACT as PRC_FCT, 
rtrim(uniq.M_LABEL) as UNIT_QUOT, rtrim(unid.M_LABEL) as UNIT_DLV,
/*
rtrim(grp.M_HISFILE) HIS,
rtrim(plin.M_DSP_LABEL) PLIN,
fut.M_REFERENCE as FUT_ID, qot.M_REFERENCE as QOT_ID,
rtrim(grp.M_GRP_DESC) GRP_ID,
plin.M_REFERENCE PLIN_ID
rtrim(fut.M_COMMENT0) CMT0,
rtrim(fut.M_COMMENT1) CMT1,
rtrim(fut.M_COMMENT2) CMT2,
*/
rtrim(altcom.M_OBJ_ALT) ALTCOM,
rtrim(altmkt.M_OBJ_ALT) ALTMKT,
rtrim(altins.M_OBJ_ALT) ALTINS,
-- rtrim(altinsfwd.M_OBJ_ALT) ALTINSFWD,
case 
when fut.M_LISTED in (1,2,16) then  
case fut.M_INS_MODE
when 0 then 'Custom'
when 1 then 'Simple' else null end 
when fut.M_LISTED in (64) then 
case fut.M_OSPRD_TYP
when 0 then 'Simple'
when 1 then 'Product spread' 
when 2 then 'Time spread' else null end 
when fut.M_LISTED in (32) then 'Custom'
else null end as CFG_MOD,
case
when fut.M_LISTED in (1,2,16,32) then 
case fut.M_INS_MODE
when 0 then rtrim(ins.M_INSTR)
when 1 then rtrim(ind.M_IND_LAB) else null end
when fut.M_LISTED in (64) then 
case fut.M_OSPRD_TYP
when 0 then rtrim(ufut.M_LABEL)
when 1 then rtrim(ufut.M_LABEL)||' - '||rtrim(ufut2.M_LABEL) 
when 2 then  
case fut.M_BENCHMARK
when 0 then 'Near - Far, Shift: '||to_char(fut.M_MAT_SPRD)
when 1 then 'Far - Near, Shift: '||to_char(fut.M_MAT_SPRD) end
else null end 
else null end as INSTRUMENT,
-- coalesce(mgen.M_REFERENCE, ins.M_GEN_NUM) INS_REF,
-- coalesce(ind.M_REFERENCE, genind0.M_REFERENCE) IND_REF,
coalesce(
case  ind.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end,
case  genind0.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end) IND_TYP,
coalesce(rtrim(ind.M_IND_LAB), rtrim(genind0.M_IND_LAB)) IND,
-- coalesce(und.M_REFERENCE, genund0.M_REFERENCE) UND_REF,
coalesce(
case  und.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end,
case  genund0.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end,
case  ind.M_RESET
when 0 then 'Spot'
when 3 then 'Average'
when 4 then 'Basket'
when 6 then 'Nearby' end) UND_TYP,
coalesce(rtrim(und.M_IND_LAB), rtrim(genund0.M_IND_LAB), rtrim(ind.M_IND_LAB)) UND,
coalesce(rtrim(cmu.M_LABEL), rtrim(gencmu0.M_LABEL), rtrim(cmi.M_LABEL)) UND_CM,
coalesce(rtrim(undqot.M_TRAD_SMB), rtrim(undqot0.M_TRAD_SMB), rtrim(indqot.M_TRAD_SMB)) PRACOD,
rtrim(dgffut.M_DGMODEL) DGFFUT,
rtrim(dghfut.M_DGPUBLICAT) DGHPUB,
rtrim(dghfut.M_DGMODEL) DGHFUT,
coalesce(rtrim(dgfund.M_DGMODEL), rtrim(dgfund0.M_DGMODEL)) DGFUND,
coalesce(rtrim(dghund.M_DGMODEL), rtrim(dghund0.M_DGMODEL)) DGHUND

from CM_FUT_DBF fut
left join TRN_PC_DBF pc on 1 = 1 
left join CM_ASSET_DBF ass on fut.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE
left join CMC_QUOT_DBF qotf on fut.M_QUOT_FWD = qotf.M_REFERENCE
left join CM_FMAT_DBF fmat on fut.M_FUT_MAT = fmat.M_REFERENCE
left join CMC_QUOT_DBF qot on fut.M_QUOT_SET = qot.M_SET
left join CM_UNIT_DBF uniq on qot.M_UNIT = uniq.M_REFERENCE
left join CM_UNIT_DBF unid on qot.M_QTY_UNIT = unid.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI= pub.M_REFERENCE 
-- Simple
left join CMC_MGEN_DBF mgen on fut.M_CM_INSTR = mgen.M_REFERENCE and fut.M_LISTED in (1,2,16,32)
left join RT_INDEX_DBF ind on mgen.M_INDEX = ind.M_INDEX
left join RT_INDEX_DBF und on ind.M_UNDRL = und.M_INDEX
left join CM_INDEX_DBF cmi on ind.M_COM_IND = cmi.M_REFERENCE
left join CMC_QUOT_DBF indqot on ind.M_COM_QUOT = indqot.M_REFERENCE
left join CM_INDEX_DBF cmu on und.M_COM_IND = cmu.M_REFERENCE
left join CMC_QUOT_DBF undqot on und.M_COM_QUOT = undqot.M_REFERENCE
left join CM_PHYS_DBF indphy on cmi.M_PHYSICAL = indphy.M_REFERENCE
left join CM_PHYS_DBF undphy on cmu.M_PHYSICAL = undphy.M_REFERENCE
-- Custom
left join RT_INSGN_DBF ins on fut.M_CM_INSTR = ins.M_GEN_NUM
left join RT_LNGN_DBF gen on ins.M_GEN_NUM = gen.M_GEN_NUM
left join RT_INDEX_DBF genind0 on gen.M_INDEX0 = genind0.M_INDEX
left join RT_INDEX_DBF genund0 on genind0.M_UNDRL = genund0.M_INDEX
left join CM_INDEX_DBF gencmu0 on genund0.M_COM_IND = gencmu0.M_REFERENCE
left join CMC_QUOT_DBF undqot0 on genund0.M_COM_QUOT = undqot0.M_REFERENCE
left join CM_PHYS_DBF undphy0 on gencmu0.M_PHYSICAL = undphy0.M_REFERENCE
-- Option
left join CM_FUT_DBF ufut  on fut.M_CM_INSTR = ufut.M_REFERENCE and fut.M_LISTED in (64)
left join CM_FUT_DBF ufut2 on fut.M_CONTRACT2 = ufut2.M_REFERENCE and fut.M_LISTED in (64)
left join RT_GROUP_DBF grp on (to_char(fut.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,1,10)) and to_char(qot.M_REFERENCE) = trim(substr(grp.M_GRP_DESC,11,15))) and rtrim(pub.M_CALENDAR) = rtrim(grp.M_CALENDAR)
left join TRN_PLIN_DBF plin on rtrim(fut.M_LABEL) = rtrim(plin.M_DSP_LABEL)
-- Keys
left join UDTB237_DBF dgffut on rtrim(fut.M_LABEL) = rtrim(dgffut.M_DGMXLABEL) and rtrim(dgffut.M_DGPTYPE) = 'COM_FUT'
left join UDTB237_DBF dgfund on rtrim(und.M_IND_LAB) = rtrim(dgfund.M_DGGENERAT) and rtrim(dgfund.M_DGPTYPE) = 'COM_SWAP'
left join UDTB237_DBF dgfund0 on rtrim(genund0.M_IND_LAB) = rtrim(dgfund0.M_DGGENERAT) and rtrim(dgfund0.M_DGPTYPE) = 'COM_SWAP'
left join UDTB274_DBF dghfut on rtrim(fut.M_LABEL) = rtrim(dghfut.M_DGMXLABEL) and rtrim(dghfut.M_DGPTYPE) = 'COM_FUT_FIXING'
left join UDTB274_DBF dghund on rtrim(cmu.M_LABEL) = rtrim(dghund.M_DGMXLABEL) and rtrim(dghund.M_DGPTYPE) = 'COM_SIND_FIXING'
left join UDTB274_DBF dghund0 on rtrim(gencmu0.M_LABEL) = rtrim(dghund0.M_DGMXLABEL) and rtrim(dghund0.M_DGPTYPE) = 'COM_SIND_FIXING'
left join KEYMAP_STC_DBF alturl on fut.M_REFERENCE = alturl.M_OBJ_ID and alturl.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898','MpHvX56898','McPlm56897') and rtrim(substr(alturl.M_OBJ_ASYS,5,3)) = 'URL'
left join KEYMAP_STC_DBF altcom on fut.M_REFERENCE = altcom.M_OBJ_ID and altcom.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898') and rtrim(altcom.M_OBJ_ASYS) = 'COMMODITY'
left join KEYMAP_STC_DBF altmkt on fut.M_REFERENCE = altmkt.M_OBJ_ID and altmkt.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898') and rtrim(altmkt.M_OBJ_ASYS) = 'MARKET'
left join KEYMAP_STC_DBF altins on fut.M_REFERENCE = altins.M_OBJ_ID and altins.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898') and rtrim(altins.M_OBJ_ASYS) = 'INSTRUMENT'
-- left join KEYMAP_STC_DBF altinsfut on fut.M_REFERENCE = altinsfut.M_OBJ_ID and altinsfut.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898') and rtrim(altinsfut.M_OBJ_ASYS) = 'INSTRUMENT_FUT'
-- left join KEYMAP_STC_DBF altinsfwd on fut.M_REFERENCE = altinsfwd.M_OBJ_ID and altinsfwd.M_OBJ_CLASS in ('MwOJI56899', 'MfHrf56898') and rtrim(altinsfwd.M_OBJ_ASYS) = 'INSTRUMENT_FWD'

where 1 = 1 
and fut.M_COMMENT0 not in ('Dummy','Obsolete')
and fut.M_LISTED in (1, 2, 64)
-- and ind.M_COM_QUOT in (718, 720, 721, 729, 730)
-- substr(fut.M_LABEL,1,3) = 'FRT'

order by rtrim(atp.M_LABEL), ASSET, PHYS, fut.M_LISTED, LABEL