select rtrim(plcc.M_LABEL) LABEL, rtrim(plcc.M_DESC) DESCRIPTION, 
rtrim(pc.M_LABEL) PC, rtrim(ent.M_LABEL) CLOSING,
rtrim(plcc.M_EOD_SHIFT) EOD_SHIFT, rtrim(plcc.M_CALENDAR) EOD_CAL, plcc.M_HBTEOD EOD_H

from TRN_PLCC_DBF plcc
left join TRN_PC_DBF pc on plcc.M_PC = pc.M_REFERENCE
left join TRN_ENTD_DBF ent on plcc.M_MD_ENTITY = ent.M_REF

order by plcc.M_LABEL