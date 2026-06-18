select distinct
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
rtrim(srcviw.M_OWNER)  PFLOWN,
rtrim(pflsrc.M_LABEL)  PFLLAB,
rtrim(srcviw.M_MASTER) PFLMDK,
rtrim(pflsrc.M_REF)    PFLREF,
--case when trn.M_BINTERNAL = trn.M_SINTERNAL then 'I' else 'E' end TRN_IE,
sum(case when trn.M_TRN_FMLY ='COM'  then 1 else 0 end) COM,
sum(case when trn.M_TRN_FMLY ='CURR' then 1 else 0 end) CURR,
sum(case when trn.M_TRN_FMLY ='IRD'  then 1 else 0 end) IRD,
sum(case when trn.M_TRN_FMLY ='EQD'  then 1 else 0 end) EQD,
sum(case when trn.M_TRN_FMLY ='SCF'  then 1 else 0 end) SCF,
sum(case when rtrim(phy.M_LABEL) = 'ALUMINA'         then 1 else 0 end) AO,
sum(case when rtrim(phy.M_LABEL) = 'ALUMINIUM ALLOY' then 1 else 0 end) AA,
sum(case when rtrim(phy.M_LABEL) = 'ALUMINIUM'       then 1 else 0 end) AL,
sum(case when rtrim(phy.M_LABEL) = 'COBALT'          then 1 else 0 end) CO,
sum(case when rtrim(phy.M_LABEL) = 'COPPER'          then 1 else 0 end) CU,
sum(case when rtrim(phy.M_LABEL) = 'LEAD'            then 1 else 0 end) PB,
sum(case when rtrim(phy.M_LABEL) = 'LITHIIUM'        then 1 else 0 end) LI,
sum(case when rtrim(phy.M_LABEL) = 'NICKEL'          then 1 else 0 end) NI,
sum(case when rtrim(phy.M_LABEL) = 'TIN'             then 1 else 0 end) SN,
sum(case when rtrim(phy.M_LABEL) = 'ZINC'            then 1 else 0 end) ZN,
sum(case when rtrim(phy.M_LABEL) = 'GOLD'            then 1 else 0 end) AU,
sum(case when rtrim(phy.M_LABEL) = 'PALLADIUM'       then 1 else 0 end) PD,
sum(case when rtrim(phy.M_LABEL) = 'PLATINUM'        then 1 else 0 end) PT,
sum(case when rtrim(phy.M_LABEL) = 'SILVER'          then 1 else 0 end) AG,
sum(case when rtrim(phy.M_LABEL) in ('IRON ORE','IRON ORE CFR') then 1 else 0 end) IO,
sum(case when rtrim(phy.M_LABEL) = 'STEEL'           then 1 else 0 end) ST,
sum(case when rtrim(phy.M_LABEL) = 'COAL'            then 1 else 0 end) CL,
sum(case when rtrim(phy.M_LABEL) = 'CAPESIZE'        then 1 else 0 end) CSZ,
sum(case when rtrim(phy.M_LABEL) = 'PANAMAX'         then 1 else 0 end) PMX,
sum(case when rtrim(phy.M_LABEL) = 'SUPRAMAX'        then 1 else 0 end) SMX,
sum(case when rtrim(phy.M_LABEL) = 'CRUDE'           then 1 else 0 end) CR,
sum(case when rtrim(phy.M_LABEL) = 'BITUMEN'         then 1 else 0 end) BU,
sum(case when rtrim(phy.M_LABEL) = 'HEATING OIL'     then 1 else 0 end) HO,
sum(case when rtrim(phy.M_LABEL) = 'FUEL OIL'        then 1 else 0 end) FO,
sum(case when rtrim(phy.M_LABEL) = 'GASOIL'          then 1 else 0 end) GOL,
sum(case when rtrim(phy.M_LABEL) = 'GASOLINE'        then 1 else 0 end) GI,
sum(case when rtrim(phy.M_LABEL) = 'LPG'             then 1 else 0 end) LP,
sum(case when rtrim(phy.M_LABEL) = 'NATGAS'          then 1 else 0 end) NG,
sum(case when rtrim(phy.M_LABEL) = 'MEG'             then 1 else 0 end) MEG,
sum(case when rtrim(phy.M_LABEL) = 'POLYPROPYLENE'   then 1 else 0 end) PPP,
sum(case when rtrim(phy.M_LABEL) = 'PTA'             then 1 else 0 end) PTA,
sum(case when rtrim(phy.M_LABEL) = 'STYRENE'         then 1 else 0 end) STY,
sum(case when rtrim(phy.M_LABEL) = 'XYLENE'          then 1 else 0 end) XYL,
count(*) OCC

from TRN_HDR_DBF trn
left join TRN_PC_DBF pc on 1 = 1
left join CONTRACT_DBF cnt on trn.M_CONTRACT = cnt.M_REFERENCE
left join CMT_PLKEY1_DBF plk on trim(trn.M_PL_KEY1) = to_char(plk.M_REFERENCE)
left join CM_ASSET_DBF ass on plk.M_ASSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE
left join CMT_DLV_DBF dlv  on trn.M_NB = dlv.M_NB
left join CM_PHYS_DBF phy  on dlv.M_PHYSICAL = phy.M_REFERENCE
left join TRN_PFLD_DBF pflsrc on trn.M_SRC_PFOLIO = pflsrc.M_REF
left join VIW_PFL_DBF srcviw on pflsrc.M_REF = srcviw.M_ID
left join TRN_PFLD_DBF pfldst on trn.M_DST_PFOLIO = pfldst.M_REF

where 1 = 1 
and rtrim(trn.M_PURPOSE) <> 'MeHzv70053'
and trn.M_MOP_LAST not in (6,7)
-- and trn.M_TRN_STATUS <> 'DEAD'
--and to_char(trn.M_TRN_DATE,'YYYY-MM-DD') >= '2023-10-01'
and substr(srcviw.M_OWNER,1,3) <> 'ALL'

group by 
pc.M_DATE,
srcviw.M_OWNER,
pflsrc.M_LABEL,
rtrim(srcviw.M_MASTER),
rtrim(pflsrc.M_REF)

order by PFLLAB