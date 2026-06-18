select
to_char(csh.M_F_VALUE,'YYYY-MM-DD') STL,
rtrim(csh.M_F_SPTF) PFL,
csh.M_TRN_GRP GRP, rtrim(csh.M_INSTRUMENT) INS,
rtrim(csh.M_F_SRC) FLW, 
rtrim(csh.M_F_TYPELAB0) TYP0, rtrim(csh.M_F_TYPELAB1) TYP1, rtrim(csh.M_F_TYPELAB2) TYP2, rtrim(csh.M_F_TYPELAB3) TYP3,
sum(csh.M_F_AMOUNT) AMT
-- to_char(csh.M_TP_DTEEXP,'YYYY-MM-DD'), csh.M_NB

from TDLPTE_CSH_REP csh

where to_char(csh.M_F_VALUE,'YYYYMMDD') > ?
and   to_char(csh.M_F_VALUE,'YYYYMMDD') <=?

group by
csh.M_F_VALUE, 
csh.M_F_SPTF,
csh.M_TRN_GRP, 
csh.M_INSTRUMENT,
csh.M_F_SRC,
csh.M_F_TYPELAB0, csh.M_F_TYPELAB1, csh.M_F_TYPELAB2, csh.M_F_TYPELAB3