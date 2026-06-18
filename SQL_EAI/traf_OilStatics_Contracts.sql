select
ass.LAB ASSET,
rtrim(traf.LAB) MM, traf.NAT TYP,

mrk.LAB MRK_LAB,  
cnt.LAB CNT_LAB, cnt.DES CNT_DES, cnt.SYM
from reg.trafigura traf
left join mdm.marker mrk on traf.MRK = mrk.ID
left join mdm.asset ass on mrk.ASS = ass.ID
left join mdm.contract cnt on mrk.ID = cnt.MRK
-- where traf.NAT = 'Spread'
order by ass.LAB, traf.LAB, cnt.LAB