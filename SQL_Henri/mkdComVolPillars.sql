select distinct 
trim(grp.M_LABEL) as VolGroup,
trim(gri.M_CURR) as Currency,
case grp.M_GTYPE
when 1024 then trim(cmf.M_LABEL)
when 2048 then trim(cmi.M_LABEL) else null end as instrument,
trim(mato.M_LABEL) as "optMatLabel",
trim(matf.M_LABEL) as "futMatLabel",
to_char(to_date(matf.M_ST_END,'DD-MON-YY'),'YYYYMMDD') as expiryDate,
substr(to_char(to_date(matf.M_ST_END,'DD-MON-YY'),'YYYYMMDD'),1,4) ||
case
when SUBSTR(matf.M_ST_END, 4, 3) ='JAN' then 'M01'
when SUBSTR(matf.M_ST_END, 4, 3) ='FEB' then 'M02'
when SUBSTR(matf.M_ST_END, 4, 3) ='MAR' then 'M03'
when SUBSTR(matf.M_ST_END, 4, 3) ='APR' then 'M04'
when SUBSTR(matf.M_ST_END, 4, 3) ='MAY' then 'M05'
when SUBSTR(matf.M_ST_END, 4, 3) ='JUN' then 'M06'
when SUBSTR(matf.M_ST_END, 4, 3) ='JUL' then 'M07'
when SUBSTR(matf.M_ST_END, 4, 3) ='AUG' then 'M08'
when SUBSTR(matf.M_ST_END, 4, 3) ='SEP' then 'M09'
when SUBSTR(matf.M_ST_END, 4, 3) ='OCT' then 'M10'
when SUBSTR(matf.M_ST_END, 4, 3) ='NOV' then 'M11'
when SUBSTR(matf.M_ST_END, 4, 3) ='DEC' then 'M12'
end as "exchMaturity",
case grp.M_GTYPE
when 1024 then 'CM_FUT'
when 2048 then 'CM_INDEX' else null end "type",
'Delta_00' as "ordinates"

from CMG_GRP_DBF grp 
left join TRN_PC_DBF pc on 1 = 1
left join CMG_GRPI_DBF gri on grp.M_REFERENCE = gri.M_GROUP and grp.M_GTYPE = gri.M_GTYPE
left join CM_FUT_DBF cmf on (gri.M_FUTURE = cmf.M_REFERENCE and gri.M_GTYPE = 1024) 
left join CM_INDEX_DBF cmi on (gri.M_INDEX = cmi.M_REFERENCE and gri.M_GTYPE = 2048)
left join CM_PLST_DBF pil on grp.M_PILSET = pil.M_REFERENCE
left join CMG_GRPP_DBF grpp on pil.M_REFERENCE = grpp.M_PIL_SET  and grp.M__DATE_ = grpp.M__DATE_
left join CM_OMAT1_DBF mato on grpp.M_OMAT_CODE = mato.M_REFERENCE
left join CM_FMAT1_DBF matf on mato.M_UND_REF = matf.M_REFERENCE

where 1 = 1
and grp.M_GTYPE in (1024, 2048, 8192)
and grp.M__DATE_ = pc.M_DATE
-- and trim(grp.M__DATE_) = to_date(20181011,'YYYYMMDD')
and trim(grp.M_LABEL) in ('AL LME','CU CMX')

order by VOLGROUP, EXPIRYDATE;
