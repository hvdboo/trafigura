select distinct
to_char(pc.M_DATE,'YYYY-MM-DD') SYSDAT,
rtrim(srcviw.M_OWNER)  PFLOWN,
rtrim(pflsrc.M_LABEL)  PFLLAB,
rtrim(srcviw.M_MASTER) PFLMDK,
rtrim(pflsrc.M_REF)    PFLREF

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

pivot (
count(*) OCC
for rtrim(phy.M_LABEL) in
(
'ALUMINA'       AO,
'ALUMINIUM'     AL,
'COBALT'        CO,
'COPPER'        CU,
'LEAD'          PB,
'LITHIIUM'      LI,
'NICKEL'        NI,
'TIN'           SN,
'ZINC'          ZN,
'GOLD'          AU,
'PALLADIUM'     PD,
'PLATINUM'      PT,
'SILVER'        AG,
'IRON ORE'      IO,
'IRON ORE CFR'  IO2,
'STEEL'         ST,
'COAL'          CL,
'CAPESIZE'      CSZ,
'PANAMAX'       PMX,
'SUPRAMAX'      SMX,
'CRUDE'         CR,
'BITUMEN'       BU,
'HEATING OIL'   HO,
'FUEL OIL'      FO,
'GASOIL'        GOL,
'GASOLINE'      GI,
'LPG'           LPG,
'NATGAS'        NG,
'MEG'           MEG,
'POLYPROPYLENE' PPP,
'PTA'           PTA,
'STYRENE'       STY,
'XYLENE'        XYL
))

order by PFLLAB;