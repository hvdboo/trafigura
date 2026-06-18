CREATE OR REPLACE FORCE EDITIONABLE VIEW 
"MUREX_MX_OWNER"."TRNPFLACCSEC" 
("TRN","IE","PHY","NATB","CATB","PFLB","ACCB","NATS","CATS","PFLS","ACCS")
AS SELECT TRN, IE, PHY, NATB, CATB, PFLB, ACCB, NATS, CATS, PFLS, ACCS
FROM

(
select 
trn.M_NB TRN, 
case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end IE,
rtrim(phy.M_LABEL) PHY,
rtrim(udfp.M_MD_LAB) PHYMD,
case when trn.M_BINTERNAL = 'Y' then 'PFL' else 'CTP' end NATB,
rtrim(udfb.M_PTFCAT) CATB,
-- rtrim(udfb.M_PTFTYPE) CATB,
rtrim(trn.M_BPFOLIO) PFLB, 
rtrim(accb.M_DESC) ACCB,
case when trn.M_SINTERNAL = 'Y' then 'PFL' else 'CTP' end NATS,
rtrim(udfs.M_PTFCAT) CATS,
-- rtrim(udfs.M_PTFTYPE) CATS,
rtrim(trn.M_SPFOLIO) PFLS, 
rtrim(accS.M_DESC) ACCS

from TRN_HDR_DBF trn
left join TRN_PFLD_DBF pflb on rtrim(trn.M_BPFOLIO) = rtrim(pflb.M_LABEL)
left join TRN_PFLD_DBF pfls on rtrim(trn.M_SPFOLIO) = rtrim(pfls.M_LABEL)
left join TRN_ACSC_DBF accb on rtrim(pflb.M_ACCSECTION) = rtrim(accb.M_LABEL)
left join TRN_ACSC_DBF accs on rtrim(pfls.M_ACCSECTION) = rtrim(accs.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF udfb on rtrim(pflb.M_LABEL) = rtrim(udfb.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF udfs on rtrim(pfls.M_LABEL) = rtrim(udfs.M_LABEL)
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_PHYS_DBF phy on plk.M_PRODUCT = phy.M_REFERENCE
left join TABLE#DATA#PRODUCTS_DBF udfp on phy.M_REFERENCE = udfp.M_REFERENCE

where 1 = 1
and trn.M_PURPOSE <> 'MeHzv70053'
and trn.M_TRN_FMLY = 'COM'
and ( rtrim(udfb.M_PTFCAT) in ('H','P','F','S') or rtrim(udfs.M_PTFCAT) in ('H','P','F','S') )
)
