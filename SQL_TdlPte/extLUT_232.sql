select 
rtrim(lut.M_LABEL) TBL, 
rtrim(luh.M_LABEL) FLD,
rtrim(lub.M_USER) USER_,
rtrim(lub.M_PUBLICATIO) PUB,
rtrim(lub.M_PTF) PFL,
rtrim(lub.M_CTP) CTP,
rtrim(lub.M_CMASSET) ASSET,
rtrim(lub.M_RECIPIENT) RECIPIENT
from UDTB232_DBF lub
left join UDTH232_DBF luh on lub.M__INDEX_ = luh.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH232'
