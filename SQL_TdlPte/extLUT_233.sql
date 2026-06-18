select 
rtrim(lut.M_LABEL) LUT, 
rtrim(hdr.M_LABEL) FOLDER,
rtrim(M_PTF) PTF,
rtrim(M_ADDCRIT) CRIT,
rtrim(M_RECIPIENT) RECIPIENT,
rtrim(M_PORTFOLIO) PFL_TGT
from UDTB233_DBF tbl
left join UDTH233_DBF hdr on tbl.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH233'
