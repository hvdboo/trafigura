select 
rtrim(lut.M_LABEL) LUT, 
rtrim(hdr.M_LABEL) FOLDER,
rtrim(tbl.M_INSTRUMENT) PLI,
rtrim(tbl.M_REG_TYPO)   TYPO,
rtrim(pli.M_FINASS)     FINASS,
substr(atp.M_DESC,1,4)  COMATP,
rtrim(tbl.M_EMIR_BASEP) EMRPRB,
case rtrim(pli.M_COMASS)
when 'AGS' then 'GROS'
when 'BMT' then 'NPRM'
when 'CHE' then 'OTHR'
when 'EMI' then 'EMIS'
when 'FMT' then 'NPRM'
when 'FRW' then 'WETF'
when 'GAS EU' then 'NGAS'
when 'GAS US' then 'NGAS'
when 'LNG' then 'NGAS'
when 'OIL' then 'OILP'
when 'PMT' then 'PRME'
when 'RFC' then 'RNNG'
when 'SRV' then null
else pli.M_COMASS end   COMASS,
rtrim(tbl.M_EMIR_SUBPR) EMRPRS,
case rtrim(pli.M_PHYLAB)
when 'ALUMINIUM' then 'ALUM'
when 'BENZENE'   then null
when 'BITUMEN'   then null
when 'BUTANE'    then 'NGLO'
when 'COAL'      then null
when 'COPPER'    then 'COPR'
when 'CORN'      then null
when 'CPO'       then null
when 'CRUDE'     then
case 
when substr(pli.M_PLILAB,1,6) = 'BR NDX'  then 'BRNX'
when substr(pli.M_PLILAB,1,6) = 'BR-DUB'  then 'WTIO'
when substr(pli.M_PLILAB,1,7) = 'BDT-DUB' then 'WTIO'
when substr(pli.M_PLILAB,1,2) = 'BR'  then 'BRNT'
when substr(pli.M_PLILAB,4,2) = 'BR'  then 'BRNT'
when substr(pli.M_PLILAB,1,3) = 'BDT' then 'BRNT'
when substr(pli.M_PLILAB,4,3) = 'BDT' then 'BRNT'
when substr(pli.M_PLILAB,1,3) = 'STO' then null
else 'WTIO' end
when 'ETHANE'      then 'NGLO'
when 'ETHANOL'     then 'ETHA'
when 'ETHYLENE'    then null
when 'FAME'        then 'BDSL'
when 'FUEL HSCR'   then 'FOIL'
when 'FUEL OIL'    then 'FOIL'
when 'GASOIL'      then 'GOIL'
when 'GASOLINE'    then 'GSLN'
when 'GG CARB EA'  then 'OTHR'
when 'GG CARB EO'  then 'OTHR'
when 'GG EUA'      then 'EUAE'
when 'GG GEO'      then 'OTHR'
when 'GG N-GEO'    then 'OTHR'
when 'GG NZU'      then 'OTHR'
when 'GG RGGI EA'  then 'OTHR'
when 'GG UKA'      then 'OTHR'
when 'GG VER NB'   then 'OTHR'
when 'GG WCA'      then 'OTHR'
when 'GOLD'        then 'GOLD'
when 'HEATING OIL' then 'HEAT'
when 'HVO'         then 'BDSL'
when 'IRON ORE'    then 'IRON'
when 'JET'         then 'JTFL'
when 'LEAD'        then 'LEAD'
when 'LNG'         then 'LNGG'
when 'LPG'         then 'NGLO'
when 'MEG'         then null
when 'METHANOL'    then null
when 'MTBE'        then 'OTHR'
when 'NAPHTHA'     then 'NAPH'
when 'NATGAS'      then 
case 
when substr(pli.M_PLILAB,4,2) = 'DE' then 'NCGG'
when substr(pli.M_PLILAB,4,2) = 'NL' then 'TTFG'
when substr(pli.M_PLILAB,4,2) = 'UK' then 'NBPG'
else 'OTHR' end
when 'NGI'         then 'NGLO'
when 'NICKEL'      then 'NICK'
when 'PALLADIUM'   then 'PLDM'
when 'PARAFFIN'    then null
when 'PLATINUM'    then 'PTNM'
when 'POLYETHYLENE'  then null
when 'POLYPROPYLENE' then null
when 'PROPANE'     then 'NGLO'
when 'PSF'         then null
when 'PTA'         then null
when 'PVC'         then null
when 'RAPESEED'    then 'RPSD'
when 'RFC'         then null
when 'RME'         then 'BDSL'
when 'SILVER'      then 'SLVR'
when 'SOYBEAN'     then 'SOYB'
when 'SOYMEAL'     then 'OTHR'
when 'SOYOIL'      then 'OTHR'
when 'STYRENE'     then null
when 'SUGAR'       then 'WHSG'
when 'TANKER'      then 'TNKR'
when 'UCOME'       then 'BDSL'
when 'WHEAT'       then 'FWHT'
when 'XYLENE'      then null
when 'ZINC'        then 'ZINC'
else rtrim(pli.M_PHYLAB) end PHY,

rtrim(tbl.M_EMIR_FSUP)  EMRPRF,
rtrim(tbl.M_EMIR_ASSET) EMRASS,
rtrim(tbl.M_R_PAYOUT_T) PAYOUT,
rtrim(tbl.M_MKTMIC)     MIC,
rtrim(tbl.M_MKTSYMBOL)  SYM,
rtrim(tbl.M_COM_REF_PR) REFPRC

from UDTB329_DBF tbl
left join UDTH329_DBF hdr on tbl.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH329'
left join VIW_PLI_DBF pli on rtrim(tbl.M_INSTRUMENT) = rtrim(pli.M_PLILAB)
left join CM_ASSET_DBF ass on rtrim(pli.M_COMASS) = rtrim(ass.M_LABEL)
left join CM_ATYPE_DBF atp on ass.M_TYPE = atp.M_REFERENCE

order by PLI
