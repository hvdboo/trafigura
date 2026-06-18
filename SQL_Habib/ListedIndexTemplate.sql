set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 1539;
set pagesize 2048;
select T1.M_LABEL as ListedIndexTemplate, T1.M_DESC as Description,
case when T2.M_COMMENT is null then ' ' else T2.M_COMMENT end as Comment,
case when T3.M_LABEL is null then ' ' else T3.M_LABEL end as RollingConfiguration,
case when M_FUTURE is null then ' ' else T5.M_LABEL end as Future,
case when M_LOT_SIZE is null then ' ' else to_char(M_LOT_SIZE) end as LotSize,
case when M_PREV_WGT is null then ' ' else to_char(M_PREV_WGT) end as PreviousWeight,
case when M_CURR_WGT is null then ' ' else to_char(M_CURR_WGT) end as CurrentWeight,
case when M_LEAD_JAN is null then ' ' else 
	case 
		when M_LEAD_JAN = 1 then 'F'	
		when M_LEAD_JAN = 2 then 'G'	
		when M_LEAD_JAN = 3 then 'H'	
		when M_LEAD_JAN = 4 then 'J'	
		when M_LEAD_JAN = 5 then 'K'	
		when M_LEAD_JAN = 6 then 'M'	
		when M_LEAD_JAN = 7 then 'N'	
		when M_LEAD_JAN = 8 then 'Q'	
		when M_LEAD_JAN = 9 then 'U'	
		when M_LEAD_JAN = 10 then 'V'	
		when M_LEAD_JAN = 11 then 'X'	
		when M_LEAD_JAN = 12 then 'Z'	
	end 
end as F,
case when M_LEAD_FEB is null then ' ' else 
	case 
		when M_LEAD_FEB = 1 then 'F'	
		when M_LEAD_FEB = 2 then 'G'	
		when M_LEAD_FEB = 3 then 'H'	
		when M_LEAD_FEB = 4 then 'J'	
		when M_LEAD_FEB = 5 then 'K'	
		when M_LEAD_FEB = 6 then 'M'	
		when M_LEAD_FEB = 7 then 'N'	
		when M_LEAD_FEB = 8 then 'Q'	
		when M_LEAD_FEB = 9 then 'U'	
		when M_LEAD_FEB = 10 then 'V'	
		when M_LEAD_FEB = 11 then 'X'	
		when M_LEAD_FEB = 12 then 'Z'	
	end 
end as G,
case when M_LEAD_MAR is null then ' ' else 
	case 
		when M_LEAD_MAR = 1 then 'F'	
		when M_LEAD_MAR = 2 then 'G'	
		when M_LEAD_MAR = 3 then 'H'	
		when M_LEAD_MAR = 4 then 'J'	
		when M_LEAD_MAR = 5 then 'K'	
		when M_LEAD_MAR = 6 then 'M'	
		when M_LEAD_MAR = 7 then 'N'	
		when M_LEAD_MAR = 8 then 'Q'	
		when M_LEAD_MAR = 9 then 'U'	
		when M_LEAD_MAR = 10 then 'V'	
		when M_LEAD_MAR = 11 then 'X'	
		when M_LEAD_MAR = 12 then 'Z'	
	end 
end as H,
case when M_LEAD_APR is null then ' ' else 
	case 
		when M_LEAD_APR = 1 then 'F'	
		when M_LEAD_APR = 2 then 'G'	
		when M_LEAD_APR = 3 then 'H'	
		when M_LEAD_APR = 4 then 'J'	
		when M_LEAD_APR = 5 then 'K'	
		when M_LEAD_APR = 6 then 'M'	
		when M_LEAD_APR = 7 then 'N'	
		when M_LEAD_APR = 8 then 'Q'	
		when M_LEAD_APR = 9 then 'U'	
		when M_LEAD_APR = 10 then 'V'	
		when M_LEAD_APR = 11 then 'X'	
		when M_LEAD_APR = 12 then 'Z'	
	end 
end as J,
case when M_LEAD_MAY is null then ' ' else 
	case 
		when M_LEAD_MAY = 1 then 'F'	
		when M_LEAD_MAY = 2 then 'G'	
		when M_LEAD_MAY = 3 then 'H'	
		when M_LEAD_MAY = 4 then 'J'	
		when M_LEAD_MAY = 5 then 'K'	
		when M_LEAD_MAY = 6 then 'M'	
		when M_LEAD_MAY = 7 then 'N'	
		when M_LEAD_MAY = 8 then 'Q'	
		when M_LEAD_MAY = 9 then 'U'	
		when M_LEAD_MAY = 10 then 'V'	
		when M_LEAD_MAY = 11 then 'X'	
		when M_LEAD_MAY = 12 then 'Z'	
	end 
end as K,
case when M_LEAD_JUN is null then ' ' else 
	case 
		when M_LEAD_JUN = 1 then 'F'	
		when M_LEAD_JUN = 2 then 'G'	
		when M_LEAD_JUN = 3 then 'H'	
		when M_LEAD_JUN = 4 then 'J'	
		when M_LEAD_JUN = 5 then 'K'	
		when M_LEAD_JUN = 6 then 'M'	
		when M_LEAD_JUN = 7 then 'N'	
		when M_LEAD_JUN = 8 then 'Q'	
		when M_LEAD_JUN = 9 then 'U'	
		when M_LEAD_JUN = 10 then 'V'	
		when M_LEAD_JUN = 11 then 'X'	
		when M_LEAD_JUN = 12 then 'Z'	
	end 
