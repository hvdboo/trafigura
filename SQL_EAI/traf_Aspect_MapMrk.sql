select distinct
traf.ProductCategory, traf.AspectName, 
-- traf.mdmMrk,
ass.LAB ASSET, mrk.LAB MARKER, 
mrk.DES MRK_DES, mrk.SYM MRK_SYM,
phy.LAB PHY, qly.LAB QLY,
loc.LAB LOC, fac.LAB FAC,
trm.LAB TRM, car.LAB CAR,pl
mxcom.IND_LABEL Murex
from reg.traf_aspect traf
left join mdm.marker mrk on traf.mdmMrk = mrk.ID
left join mdm.asset ass on mrk.ASS = ass.ID
left join mdm.delivery dlv on mrk.DLV = dlv.ID
left join mdm.physical phy on dlv.PHY = phy.ID
left join mdm.quality qly on dlv.QLY = qly.ID
left join mdm.location loc on dlv.LOC = loc.ID
left join mdm.facility fac on dlv.FAC = fac.ID
left join mdm.term trm on dlv.TRM = trm.ID
left join mdm.carrier car on dlv.CAR = car.ID
left join mdm._map_mapping mapmx on (mrk.ID = mapmx.S_KNUM and mapmx.HDR = 25)
left join reg.mx_comindex mxcom on mapmx.T_KNUM = mxcom.M_REFERENCE
where 
traf.ProductCategory not in ('Emissions','Freight','Metal') 
and substring(traf.Server,8,4) = 'spec' 
and traf.FormulaID = 'NULL'
-- group by traf.AspectName
order by traf.ProductCategory, traf.AspectName