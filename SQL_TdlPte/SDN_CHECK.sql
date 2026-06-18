
select 
rvl.M_REF_DATA REFDATA,
rvl.M_NB TRN, 
rtrim(rvl.M_TP_GID) GID,
rtrim(rvl.M_TP_PFOLIO) PFL,
rtrim(rvl.M_CNT_TYPO) TYPO, 
rtrim(rvl.M_INSTRUMENT) INS,
rvl.M_C_CUR_PL CUR, 
to_char(rvl.M_TP_DTESYS,'YYYY-MM-DD')  SYS_DAT,

to_char(rvl.M_TP_DTETRN,'YYYY-MM-DD')  TRN_DAT,
to_char(rvl.M_TP_DTEFLWL,'YYYY-MM-DD') STL_TRN,
greatest(TO_CHAR(rvl.M_TP_DTETRN,'YYYY-MM-DD'), 
coalesce(TO_CHAR(rvl.M_TP_FEEDAT0,'YYYY-MM-DD'),'0'), coalesce(TO_CHAR(rvl.M_TP_FEEDAT1,'YYYY-MM-DD'),'0')) STL_FEE,
rvl.M_PL_PC_NN2,
rvl.M_PL_PC_NC2,
rvl.M_PL_PC_NCE,
rvl.M_PL_FE_NN2,
rvl.M_TP_FEES,
rvl.M_TP_FEESCS,
rvl.M_TP_FEESC2,
rvl.M_PL_ACC_N2

from MUREX_DM_OWNER.TRF_PL_RVL_REP rvl

where rvl.M_REF_DATA = 8397
and rtrim(rvl.M_TP_PFOLIO) = 'RMTS PBPAP TICD'
and rtrim(rvl.M_INSTRUMENT) = 'PB SHFE'
and to_char(rvl.M_TP_DTEFLWL,'YYYY-MM-DD') = '2019-09-17'
order by REFDATA, STL_TRN, TRN_DAT, TRN

===

select 
M_TP_PFOLIO, M_TP_CNTRP,
M_NB TRN, M_TP_GID GID,
M_CNT_TYPO,
M_TP_DTEFLWL STL,
M_TP_DTEEXP EXP,
M_PL_PC_NFI2

from MUREX_DM_OWNER.SDN_PL_REP

where M_TP_PFOLIO = 'BKEX JDI TICI'
and M_INSTRUMENT = 'COAL DCE'
--and to_char(M_TP_DTEEXP,'YYYY-MM-DD') = '2019-04-16'

order by TRN

=== 

select * from TRN_EXT_DBF where M_TRADE_REF in
(
13827538,
13827539,
13827540,
13827541,
13827542,
13827543,
13827548
)

====

select
to_char(pnl.M_VAL_DAT2,'YYYY-MM-DD') VAL_DAT,
pnl.M_TP_PFOLIO PFL,
to_char(pnl.M_TP_DTEEXP,'YYYY-MM-DD') STL_DAT,
rtrim(pnl.M_INSTRUMENT) INS,
pnl.M_C_CUR_PL STL_CUR,
sum(case when rtrim(pnl.M_CNT_TYPO) <> 'SCF SDN' then pnl.M_PL_ACC_N2 else 0 end) PL_TRN,
0 PL_FEE,
sum(case when (rtrim(pnl.M_CNT_TYPO) =  'SCF SDN' and substr(pnl.M_TP_GID,8,2) <> 'FE') then pnl.M_PL_ACC_N2 else 0 end) PL_SDN,
round( 
sum(case when rtrim(pnl.M_CNT_TYPO) <> 'SCF SDN' then pnl.M_PL_ACC_N2 else 0 end) +
sum(case when (rtrim(pnl.M_CNT_TYPO) =  'SCF SDN' and substr(pnl.M_TP_GID,8,2) <> 'FE') then pnl.M_PL_ACC_N2 else 0 end)
,0) PL_DIFF

from MUREX_DM_OWNER.TRF_PL_RVL_REP pnl
left join MUREX_DM_OWNER.PORTFOLIO_REP pfl on RTRIM(pnl.M_TP_PFOLIO) = RTRIM(pfl.M_LABEL)

where pnl.M_TP_PFOLIO = 'RMTS PBPAP TICD'
and pnl.M_C_CUR_PL <> 'USD'
-- and substr(pnl.M_TP_GID,8,2) <> 'FE'
and pnl.M_TP_DTEEXP <= pnl.M_VAL_DAT2

group by
pnl.M_VAL_DAT2,
pnl.M_TP_PFOLIO,
pnl.M_TP_DTEEXP,
pnl.M_INSTRUMENT,
pnl.M_C_CUR_PL

UNION

select
to_char(pnl.M_VAL_DAT2,'YYYY-MM-DD') VAL_DAT,
pnl.M_TP_PFOLIO PFL,
greatest(TO_CHAR(pnl.M_TP_DTETRN,'YYYY-MM-DD'), coalesce(TO_CHAR(pnl.M_TP_FEEDAT0,'YYYY-MM-DD'),'0'), coalesce(TO_CHAR(pnl.M_TP_FEEDAT1,'YYYY-MM-DD'),'0')) STL_DAT,
rtrim(pnl.M_INSTRUMENT) INS,
'CNY' STL_CUR,
0 PL_TRN,
sum(case when rtrim(pnl.M_CNT_TYPO) <> 'SCF SDN' then pnl.M_PL_FE_NN2 else 0 end) PL_FEE,
sum(case when (rtrim(pnl.M_CNT_TYPO) =  'SCF SDN' and substr(pnl.M_TP_GID,8,2) = 'FE') then pnl.M_PL_ACC_N2 else 0 end) PL_SDN,
round( 
sum(case when rtrim(pnl.M_CNT_TYPO) <> 'SCF SDN' then pnl.M_PL_FE_NN2 else 0 end) +
sum(case when (rtrim(pnl.M_CNT_TYPO) =  'SCF SDN' and substr(pnl.M_TP_GID,8,2) = 'FE') then pnl.M_PL_ACC_N2 else 0 end)
,0) PL_DIFF

from MUREX_DM_OWNER.TRF_PL_RVL_REP pnl
left join MUREX_DM_OWNER.PORTFOLIO_REP pfl ON RTRIM(pnl.M_TP_PFOLIO) = RTRIM(pfl.M_LABEL)

where pnl.M_TP_PFOLIO = 'BKEX JDI TICI'
and pnl.M_C_CUR_PL <> 'USD'
-- and substr(pnl.M_TP_GID,8,2) in ('FE')
and pnl.M_TP_DTEEXP <= pnl.M_VAL_DAT2

group by
pnl.M_VAL_DAT2,
pnl.M_TP_PFOLIO,
greatest(TO_CHAR(pnl.M_TP_DTETRN,'YYYY-MM-DD'), coalesce(TO_CHAR(pnl.M_TP_FEEDAT0,'YYYY-MM-DD'),'0'), coalesce(TO_CHAR(pnl.M_TP_FEEDAT1,'YYYY-MM-DD'),'0')),
pnl.M_INSTRUMENT