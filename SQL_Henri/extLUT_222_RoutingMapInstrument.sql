select 
rtrim(M_REGISTR) REG_SRC,
rtrim(M_CMASSET) ASS,
rtrim(M_INSTRUMENT) PLI_SRC,
rtrim(M_ACTIVE) ACT,
rtrim(M_PATTERN_T) PATT,
'>',
rtrim(M_REGISTRLBL) REG_TGT,
rtrim(M_PATTERN) TYPO_TGT,
rtrim(M_EQD_INSTR) PLI_TGT

from UDTB222_DBF tbl
left join UDTH222_DBF hdr on tbl.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH222'

order by PLI_SRC, REG_SRC


