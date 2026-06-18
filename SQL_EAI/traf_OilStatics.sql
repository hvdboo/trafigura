select
traf.NAT TYP, rtrim(traf.LAB) MM,
mrk.DES MRK_DES, mrk.LAB MRK_LAB, 
dlv.LAB DLV, phy.LAB PHY, qly.LAB QLY, loc.LAB LOC, trm.LAB TRM, car.LAB CAR,
pub.LAB PUB, pub.ID, mrk.SYM SYM,
case mrk.PUB
when  64 then rtrim(poil.Description)
when  68 then rtrim(poil.Description)
when  70 then rtrim(poil.Description)
when  74 then rtrim(poil.Description)
when  77 then rtrim(poil.Description)
when  71 then rtrim(pgas.Description)
when  72 then rtrim(pgas.Description)
when  73 then rtrim(pgas.Description)
when  67 then rtrim(pcoa.Description)
when   6 then rtrim(arg.DisplayName)
when   7 then rtrim(arg.DisplayName)
when   8 then rtrim(arg.DisplayName)
when 103 then rtrim(arg.DisplayName)
else null end PUB_DES
from reg.trafigura traf
left join mdm.marker mrk on traf.MRK = mrk.ID
left join mdm.delivery dlv on mrk.DLV = dlv.ID
left join mdm.physical phy on dlv.PHY = phy.ID
left join mdm.quality qly  on dlv.QLY = qly.ID
left join mdm.location loc on dlv.LOC = loc.ID
left join mdm.term trm on dlv.TRM = trm.ID
left join mdm.carrier car on dlv.CAR = car.ID
left join mdm.publication pub on mrk.PUB = pub.ID
left join reg.platts_petass poil on (mrk.SYM = poil.Symbol and mrk.PUB in (64, 68, 70, 74, 77)) 
left join reg.platts_natgas pgas on (mrk.SYM = pgas.Symbol and mrk.PUB in (71, 72, 73))
left join reg.platts_coal pcoa on (mrk.SYM = pcoa.Symbol and mrk.PUB in (67))
left join reg.argus arg on (mrk.SYM = arg.Code and mrk.PUB in (6, 7, 8, 103))
order by traf.NAT, traf.LAB