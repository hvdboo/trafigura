select 
case
when h.M_TYPE=34 then 'Com PRICE'
when h.M_TYPE=50 then 'Com VOLAT' else ' ' end FAMTYP,
h.M_LABEL FAMILY, h.M_DESC DESCRIPTION,
b.M_HEIGHT LEV, b.M_FATHER_L FATHER,  
b.M_LABEL CURVE,  
case
when s.M_PROPAG=0 then 'Default'
when s.M_PROPAG=1 then 'By contract' 
when s.M_PROPAG=2 then 'Avg.weight (1,0)'
when s.M_PROPAG=3 then 'Avg.weight (1,1)'
when s.M_PROPAG=4 then 'On fixing' else ' ' end PROPAGATION
from MDI_FMLY_T_DBF b
left join MDI_FT_DBF h on to_number(b.M_TRE_NAME) = h.M_REFERENCE
left join MDI_FKCFG_DBF s on b.M_D_DATA2 = s.M_REFERENCE
left join MDI_FN_34_DBF f34 on (b.M_REF = f34.M_REFERENCE) 
left join RT_CT_DBF crv on f34.M_F_129 = crv.M_SLABEL
left join CM_INDEX_DBF ind on crv.M_SLABEL = cast(ind.M_REFERENCE as char) 
where h.M_TYPE=34 or h.M_TYPE=50 
order by h.M_TYPE, h.M_LABEL, b.M_HEIGHT, b.M_NODE_ID, b.M_FATHER_L 
