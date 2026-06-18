select 
case 
PROD = 'Canola'      and FILL = 'Future' then rtrim(canola_fut.M_LABEL)
PROD = 'Canola'      and FILL = 'Option' then rtrim(canola_opt.M_LABEL)
PROD = 'Cocoa'       and FILL = 'Future' then rtrim(cocNYC_fut.M_LABEL)
PROD = 'Cocoa'       and FILL = 'Option' then rtrim(cocNYC_opt.M_LABEL)
PROD = 'C'           and FILL = 'Future' then rtrim(cocLDN_fut.M_LABEL)
PROD = 'C'           and FILL = 'Option' then rtrim(cocLDN_opt.M_LABEL)
PROD = 'Coffee C'    and FILL = 'Future' then rtrim(cofNYC_fut.M_LABEL)
PROD = 'Coffee C'    and FILL = 'Option' then rtrim(cofNYC_opt.M_LABEL)
PROD = 'RC'          and FILL = 'Future' then rtrim(cofLDN_fut.M_LABEL)
PROD = 'RC'          and FILL = 'Option' then rtrim(cofLDN_opt.M_LABEL)
PROD = 'ZC'          and FILL = 'Future' then rtrim(cornCHI_fut.M_LABEL)
PROD = 'OZC'         and FILL = 'Option' then rtrim(cornCHI_opt.M_LABEL)
PROD = 'yEMA'        and FILL = 'Future' then rtrim(cornPAR_fut.M_LABEL)
PROD = 'yOMA'        and FILL = 'Option' then rtrim(cornPAR_opt.M_LABEL)
PROD = 'Cotton No 2' and FILL = 'Future' then rtrim(cott_fut.M_LABEL)
PROD = 'Cotton No 2' and FILL = 'Option' then rtrim(cott_opt.M_LABEL)
PROD = 'FCOJ A'      and FILL = 'Future' then rtrim(fcoj_fut.M_LABEL)
PROD = 'FCOJ A'      and FILL = 'Option' then rtrim(fcoj_opt.M_LABEL)
PROD = 'yECO'        and FILL = 'Future' then rtrim(rapsPAR_fut.M_LABEL)
PROD = 'yOCO'        and FILL = 'Option' then rtrim(rapsPAR_opt.M_LABEL)
PROD = 'ZS'          and FILL = 'Future' then rtrim(soybCHI_fut.M_LABEL)
PROD = 'OZS'         and FILL = 'Option' then rtrim(soybCHI_opt.M_LABEL)
PROD = 'ZM'          and FILL = 'Future' then rtrim(soymCHI_fut.M_LABEL)
PROD = 'OZM'         and FILL = 'Option' then rtrim(soymCHI_opt.M_LABEL)
PROD = 'ZL'          and FILL = 'Future' then rtrim(soyoCHI_fut.M_LABEL)
PROD = 'OZL'         and FILL = 'Option' then rtrim(soyoCHI_opt.M_LABEL)
PROD = 'Sugar No 11' and FILL = 'Future' then rtrim(sug11_fut.M_LABEL)
PROD = 'Sugar No 11' and FILL = 'Option' then rtrim(sug11_opt.M_LABEL)
PROD = 'Sugar No 16' and FILL = 'Future' then rtrim(sug16_fut.M_LABEL)
PROD = 'Sugar No 16' and FILL = 'Option' then rtrim(sug16_opt.M_LABEL)
PROD = 'W'           and FILL = 'Future' then rtrim(sugwhi_fut.M_LABEL)
PROD = 'W'           and FILL = 'Option' then rtrim(sugwhi_opt.M_LABEL)
PROD = 'ZW'          and FILL = 'Future' then rtrim(whtCHI_fut.M_LABEL)
PROD = 'OZW'         and FILL = 'Option' then rtrim(whtCHI_opt.M_LABEL)
PROD = 'T'           and FILL = 'Future' then rtrim(whtLDN_fut.M_LABEL)
PROD = 'T'           and FILL = 'Option' then rtrim(whtLDN_opt.M_LABEL)
PROD = 'KE'          and FILL = 'Future' then rtrim(whtKC_fut.M_LABEL)
PROD = 'OKE'         and FILL = 'Option' then rtrim(whtKC_opt.M_LABEL)
PROD = 'MW'          and FILL = 'Future' then rtrim(whtMIN_fut.M_LABEL)
PROD = 'OMW'         and FILL = 'Option' then rtrim(whtMIN_opt.M_LABEL)
PROD = 'yEBM'        and FILL = 'Future' then rtrim(whtPAR_fut.M_LABEL)
PROD = 'yOBM'        and FILL = 'Option' then rtrim(whtPAR_opt.M_LABEL)
from TT_DBF tt
left join CM_FMAT1_DBF canola_fut  on upper(TT.MAT) = substring(canola_fut.M_LABEL,1,6) and canola_fut.M_FMATID = 232
left join CM_OMAT1_DBF canola_opt  on upper(TT.MAT) = substring(canola_opt.M_LABEL,1,6) and canola_opt.M_OMATID = 82
left join CM_FMAT1_DBF cocNYC_fut  on upper(TT.MAT) = substring(cocNYC_fut.M_LABEL,1,6) and cocNYC_fut.M_FMATID = 64
left join CM_OMAT1_DBF cocNYC_opt  on upper(TT.MAT) = substring(cocNYC_opt.M_LABEL,1,6) and cocNYC_opt.M_OMATID = 67
left join CM_FMAT1_DBF cocLDN_fut  on upper(TT.MAT) = substring(cocLDN_fut.M_LABEL,1,6) and cocLDN_fut.M_FMATID = 235
left join CM_OMAT1_DBF cocLDN_opt  on upper(TT.MAT) = substring(cocLDN_opt.M_LABEL,1,6) and cocLDN_opt.M_OMATID = 85
left join CM_FMAT1_DBF cofNYC_fut  on upper(TT.MAT) = substring(cofNYC_fut.M_LABEL,1,6) and cofNYC_fut.M_FMATID = 21
left join CM_OMAT1_DBF cofNYC_opt  on upper(TT.MAT) = substring(cofNYC_opt.M_LABEL,1,6) and cofNYC_opt.M_OMATID = 66
left join CM_FMAT1_DBF cofLDN_fut  on upper(TT.MAT) = substring(cofLDN_fut.M_LABEL,1,6) and cofLDN_fut.M_FMATID = 234
left join CM_OMAT1_DBF cofLDN_opt  on upper(TT.MAT) = substring(cofLDN_opt.M_LABEL,1,6) and cofLDN_opt.M_OMATID = 84
left join CM_FMAT1_DBF cornCHI_fut on upper(TT.MAT) = substring(cornCHI_fut.M_LABEL,1,6) and cornCHI_fut.M_FMATID = 30
left join CM_OMAT1_DBF cornCHI_opt on upper(TT.MAT) = substring(cornCHI_opt.M_LABEL,1,6) and cornCHI_opt.M_OMATID = 34
left join CM_FMAT1_DBF cornPAR_fut on upper(TT.MAT) = substring(cornPAR_fut.M_LABEL,1,6) and cornPAR_fut.M_FMATID = 231
left join CM_OMAT1_DBF cornPAR_opt on upper(TT.MAT) = substring(cornPAR_opt.M_LABEL,1,6) and cornPAR_opt.M_OMATID = 81
left join CM_FMAT1_DBF cott_fut    on upper(TT.MAT) = substring(cott_fut.M_LABEL,1,6) and cott_fut.M_FMATID = 65
left join CM_OMAT1_DBF cott_opt    on upper(TT.MAT) = substring(cott_opt.M_LABEL,1,6) and cott_opt.M_OMATID = 62
left join CM_FMAT1_DBF fcoj_fut    on upper(TT.MAT) = substring(fcoj_fut.M_LABEL,1,6) and fcoj_fut.M_FMATID = 236
left join CM_OMAT1_DBF fcoj_opt    on upper(TT.MAT) = substring(fcoj_opt.M_LABEL,1,6) and fcoj_opt.M_OMATID = 86
left join CM_FMAT1_DBF rapsPAR_fut on upper(TT.MAT) = substring(rapsPAR_fut.M_LABEL,1,6) and rapsPAR_fut.M_FMATID = 217
left join CM_OMAT1_DBF rapsPAR_opt on upper(TT.MAT) = substring(rapsPAR_opt.M_LABEL,1,6) and rapsPAR_opt.M_OMATID = 69
left join CM_FMAT1_DBF soybCHI_fut on upper(TT.MAT) = substring(soybCHI_fut.M_LABEL,1,6) and soybCHI_fut.M_FMATID = 28
left join CM_OMAT1_DBF soybCHI_opt on upper(TT.MAT) = substring(soybCHI_opt.M_LABEL,1,6) and soybCHI_opt.M_OMATID = 40
left join CM_FMAT1_DBF soymCHI_fut on upper(TT.MAT) = substring(soymCHI_fut.M_LABEL,1,6) and soymCHI_fut.M_FMATID = 69
left join CM_OMAT1_DBF soymCHI_opt on upper(TT.MAT) = substring(soymCHI_opt.M_LABEL,1,6) and soymCHI_opt.M_OMATID = 59
left join CM_FMAT1_DBF soyoCHI_fut on upper(TT.MAT) = substring(soyoCHI_fut.M_LABEL,1,6) and soyoCHI_fut.M_FMATID = 29
left join CM_OMAT1_DBF soyoCHI_opt on upper(TT.MAT) = substring(soyoCHI_opt.M_LABEL,1,6) and soyoCHI_opt.M_OMATID = 41
left join CM_FMAT1_DBF sug11_fut   on upper(TT.MAT) = substring(sug11_fut.M_LABEL,1,6) and sug11_fut.M_FMATID = 68
left join CM_OMAT1_DBF sug11_opt   on upper(TT.MAT) = substring(sug11_opt.M_LABEL,1,6) and sug11_opt.M_OMATID = 35
left join CM_FMAT1_DBF sug16_fut   on upper(TT.MAT) = substring(sug16_fut.M_LABEL,1,6) and sug16_fut.M_FMATID = 108
--left join CM_OMAT1_DBF sug16_opt on upper(TT.MAT) = substring(sug16_opt.M_LABEL,1,6) and sug16_opt.M_OMATID = n
left join CM_FMAT1_DBF sugwhi_fut  on upper(TT.MAT) = substring(sugwhi_fut.M_LABEL,1,6) and sugwhi_fut.M_FMATID = 151
left join CM_OMAT1_DBF sugwhi_opt  on upper(TT.MAT) = substring(sugwhi_opt.M_LABEL,1,6) and sugwhi_opt.M_OMATID = 64
left join CM_FMAT1_DBF whtCHI_fut  on upper(TT.MAT) = substring(whtCHI_fut.M_LABEL,1,6) and whtCHI_fut.M_FMATID = 31
left join CM_OMAT1_DBF whtCHI_opt  on upper(TT.MAT) = substring(whtCHI_opt.M_LABEL,1,6) and whtCHI_opt.M_OMATID = 63
left join CM_FMAT1_DBF whtLDN_fut  on upper(TT.MAT) = substring(whtLDN_fut.M_LABEL,1,6) and whtLDN_fut.M_FMATID = 233
left join CM_OMAT1_DBF whtLDN_opt  on upper(TT.MAT) = substring(whtLDN_opt.M_LABEL,1,6) and whtLDN_opt.M_OMATID = 83
left join CM_FMAT1_DBF whtKC_fut   on upper(TT.MAT) = substring(whtKC_fut.M_LABEL,1,6) and whtKC_fut.M_FMATID = 238
left join CM_OMAT1_DBF whtKC_opt   on upper(TT.MAT) = substring(whtKC_opt.M_LABEL,1,6) and whtKC_opt.M_OMATID = 88
left join CM_FMAT1_DBF whtMIN_fut  on upper(TT.MAT) = substring(whtMIN_fut.M_LABEL,1,6) and whtMIN_fut.M_FMATID = 237
left join CM_OMAT1_DBF whtMIN_opt  on upper(TT.MAT) = substring(whtMIN_opt.M_LABEL,1,6) and whtMIN_opt.M_OMATID = 87
left join CM_FMAT1_DBF whtPAR_fut  on upper(TT.MAT) = substring(whtPAR_fut.M_LABEL,1,6) and whtPAR_fut.M_FMATID = 162
left join CM_OMAT1_DBF whtPAR_opt  on upper(TT.MAT) = substring(whtPAR_opt.M_LABEL,1,6) and whtPAR_opt.M_OMATID = 53