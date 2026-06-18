select 
TYP.M_LABEL,
STS.M_GI_DATE as M_GI_DATE, -- Last accounting date at which occured intrinsic generation
count(STS.M_GI_DONE) as M_GI_DONE , --Is intrinsic accounting entries generation completed? -- completed: 1 /not completed: 0
STS.M_GR_DATE as M_GR_DATE,  ---Last accounting date at which occured revaluation generation
count(STS.M_GR_DONE) as M_GR_DONE   --Is revaluation accounting entries generation completed? -- completed: 1 /not completed: 0

from 
ACG_TRD_GEN_STS_DBF STS,
TRN_HDR_DBF TRN,
TYPOLOGY_DBF TYP
where STS.M_GR_DONE=0 and STS.M_TRADE in (select M_NB from trn_hdr_dbf where M_TYPOLOGY='1402') -- 1402 = BackPricing
and STS.M_TRADE=TRN.M_NB
and TRN.M_TYPOLOGY=TYP.M_REFERENCE
group by TYP.M_LABEL,STS.M_GI_DATE ,STS.M_GR_DATE
