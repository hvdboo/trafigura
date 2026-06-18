select 
rtrim(lut.M_LABEL)       LUT, 
rtrim(hdr.M_LABEL)       FOLDER,
rtrim(tbl.M_INSTRUMENT)  PLI,
rtrim(tbl.M_I_CNT_TYPO)  TYPO,
rtrim(tbl.M_NCCY1)       CUR1,
rtrim(tbl.M_NCCY2)       CUR2,
rtrim(tbl.M_I_REFRATE)   REFRTE,
rtrim(tbl.M_I_RR_TUNIT)  RFRUOM,
rtrim(tbl.M_I_RR_TVAL)   RFRVAL,
rtrim(tbl.M_I_UII_TUNI)  UNDUOM,
rtrim(tbl.M_I_UII_TVAL)  UNDVAL,
rtrim(tbl.M_I_OL_RRATE)  REFRTE_OL,
rtrim(tbl.M_I_OL_RR_TU)  RFRUOM_OL,
rtrim(tbl.M_I_OL_RR_TV)  RFRVAL_OL, 
rtrim(tbl.M_I_NOTSCH)    SCHNOT,
rtrim(tbl.M_R_PAYOUT_T)  PAYOUT,
rtrim(tbl.M_I_ASSETCL)   ASSET

from UDTB342_DBF tbl
left join UDTH342_DBF hdr on tbl.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH342'