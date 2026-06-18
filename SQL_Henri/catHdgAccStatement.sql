select 
rtrim (stm.M_LABEL) LAB, 
rtrim(stm.M_DESC) DES

from HEDGE#STAT_CAT_DBF stm

order by LAB
