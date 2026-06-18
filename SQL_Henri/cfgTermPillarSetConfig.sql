select 
pils.M_REFERENCE, pild.M_REFERENCE, 
pils.M_LABEL PILSET, pils.M_DESC DESCRIPTION,
case pild.M__TYPE_
when 1 then 'Fut.mat'
when 2 then 'Opt.mat'
when 3 then 'Pil.set' end TYP,
case pild.M__TYPE_
when 1 then fmat.M_LABEL
when 2 then omat.M_LABEL
when 3 then pmat.M_LABEL end MATSET,
case pild.M_BL_TYPE
when -9 then 'All'
when -1 then 'Floating'
when  0 then 'Fixed'
when  1 then 'Day'
when  3 then 'Month'
when  4 then 'Quarter'
when  6 then 'Year' else '' end BLOCK,
case pild.M_WIN_TYPE
when 1 then 'Single'
when 2 then 'Range'
when 3 then 'All' else '' end WIND,
case pild.M_DATE_TYPE
when 1 then 'Quot.start'
when 2 then 'Quot.end'
when 4 then 'Dlv.start'
when 8 then 'Dlv.end' end DECISION,
pild.M_PIL_MODE,
case pild.M_PIL_MODE
when 1 then 'Delivery period (along bucket)'
when 2 then 'Quotation end (on pillar)' 
when 3 then 'Delivery start'
when 4 then 'On pillar (underlying delivery start)'
when 5 then 'Delivery end'
when 6 then 'Notification start'
when 7 then 'Notification end' end GRAVITY,
case pild.M_PIL_MODE2
when 1 then 'Finest'
when 2 then 'Bucket' end DELIVERY

from CMG_CNFL_DBF pild
left join CM_PLST_DBF pils on pild.M_LIST = pils.M_REFERENCE
left join CM_FMAT_DBF fmat on pild.M_MS_FUT = fmat.M_REFERENCE
left join CM_OMAT_DBF omat on pild.M_MS_OFUT = omat.M_REFERENCE
left join CM_PLST_DBF pmat on pild.M_PIL_SET = pmat.M_REFERENCE

-- where pild.M_REFERENCE = 355
order by PILSET 