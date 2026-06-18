select
mtxh.M_M_LABEL LABEL, mtxh.M_M_DESC DESCRIPTION, layh.M_L_NAME LAYOUT,
case mtxb.M_B_TYPE
when 0 then 'Global'
when 1 then 'Filter'
when 2 then 'Parameter'
when 3 then 'Output'
when 4 then 'Multi scenario'
when 5 then 'Batch'
when 6 then 'Category'
else null end DIMENSION,
case mtxb.M_B_CODE
when 950 then 'Prc scenario'
when 951 then 'Vol scenario' 
when 953 then 'Ag.P&L'
when 955 then 'Delta'
when 956 then 'Adap.delta'
when 957 then 'Gamma'
when 958 then 'Vega'
when 959 then 'Spot delta'
when 960 then 'Lease delta'
when 961 then 'Price'
when 963 then 'Batch PL'
when 964 then 'Adap.gamma'
when 965 then 'Theta'
when 982 then 'Spot gamma'
when 983 then 'Rega'
when 984 then 'Sega'
when 985 then 'Vanna'
when 986 then 'Volga'
else null end PARAM,
M_B_MKEY150 ARGUMENT,
case mtxb.M_B_TYPE
when   2 then M_MSKEY
when   3 then 
case to_number(trim(mtxb.M_B_MKEY151))
when   0 then 'Total'
when   1 then 'Portfolio'
when   2 then 'Trn Family'
when   4 then 'Trn Group'
when   8 then 'Trn Type'
when  16 then 'P&L instrument'
when  32 then 'Curve'
when  64 then 'Curve pillar'
when  96 then 'Curve|Curve pillar'
when 128 then 'Bucket'
when 256 then 'Trade Nb'
when 512 then 'Typology'
when 528 then 'P&L instrument|Typology'
when 529 then 'Portfolio|P&L instrument|Typology'
when 576 then 'Curve pillar|Typology'
when 592 then 'P&L instrument|Curve pillar|Typology'
when 608 then 'Curve|Curve pillar|Typology'
else trim(mtxb.M_B_MKEY151) end 
when   5 then M_MSKEY end CURVE_BRKDWN,
case spec.M_CM_HDPRJD
when 0 then 'Yes'
when 1 then 'No' else null end SPCM_HDGPROJ,
case spec.M_CM_DISCSNS
when 0 then 'No'
when 1 then 'Yes' else null end SPCM_SNSDIS,
case spec.M_CM_SNS_LOT
when 0 then 'No'
when 1 then 'Yes' else null end SPCM_SNSLOT,
case spec.M_CM_SNS_AGG
when 0 then 'No'
when 1 then 'Yes' else null end SPCM_SNSAGG,
pils.M_LABEL SPCM_PILSET,
case spec.M_CM_F_FMLY
when 0 then 'Inherited'
when 1 then 'On' 
when 2 then 'Off' else null end SPCM_FMLMOD
from RSK_MTXB_DBF mtxb
left join RSK_MTXH_DBF mtxh on rtrim(mtxb.M_M_LABEL) = rtrim(mtxh.M_M_LABEL)
left join MDL_LAYH_DBF layh on mtxh.M_DEF_LAYOUT = layh.M_ID
left join RSK_UCNF_DBF spec on rtrim(mtxh.M_M_LABEL) = rtrim(spec.M_MTX_LAB)
left join CM_PLST_DBF  pils on spec.M_CM_PIL_SET = pils.M_REFERENCE
where mtxb.M_B_TYPE > 0
order by mtxb.M_M_LABEL, M_B_TYPE, M_B_RANK