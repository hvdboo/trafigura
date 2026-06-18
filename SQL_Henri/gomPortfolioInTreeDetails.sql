select distinct
rtrim(pfl.M_LABEL) PFL_LAB, 
max(rtrim(pfl.M_DESC)) PFL_DES,
rtrim(udf.M_DIVISION) DIVISION,
rtrim(udf.M_STREAM) STREAM,
rtrim(udf.M_MASTRDSK) MASTER,

max(case when rtrim(tre.M_TRE_GROUP) = 'MUB' then 
rtrim(plc00.M_LABEL)||' > '||rtrim(plc01.M_LABEL)||' > '||rtrim(plc02.M_LABEL)||' > '||rtrim(plc03.M_LABEL)||' > '||rtrim(plc04.M_LABEL)||' > '||rtrim(plc05.M_LABEL)||' > '||rtrim(plc06.M_LABEL)||' > '||rtrim(plc07.M_LABEL) 
else null end) PL_CONTROL


from TRN_PFLD_DBF pfl
left join TABLE#DATA#PORTFOLI_DBF udf on rtrim(pfl.M_LABEL) = rtrim(udf.M_LABEL)
left join MUB#MUB_TREE_DBF tre on rtrim(pfl.M_LABEL) = rtrim(tre.M_LABEL)
left join MUB#MUB_TPL_DBF  tpl on rtrim(tre.M_TRE_GROUP) = rtrim(tre.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF oth02 on (rtrim(pfl.M_LABEL) = rtrim(oth02.M_LABEL) and oth02.M_TRE_GROUP = '4' and oth02.M_HEIGHT = 2) 
left join MUB#MUB_TREE_DBF oth01 on (oth02.M_FATHER_R = oth01.M_REF and oth02.M_HEIGHT = 2 and oth02.M_TRE_GROUP = oth01.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF oth00 on (oth01.M_FATHER_R = oth00.M_REF and oth01.M_HEIGHT = 1 and oth01.M_TRE_GROUP = oth00.M_TRE_GROUP) 
left join MUB#MUB_TREE_DBF oth02 on (rtrim(pfl.M_LABEL) = rtrim(oth02.M_LABEL) and oth02.M_HEIGHT = 2 and oth02.M_TRE_GROUP = '4') 
left join MUB#MUB_TREE_DBF oth01 on (oth02.M_FATHER_R = oth01.M_REF and oth02.M_HEIGHT = 2 and oth02.M_TRE_GROUP = oth01.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF oth00 on (oth01.M_FATHER_R = oth00.M_REF and oth01.M_HEIGHT = 1 and oth01.M_TRE_GROUP = oth00.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF plc07 on (rtrim(pfl.M_LABEL) = rtrim(plc07.M_LABEL) and plc07.M_HEIGHT = 7 and plc07.M_TRE_GROUP = 'MUB')
left join MUB#MUB_TREE_DBF plc06 on (plc07.M_FATHER_R = plc06.M_REF and plc06.M_HEIGHT = 6 and plc07.M_TRE_GROUP = plc06.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF plc05 on (plc06.M_FATHER_R = plc05.M_REF and plc05.M_HEIGHT = 5 and plc06.M_TRE_GROUP = plc05.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF plc04 on (plc05.M_FATHER_R = plc04.M_REF and plc04.M_HEIGHT = 4 and plc05.M_TRE_GROUP = plc04.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF plc03 on (plc04.M_FATHER_R = plc03.M_REF and plc03.M_HEIGHT = 3 and plc04.M_TRE_GROUP = plc03.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF plc02 on (plc03.M_FATHER_R = plc02.M_REF and plc02.M_HEIGHT = 2 and plc03.M_TRE_GROUP = plc02.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF plc01 on (plc02.M_FATHER_R = plc01.M_REF and plc01.M_HEIGHT = 1 and plc02.M_TRE_GROUP = plc01.M_TRE_GROUP)
left join MUB#MUB_TREE_DBF plc00 on (plc01.M_FATHER_R = plc00.M_REF and plc00.M_HEIGHT = 0 and plc01.M_TRE_GROUP = plc00.M_TRE_GROUP)

where 1 = 1
and pfl.M_TYPE = 0
and pfl.M_REF not in (2,3,5,6,7,1723)
and substr(pfl.M_LABEL,1,4) not in ('ORDE','WASH')

group by pfl.M_LABEL, tpl.M_LABEL, udf.M_DIVISION, udf.M_STREAM, udf.M_MASTRDSK
order by PFL_LAB