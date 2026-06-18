select
rtrim(mkt.M_LABEL) MKT,
rtrim(mst.M_LABEL) MATSET,
case mat.M_TYPE
when  0 then 'Pillar'
when  1 then 'Future'
when  2 then 'Opt Future'
when  3 then 'Opt Cash'
when  4 then 'Opt Btan'
when  5 then 'Security'
when  6 then 'Com Future'
when  7 then 'Com Option'
when  8 then 'Mrg Future'
when  9 then 'XXX'
when 12 then 'XXX' else null end MATTYP,
rtrim(mat.M_LABEL) MATLAB,
to_char(mat.M_MAT,'YYYY-MM-DD') MATDAT,
to_char(mat.M_VMAT,'YYYY-MM-DD') VALDAT,
to_char(mat.M_TSDATE,'YYYY-MM-DD') FSTTRD,
to_char(mat.M_TEDATE,'YYYY-MM-DD') LSTTRD,
mat.M_CODE MATCOD

from OM_MAT_DBF mat
left join MATSET_DBF mst on rtrim(mat.M_SETNAME) = rtrim(mst.M_LABEL)
left join MARKET_DBF mkt on rtrim(mst.M_LABEL) = rtrim(mkt.M_FUT_MSET)

where rtrim(mat.M_SETNAME) = 'NSE FF'
order by MKT, MATSET, mat.M_MAT