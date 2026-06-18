select 
rtrim(pli.M_SUBFML)     SUBFML,
rtrim(lut.M_INSTRUMENT) LUTLAB,
rtrim(pli.M_PLILAB)     PLILAB,
rtrim(pli.M_PHY)        PHY,
rtrim(lut.M_EMIR_BASEP) LUTPHY1,
rtrim(phyudf.M_EMR_CM1) PRD_BASE,
rtrim(lut.M_EMIR_SUBPR) LUTPHY2,
rtrim(phyudf.M_EMR_CM2) PRD_SUB,
case when rtrim(lut.M_EMIR_SUBPR) != rtrim(phyudf.M_EMR_CM2) then 'Diff' else null end DIFF,
rtrim(lut.M_EMIR_FSUP)  LUTPHY3,
rtrim(phyudf.M_EMR_CM3) PRD_SF,
rtrim(lut.M_EMIR_ASSET) LUTASS,
--pli.M_LEGNAT,
--pli.M_INDTYP0,
--pli.M_UNDTYP0,
case 
when pli.M_SUBFML in ('CM Swap') then 
    case 
    when pli.M_LEGNAT = 'Flt-Fix' and pli.M_INDTYP0 = 'AVG' then 'Swap'
    when pli.M_LEGNAT = 'Flt-Fix' and pli.M_INDTYP0 = 'Basket' then 'Basis_Swap'
    when pli.M_LEGNAT = 'Flt-Flt' then 'Basis_Swap' else null end
when pli.M_SUBFML in ('EQ Future, Equity', 'IR Future, Bond','IR Future, Rate','CM Future','CM Forward','CM Physical','CM Phys.Fwd') then 'Forward'
when pli.M_SUBFML in ('CM Option LST','CM Clr.Asian','CM Asian') then 'Option' 
else null end ASSET,
rtrim(lut.M_R_PAYOUT_T) LUTPAY,
case 
when pli.M_SUBFML in ('CM Swap') then 'CFD'
when pli.M_SUBFML in ('CM Option LST') then 'Vanilla' 
when pli.M_SUBFML in ('CM Clr.Asian','CM Asian') then 'Asian'
else 'Forward' end PAYOUT,
rtrim(lut.M_MKTMIC)     LUTMIC,
case when pli.M_PLIMKT = 'OTC' or pli.M_SUBFML = 'CM Forward' then null else rtrim(pli.M_MKTMIC) end MIC,
case when rtrim(lut.M_MKTMIC) != rtrim(pli.M_MKTMIC) then 'Diff' else null end DIFF,
rtrim(lut.M_MKTSYMBOL)  LUTSYM,
case when pli.M_PLIMKT = 'OTC' or pli.M_SUBFML = 'CM Forward' then null else rtrim(pli.M_MKTSYM) end SYMBOL


from UDTB329_DBF lut
left join VIW_PLI_DBF pli on rtrim(lut.M_INSTRUMENT) = rtrim(pli.M_PLILAB)
left join CM_PHYS_DBF phy on pli.M_PHY = rtrim(phy.M_LABEL)
left join CM_PHYS_DBF phy on pli.M_PHY = rtrim(phy.M_LABEL)
left join TABLE#DATA#PRODUCTS_DBF phyudf on phy.M_REFERENCE = phyudf.M_REFERENCE