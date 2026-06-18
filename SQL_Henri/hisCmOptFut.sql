select
to_char(bdy.M_DATE,'YYYY-MM-DD') DATSYS,
rtrim(fut.M_LABEL) CNT,
rtrim(mat.M_LABEL) MAT,
to_char(mat.M_MATURITY,'YYYY-MM-DD') EXP,
substr(hdr.M_KEY1,1,length(rtrim(hdr.M_KEY1))-2) STK, 
substr(hdr.M_KEY1,length(rtrim(hdr.M_KEY1)),1) RGT,
rtrim(hsr.M_LABEL) HSR,
round(bdy.M_P13,qot.M_PRC_DEC) HIS

from B165614_HBS bdy
left join H165614_H2S hdr on bdy.M_KEYID = hdr.M_KEYID
left join CM_OMAT1_DBF mat on hdr.M_KEY0 = mat.M_REFERENCE
left join RT_GROUP_DBF grp on rtrim(grp.M_HISFILE) = '165614'
left join CM_FUT_DBF fut on trim(substr(grp.M_GRP_DESC,1,10)) = to_char(fut.M_REFERENCE)
left join CMC_QUOT_DBF qot on trim(substr(grp.M_GRP_DESC,11,15)) = to_char(qot.M_REFERENCE)
left join CM_MKTSR_DBF hsr on hsr.M_SERIE = 13

order by CNT, EXP, STK, RGT
