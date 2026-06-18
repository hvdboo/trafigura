select distinct
rtrim(th.M_LABEL) as M_TREE, 
case when t.M_HEIGHT >= 0 then  
      case t0.M_D_DATA2 
      when 1 then rtrim(elt0.M_LABEL) 
      when 2 then rtrim(fld0.M_LABEL) end 
else '.' end as M_NODE0,
case when t.M_HEIGHT >= 1 then 
      case t1.M_D_DATA2 
      when 1 then rtrim(elt1.M_LABEL) 
      when 2 then rtrim(fld1.M_LABEL) end 
else '.' end as M_NODE1,
case when t.M_HEIGHT >= 2 then 
      case t2.M_D_DATA2 
      when 1 then rtrim(elt2.M_LABEL) 
      when 2 then rtrim(fld2.M_LABEL) end 
else '.' end as M_NODE2,
case when t.M_HEIGHT >= 3 then 
      case t3.M_D_DATA2 
      when 1 then rtrim(elt3.M_LABEL) 
      when 2 then rtrim(fld3.M_LABEL) end 
else '.' end as M_NODE3,
rtrim(elt.M_DESC) as M_PHY_DES, 
case t.M_D_DATA2 
   when 1 then 'Elt' 
   when 2 then 'Fld' end as M_NODE_TYP,
case t.M_D_DATA2 
   when 1 then rtrim(elt.M_LABEL) 
   when 2 then rtrim(fld.M_LABEL) end as M_NODE_LAB,
t.M_REF as M_NODE_REF,
t.M_D_DATA1 as M_LIM_MTM, t.M_D_DATA3 as M_LIM_VAR, t.M_D_DATA4 as M_LIM_STR
from CMU_MMST_DBF t
left outer join CMU_TREE_DBF th on to_number(t.M_TRE_NAME) = th.M_REFERENCE
left outer join CMU_MMST_DBF t0 on (t0.M_FATHER_R = 0        and t0.M_HEIGHT = 0 and rtrim(t0.M_TRE_GROUP) = 'CMU_TREEG' and to_number(t0.M_TRE_NAME) = th.M_REFERENCE)
left outer join CMU_MMST_DBF t1 on (t1.M_FATHER_R = t0.M_REF and t1.M_HEIGHT = 1 and rtrim(t1.M_TRE_GROUP) = 'CMU_TREEG' and to_number(t1.M_TRE_NAME) = th.M_REFERENCE)
left outer join CMU_MMST_DBF t2 on (t2.M_FATHER_R = t1.M_REF and t2.M_HEIGHT = 2 and rtrim(t2.M_TRE_GROUP) = 'CMU_TREEG' and to_number(t2.M_TRE_NAME) = th.M_REFERENCE)
left outer join CMU_MMST_DBF t3 on (t3.M_FATHER_R = t2.M_REF and t3.M_HEIGHT = 3 and rtrim(t3.M_TRE_GROUP) = 'CMU_TREEG' and to_number(t3.M_TRE_NAME) = th.M_REFERENCE)
left outer join ADT_TREEF_DBF fld  on (t.M_REF  = fld.M_REFERENCE  and t.M_D_DATA2  = 2)
left outer join ADT_TREEF_DBF fld0 on (t0.M_REF = fld0.M_REFERENCE and t0.M_D_DATA2 = 2) 
left outer join ADT_TREEF_DBF fld1 on (t1.M_REF = fld1.M_REFERENCE and t1.M_D_DATA2 = 2) 
left outer join ADT_TREEF_DBF fld2 on (t2.M_REF = fld2.M_REFERENCE and t2.M_D_DATA2 = 2)
left outer join ADT_TREEF_DBF fld3 on (t3.M_REF = fld3.M_REFERENCE and t3.M_D_DATA2 = 2)
left outer join CM_PHYS_DBF elt  on (t.M_REF  = elt.M_REFERENCE  and t.M_D_DATA2  = 1)
left outer join CM_PHYS_DBF elt0 on (t0.M_REF = elt0.M_REFERENCE and t0.M_D_DATA2 = 1)
left outer join CM_PHYS_DBF elt1 on (t1.M_REF = elt1.M_REFERENCE and t1.M_D_DATA2 = 1)
left outer join CM_PHYS_DBF elt2 on (t2.M_REF = elt2.M_REFERENCE and t2.M_D_DATA2 = 1)
left outer join CM_PHYS_DBF elt3 on (t3.M_REF = elt3.M_REFERENCE and t3.M_D_DATA2 = 1)
where rtrim(t.M_TRE_GROUP) = 'CMU_TREEG' and to_number(t.M_TRE_NAME) = th.M_REFERENCE and
case
when t.M_HEIGHT = 0 then t0.M_REF
when t.M_HEIGHT = 1 then t1.M_REF
when t.M_HEIGHT = 2 then t2.M_REF
when t.M_HEIGHT = 3 then t3.M_REF
end = t.M_REF
order by 1,2,3,4,5
