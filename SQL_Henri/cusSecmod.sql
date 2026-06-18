select distinct 
sechdr.M_SE_D_LABEL, 
sechdr.M_SE_LABEL, 
genins.M_GEN_NUM, 
genins.M_INSTR, 
case secmod.M_TYPE 
when 0 then 'Payment date' 
when 1 then 'Fixing date' 
when 2 then 'Calculation start date' 
when 3 then 'Capital date' 
when 4 then 'Interest date' 
when 5 then 'Interest flow' 
when 6 then 'Remaining capital payment flow' 
when 7 then 'Main strike' 
when 8 then 'Fixing' 
when 9 then 'Period main volatility' 
when 10 then 'Calculation end date' 
when 11 then 'Interest margin' 
when 12 then 'Secondary strike' 
when 13 then 'Period secondary volatility' 
when 14 then 'First fixing' 
when 15 then 'Exercise date' 
when 16 then 'Compounding rule' 
when 17 then 'Compounding mode' 
when 18 then 'Settlement date' 
when 19 then 'Settlement rate' 
when 20 then 'Settlement flow' 
when 21 then 'Settlement calculation start date' 
when 22 then 'Settlement calculation end date' 
when 23 then 'Adjustment rule' 
when 24 then 'Interest flow factor' 
when 25 then 'Capital calculation start date' 
when 26 then 'Capital calculation end date' 
when 27 then 'Capital payment date' 
when 28 then 'Capital payment flow' 
when 29 then 'Exercised (for flex)' 
when 30 then 'Cliquet strike' 
when 31 then 'Cliquet secondary strike' 
when 32 then 'Amortizing annuity' 
when 33 then 'Barrier' 
when 34 then 'Capital payment flow' 
when 35 then 'Capital calculation payment flow' 
when 36 then 'Interest reinvestment' 
when 37 then 'Interest rate + dividend' 
when 38 then 'Interest flow + dividend flow' 
when 39 then 'Interest first indexation' 
when 40 then 'Interest second indexation' 
when 41 then 'Fixing first indexation' 
when 42 then 'Fixing second indexation' 
when 43 then 'Margin first indexation' 
when 44 then 'Margin second indexation' 
when 45 then 'Interest rate first indexation' 
when 46 then 'Interest rate second indexation' 
when 47 then 'Initial capital first indexation' 
when 48 then 'Initial capital second indexation' 
when 49 then 'Capital flow first indexation' 
when 50 then 'Capital flow second indexation' 
when 51 then 'Final capital first indexation' 
when 52 then 'Final capital second indexation' 
when 53 then 'Remaining capital first indexation' 
when 54 then 'Remaining capital second indexation' 
when 55 then 'Interest first indexation date' 
when 56 then 'Interest second indexation date' 
when 57 then 'Fixing first indexation date' 
when 58 then 'Fixing second indexation date' 
when 59 then 'Margin first indexation date' 
when 60 then 'Margin second indexation date' 
when 61 then 'Interest rate first indexation date' 
when 62 then 'Interest rate second indexation date' 
when 63 then 'Initial capital first indexation date' 
when 64 then 'Initial capital second indexation date' 
when 65 then 'Capital flow first indexation date' 
when 66 then 'Capital flow second indexation date' 
when 67 then 'Final capital first indexation date' 
when 68 then 'Final capital second indexation date' 
when 69 then 'Remaining capital first indexation date' 
when 70 then 'Remaining capital second indexation date' 
when 71 then 'Rate factor' 
else 'Other' end CUSNAT 

from SE_HEAD_DBF  sechdr
join SE_MKTOP_DBF secmkt on sechdr.M_SE_LABEL = secmkt.M_SE_LABEL 
join BD_BOND_DBF  bond   on secmkt.M_SE_INUM = bond.M_BD_INUM 
join RT_LNSEC_DBF lnsec  on lnsec.M_NB = bond.M_BD_INUM 
join RT_SCMOD_DBF secmod on lnsec.M_NB = secmod.M_NB
join RT_INSGN_DBF genins on lnsec.M_GEN_NUM = genins.M_GEN_NUM  
join RT_LNGN_DBF  lngen  on genins.M_GEN_NUM = lngen.M_GEN_NUM  

where 1 = 1
and sechdr.M_SE_GROUP = 'Bond' 
and bond.M_BD_RT_STOR = 1 --bond is customised 
and secmod.M_TYPE = 6 --customisation on outstanding capital 
