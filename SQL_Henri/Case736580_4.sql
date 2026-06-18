-- Update Swap prices, Curve
-- AG CMX,  old MGEN =  25, new MGEN = 299
-- PD LPPM, old MGEN = 157, new MGEN = 302
-- PT LPPM, old MGEN = 155, new MGEN = 303
update CMG_GRPI_DBF set M_INSTR_GEN = 302 where M_GTYPE = 256 and M_GROUP = 145 and M_INSTR_GEN = 157;
update CMG_GRPI_DBF set M_INSTR_GEN = 302 where M_GTYPE = 512 and M_GROUP =  94 and M_INSTR_GEN = 157;
update CMG_GRPI_DBF set M_INSTR_GEN = 303 where M_GTYPE = 256 and M_GROUP = 145 and M_INSTR_GEN = 155;
update CMG_GRPI_DBF set M_INSTR_GEN = 303 where M_GTYPE = 512 and M_GROUP =  93 and M_INSTR_GEN = 155;