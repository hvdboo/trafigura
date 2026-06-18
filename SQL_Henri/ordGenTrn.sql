select 
ord.M_REFERENCE ORD, 
trn.M_NB TRN, 
rtrim(trn.M_PURPOSE) PURPCLA, 
rtrim(substr(cla.M_NAME,26,20)) PURPLAB,
gentrn.M_TRADE_ORIG_REF 

from ORDER_DBF ord
left outer join ORDERCMP_DBF ordcmp on ordcmp.M_ORD_REF = ord.M_REFERENCE
left outer join ORDER_TRADE_ORIGIN_DBF gentrn on (ord.M_REFERENCE = gentrn.M_ORDER_REF)
left outer join PACKAGE_DBF  pck on (pck.M_REFERENCE = ordcmp.M_BO_REF) and (pck.M__INTID_ = ordcmp.M_BO_CLASS)
left outer join CONTRACT_DBF cnt on ((cnt.M_REFERENCE = ordcmp.M_BO_REF) and (cnt.M__INTID_ = ordcmp.M_BO_CLASS)) or ((cnt.M_PACK_REF = pck.M_REFERENCE) and (cnt.M_PACK_INTID = pck.M__INTID_))
left outer join TRN_HDR_DBF  trn on (trn.M_CONTRACT = cnt.M_REFERENCE)
left join CLASS_MAPPING_DBF cla on rtrim(trn.M_PURPOSE) = rtrim(cla.M_ID)
where trn.M_PURPOSE != 'MeHzv70053'
