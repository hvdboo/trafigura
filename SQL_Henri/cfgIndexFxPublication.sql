select
rtrim(arc.M_DESC)      ARCLAB,
rtrim(arc.M_DETAILS)   ARCDES,
rtrim(arc.M_LOCATION)  LOC,
case when arc.M_FREQUENCY = 0 then 'Daily' else 'Free' end FRQ,
rtrim(arc.M_CALENDAR)  CALLAB,
rtrim(cal.M_DESC)      CALDES,
rtrim(arc.M_SHIFTER)   SHIFT,
rtrim(lnk.M_CONTRACT)  CNT,
rtrim(lnk.M_QUOTATION) QOT,
rtrim(curbas.M_FULL_NAME) CURBAS,
rtrim(curund.M_FULL_NAME) CURUND,
rtrim(lnk.M_FORM_FACT) FCT,
rtrim(hsr0.M_COLUMN)   HSR0,
rtrim(hsr1.M_COLUMN)   HSR1,
--rtrim(arc.M_DESC)||' '||rtrim(cnt.M_CONTRACT)||' '||rtrim(hsr0.M_COLUMN) ALTKEY,
rtrim(alt.M_OBJ_ALBL)  FIXSRC,
rtrim(alt.M_OBJ_ALT)   SRDSRC,
rtrim(arc.M_HIS_FILE)  HIS

from FX_ARCCT_DBF lnk
left join FX_CNT_DBF   cnt on rtrim(lnk.M_CONTRACT) = rtrim(cnt.M_LABEL)
left join FX_CURR_DBF  curbas on cnt.M_BASE = curbas.M_LABEL
left join FX_CURR_DBF  curund on cnt.M_UNDERLNG = curund.M_LABEL
left join FX_ARCGR_DBF arc on rtrim(lnk.M_DESC) = rtrim(arc.M_DESC)
left join CAL_DEF_DBF  cal on rtrim(arc.M_CALENDAR) = rtrim(cal.M_LABEL)
left join FX_ARCCL_DBF hsr0 on arc.M_COL_LINK = hsr0.M_LINK and hsr0.M_INDEX = 0
left join FX_ARCCL_DBF hsr1 on arc.M_COL_LINK = hsr1.M_LINK and hsr1.M_INDEX = 1
left join KEYMAP_STC_DBF alt on (rtrim(arc.M_DESC)||' '||rtrim(lnk.M_CONTRACT)||' '||rtrim(hsr0.M_COLUMN)) = rtrim(alt.M_OBJ_DESC) and rtrim(alt.M_OBJ_CLASS) = 'MdDui65528'

order by ARCLAB, arc.M_COL_NUM