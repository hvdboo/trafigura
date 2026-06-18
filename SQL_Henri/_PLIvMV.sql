
select 
rtrim(lut.M_MXPTYPE) LUTTYP, rtrim(lut.M_MXLABEL) LUTLAB, rtrim(lut.M_MXGENERAT) LUTGEN,
pli.M_PLITYP, pli.M_PLILAB,
case when rtrim(lut.M_MXLABEL) = rtrim(pli.M_PLILAB) then 1 else 0 end DIF

from UDTB343_DBF lut
left join VIW_PLI_DBF pli on rtrim(lut.M_MXLABEL) = rtrim(pli.M_PLILAB)