select distinct
traf.ProductCategory, traf.AspectName, 
-- traf.mdmMrk,
ass.LAB ASSET,
mrk.LAB MARKER, 
pub.LAB PUB, 
cnt.LAB CONTRACT, cnt.SYM CNT_SYM,
obs.LAB OBS
from reg.traf_aspect traf
left join mdm.marker mrk on traf.mdmMrk = mrk.ID
left join mdm.asset ass on mrk.ASS = ass.ID
left join mdm.contract cnt on mrk.ID = cnt.MRK
left join mdm.publication pub on cnt.XCH = pub.ID
left join mdm.observation obs on cnt.OBS = obs.ID 
where 
traf.ProductCategory not in ('Emissions','Freight','Metal') 
and substring(traf.Server,8,4) = 'spec' 
and traf.FormulaID = 'NULL'
order by traf.ProductCategory, traf.AspectName