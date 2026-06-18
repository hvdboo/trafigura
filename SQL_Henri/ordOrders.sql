select 
rtrim(claord.M_NAME) ORDCLA, ord.M_REFERENCE ORD_ID, 
case M_DST_TYPE
when 0 then 'CTP'
when 1 then 'PFL' else null end IE,
rtrim(pfl.M_LABEL) SRC,
case 
when trn.M_BINTERNAL = trn.M_SINTERNAL  then rtrim(pfldst.M_LABEL)
when trn.M_BINTERNAL <> trn.M_SINTERNAL then rtrim(ctpdst.M_DSP_LABEL)
else null end DST,
ord.M_QTY_ALL QTY_AON,
case ord.M_DURATION
when 0 then 'GTC'
when 1 then 'DAY'
when 2 then 'GTD'
when 3 then 'IMM' else null end DURATION,
ord.M__DT_EXPD EXP,
ord.M_CALL_ORDER CALLORD, 
rtrim(otp.M_LABEL) ORDTPL,
ocmp.M_QTY_AMOUNT QTY, ocmp.M_PRC_LIMIT PRC_LIM, 
rtrim(clacmp.M_NAME) CMPCLA, substr(rtrim(clapur.M_NAME),26,30) PURP,
rtrim(typo.M_LABEL) TYPO, rtrim(plin.M_DSP_LABEL) INSTRUM,
cnt.M_REFERENCE CNT, 
trn.M_NB TRN, trn.M_GID GID,
rtrim(clascr.M_NAME) SCRIPT,
rtrim(scrsta.M_VALUE) SCRSTA

from ORDER_DBF ord
left join CLASS_MAPPING_DBF claord on ord.M__INTID_ = claord.M_ID 
left join TRN_PFLD_DBF pfl on ord.M_SRC_PTF = pfl.M_REF
left join ORD_TPL_DBF otp on ord.M_TPL = otp.M_REFERENCE
left join ORDERCMP_DBF ocmp on ord.M_REFERENCE = ocmp.M_REFERENCE
left join CLASS_MAPPING_DBF clacmp on ocmp.M_BO_CLASS = clacmp.M_ID
left join ORD_SCRIPT_DBF scr on ocmp.M_ACTION = scr.M_REFERENCE
left join CLASS_MAPPING_DBF clascr on scr.M__INTID_ = clascr.M_ID
left join ORD_SCRIPT_STATUS_DBF scrsta on ocmp.M_ACTION = scrsta.M_CTN
left join CONTRACT_DBF cnt on ocmp.M_BO_REF = cnt.M_REFERENCE
left join CONTRACT_DBF cnt on ocmp.M_BO_REF = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_HDR_DBF trn on cnt.M_REFERENCE = trn.M_CONTRACT
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join CLASS_MAPPING_DBF clapur on trn.M_PURPOSE = clapur.M_ID
left join TRN_PFLD_DBF pfldst on trn.M_DST_PFOLIO = pfldst.M_REF
left join TRN_CPDF_DBF ctpdst on trn.M_COUNTRPART = ctpdst.M_ID

where  
-- ord.M_REFERENCE = 215941
-- cnt.M_REFERENCE = 2283109
trn.M_NB = 14994826