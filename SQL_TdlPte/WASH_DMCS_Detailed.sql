select
to_char(csh.M_F_VALUE,'YYYY-MM-DD') STL,
rtrim(csh.M_F_SPTF) PFL,
csh.M_TRN_GRP GRP, rtrim(csh.M_INSTRUMENT) INS,
rtrim(csh.M_F_SRC) FLW, 
rtrim(csh.M_F_TYPELAB0) TYP0, rtrim(csh.M_F_TYPELAB1) TYP1, rtrim(csh.M_F_TYPELAB2) TYP2, rtrim(csh.M_F_TYPELAB3) TYP3,
csh.M_F_AMOUNT AMT,
to_char(csh.M_TP_DTEEXP,'YYYY-MM-DD') EXP, csh.M_NB TRN

from TDLPTE_CSH_REP csh

/*
where to_char(csh.M_F_VALUE,'YYYYMMDD') > ?
and   to_char(csh.M_F_VALUE,'YYYYMMDD') <=?
*/

where M_NB = 9638039
