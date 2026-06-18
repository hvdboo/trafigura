select
bzl.COD CODE,
substr(bzl.COD,1,3) STLCOD,
bzl.LAB  LABEL,
bzl.GUID GUID

from SRD_BZL bzl
order by LABEL
