create view
CMT_DLV_VW_DBF 
(
M_NB,
M_LEG,
M_CALC_FST,
M_CALC_LST,
M_TOT_QTY,
M_LOCATION,
M_PHYSICAL,
M_PROFILE
)

as

select
dlv.M_NB,
dlv.M_LEG_NB as M_LEG,
dlv.M_CALC_FST,
dlv.M_CALC_LST,
dlv.M_TOT_QTY,
rtrim(loc.M_LABEL) as M_LOCATION,
rtrim(phy.M_LABEL) as M_PHYSICAL,
case dlv.M_VOL_PROF
when 0 then 'None'
else 
   case prf.M_PROF_TYPE
   when 1 then 'OTC'
   when 0 then 'None'
   else rtrim(prf.M_LABEL) end
end as M_PROFILE

from CMT_DLV_DBF dlv
left join CM_LOCAT_DBF loc on dlv.M_LOCATION = loc.M_REFERENCE
left join CM_PHYS_DBF  phy on dlv.M_PHYSICAL = phy.M_REFERENCE
left outer join CM_PROFH_DBF prf on (dlv.M_VOL_PROF = prf.M_REFERENCE)
-- left join COM_LOAN_DBF cln on (dlv.M_NB = cln.M_REFERENCE and cln.M_REF_DB = 0 and cnl.M_LEG = dlv.M_LEG_NB)
-- left outer join CM_TS_DBF tms on (cln.M_VOL_TS = tms.M_REFERENCE and cln.M_VOL_TS > 0)