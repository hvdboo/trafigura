select 
rtrim(asgh.M_LABEL) TMPL, 
rtrim(asgb.M_INST) INSTRUM, rtrim(asgb.M_MDL) MODEL, (asgb.M_CONFIG) MODSET,
asgb.M_MODELID
from COMMDL_RTGH_DBF asgh
left join TRN_PC_DBF pc on asgh.M__DATE_ = pc.M_DATE
left join COMMDL_RTGB_DBF asgb on asgh.M__INDEX_ = asgb.M__INDEX_  
where asgh.M__DATE_ = pc.M_DATE
order by asgh.M_LABEL, asgb.M_INST
