select 
rtrim(cal.M_LABEL) LAB,
rtrim(cal.M_DSP_LABEL) LABDSP,
rtrim(cal.M_DESC) DES,
rtrim(cal.M_SWIFTCDE) SWIFT,
cal.M_ISUNION UNI, 
cal.M_MONDAY MON,
cal.M_TUESDAY TUE,
cal.M_WDNESDAY WED,
cal.M_THURSDAY THU,
cal.M_FRIDAY FRI,
cal.M_SATURDAY SAT,
cal.M_SUNDAY SUN,
rtrim(altsrd.M_OBJ_ALT) SRD,
rtrim(prflst.M_LABEL) PRFLST

from CAL_DEF_DBF cal
left join KEYMAP_STC_DBF altsrd on (rtrim(cal.M_LABEL) = rtrim(altsrd.M_OBJ_DESC) and altsrd.M_OBJ_CLASS = 'MbRYC67318' and rtrim(altsrd.M_OBJ_ASYS) = 'SRD')
left join LST_PREFV_DBF prfcal on rtrim(cal.M_LABEL) = rtrim(prfcal.M_VALUE) and prfcal.M_INDEX2 in (194)
left join LST_PREFH_DBF prflst on prfcal.M_INDEX2 = prflst.M_INDEX

-- where prfcal.M_INDEX2 in (194) or rtrim(cal.M_DSP_LABEL) in ('ENL','GeB')

order by UNI, LAB