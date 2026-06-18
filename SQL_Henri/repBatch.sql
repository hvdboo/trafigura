select distinct
case bat.M_TYPE
when 1 then 'Batch of feeder'
when 2 then 'Batch of extract' else '_' end BAT_TYP,
rtrim(bat.M_LABEL) BAT_LAB, rtrim(bat.M_DESC) BAT_DESC,
rtrim(bat.M_FLTTEMP) BAT_FLT, 
-- flt.M_FILTER_REF,
case bat.M_DATAHIS
when 0 then 'One set'
when 1 then 'One set per day'
when 2 then 'One set per run' else '_' end BAT_DATHIS, 
rtrim(bat.M_TAGDATA) BAT_DATTAG,
case fed.M_EXECTX
when 5 then 'Feeder'
when 6 then 'Actuate'
when 7 then 'Extraction'
when 8 then 'Procedure' else '_' end ELT_TYP,
rtrim(fed.M_LABEL) ELT_LAB, rtrim(fed.M_DESC) ELT_DESC,
rtrim(rep.M_OUTPUT) REP, 
rtrim(dtm.M_LABEL) DTM_LAB, 
case dtm.M_TYPE
when 0 then 'Dynamic'
when 1 then 'Data dictionary'
when 4 then 'SQL' end DTM_TYP,
-- dtm.M_REFERENCE DTM_REF,
rtrim(dyn.M_DYN_TABLE) DYN_TBL, 
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then rtrim(dynmr.M_CLASS)
when 1 then rtrim(dynma.M_CLASS)
when 2 then rtrim(dynur.M_CLASS)
when 3 then rtrim(dynua.M_CLASS) else '_' end DYN_CLASS,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then 
case dynmr.M_CLASS_TYPE
when 8 then rtrim(dynmr.M_VIEW) else rtrim(dynmr.M_DBFALIAS) end 
when 1 then 
case dynma.M_CLASS_TYPE
when 8 then rtrim(dynma.M_VIEW) else rtrim(dynma.M_DBFALIAS) end 
when 2 then 
case dynur.M_CLASS_TYPE
when 8 then rtrim(dynur.M_VIEW) else rtrim(dynur.M_DBFALIAS) end
when 3 then 
case dynua.M_CLASS_TYPE
when 8 then rtrim(dynua.M_VIEW) else rtrim(dynua.M_DBFALIAS) end end DYN_UND
from ACT_DYN_DBF rep
left join ACT_BAT_DBF fed on rep.M_REF = fed.M_REF
left join ACT_SETREP_DBF lnk on fed.M_REF = lnk.M_REFBAT
left join ACT_SET_DBF bat on lnk.M_REFSET = bat.M_REF
left join ACT_EXTR_DBF xtr on fed.M_REF = xtr.M_REF_BATCH
left join ACT_REQXTR_DBF req on xtr.M_REF_REQ = req.M_REF
left join DAPFILTER_DBF flt on rtrim(bat.M_FLTTEMP) = rtrim(flt.M_LABEL)
left join RPO_DMSETUP_TABLE_DBF dtm on rtrim(rep.M_OUTPUT) = rtrim(dtm.M_LABEL)
left join RPO_DMSETUP_DYN_TABLE_DBF dyn on dtm.M_REFERENCE = dyn.M_REFERENCE
left join DYNDBF1#TRN_DYND_DBF dynmr on dyn.M_DYN_TABLE = dynmr.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 0
left join DYNDBF2#TRN_DYND_DBF dynur on dyn.M_DYN_TABLE = dynur.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 2
left join DYNDBF3#TRN_DYND_DBF dynma on dyn.M_DYN_TABLE = dynma.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 1
left join DYNDBF4#TRN_DYND_DBF dynua on dyn.M_DYN_TABLE = dynua.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 3
where (bat.M_TYPE = 1 or bat.M_TYPE = 2) 
and bat.M_REF in 
(
144, 145, 146, 185, 188, 190, 193, 196, 198,
201, 204, 206, 208, 209, 210, 212, 213, 214, 215, 216, 217, 218, 219,
220, 237, 240, 241, 248, 249, 250, 258, 264, 265, 266, 267, 268, 269,
275, 281, 290, 291, 293, 296, 297, 299,
300, 301, 302, 303, 305, 307, 309, 312, 315, 318, 319,
320, 321, 322, 323, 324, 325, 326, 328, 329,
330, 331, 332, 333, 334, 336, 397,
401, 402, 410, 431, 432, 433, 435, 437, 439, 444,
476, 477, 478, 479, 480, 481, 482, 485, 486, 487, 488, 489,
490, 491, 492, 493, 494, 495, 496, 497, 498, 499,
500, 501, 502, 503, 504, 505, 506, 507, 508
)
order by BAT_TYP desc, BAT_LAB, ELT_TYP, ELT_LAB, REP