select 
rtrim(lut.M_LABEL)       LUT, 
rtrim(hdr.M_LABEL)       FOLDER,
rtrim(tbl.M_MXPTYPE)     MX_TYP,
rtrim(nav.M_MVNAVPATH)   MX_NAV,
rtrim(tbl.M_MXPUBLICAT)  MX_PUB,
rtrim(tbl.M_MXLABEL)     MX_LAB,
rtrim(tbl.M_MXQLABEL)    MX_QOT,
rtrim(tbl.M_MXGENERAT)   MX_GEN,
rtrim(tbl.M_MXTENOR)     MX_TENOR,
rtrim(tbl.M_MVSYMBOL)    MV_SYM,
rtrim(tbl.M_MVPRICEFLD)  MV_PRCFLD,
rtrim(tbl.M_MVVOLPF)     MV_VOLPF,
rtrim(tbl.M_MVTEMPLATE)  MV_TMPL,
rtrim(tbl.M_MVSEP)       MV_SEP,
rtrim(tbl.M_MVDIVIDE)    MV_DIV,
rtrim(tbl.M_MVFOLDER)    MV_FOLDER

from UDTB343_DBF tbl
left join UDTH343_DBF hdr on tbl.M__INDEX_ = hdr.M__INDEX_
left join RTG_TYP_DBF lut on lut.M_HEADER = 'UDTH343'
left join UDTB346_DBF nav on rtrim(tbl.M_MXPTYPE) = rtrim(nav.M_MXPTYPE)
