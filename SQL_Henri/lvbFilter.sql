select
rtrim(lvbflt.M_LABEL) FLTLAB,
rtrim(lvbflt.M_DESC) FLTDES,
case flttyp.M__INTID_
when 'MsYJh65287' then 'FGT' 
when 'MfCHg63257' then 'INS' else null end FTTYP,
case flttyp.M__INTID_
when 'MsYJh65287' then rtrim(fltfgt.M_LABEL) 
when 'MfCHg63257' then rtrim(ins.M_DSP_LABEL) else null end FLTVAL,
case flttyp.M__INTID_
when 'MsYJh65287' then fltfgt.M_TYPE_ID 
when 'MfCHg63257' then fltins.M_PL_INSTR_REF else null end VALID

from LIVEBOOK_FLTRS_DBF flttyp
left join LIVEBOOK_FILTER_SET_DBF lvbflt on flttyp.M_CTN = lvbflt.M_REFERENCE
left join LIVEBOOK_TRN_TYPE_DBF fltfgt   on flttyp.M_REF = fltfgt.M_FILTER_REF
left join LIVEBOOK_PL_INST_DBF fltins    on flttyp.M_REF = fltins.M_FILTER_REF
left join TRN_PLIN_DBF ins on fltins.M_PL_INSTR_REF = ins.M_ID