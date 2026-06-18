select
traf.NAT TYP, rtrim(traf.LAB) MM,
ass.LAB ASSET,
mrk.LAB CMP_MRKLAB, mrk.DES CMP_MRKDES, 
mrk1.LAB ELT1, mrk1.DES, mrk1.UCF,
mrk2.LAB ELT2, mrk2.UCF
from reg.trafigura traf
left join mdm.marker mrk on traf.MRK = mrk.ID
left join mdm.asset ass on mrk.ASS = ass.ID
left join mdm.delivery dlv on mrk.DLV = dlv.ID
left join mdm.compound cm1 on mrk.ID = cm1.WRP and cm1.ELT = 1
left join mdm.compound cm2 on mrk.ID = cm2.WRP and cm2.ELT = 2
left join mdm.marker mrk1 on cm1.MRK = mrk1.ID
left join mdm.marker mrk2 on cm2.MRK = mrk2.ID
where traf.NAT = 'Spread'
order by traf.NAT, ass.LAB, traf.LAB