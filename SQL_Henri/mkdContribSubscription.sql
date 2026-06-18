select
rtrim(srh.M_LABEL) LAB,
rtrim(srh.M_DESC) DES,
rtrim(srh.M_ENTITLEMENT_LABEL) ENTIT,
-- srb.M_TYPE TYPN,
case srb.M_TYPE
when 0     then 'fxsp:spot'
when 1     then 'fxfp:futurePrice'
when 2     then 'fxvl:volatility'
when 6     then 'fxsm:smile'
when 7     then 'rtsh:sheet'
when 10    then 'fxsw:swap'
when 14    then 'rtcu:curve'
when 19    then 'scpr:price'
when 20    then 'scvl:volatility'
when 22    then 'rtcv:capVolatility'
when 23    then 'rtsv:swaptionVolatility'
when 24    then 'rtcs:capSmile'
when 25    then 'rtss:swaptionSmile'
when 26    then 'cmfp:futurePrice'
when 27    then 'cmip:indexPrice'
when 28    then 'cmop:optionPrice'
when 31    then 'scsm:smile'
when 32    then 'scos:optionSeries'
when 34    then 'cmcu:curve'
when 50    then 'cmvolcu:volcurve'
when 55    then 'cmsmile:smile'
when 65    then 'rticv:inflationCapVolatility'
when 66    then 'rtics:inflationCapSmile'
when 67    then 'fxsmd:smileDyn'
when 68    then 'fxbr:broker'
when 70    then 'fxlo:listedOptions'
when 71    then 'rthedcu:curve'
when 104   then 'cmts:timeSeries'
when 108   then 'cmph:physicalMarketData'
when 503   then 'rtinfl:curve'
when 600   then 'rtvsswv:swVanilla'
when 601   then 'rtvsswcs:swCollarStrangle'
when 603   then 'rtvscf:capFloor'
when 1063  then 'CM_STORAGE_COST'
else 'To be defined' end TYP,
srb.M_FREQUENCY FRQ,
rtrim(actfed.M_LABEL) ACTFED 

from MD_RTSRB_DBF srb
left join MD_RTSRH_DBF srh on srb.M_REFERENCE = srh.M_REFERENCE
left join MD_ACTIVITY_FEEDER_DBF actfed on srb.M_ACTFEEDER = actfed.M_REFERENCE

-- where rtrim(srh.M_LABEL) = 'TEST'

order by LAB, TYP