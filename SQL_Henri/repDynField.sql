select distinct 'MR' CAT, 
case dyn1.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
dyn1.M_CLASS CLAS, fld1.M_CREATION DYN_TBL, rtrim(dyn1.M_DESC) DYN_DES,
fld1.M_FLD_LABEL FLD, 
rtrim(fld1.M_FLD_SHORT) SHT,
case when hor1.M_DUP_LABEL is not null then 'H' else 'F' end NAT, 
rtrim(hor1.M_DUP_DESC) DES, 
hor1.M_DUP_TYPE TYP, hor1.M_DUP_WIDTH LEN, hor1.M_DUP_DEC DCM,
(rtrim(hor1.M_DUP_DEF0)|| rtrim(hor1.M_DUP_DEF1) || rtrim(hor1.M_DUP_DEF2)|| rtrim(hor1.M_DUP_DEF3)) DEF
from DYNDBF1#TRN_DYNF_DBF fld1
left join DYNDBF1#TRN_DYND_DBF dyn1 on rtrim(fld1.M_CREATION) = rtrim (dyn1.M_CREATION)
left join DYNDBF1#TRN_DYNU_DBF hor1 on fld1.M_FLD_LABEL = hor1.M_DUP_LABEL and fld1.M_CREATION = hor1.M_CREATION
left join DYNDBF1#TRN_DYNI_DBF iaf1 on fld1.M_CREATION = iaf1.M_CREATION
where rtrim(dyn1.M_CREATION) = (:MR)

union

select distinct 'CR' CAT, 
case dyn2.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
dyn2.M_CLASS CLAS, fld2.M_CREATION DYN_TBL, rtrim(dyn2.M_DESC) DYN_DES,
fld2.M_FLD_LABEL FLD,
rtrim(fld2.M_FLD_SHORT) SHT,
case when hor2.M_DUP_LABEL is not null then 'H' else 'F' end NAT, 
rtrim(hor2.M_DUP_DESC) DES, 
hor2.M_DUP_TYPE TYP, hor2.M_DUP_WIDTH LEN, hor2.M_DUP_DEC DCM,
(rtrim(hor2.M_DUP_DEF0)|| rtrim(hor2.M_DUP_DEF1)|| rtrim(hor2.M_DUP_DEF2)|| rtrim(hor2.M_DUP_DEF3)) DEF
from DYNDBF2#TRN_DYNF_DBF fld2
left join DYNDBF2#TRN_DYND_DBF dyn2 on rtrim(fld2.M_CREATION) = rtrim (dyn2.M_CREATION)
left join DYNDBF2#TRN_DYNU_DBF hor2 on fld2.M_FLD_LABEL = hor2.M_DUP_LABEL and fld2.M_CREATION = hor2.M_CREATION
left join DYNDBF2#TRN_DYNI_DBF iaf2 on fld2.M_CREATION = iaf2.M_CREATION
where rtrim(dyn2.M_CREATION) = (:CR)

union

select distinct 'MA' CAT, 
case dyn3.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
dyn3.M_CLASS CLAS, fld3.M_CREATION DYN_TBL, rtrim(dyn3.M_DESC) DYN_DES,
fld3.M_FLD_LABEL FLD, 
rtrim(fld3.M_FLD_SHORT) SHT,
case when hor3.M_DUP_LABEL is not null then 'H' else 'F' end NAT, 
rtrim(hor3.M_DUP_DESC) DES, 
hor3.M_DUP_TYPE TYP, hor3.M_DUP_WIDTH LEN, hor3.M_DUP_DEC DCM,
(rtrim(hor3.M_DUP_DEF0)|| rtrim(hor3.M_DUP_DEF1)|| rtrim(hor3.M_DUP_DEF2)|| rtrim(hor3.M_DUP_DEF3)) DEF
from DYNDBF3#TRN_DYNF_DBF fld3
left join DYNDBF3#TRN_DYND_DBF dyn3 on rtrim(fld3.M_CREATION) = rtrim (dyn3.M_CREATION)
left join DYNDBF3#TRN_DYNU_DBF hor3 on fld3.M_FLD_LABEL = hor3.M_DUP_LABEL and fld3.M_CREATION = hor3.M_CREATION
left join DYNDBF3#TRN_DYNI_DBF iaf3 on fld3.M_CREATION = iaf3.M_CREATION
where rtrim(dyn3.M_CREATION) = (:MA)

union

select distinct 'UA' CAT, 
case dyn4.M_CLASS_TYPE
when  0 then 'Transaction'
when  1 then 'Accounting'
when  2 then 'Copy creation'
when  3 then 'External'
when  5 then 'Definition report'
when  6 then 'Accounting report' 
when  7 then 'Cash balances' 
when  8 then 'Sim.view' 
when  9 then 'PL Variance'
when 10 then 'Java plugin'  
when 11 then 'Data dictionary' 
when 12 then 'Theta analysis' 
when 13 then 'Value at Risk' 
when 14 then 'PL entry, Simulation' 
when 15 then 'PL entry, Generator' 
when 16 then 'Deliverable, cash vostro' 
when 17 then 'Deliverable, cash nostro' else ' ' end CLASS_TYPE,
dyn4.M_CLASS CLAS, fld4.M_CREATION DYN_TBL, rtrim(dyn4.M_DESC) DYN_DES,
fld4.M_FLD_LABEL FLD, 
rtrim(fld4.M_FLD_SHORT) SHT,
case when hor4.M_DUP_LABEL is not null then 'H' else 'F' end NAT, 
rtrim(hor4.M_DUP_DESC) DES, 
hor4.M_DUP_TYPE TYP, hor4.M_DUP_WIDTH LEN, hor4.M_DUP_DEC DCM,
(rtrim(hor4.M_DUP_DEF0)|| rtrim(hor4.M_DUP_DEF1)|| rtrim(hor4.M_DUP_DEF2)|| rtrim(hor4.M_DUP_DEF3)) DEF
from DYNDBF4#TRN_DYNF_DBF fld4
left join DYNDBF4#TRN_DYND_DBF dyn4 on rtrim(fld4.M_CREATION) = rtrim (dyn4.M_CREATION)
left join DYNDBF4#TRN_DYNU_DBF hor4 on fld4.M_FLD_LABEL = hor4.M_DUP_LABEL and fld4.M_CREATION = hor4.M_CREATION
left join DYNDBF4#TRN_DYNI_DBF iaf4 on fld4.M_CREATION = iaf4.M_CREATION
where rtrim(dyn4.M_CREATION) = (:CA)

order by CAT desc, CLASS_TYPE, CLAS, DYN_TBL, FLD