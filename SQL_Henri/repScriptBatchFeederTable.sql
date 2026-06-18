select distinct
scr.M_REF SCR_ID,
rtrim(scr.M_NAME) SCR_LAB, rtrim(scr.M_DESC) SCR_DES,
case bat.M_TYPE
when 1 then 'Feeders'
when 2 then 'Extracts' 
when 3 then 'Stored proc' else '_' end BATCH_TYP,
-- bat.M_REF BAT_REF,
rtrim(bat.M_LABEL) BATCH_LAB, rtrim(bat.M_DESC) BATCH_DES,
bat.M_FLTTEMP BATCH_FLT,
case  
when bat.M_TYPE = 1 then 
case bat.M_DATAHIS
when 0 then 'One set'
when 1 then 'One set per day'
when 2 then 'One set per run' else null end end BATCH_DATHIS, 
bat.M_TAGDATA BATCH_DATTAG,
fed.M_REF FEED_REF,
case fed.M_EXECTX
when 5 then 'Feeder'
when 6 then 'Actuate'
when 7 then 'Extraction'
when 8 then 'Procedure' else '_' end FEED_TYP,
rtrim(fed.M_LABEL) FEED_LAB, rtrim(fed.M_DESC) FEED_DES,
reqxtr.M_REF XTR_REF,
rtrim(reqxtr.M_LABEL) XTR_LAB,
rtrim(reqprc.M_LABEL) PRO_LAB,
case dtm.M_TYPE
when 0 then 'Dynamic'
when 1 then 'DataDic'
when 4 then 'SQL' else null end DTMTYP,
rtrim(dtm.M_LABEL) DTM, 
dyn.M_DYN_TABLE DYN_LAB,
case dyn.M_DYN_TABLE_DIR_TYPE
when 0 then vw1.M_CLASS
when 1 then vw3.M_CLASS
when 2 then vw2.M_CLASS
when 3 then vw4.M_CLASS else null end DYN_CLAS

from PROCESS#PS_ITEM_DBF itm 
left join PROCESS#PS_SCRPT_DBF scr on itm.M_REF = scr.M_REF 
left join ACT_SET_DBF bat on itm.M_PARAM_LAB2 = bat.M_LABEL and itm.M_UNIT in ('REP_BATCHES_EXT','REP_BATCHES_FEED','REP_BATCHES_PROC')
left join ACT_SETREP_DBF lnk on bat.M_REF = lnk.M_REFSET
left join ACT_BAT_DBF fed on lnk.M_REFBAT = fed.M_REF
left join ACT_DYN_DBF rep on fed.M_REF = rep.M_REF
left join ACT_EXTR_DBF xtr on fed.M_REF = xtr.M_REF_BATCH
left join ACT_REQXTR_DBF reqxtr on xtr.M_REF_REQ = reqxtr.M_REF
left join ACT_STDPRC_DBF stp on fed.M_REF = stp.M_REF_BATCH
left join ACT_REQPROC_DBF reqprc on stp.M_REF_REQ = reqprc.M_REF
left join DAPFILTER_DBF flt on rtrim(bat.M_FLTTEMP) = rtrim(flt.M_LABEL)
left join RPO_DMSETUP_TABLE_DBF dtm on rtrim(rep.M_OUTPUT) = rtrim(dtm.M_LABEL)
left join RPO_DMSETUP_DYN_TABLE_DBF dyn on dtm.M_REFERENCE = dyn.M_REFERENCE
left join DYNDBF1#TRN_DYND_DBF vw1 on dyn.M_DYN_TABLE = vw1.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 0
left join DYNDBF2#TRN_DYND_DBF vw2 on dyn.M_DYN_TABLE = vw2.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 2
left join DYNDBF3#TRN_DYND_DBF vw3 on dyn.M_DYN_TABLE = vw3.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 1
left join DYNDBF4#TRN_DYND_DBF vw4 on dyn.M_DYN_TABLE = vw4.M_CREATION and dyn.M_DYN_TABLE_DIR_TYPE = 3

where scr.M_REF in 
(
123, 
166, 
167, 
213, 
214, 
218, 
219, 
220, 
230, 
234, 
250, 
251, 
252, 
253, 
254, 
255, 
256, 
257, 
258, 
259,
260, 
264, 
267, 
269, 
270, 
271, 
272, 
273, 
274, 
276, 
279, 
284, 
287, 
288, 
289, 
290, 
291, 
292, 
293, 
294, 
295, 
296, 
298, 
299, 
300,
301, 
302, 
306, 
322,--
323,--
327, 
328, 
329,
333, 
334, 
335, 
336, 
337, 
338, 
339, 
340, 
341, 
342, 
343, 
354, 
355, 
356, 
357, 
358, 
359, 
360, 
361, 
362, 
363, 
364, 
365, 
366, 
367, 
368, 
369, 
370, 
371, 
372, 
377, 
378, 
379, 
380, 
381, 
382, 
383, 
384, 
385, 
386, 
387, 
388, 
391, 
392, 
393, 
394, 
395, 
396, 
399, 
400, 
401, 
404, 
406, 
407, 
408, 
409, 
410, 
411, 
412, 
413, 
415, 
416, 
417, 
422, 
427,
434,
435,
442,
443,
444,
451,
452,
453,
454,
455,
458,
474,
476,
477
)

order by SCR_LAB, BATCH_TYP, BATCH_LAB, FEED_TYP, FEED_LAB, DTM