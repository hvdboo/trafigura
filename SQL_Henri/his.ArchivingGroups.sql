select
case grp.M_GRP_TYPE
when  0 then 'RT Index'
when  2 then 'Security'
when  3 then 'CM Future'
when  4 then 'CM Spot' 
when  5 then 'Pool factor'
when  7 then 'CM Clr.Asn'
when  8 then 'CM Opt.Fut'
when  9 then 'EQ Future'
when 10 then 'EQ Opt.Lst'
when 11 then 'FX Opt.Lst'
when 12 then 'CM Nearby' else null end TYP,
case grp.M_GRP_TYPE
when  3 then rtrim(fcm.M_LABEL)
when  7 then rtrim(fcm.M_LABEL)
when  8 then rtrim(fcm.M_LABEL)
else rtrim(grp.M_GRP_DESC) end GRP,
case grp.M_GRP_TYPE
when  3 then rtrim(icmpub.M_LABEL)
when  4 then rtrim(icmpub.M_LABEL)
when  7 then rtrim(icmpub.M_LABEL)
when  8 then rtrim(icmpub.M_LABEL)
when 12 then rtrim(icmpub.M_LABEL)
else rtrim(grp.M_GRP_CATEG) end CAT,
case grp.M_GRP_NAT
when 0 then 'Simple'
when 1 then 'Time series' else null end NAT,
rtrim(grp.M_CALENDAR) CAL,
rtrim(hsr.M_LABEL) HSR,
case grp.M_FREQUENCY
when 0 then 'Daily'
when 1 then 'Working days'
when 2 then 'Weekly'
when 3 then 'Monthly'
when 4 then 'Quarterly'
when 6 then 'Yearly' else null end FRQ,
rtrim(grp.M_SHIFTER) SHF,
case grp.M_PRICE
when 0 then 'Published rates'
when 1 then 'Market price'
when 2 then 'Multi column'
when 3 then 'Opt.multi column' else null end FMT,
case grp.M_ROUND_RUL
when 0 then 'None'
when 1 then 'Nearest'
when 5 then ' ' else null end RNDRUL,
grp.M_DECIMALS RNDDEC,
case grp.M_STAMPED when 0 then 'N' else 'Y' end TIMSTA,
case grp.M_NULLFIX when 0 then 'N' else 'Y' end FIXNUL,
rtrim(grp.M_HISFILE) HIS
/*
grp.M_GRP_TYPE,
grp.M_GRP_DESC
*/

from RT_GROUP_DBF grp
left join CM_MKT_DBF icmpub on trim(grp.M_GRP_CATEG) = to_char(icmpub.M_REFERENCE) and trim(grp.M_GRP_TYPE) in ('3','4','7','8','12')
left join CM_FUT_DBF fcm on trim(substr(grp.M_GRP_DESC,1,10)) = to_char(fcm.M_REFERENCE) and trim(grp.M_GRP_TYPE) in ('3','7','8')
left join RT_PUBL_SR_DBF hsr on grp.M_SERIES = hsr.M_PUBL