select 
rtrim(viwhdr.M_CFG_LBL)

from VWR_CFGS_DBF viwhdr
where
exists (
    select 1
    from VWR_CFG_DBF viwbdy
    where viwhdr.M_CFG_REF = viwbdy.M_CFG_REF
    and M_OBJ_UID in (
          select M_OBJ_REF
          from VWR_DCT_DBF d1
          where d1.M_N_SPACE = 0
          and d1.M_OBJ_DESC ='Risk Engine' and d1.M_OBJ_ORD = 0
          and exists (
                select 1
                from VWR_DCT_DBF d2
                where d2.M_N_SPACE = d1.M_N_SPACE
                  and d2.M_OBJ_REF = d1.M_OBJ_REF
                AND d2.M_OBJ_DESC ='Results' and d2.M_OBJ_ORD = 1
                and exists (
                      select 1
                      from VWR_DCT_DBF d3
                      where d3.M_N_SPACE = d2.M_N_SPACE
                      and d3.M_OBJ_REF = d2.M_OBJ_REF
                      and d3.M_OBJ_DESC ='PL' and d3.M_OBJ_ORD = 2
                      and exists (
                           select 1
                           from VWR_DCT_DBF d4
                           where d4.M_N_SPACE = d3.M_N_SPACE
                           and d4.M_OBJ_REF = d3.M_OBJ_REF
                           and d4.M_OBJ_DESC ='P&L (Org)' and d4.M_OBJ_ORD = 3
                       )
                  )
              )
           )
       )
