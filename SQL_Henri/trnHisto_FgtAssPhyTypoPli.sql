select 
rtrim(trn.M_TRN_FMLY)   FML,
rtrim(atp.M_LABEL)      ASSTYP,
rtrim(ass.M_LABEL)      ASSLAB,
rtrim(phy.M_LABEL)      PHYLAB,
trn.M_TRN_GTYPE         FGT,
rtrim(trn.M_TRN_GRP)    GRP,
rtrim(trn.M_TRN_TYPE)   TYP,
--typo.M_REFERENCE        TYPOID,
rtrim(typo.M_LABEL)     TYPO,
rtrim(pli.M_FMLY_LBL)   PLIFML,
pli.M_ID                PLIUID,
rtrim(pli.M_LABEL)      PLILAB,
rtrim(pli.M_DSP_LABEL)  PLIDES,
sum(case when trn.M_TRN_STATUS not in ('DEAD') then 1 else null end) LIVE,
sum(case when trn.M_TRN_STATUS in     ('DEAD') then 1 else null end) DEAD,
count(*) OCC

from TRN_HDR_DBF trn
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join TYPOLOGY_DBF typo on cnt.M_TYPOLOGY = typo.M_REFERENCE
left join TRN_PLIN_DBF   pli on trn.M_INSTRUMENT = pli.M_REFERENCE
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE) and rtrim(trn.M_TRN_FMLY) = 'COM'
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE
left join CM_PHYS_DBF  phy on plk.M_PRODUCT = phy.M_REFERENCE
left join LST_PREFV_DBF prfpli on rtrim(pli.M_DSP_LABEL) = rtrim(prfpli.M_VALUE) and prfpli.M_INDEX2 in 
(
142, --TRAF_INCL_OIL  [6]
145, --TRAF_INCL_GAS  [3,4,20]
151, --TRAF_INCL_COAL [17]
152, --TRAF_INCL_CHE  [21]
160, --TRAF_INCL_EMI  [13]
161, --TRAF_INCL_PMT  [11]
162, --TRAF_INCL_FMT  [19]
163, --TRAF_INCL_BMT  [2]
164, --TRAF_INCL_AGS  [14]
170, --TRAF_INCL_FRW  [22]
171, --TRAF_INCL_FRB  [12]
173, --TRAF_INCL_EQD  [EQD]
174, --TRAF_INCL_IRD  [IRD]
191, --TRAF_INCL_RFC  [23]
195, --TRAF_INCL_FXD  [CURR|FUT]
196, --TRAF_INCL_FXC  [CURR|FXD]
200, --TRAF_INCL_CRD  [CDS]
201  --TRAF_INCL_BND  [BND]
)
left join LST_PREFH_DBF prflst on prfpli.M_INDEX2 = prflst.M_INDEX

where 1 = 1
and trn.M_MOP_LAST not in (6,7)
and rtrim(prfpli.M_VALUE) is not null 

group by
rtrim(trn.M_TRN_FMLY),
rtrim(atp.M_LABEL),
rtrim(ass.M_LABEL),
rtrim(phy.M_LABEL),
trn.M_TRN_GTYPE,
rtrim(trn.M_TRN_GRP),
rtrim(trn.M_TRN_TYPE),
--typo.M_REFERENCE,
rtrim(typo.M_LABEL),
rtrim(pli.M_FMLY_LBL),
pli.M_ID,
rtrim(pli.M_LABEL),
rtrim(pli.M_DSP_LABEL)

order by FML, ASSTYP, ASSLAB, PHYLAB, GRP, TYP, TYPO, PLIDES
