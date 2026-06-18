set colsep '#';
SET TERMOUT OFF;
SPOOL &1;
set linesize 755;
set pagesize 2048;
select  T1.M_LABEL as OptionMaturitySet, T1.M_DESC as Description,  
----------------------------------       
      case 
       When T1.M_TYPE=0 then 'Standard'
       When T1.M_TYPE=1 then 'Series'
       When T1.M_TYPE=2 then 'Composite'
      end as Type,
---------------------------------------
----------------------------------------                 
	
        T2.M_LABEL as UnderlyingMaturitySet,
-------------------------------------------	
          case
              when T1.M_TYPE=2 then ' '
               else to_char(T1.M_OPT_COUNT) end as NumberOfDates, 
---------------------------------------------	
     case
              when T1.M_TYPE=2 then ' '
              when T1.M_OPT_RULE1 = 0 then 'None'
		when T1.M_OPT_RULE1 = 1 then 'LME'
	end as RuleUsed,
-----------------------------------------------
       	case 	when T1.M_DSP_ALIAS=0 then 'No'
		when T1.M_DSP_ALIAS=1 then 'Yes'
	end as DsiplayAliases,
------------------------------------------------
	case 	when T1.M_AUTO_ROLL=0 then 'No'
		when T1.M_AUTO_ROLL=1 then 'Yes'
	end as AutomaticRoll,
---------------------------------------------------       
   case 
            when T1.M_TYPE<>2 then ' '
            when T1.M_LAB_FORMULA=0 then 'Standard'
             when T1.M_LAB_FORMULA=1 then 'Formula'
    end as LabelGenMode,
-----------------------------------------------------------
------------------------------------------------------------ 
------------------------------------------------------------	
        case when T1.M_TYPE=2 then ' ' else T1.M_OQT_RULE0 end as QuotationStarts,
	case when T1.M_TYPE=2 then ' ' else  T1.M_OQT_RULE1 end  as Maturity, 
	case
               when T1.M_TYPE=2 then ' '
               when (T1.M_OPT_RULE is NULL) then ' ' 
		else  T1.M_OPT_RULE
	end as Series,
	case when T5.M_BLK_TYPE is null then ' '
		when (T5.M_BLK_TYPE = 1) then 'Day'
		when (T5.M_BLK_TYPE = 2) then 'Week'
		when (T5.M_BLK_TYPE = 3) then 'Month'
		when (T5.M_BLK_TYPE = 4) then 'Quarter'
		when (T5.M_BLK_TYPE = 5) then 'Season'
		when (T5.M_BLK_TYPE = 6) then 'Year'
		when (T5.M_BLK_TYPE = 7) then 'Week-end'
	end as Period,
	case when T5.M_OQT_RULE is null then ' ' else T5.M_OQT_RULE end as Shifter,
   case 
    when T1.M_TYPE<>2 then ' '
    when T6.M_CATEGORY=1 then 'Regular'
    when T6.M_CATEGORY=2 then 'Series'
    when T6.M_CATEGORY=3 then 'Weekly'
    when T6.M_CATEGORY=4 then 'Short Term'
   end as Category,
    case 
    when T1.M_TYPE<>2 then ' '
    when T6.M_ACTIVATED=0 then 'No'
    when T6.M_ACTIVATED=1 then 'Yes'
    end as Generate_Maturities,
---------------------------------------------------------
    case 
    when T1.M_TYPE<>2 then ' '
    else to_char(T6.M_NB_MAT)
    end as Nb_Maturities,
     case 
      when T1.M_TYPE<>2 then ' '
      when T6.M_QTSTARTFRM=0 then 'From driving date'
      when T6.M_QTSTARTFRM=1 then 'From underlying quotation start'
      when T6.M_QTSTARTFRM=2 then 'From underlying quotation end'
      when T6.M_QTSTARTFRM=3 then 'From underlying delivery start'
      when T6.M_QTSTARTFRM=4 then 'From underlying delivery end'
      when T6.M_QTSTARTFRM=5 then 'From underlying notification start'
      when T6.M_QTSTARTFRM=6 then 'From underlying notification end'
    end as Comp_Quot_start,
            case 
      when T1.M_TYPE<>2 then ' ' 
      else T6.M_QTSTARTSHF   
      end as Quot_start_Shift,
           case 
      when T1.M_TYPE<>2 then ' '
      when T6.M_QTENDFRM=0 then 'From driving date'
      when T6.M_QTENDFRM=1 then 'From underlying quotation start'
      when T6.M_QTENDFRM=2 then 'From underlying quotation end'
      when T6.M_QTENDFRM=3 then 'From underlying delivery start'
      when T6.M_QTENDFRM=4 then 'From underlying delivery end'
      when T6.M_QTENDFRM=5 then 'From underlying notification start'
      when T6.M_QTENDFRM=6 then 'From underlying notification end'
    end as Comp_Quot_end,
case 
      when T1.M_TYPE<>2 then ' ' 
      when T7.M_TYPE=3 then 'Month'
      end as Shift_Matrix_Type,
--------------------------------------------------------------
        case 
       when T1.M_TYPE<>2 then ' ' 
       when T8.M_X=0 then 'January'
      when T8.M_X=1 then 'February'
      when T8.M_X=2 then 'March'
      when T8.M_X=3 then 'April'
     when T8.M_X=4 then 'May'
    when T8.M_X=5 then 'June'
    when T8.M_X=6 then 'July'
    when T8.M_X=7 then 'August'
   when T8.M_X=8 then 'September'
   when T8.M_X=9 then 'October'
   when T8.M_X=10 then 'November'
   when T8.M_X=11 then 'December'
   end as Option_Month,
case 
       when T1.M_TYPE<>2 then ' ' 
       when T8.M_Y=0 then 'January'
      when T8.M_Y=1 then 'February'
      when T8.M_Y=2 then 'March'
      when T8.M_Y=3 then 'April'
     when T8.M_Y=4 then 'May'
    when T8.M_Y=5 then 'June'
    when T8.M_Y=6 then 'July'
    when T8.M_Y=7 then 'August'
   when T8.M_Y=8 then 'September'
   when T8.M_Y=9 then 'October'
   when T8.M_Y=10 then 'November'
   when T8.M_Y=11 then 'December'
   end as Underly_FUT_Month,
    case 
    when T1.M_TYPE<>2 then ' '
    when T8.M_CATEGORY=1 then 'Regular'
    when T8.M_CATEGORY=2 then 'Series'
    when T8.M_CATEGORY=3 then 'Weekly'
    when T8.M_CATEGORY=4 then 'Short Term'
   end as Contract_Category
from 	CM_OMAT_DBF T1 
----------------------------------------------------
left outer join	 CM_FMAT_DBF T2 on T1.M_FMAT_ID= T2.M_REFERENCE
left outer join CM_OMCNF_DBF T5 on T1.M_REFERENCE = T5.M_OMAT_ID 
left outer join CM_OM_CATCFG_DBF T6 on  T1.M_REFERENCE=T6.M_OMAT_ID
left outer join CM_OM_SHIFTM_DBF T7 on T1.M_REFERENCE=T7.M_OMAT_ID
left outer join CM_OM_SHIFTM_BODY_DBF T8 on T7.M_REFERENCE=T8.M_REFERENCE
-------------------------------
order by T1.M_LABEL;
quit;
SPOOL OFF;