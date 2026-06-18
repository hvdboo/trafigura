select rtrim(trh.M_LABEL) TREE,
case tr0.M_D_DATA2 
when 1 then rtrim(elt0.M_LABEL) 
when 2 then rtrim(fld0.M_LABEL) end LAB0,
case tr1.M_D_DATA2 
when 1 then rtrim(elt1.M_LABEL) 
when 2 then rtrim(fld1.M_LABEL) end LAB1,
case tr2.M_D_DATA2 
when 1 then rtrim(elt2.M_LABEL) 
when 2 then rtrim(fld2.M_LABEL) end LAB2,
case tr3.M_D_DATA2 
when 1 then rtrim(elt3.M_LABEL) 
when 2 then rtrim(fld3.M_LABEL) end LAB3
from CMU_MMST_DBF tr3
left join CMU_TREE_DBF trh on to_number(tr3.M_TRE_NAME) = trh.M_REFERENCE
left join CMU_MMST_DBF tr2 on tr3.M_FATHER_R = tr2.M_REF
left join CMU_MMST_DBF tr1 on tr2.M_FATHER_R = tr1.M_REF
left join CMU_MMST_DBF tr0 on tr1.M_FATHER_R = tr0.M_REF
left join ADT_TREEF_DBF fld3 on tr3.M_REF = fld3.M_REFERENCE
left join ADT_TREEF_DBF fld2 on tr2.M_REF = fld2.M_REFERENCE
left join ADT_TREEF_DBF fld1 on tr1.M_REF = fld1.M_REFERENCE
left join ADT_TREEF_DBF fld0 on tr0.M_REF = fld0.M_REFERENCE
left join CM_PHYS_DBF elt3 on tr3.M_REF = elt3.M_REFERENCE
left join CM_PHYS_DBF elt2 on tr2.M_REF = elt2.M_REFERENCE
left join CM_PHYS_DBF elt1 on tr1.M_REF = elt1.M_REFERENCE
left join CM_PHYS_DBF elt0 on tr0.M_REF = elt0.M_REFERENCE
--where tr3.M_HEIGHT = 3
order by LAB0, LAB1, LAB2, LAB3