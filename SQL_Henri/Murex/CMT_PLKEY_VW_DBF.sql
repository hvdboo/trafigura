--drop view CMT_PLKEY_VW_DBF2;
create view CMT_PLKEY_VW_DBF2 
(
M_PLKEY,
M_ASSETTYPE,
M_ASSET,
M_PHYS,
M_VINTAGE,
M_PUBLI,
M_FUTURE,
M_FUTDES,
M_EXCH_CODE,
M_OBS,
M_MATCAST,
M_INDEX,
M_UNDERL,
M_CMIND,
M_CMIDES,
M_QOT,
M_CUR,
M_UOQ,
M_LOTSIZE,
M_FUTMATLAB,
M_OPTMATLAB,
M_OPTMATDAT,
M_FUTQOTEND,
M_FUTDLVFST,
M_FUTDLVLST,
M_FIXFST,
M_FIXLST,
M_SPLITMODE,
M_NETMODE
) 

as

(
select distinct
plk.M_REFERENCE         as M_PLKEY,
rtrim(atp.M_LABEL)      as M_ASSETTYPE,
rtrim(ass.M_LABEL)      as M_ASSET,
rtrim(phy.M_LABEL)      as M_PHYS,
rtrim(vin.M_LABEL)      as M_VINTAGE,
rtrim(pub.M_LABEL)      as M_PUBLI,
rtrim(fcm.M_LABEL)      as M_FUTURE,
rtrim(fcm.M_DESC)       as M_FUTDES,
rtrim(qot.M_TRAD_SMB)   as M_EXCH_CODE,
rtrim(fcmudf.M_OBS)     as M_OBS,
rtrim(fcmudf.M_MATCAST) as M_MATCAST,
rtrim(ind.M_IND_LAB)    as M_INDEX,
rtrim(und.M_IND_LAB)    as M_UNDERL,
rtrim(icm.M_LABEL)      as M_CMIND,
rtrim(icm.M_DESC)       as M_CMIDES,
rtrim(qot.M_LABEL)      as M_QOT,
rtrim(qot.M_CURR)       as M_CUR,
rtrim(uoq.M_LABEL)      as M_UOQ,
coalesce(fcm.M_QTY, icm.M_LOTSIZE) as M_LOTSIZE,
rtrim(fmat.M_LABEL)     as M_FUTMATLAB,
rtrim(omat.M_LABEL)     as M_OPTMATLAB,
omat.M_MATURITY         as M_OPTMATDAT,
fmat.M_QT_END           as M_FUTQOTEND,
fmat.M_ST_START         as M_FUTDLVFST,
fmat.M_ST_END           as M_FUTDLVLST,
case fcmudf.M_OBS
when 'LGM' then lgmmat.M_QT_START
when 'NGE' then ngemat.M_QT_START
when 'TMA' then tmamat.M_QT_START
when 'BAS' then tmamat.M_NT_START
else fmat.M_QT_END end as M_FIXFST,
case fcmudf.M_OBS
when 'LGM' then lgmmat.M_QT_END
when 'NGE' then ngemat.M_QT_END
when 'TMA' then tmamat.M_QT_END
when 'BAS' then tmamat.M_QT_END
else fmat.M_QT_END end as M_FIXLST,
case
when (fcm.M_LISTED * fcm.M_SPLT_RULE) = 0 then 'N'
when fcm.M_SPLT_RULE = 2 then 'T'
else 'E' end as M_SPLITMODE,
case
when fcm.M_NETTING_ALLOWED = 1 then 'Y'
else 'N' end as M_NETMODE

from CMT_PLKEY1_DBF plk
left join CM_ASSET_DBF ass on plk.M_asSET = ass.M_REFERENCE
left join CM_ATYPE_DBF atp on ass.M_TYPE  = atp.M_REFERENCE
left join RT_INDEX_DBF ind on plk.M_INDEX = ind.M_INDEX
left join RT_INDEX_DBF und on plk.M_RT_UNDL = und.M_INDEX
left join CM_INDEX_DBF icm on plk.M_UNDL = icm.M_REFERENCE
left join CM_FUT_DBF fcm on plk.M_FUTURE = fcm.M_REFERENCE and plk.M_FUTURE <> 0
left join TABLE#DATA#COMMODIT_DBF fcmudf on fcm.M_REFERENCE = fcmudf.M_REFERENCE
left join CMC_QUOT_DBF qot on plk.M_QUOT = qot.M_REFERENCE and plk.M_QUOT <> 0
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_UNIT_DBF uoq on qot.M_UNIT = uoq.M_REFERENCE
left join CM_PHYS_DBF phy on plk.M_PRODUCT = phy.M_REFERENCE and plk.M_PRODUCT <> 0
left join CM_VINTAGE_DBF vin on plk.M_VINTAGE = vin.M_REFERENCE and plk.M_VINTAGE <> 0
left join CM_FMAT1_DBF fmat on plk.M_FUT_MAT = fmat.M_REFERENCE and plk.M_FUT_MAT <> 0
left join CM_OMAT1_DBF omat on plk.M_OPT_MAT = omat.M_REFERENCE and plk.M_OPT_MAT <> 0
left join CM_FMAT1_DBF lgmmat on rtrim(fmat.M_LABEL) = rtrim(lgmmat.M_LABEL) and rtrim(fcmudf.M_OBS) = 'LGM' and lgmmat.M_FMAT_ID = 405 --TITAN - LNG
left join CM_FMAT1_DBF ngemat on rtrim(fmat.M_LABEL) = rtrim(ngemat.M_LABEL) and rtrim(fcmudf.M_OBS) = 'NGE' and ngemat.M_FMAT_ID = 404 --TITAN - GAS EU 
left join CM_FMAT1_DBF tmamat on rtrim(fmat.M_LABEL) = rtrim(tmamat.M_LABEL) and rtrim(fcmudf.M_OBS) = 'TMA' and tmamat.M_FMAT_ID = 364 --TITAN - OIL US TMA
left join CM_FMAT1_DBF ngumat on rtrim(fmat.M_LABEL) = rtrim(ngumat.M_LABEL) and rtrim(fcmudf.M_OBS) = 'BAS' and tmamat.M_FMAT_ID = 363 --TITAN - GAS US
-- where plk.M_REFERENCE in (46575, 46958)

);
