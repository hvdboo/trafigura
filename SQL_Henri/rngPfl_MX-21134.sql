select 
rtrim(acs.M_LABEL)   ORA,
rtrim(acs.M_DESC)    MDK,
rtrim(alt.M_OBJ_ALT) MDKGUID

from TRN_ACSC_DBF acs
left join KEYMAP_STC_DBF alt on acs.M_REFERENCE = alt.M_OBJ_ID and alt.M_OBJ_CLASS = 'MDkZb35207' and rtrim(alt.M_OBJ_ASYS) = 'SRD'

order by ORA