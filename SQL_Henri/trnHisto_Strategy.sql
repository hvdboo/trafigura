select 
trn.M_NB TRN,
trn.M_TRN_GTYPE FGT,
trn.M_TRN_FMLY  FML, 
trn.M_TRN_GRP   GRP, 
trn.M_TRN_TYPE  TYP,
rtrim(trn.M_BSTRATEGY) BSTG,
rtrim(M_BPFOLIO) BPFL,
upper(rtrim(bpfudf.M_MASTRDSK)) BPFMAS,
rtrim(trn.M_SSTRATEGY) SSTG,
rtrim(M_SPFOLIO) SPFL

from TRN_HDR_DBF trn
left join TRN_PFLD_DBF bpf on rtrim(trn.M_BPFOLIO) = rtrim(bpf.M_LABEL)
left join TABLE#DATA#PORTFOLI_DBF bpfudf on rtrim(bpf.M_LABEL) = rtrim(bpfudf.M_LABEL)

where 1 = 1
and trn.M_BINTERNAL = trn.M_SINTERNAL
and trn.M_BSTRATEGY <> trn.M_SSTRATEGY
and rtrim(trn.M_BSTRATEGY) <> 'FX' 
and rtrim(trn.M_SSTRATEGY) <> 'FX'
and rtrim(trn.M_BSTRATEGY) <> upper(rtrim(bpfudf.M_MASTRDSK))

