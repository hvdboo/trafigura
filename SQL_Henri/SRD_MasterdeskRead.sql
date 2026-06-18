select
-- mdk.CODS  ACR,
mdk.COD   CODE,
mdk.DES   DESCR,
-- mdk.ALIAS ALIAS,
mdk.ORA   ORACLE,
mdk.GUID  GUID,
case mdk.STA when 0 then 'Inactive' else 'Active' end STATUS

from SRD_MDK mdk
where mdk.STA is null

order by DESCR