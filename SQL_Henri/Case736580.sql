-- Assign TYPE to QUOT
update CMC_QUOT_DBF set M__TYPE_ = 1 where M_REFERENCE in (2128, 2131, 2132, 2133);
update CMC_QUOT_DBF set M__TYPE_ = 2 where M_REFERENCE in (2134, 2135);

-- Link HIS to Future
delete from RT_GROUP_DBF where rtrim(M_GRP_DESC) = '       126        720';
update RT_GROUP_DBF set M_HISFILE = '902455      ' 
where rtrim(M_GRP_DESC) = '       126       2134' 
and M_GRP_TYPE = 3
and M_HISFILE = 737334;
delete from RT_GROUP_DBF where rtrim(M_GRP_DESC) = '       127        722';
update RT_GROUP_DBF set M_HISFILE = '139395      ' 
where rtrim(M_GRP_DESC) = '       127       2135' 
and M_GRP_TYPE = 3
and M_HISFILE = 737464;

-- Update RT_INDEX
update RT_INDEX_DBF set M_COM_QUOT = 2134 where M_COM_FUT = 126 and M_COM_QUOT = 720;
update RT_INDEX_DBF set M_COM_QUOT = 2135 where M_COM_FUT = 127 and M_COM_QUOT = 722;

-- Update CMT_PL_KEY1
update CMT_PLKEY1_DBF set M_QUOT = 2134 where M_FUTURE = 126 and M_QUOT = 720;
update CMT_PLKEY1_DBF set M_QUOT = 2135 where M_FUTURE = 127 and M_QUOT = 722;
update CMT_PLKEY1_DBF set M_QUOT = 2132 where M_UNDL = 572 and M_QUOT = 729;
update CMT_PLKEY1_DBF set M_QUOT = 2133 where M_UNDL = 573 and M_QUOT = 730;