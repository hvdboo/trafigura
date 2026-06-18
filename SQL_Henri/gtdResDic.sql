select 
dic.COL,
dic.CAT02 CAT,
dic.FLD,
dic.TYP, dic.SIZ, dic.PRC,
dic.DES,
rtrim(to_char(dic.CMT)) CMT

from gtddic dic
where dic.CAT01 = 'PNL'
order by SEQ
