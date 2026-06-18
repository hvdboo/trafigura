select
rtrim(frm.M_LABEL) FRM, coalesce(rtrim(frm.M_DESC),' ') DES,
case frm.M_CLASS 
when 'BS' then 'Balance sheet'
when 'OB' then 'Off balance sheet'
when 'IS' then 'Income statement' else null end CLASS,
case frm.M_TRN_CLASS
when 0 then 'Transaction'
when 2 then 'Payment flow'
when 3 then 'Hedge'
when 4 then 'Lot'
when 5 then 'Contributor'
when 8 then 'Position'
when 9 then 'Business event' else null end OBJ,
case tre.M_D_DATA0
when  1 then 'root'
when 10 then 'case'
when 11 then 'if'
when 20 then 'filter if'
when 21 then 'filter case'
when 30 then 'simple account'
when 31 then 'dynamic account' else null end FLAG,
case when tre.M_HEIGHT = 1 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV1,
case when tre.M_HEIGHT = 2 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV2,
case when tre.M_HEIGHT = 3 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV3,
case when tre.M_HEIGHT = 4 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV4,
case when tre.M_HEIGHT = 5 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV5,
case when tre.M_HEIGHT = 6 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV6,
case when tre.M_HEIGHT = 7 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV7,
case when tre.M_HEIGHT = 8 then case when tre.M_D_DATA0 in (30,31) then rtrim(ac1.M_LABEL) else rtrim(tre.M_LABEL) end end LEV8
from TRN_ACAT_DBF tre
left join TRN_ACAF_DBF frm on to_number(tre.M_TRE_NAME) = frm.M_REFERENCE
left join TRN_ACA1_DBF ac1 on tre.M_D_DATA1 = ac1.M_REFERENCE
-- where rtrim(tre.M_TRE_NAME)='2'
order by frm.M_LABEL, tre.M_NODE_ID