/*select distinct PFLTGT from
();
*/

-- Current to Target --

select 
rtrim(pfl.M_LAB)      LAB,
rtrim(pfl.M_STREAM)   STREAM,
rtrim(pfl.M_MASTER)   MASTER,
rtrim(pfl.M_CATEGORY) CATEGORY,
rtrim(pfl.M_OWNER)    OWNER,
his.OCC OCC,
pfl.M_STR||pfl.M_MAS||' '||pfl.M_CAT||pfl.M_CE||' '||pfl.M_PC||pfl.M_MKT PFLTGT,
pfl.M_STRATEGY   STGTGT,
rtrim(pfl.M_DES) DES

from PFL_VW_DBF  pfl
--from PFL_VIW_REP pfl
left join trnHisto_Pfl his on rtrim(pfl.M_LAB) = rtrim(his.PFL)

where his.OCC is not null
order by LAB

-- Target from Current --
select 
rtrim(pfl.M_STREAM)   STREAM,
rtrim(pfl.M_MASTER)   MASTER,
rtrim(pfl.M_CATEGORY) CATEGORY,
pfl.M_STR||pfl.M_MAS||' '||pfl.M_CAT||pfl.M_CE||' '||pfl.M_PC||pfl.M_MKT PFLTGT,
pfl.M_STRATEGY      STGTGT,
rtrim(pfl.M_LAB)    LAB,
rtrim(pfl.M_OWNER)  OWNER,
rtrim(pfl.M_RMDLAB) ACCSEC,
his.OCC OCC

from PFL_VW_DBF  pfl
--from PFL_VIW_REP pfl
left join trnHisto_Pfl his on rtrim(pfl.M_LAB) = rtrim(his.PFL)
where his.OCC is not null

order by PFLTGT

-- Statistics --
select 
pfl.M_STR||pfl.M_MAS||' '||pfl.M_CAT||pfl.M_CE||' '||pfl.M_PC||pfl.M_MKT PFLTGT,
count(*)     SRC,
sum(his.OCC) TRN

from PFL_VW_DBF  pfl
--from PFL_VIW_REP pfl
left join trnHisto_Pfl his on rtrim(pfl.M_LAB) = rtrim(his.PFL)
where his.OCC is not null

group by (pfl.M_STR||pfl.M_MAS||' '||pfl.M_CAT||pfl.M_CE||' '||pfl.M_PC||pfl.M_MKT)
order by PFLTGT
