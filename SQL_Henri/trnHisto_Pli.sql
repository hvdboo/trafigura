select
pli.M_FINASS    ASS,
trn.M_TRN_FMLY  FML,
trn.M_TRN_GRP   GRP,
trn.M_TRN_TYPE  TYP,
trn.M_TRN_GTYPE FGT,
case  
when trn.M_TRN_GTYPE in (31,47,49,50,69,76,80,100,101,146) then 'LST' else 'OTC' end LO,
rtrim(ins.M_DSP_LABEL) INSLAB,
pli.M_PUBLAB PUBLAB,
pli.M_PUBMIC PUBMIC,
pli.M_CNTSYM CNTSYM,
count(case when trn.M_TRN_STATUS in ('LIVE','MKT_OP') then 1 else null end) LIVE, 
count(case when trn.M_TRN_STATUS = 'DEAD' then 1 else null end) DEAD,
count(*) OCC,
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT

from TRN_HDR_DBF trn
cross join (select M_DATE from TRN_PC_DBF where ROWNUM = 1) pc
left join TRN_PLIN_DBF  ins on trn.M_INSTRUMENT = ins.M_REFERENCE
left join VIW_PLI_DBF   pli on ins.M_ID = pli.M_PLIUID
--left join LST_PREFV_DBF prfpli on rtrim(ins.M_DSP_LABEL) = rtrim(prfpli.M_VALUE) and rtrim(prfpli.M_VALUE) is not null

where 1 = 1
-- and trn.M_TRN_STATUS in ('LIVE','MKT_OP')
--and rtrim(prfpli.M_INDEX2) in (142, 145, 151, 152, 160, 161, 162, 163, 164, 170, 171, 173, 174, 191, 195, 196, 201, 202)
and pli.M_PRFLST in
(
'TRAF_INCL_AGS',
'TRAF_INCL_BMT',
'TRAF_INCL_BND',
'TRAF_INCL_CHE',
'TRAF_INCL_COAL',
'TRAF_INCL_CRD',
'TRAF_INCL_EMI',
'TRAF_INCL_EQD',
'TRAF_INCL_FMT',
'TRAF_INCL_FRB',
'TRAF_INCL_FRW',
'TRAF_INCL_FXC',
'TRAF_INCL_FXD',
'TRAF_INCL_GAS',
'TRAF_INCL_IRD',
'TRAF_INCL_OIL',
'TRAF_INCL_PMT',
'TRAF_INCL_REC',
'TRAF_INCL_RFC'
)

group by
pli.M_FINASS,
trn.M_TRN_FMLY,
trn.M_TRN_GRP,
trn.M_TRN_TYPE,
trn.M_TRN_GTYPE,
rtrim(ins.M_DSP_LABEL),
pli.M_PUBLAB,
pli.M_PUBMIC,
pli.M_CNTSYM,
to_char(pc.M_DATE,'YYYY-MM-DD')

order by ASS, INSLAB
