select 
cmi.M_REFERENCE CMIREF, rtrim(cmi.M_LABEL) CMILAB, 
qot.M_REFERENCE QREF, rtrim(qot.M_LABEL) QLAB,
ind.M_REFERENCE INDREF, rtrim(ind.M_IND_LAB) INDLAB,
mgn.M_REFERENCE MGEN,
und.M_REFERENCE UNDREF, rtrim(und.M_IND_LAB) UNDLAB,
gen0.M_GEN_NUM GEN0, gen1.M_GEN_NUM GEN1,
ndx.M_REFERENCE NDX,
bsk.M_REFERENCE BSK,
grpi.M_REFERENCE GRPI, 
grpi.M_REFERENCE GRPG,
substr(crv.M_KEY,21,5) CRV,
rtrim(phy.M_LABEL) ASGPHY, 
lst.M_REFERENCE LST,
rtrim(plin.M_DSP_LABEL) PLIN,
plki.M_REFERENCE PLKI,
plku.M_REFERENCE PLKU,
trn1.M_NB TRN1,
trn2.M_NB TRN2

from CM_INDEX_DBF cmi

left join TRN_PC_DBF pc on 1 = 1
left join RT_INDEX_DBF ind on cmi.M_REFERENCE = ind.M_COM_IND
left join CMC_QUOT_DBF qot on ind.M_COM_QUOT = qot.M_REFERENCE
left join CMC_MGEN_DBF mgn on ind.M_INDEX = mgn.M_INDEX
left join RT_INDEX_DBF und on ind.M_INDEX = und.M_UNDRL
left join RT_LNGN_DBF gen0 on ind.M_INDEX = gen0.M_INDEX0
left join RT_LNGN_DBF gen1 on ind.M_INDEX = gen1.M_INDEX1
left join RT_LNDXG_DBF ndx on ind.M_INDEX = ndx.M_INDEX
left join RT_INDBK_COMPONENT_DBF bsk on ind.M_INDEX = bsk.M_INDEX 
left join CMG_GRPI_DBF grpi on (cmi.M_REFERENCE = grpi.M_INDEX and grpi.M__DATE_ = pc.M_DATE)
left join CMG_GRPI_DBF grpg on (mgn.M_REFERENCE = grpg.M_INDEX and grpg.M__DATE_ = pc.M_DATE)
left join CMK_SCCF_DBF crv on cmi.M_REFERENCE = to_number(substr(crv.M_KEY,1,10))
left join ASGPRDB_DBF asg on ind.M_INDEX = asg.M_INDEX
left join CM_PHYS_DBF phy on asg.M_PRODUCT = phy.M_REFERENCE 
left join CMC_LIST_DBF lst on cmi.M_REFERENCE = lst.M_INDEX
left join TRN_PLIN_DBF plin on (ind.M_INDEX = plin.M_LABEL and plin.M_FAMILY = 256)
left join CMT_PLKEY1_DBF plki on ind.M_INDEX = plki.M_INDEX
left join CMT_PLKEY1_DBF plku on ind.M_INDEX = plku.M_RT_UNDL
left join TRN_HDR_DBF trn1 on ind.M_INDEX = substr(trn1.M_MKT_INDEX,1,15)
left join TRN_HDR_DBF trn2 on ind.M_INDEX = substr(trn2.M_MKT_INDEX,18,15)

where cmi.M_REFERENCE = 1242
order by CMILAB