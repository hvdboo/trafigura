select 
rtrim(plin.M_DSP_LABEL) PL_INS,
rtrim(insgen.M_INSTR) GEN_INS,
case insgen.M_INSTR_TYPE
when 12 then 'Asian'
when 13 then 'Swap'
when 27 then 'Phy.Fwd' else null end INSTYP,
gen.M_GEN_NUM GEN, 
insgen.M_CREAT_MODE CREA,
rtrim(ind0.M_IND_LAB) IND0, 
und0.M_INDEX, und0.M_REFERENCE,
rtrim(pub0.M_LABEL) UNDPUB0,
rtrim(und0.M_IND_LAB) UNDLAB0,
rtrim(hsr0.M_LABEL) UNDHSR0,
rtrim(und0.M_HISFILE) UNDHIS0,
rtrim(ndxind0.M_FX_GROUP) NDXPUB0,
rtrim(ndxind0.M_IND_LAB) NDXIND0,
rtrim(ndxind0.M_COL_CODE) NDXHSR0,
rtrim(ndxind0.M_HISFILE) NDXHIS0,
rtrim(ind1.M_IND_LAB) IND1,
rtrim(pub1.M_LABEL) UNDPUB1,
rtrim(und1.M_IND_LAB) UNDLAB1,
rtrim(und1.M_HISFILE) UNDHIS1,
rtrim(hsr1.M_LABEL) UNDHSR1,
rtrim(ndxind1.M_FX_GROUP) NDXPUB1,
rtrim(ndxind1.M_IND_LAB) NDXIND1,
rtrim(ndxind1.M_COL_CODE) NDXHSR1,
rtrim(ndxind1.M_HISFILE) NDXHIS1,
count(*) OCC

from RT_LNGN_DBF gen
left join RT_INSGN_DBF insgen on gen.M_GEN_NUM = insgen.M_GEN_NUM 
left join RT_LOAN_DBF loan on gen.M_GEN_NUM = loan.M_GEN_NUM
left join TRN_HDR_DBF trn on loan.M_NB = trn.M_NB
left join TRN_PLIN_DBF plin on trn.M_INSTRUMENT = plin.M_REFERENCE
left join RT_INDEX_DBF ind0 on gen.M_INDEX0 = ind0.M_INDEX
left join RT_INDEX_DBF und0 on ind0.M_UNDRL=und0.M_INDEX
left join CM_MKTSR_DBF hsr0 on rtrim(substr(gen.M_FORMULA0,2,10)) = to_char(hsr0.M_SERIE)
left join CM_MKT_DBF pub0 on hsr0.M_REFERENCE = pub0.M_REFERENCE
left join RT_INDEX_DBF ind1 on gen.M_INDEX1 = ind1.M_INDEX
left join RT_INDEX_DBF und1 on ind1.M_UNDRL=und1.M_INDEX
left join CM_MKTSR_DBF hsr1 on rtrim(substr(gen.M_FORMULA1,2,10)) = to_char(hsr1.M_SERIE)
left join CM_MKT_DBF pub1 on hsr1.M_REFERENCE = pub1.M_REFERENCE
left join RT_LNDXGL_DBF ndxl0 on (gen.M_REFERENCE = ndxl0.M_REF_LOAN_GENERATOR and gen.M_INDEXED0 = 1)
left join RT_LNDXG_DBF ndxi0 on ndxl0.M_REF_INDEXATION_TEMPL = ndxi0.M_REFERENCE
left join RT_INDEX_DBF ndxind0 on ndxi0.M_INDEX = ndxind0.M_INDEX
left join RT_LNDXGL_DBF ndxl1 on (gen.M_REFERENCE = ndxl1.M_REF_LOAN_GENERATOR and gen.M_INDEXED1 = 1)
left join RT_LNDXG_DBF ndxi1 on ndxl1.M_REF_INDEXATION_TEMPL = ndxi1.M_REFERENCE
left join RT_INDEX_DBF ndxind1 on ndxi1.M_INDEX = ndxind1.M_INDEX

where trn.M_TRN_GTYPE in (100, 101, 102, 103, 130, 131, 146, 154) 
-- and trn.M_TRN_STATUS <> 'DEAD'

group by 
plin.M_DSP_LABEL,
insgen.M_INSTR,
insgen.M_INSTR_TYPE,
gen.M_GEN_NUM, 
insgen.M_CREAT_MODE,
rtrim(ind0.M_IND_LAB), 
und0.M_INDEX, und0.M_REFERENCE,
rtrim(pub0.M_LABEL),
rtrim(und0.M_IND_LAB),
rtrim(hsr0.M_LABEL),
rtrim(und0.M_HISFILE),
rtrim(ndxind0.M_FX_GROUP),
rtrim(ndxind0.M_IND_LAB),
rtrim(ndxind0.M_COL_CODE),
rtrim(ndxind0.M_HISFILE),
rtrim(ind1.M_IND_LAB),
rtrim(pub1.M_LABEL),
rtrim(und1.M_IND_LAB),
rtrim(und1.M_HISFILE),
rtrim(hsr1.M_LABEL),
rtrim(ndxind1.M_FX_GROUP),
rtrim(ndxind1.M_IND_LAB),
rtrim(ndxind1.M_COL_CODE),
rtrim(ndxind1.M_HISFILE)

order by PL_INS
