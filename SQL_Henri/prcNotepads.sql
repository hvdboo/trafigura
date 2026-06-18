select 
npdbdy.M_ROOT_ID      HDRID,
npdbdy.M_LEG_ID       BDYID,
rtrim(npdhdr.M_LABEL) LAB,
rtrim(npdhdr.M_USER)  USR,
rtrim(npdhdr.M_OWNER) OWNR,
rtrim(usr.M_CODE)     USRNAME,
usr.M_SUSPENDED       SUSPEND,
-- rtrim(npdbdy.M_REG_LBL),
case rtrim(npdbdy.M_REG_LBL)
when '1.234' then 'Package, Free'
when '1.238' then 'Single'
when '1.526' then 'Structure'
when '1.626' then 'Package, Single'
when '1.726' then 'Strip'
when 'MbJHH70702' then 'Package, Registered'
else null end CLASS,
rtrim(reg.M_REG_DES) FGT,
rtrim(npdpat.M_REG_DESC) PATREG,
rtrim(typo.M_LABEL) TYPO

from NPD_BDY_DBF npdbdy
left join NPD_HDR_DBF npdhdr on npdbdy.M_ROOT_ID = npdhdr.M_ID
left join UDTB279_DBF reg on npdbdy.M_REG_ID = reg.M_REG_FGT
left join NPD_PAT_DBF npdpat on npdbdy.M_PAT_ID = npdpat.M_PAT_ID
left join TYPOLOGY_DBF typo on npdbdy.M_TYPO_REF = typo.M_REFERENCE
left join MX_USER_DBF usr on rtrim(npdhdr.M_OWNER) = rtrim(usr.M_LABEL)

where rtrim(npdhdr.M_OWNER) in
(
'ALVIN.WONG',
'AMIT.K',
'ANDRES.PA0',
'CECILIA.Z0',
'DAVID.LAZ0',
'DHWANI.VO0',
'ERIC.ZHOU',
'GUAN.WANG',
'JAMES.DIX0',
'JUANPABLO0',
'KATIE.TES0',
'KHUSHBOO.1',
'MIA.GUAN',
'MOATAZ.AB0',
'NICHOLAS.0',
'NICHOLAS.1',
'OLIVIER.M0',
'PABLO.MAR0',
'TIM.READ',
'TRIPTI.PO0',
'WINSTON.MA',
'WOODY.ZHA0',
'YASH.SHAH'
)

order by OWNR, HDRID, BDYID