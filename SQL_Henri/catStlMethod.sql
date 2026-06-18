select 
rtrim (stl.M_LABEL) LAB, 
rtrim(stl.M_DESC) DES

from STL_METHOD_DBF stl

order by stl.M_LABEL
