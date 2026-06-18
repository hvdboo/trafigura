select 
trn.M_NB TRN,
rtrim(trn.M_TRN_STATUS) STAT,
rtrim(typo.M_LABEL) CNT_TYPO,
trn.M_TRN_FMLY FML,
trn.M_TRN_GRP  GRP,
trn.M_TRN_TYPE TYP,
trn.M_TRN_GTYPE GTYP,
trn.M_INSTRUMENT INS_REF,
rtrim(plin.M_DSP_LABEL) INS_LAB, -- rtrim(plin.M_DESC) INS_DES,
rtrim(trn.M_MKT_INDEX) MKTNDX, 
rtrim(indmkt.M_IND_LAB) MKT_INDLAB,
to_char(trn.M_TRN_EXP,'YYYY-MM-DD') EXP,
rtrim(ind0.M_IND_LAB) IND0,
case ind0.M_RESET
when 0 then (indcm0.M_LABEL)
when 3 then (und0.M_IND_LAB)
when 6 then (fut0.M_LABEL) else null end UND0,
rtrim(hsr0.M_LABEL) HSR0,
rtrim(ind1.M_IND_LAB) IND1,
case ind1.M_RESET
when 0 then (indcm1.M_LABEL)
when 3 then (und1.M_IND_LAB)
when 6 then (fut1.M_LABEL) else null end UND1,
rtrim(hsr1.M_LABEL) HSR1

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join SRC_MOD_DBF src on cnt.M_SRC_MODULE = src.M_REFERENCE 
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join RT_INDEX_DBF indmkt on trn.M_MKT_INDEX = indmkt.M_INDEX
left join RT_LOAN_DBF loan on trn.M_NB = loan.M_NB
left join RT_LNGN_DBF gen on loan.M_GEN_NUM = gen.M_GEN_NUM
left join RT_INDEX_DBF ind0 on gen.M_INDEX0 = ind0.M_INDEX
left join RT_INDEX_DBF ind1 on gen.M_INDEX1 = ind1.M_INDEX
left join CM_INDEX_DBF indcm0 on ind0.M_COM_IND = indcm0.M_REFERENCE
left join CM_INDEX_DBF indcm1 on ind1.M_COM_IND = indcm1.M_REFERENCE
left join CM_FUT_DBF fut0 on ind0.M_COM_FUT = fut0.M_REFERENCE
left join CM_FUT_DBF fut1 on ind1.M_COM_FUT = fut1.M_REFERENCE
left outer join RT_INDEX_DBF und0 on ind0.M_UNDRL = und0.M_INDEX
left outer join RT_INDEX_DBF und1 on ind1.M_UNDRL = und1.M_INDEX
left join CM_MKTSR_DBF hsr0 on to_number(trim(substr(gen.M_FORMULA0,2,10))) = hsr0.M_SERIE
left join CM_MKTSR_DBF hsr1 on to_number(trim(substr(gen.M_FORMULA1,2,10))) = hsr1.M_SERIE

where 
trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_TRN_GTYPE in (113, 130, 131, 134, 154)
and substr(plin.M_DSP_LABEL,1,2) = 'AU'
and rtrim(hsr1.M_LABEL) = 'MEAN'
and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') > '2018-12-31'
and to_char(trn.M_TRN_EXP,'YYYY-MM-DD') < '2019-02-01'