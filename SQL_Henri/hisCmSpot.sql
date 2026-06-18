select 
rtrim(ind.M_HISFILE) HIS,
to_char(hisbdy.M_INS_DATE,'YYYY-MM-DD') INS_DAT,
to_char(hisbdy.M_DATE,'YYYY-MM-DD') FIX_DAT,
rtrim(grp.M_GRP_DESC) GRP,
rtrim(pub.M_LABEL) PUB,
-- rtrim(ind.M_IND_LAB) IND,
rtrim(cmi.M_LABEL) CMI,
rtrim(qot.M_LABEL) QOT,
'653: '||rtrim(hsr1.M_LABEL)||
', 654: '||rtrim(hsr2.M_LABEL)||
', 655: '||rtrim(hsr3.M_LABEL) HSR, 
hisbdy.M_P653 P653,
hisbdy.M_P654 P654,
hisbdy.M_P655 P655

from B835025_HBS hisbdy
left join TRN_PC_DBF bo on 1 = 1
left join H835025_H1S  hishdr on hisbdy.M_KEYID = hishdr.M_KEYID
left join CM_INDEX_DBF cmi on to_number(trim(substr(hishdr.M_KEY0,1,8))) = cmi.M_REFERENCE
left join CMC_QUOT_DBF qot on to_number(trim(substr(hishdr.M_KEY0,9,8))) = qot.M_REFERENCE
left join CM_MKT_DBF pub on qot.M_PUBLI = pub.M_REFERENCE
left join CM_MKTSR_DBF hsr1 on hsr1.M_SERIE = 653
left join CM_MKTSR_DBF hsr2 on hsr2.M_SERIE = 654
left join CM_MKTSR_DBF hsr3 on hsr3.M_SERIE = 655
left join RT_INDEX_DBF ind on cmi.M_REFERENCE = ind.M_COM_IND and qot.M_REFERENCE = ind.M_COM_QUOT
left join RT_GROUP_DBF grp on rtrim(ind.M_HISFILE) = rtrim(grp.M_HISFILE)

where 1 = 1
and hisbdy.M_DATE = bo.M_DATE
-- and to_char(his.M_DATE,'YYYY-MM-DD') = '2021-11-15'

order by FIX_DAT, CMI
