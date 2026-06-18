select
rtrim(sd.M_LABEL) CONFIG, 
rtrim(M_DESC) DES,
-- Method
rtrim(sd.M_DATE) DAT,
case sd.M_METHOD
when 'C'  then 'Conversion'
when 'T'  then 'Transfer'
when 'CT' then 'Transfer and conversion' end METH,
case sd.M_SCOPE
when 'Eco'       then 'Economic PL'
when 'Acc'       then 'Accrual PL'
when 'EcoNF'     then 'Economic PL - (Financing+PVE)'     
when 'EcoNF+PVE' then 'Economic PL - Financing'
when 'PastCash'  then 'Past cash'
when 'PastCashR' then 'Past cash (realized)'
when 'ThFin'     then 'Theoretical financing'
when 'ThFinCtPL' then 'Theoretical financing (constant PL)'
when 'Brk'       then 'Brokerage fees' end TGT,
sd.M_BYLEG PNL_BYLEG,
sd.M_INCL_BRK BRK_INCL,
-- Scope
case sd.M_LOADING
when 'C' then 'By Portfolio'
when 'D' then 'Predefined filter' end LOAD,
rtrim(sd.M_FILTER) FLT,
case sd.M_BYCUR
when 'N' then 'Instrument'
when 'Y' then 'Currency' end GRPBY,
sd.M_MIN_AMT IGNIFLESS,
-- Deals
case sd.M_DEALS
when 'SCF' then 'Simple cash flows'
when 'ASS' then 'Assignments' end DEAL,
rtrim(sd.M_SD_CUR) CURASG_RULE,
rtrim(rtgCurB.M_SDCUR) CURASG_CURSLD,
sd.M_SD_PTF  PFLASGSDN_RULE,
-- rtrim(rtgPflSldB.M_SDPTF) PFLASG_PFLSLD,
sd.M_RES_PTF PFLASGRES_RULE,
rtrim(rtgPflResB.M_SDPTF) PFLASG_PFLRES,
sd.M_FXHEDGE FXSPOT,
-- Market data
case sd.M_DATA_SRC
when 'Ref' then 'Reference set'
when 'Xml' then 'External XML file'
when 'RT'  then 'Real-time set' end CNVSRC,
rtrim(sd.M_DATA_SRC2) CNVSET,
rtrim(sd.M_PL_MDS) PNLSET

from SD_CFG_DBF sd
left join RTGSDCH_DBF rtgCurH on rtrim(sd.M_SD_CUR) = rtrim(rtgCurH.M_LABEL)
left join RTGSDCB_DBF rtgCurB on rtgCurH.M__INDEX_ = rtgCurB.M__INDEX_
left join RTGSDPH_DBF rtgPflSldH on rtrim(sd.M_SD_PTF) = rtrim(rtgPflSldH.M_LABEL)
-- left join RTGSDPB_DBF rtgPflSldB on rtgPflSldH.M__INDEX_ = rtgPflSldB.M__INDEX_
left join RTGSDPH_DBF rtgPflResH on rtrim(sd.M_RES_PTF) = rtrim(rtgPflResH.M_LABEL)
left join RTGSDPB_DBF rtgPflResB on rtgPflResH.M__INDEX_ = rtgPflResB.M__INDEX_

order by CONFIG, FLT