end as M,
case when M_LEAD_JUL is null then ' ' else 
	case 
		when M_LEAD_JUL = 1 then 'F'	
		when M_LEAD_JUL = 2 then 'G'	
		when M_LEAD_JUL = 3 then 'H'	
		when M_LEAD_JUL = 4 then 'J'	
		when M_LEAD_JUL = 5 then 'K'	
		when M_LEAD_JUL = 6 then 'M'	
		when M_LEAD_JUL = 7 then 'N'	
		when M_LEAD_JUL = 8 then 'Q'	
		when M_LEAD_JUL = 9 then 'U'	
		when M_LEAD_JUL = 10 then 'V'	
		when M_LEAD_JUL = 11 then 'X'	
		when M_LEAD_JUL = 12 then 'Z'	
	end 
end as N,
case when M_LEAD_AUG is null then ' ' else 
	case 
		when M_LEAD_AUG = 1 then 'F'	
		when M_LEAD_AUG = 2 then 'G'	
		when M_LEAD_AUG = 3 then 'H'	
		when M_LEAD_AUG = 4 then 'J'	
		when M_LEAD_AUG = 5 then 'K'	
		when M_LEAD_AUG = 6 then 'M'	
		when M_LEAD_AUG = 7 then 'N'	
		when M_LEAD_AUG = 8 then 'Q'	
		when M_LEAD_AUG = 9 then 'U'	
		when M_LEAD_AUG = 10 then 'V'	
		when M_LEAD_AUG = 11 then 'X'	
		when M_LEAD_AUG = 12 then 'Z'	
	end 
end as Q,
case when M_LEAD_SEP is null then ' ' else 
	case 
		when M_LEAD_SEP = 1 then 'F'	
		when M_LEAD_SEP = 2 then 'G'	
		when M_LEAD_SEP = 3 then 'H'	
		when M_LEAD_SEP = 4 then 'J'	
		when M_LEAD_SEP = 5 then 'K'	
		when M_LEAD_SEP = 6 then 'M'	
		when M_LEAD_SEP = 7 then 'N'	
		when M_LEAD_SEP = 8 then 'Q'	
		when M_LEAD_SEP = 9 then 'U'	
		when M_LEAD_SEP = 10 then 'V'	
		when M_LEAD_SEP = 11 then 'X'	
		when M_LEAD_SEP = 12 then 'Z'	
	end 
end as U,
case when M_LEAD_OCT is null then ' ' else 
	case 
		when M_LEAD_OCT = 1 then 'F'	
		when M_LEAD_OCT = 2 then 'G'	
		when M_LEAD_OCT = 3 then 'H'	
		when M_LEAD_OCT = 4 then 'J'	
		when M_LEAD_OCT = 5 then 'K'	
		when M_LEAD_OCT = 6 then 'M'	
		when M_LEAD_OCT = 7 then 'N'	
		when M_LEAD_OCT = 8 then 'Q'	
		when M_LEAD_OCT = 9 then 'U'	
		when M_LEAD_OCT = 10 then 'V'	
		when M_LEAD_OCT = 11 then 'X'	
		when M_LEAD_OCT = 12 then 'Z'	
	end 
end as V,
case when M_LEAD_NOV is null then ' ' else 
	case 
		when M_LEAD_NOV = 1 then 'F'	
		when M_LEAD_NOV = 2 then 'G'	
		when M_LEAD_NOV = 3 then 'H'	
		when M_LEAD_NOV = 4 then 'J'	
		when M_LEAD_NOV = 5 then 'K'	
		when M_LEAD_NOV = 6 then 'M'	
		when M_LEAD_NOV = 7 then 'N'	
		when M_LEAD_NOV = 8 then 'Q'	
		when M_LEAD_NOV = 9 then 'U'	
		when M_LEAD_NOV = 10 then 'V'	
		when M_LEAD_NOV = 11 then 'X'	
		when M_LEAD_NOV = 12 then 'Z'	
	end 
end as X,
case when M_LEAD_DEC is null then ' ' else 
	case 
		when M_LEAD_DEC = 1 then 'F'	
		when M_LEAD_DEC = 2 then 'G'	
		when M_LEAD_DEC = 3 then 'H'	
		when M_LEAD_DEC = 4 then 'J'	
		when M_LEAD_DEC = 5 then 'K'	
		when M_LEAD_DEC = 6 then 'M'	
		when M_LEAD_DEC = 7 then 'N'	
		when M_LEAD_DEC = 8 then 'Q'	
		when M_LEAD_DEC = 9 then 'U'	
		when M_LEAD_DEC = 10 then 'V'	
		when M_LEAD_DEC = 11 then 'X'	
		when M_LEAD_DEC = 12 then 'Z'	
	end 
end as Z
from CM_LI_TEMP_DBF T1	
left join CM_LI_TVER_DBF T2 on T2.M_TEMPLATE = T1.M_REFERENCE
left join CM_LI_ROLL_DBF T3 on T2.M_ROLL_CONF = T3.M_REFERENCE
left join CM_LI_CTEM_DBF T4 on T4.M_VER_REF = T2.M_REFERENCE
left join CM_FUT_DBF T5 on T5.M_REFERENCE = T4.M_FUTURE
order by T1.M_LABEL, T5.M_LABEL;
quit;
SPOOL OFF;