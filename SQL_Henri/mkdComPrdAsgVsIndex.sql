select
asg.*,
rtrim(fysa.M_LABEL) ASG_PHY, rtrim(qlya.M_LABEL) ASG_QLY, 
rtrim(loca.M_LABEL) ASG_LOC, 
-- rtrim(lar.M_LABEL) REGION, rtrim(lto.M_LABEL) MARCHE,
rtrim(trm.M_LABEL) ASG_TERM, rtrim(asg.M_CURRENCY) CUR,
rtrim(ind.M_IND_LAB) ASG_INDEX, 
rtrim(hsr.M_LABEL) ASG_SERIE,
rtrim(fysi.M_LABEL) IND_PHY, rtrim(qlyi.M_LABEL) IND_QLYDEF, rtrim(loci.M_LABEL) IND_LOC
from ASGPRDB_DBF asg
left join ASGPRDH_DBF ash on asg.M__INDEX_ = ash.M__INDEX_
left join TRN_PLCC_DBF plcc on ash.M__DATE_ = plcc.M_DATE
left join CM_PHYS_DBF fysa on asg.M_PRODUCT = fysa.M_REFERENCE
left join CM_QUALITY_DBF qlya on asg.M_QUALITY = qlya.M_REFERENCE
left join CM_LOCAT_DBF loca on asg.M_LOCATION = loca.M_REFERENCE
left join CM_LOCAT_DBF lar on loca.M_AREA = lar.M_REFERENCE
left join CM_LOCAT_DBF lto on loca.M_TO = lto.M_REFERENCE
left join CMC_DLV_TRM_DBF trm on asg.M_DLV_TERM = trm.M_REFERENCE
left join RT_INDEX_DBF ind on asg.M_INDEX = ind.M_INDEX
left join CM_MKTSR_DBF hsr on asg.M_SERIE = hsr.M_SERIE
left join CM_INDEX_DBF indc on ind.M_COM_IND = indc.M_REFERENCE
left join CM_PHYS_DBF fysi on indc.M_PHYSICAL = fysi.M_REFERENCE
left join CM_QUALITY_DBF qlyi on fysi.M_DEF_QUAL = qlyi.M_REFERENCE
left join CM_LOCAT_DBF loci on indc.M_LOCATION = loci.M_REFERENCE
where ash.M__DATE_ = plcc.M_DATE
order by ASG_PHY, ASG_QLY, ASG_LOC, ASG_TERM, CUR