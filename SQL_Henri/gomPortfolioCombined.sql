select 
rtrim(cmb.M_GROUP) GRP,
rtrim(cmb.M_LABEL) COMBI, 
-- cmb.M_UNIT_TYPE,
case cmb.M_UNIT_TYPE
when 0 then 'Empty' 
when 2 then 'Simple'  
when 3 then 'Combined'  
when 4 then 'Node' end as SIBTYP,
case 
when cmb.M_UNIT_TYPE in (2,3) then
   case pfl.M_TYPE
   when 0 then 'Simple'
   when 1 then 'Combined' else null end 
when cmb.M_UNIT_TYPE in (4) then to_char(pftree.M_HEIGHT) else null end PFLTYP,
coalesce(rtrim(pfl.M_LABEL), rtrim(pftree.M_LABEL)) PFL, 
rtrim(cto.M_DSP_LABEL) PC,
rtrim(pfl.M_ENTITY) CE,
rtrim(pfl.M_DESC) PFLD

from MUB#GRP_COMB_DBF cmb
left join TRN_PFLD_DBF pfl on cmb.M_UNIT = pfl.M_LABEL --and cmb.M_UNIT_TYPE = 2
left join TRN_CPDF_DBF cto on pfl.M_PROC_AREA = cto.M_ID
left join MUB#MUB_TREE_DBF pftree on cmb.M_UNIT_REF = pftree.M_REF and cmb.M_UNIT_TYPE = 4

--where cmb.M_UNIT_TYPE = 2 
--and rtrim(cmb.M_LABEL) in ('SDN CNY_MVPC','SDN CNY_PC')

order by COMBI, PFL