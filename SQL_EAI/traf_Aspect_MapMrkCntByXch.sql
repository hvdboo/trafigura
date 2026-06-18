select distinct
traf.ProductCategory, traf.AspectName, 
-- traf.mdmMrk,
ass.LAB ASSET,
mrk.LAB MARKER, mrk.SYM MRK_SYM,
max(case when cnt.XCH in (40, 41, 131) then cnt.LAB else null end) ICE,
-- max(case when cnt.XCH in (40, 41, 131) then concat('=HYPERLINK("',rtrim(ice.WEB),'","',cnt.SYM,'")') else null end) ICE_SYM, 
max(case when cnt.XCH in (40, 41, 131) then concat('=LIEN_HYPERTEXTE("',rtrim(ice.WEB),'";"',cnt.SYM,'")') else null end) ICE_SYM, 
max(case when cnt.XCH in (61, 126) then cnt.LAB else null end) CME,
-- max(case when cnt.XCH in (61, 126) then concat('=HYPERLINK("',rtrim(cme.WEB),'","',cnt.SYM,'")') else null end) CME_SYM,
max(case when cnt.XCH in (61, 126) then concat('=LIEN_HYPERTEXTE("',rtrim(cme.WEB),'";"',cnt.SYM,'")') else null end) CME_SYM,
max(case when cnt.XCH in (94,26) then cnt.LAB else null end) TOCOM_DME,
max(case when cnt.XCH in (15, 18, 33) then cnt.LAB else null end) AGS
from reg.traf_aspect traf
left join mdm.marker mrk on traf.mdmMrk = mrk.ID
left join mdm.asset ass on mrk.ASS = ass.ID
left join mdm.contract cnt on mrk.ID = cnt.MRK
left join mdm.publication pub on cnt.XCH = pub.ID
left join mdm.observation obs on cnt.OBS = obs.ID 
left join reg.cme cme on cnt.COD = cme.Clearing
left join reg.ice ice on cnt.COD = ice.CODE
where 
traf.ProductCategory not in ('Emissions','Freight','Metal') 
and substring(traf.Server,8,4) = 'spec' 
and traf.FormulaID = 'NULL'
group by cnt.ID
order by traf.ProductCategory, traf.AspectName