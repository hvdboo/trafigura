select
--lut.* , viw.*

rtrim(lut.M_INSTRUMENT) LUTPLI,
rtrim(viw.M_PLILAB)     VIWPLI,
rtrim(lut.M_I_CNT_TYPO) LUTTYPO,
rtrim(viw.M_LEGPAT)     LEGPAT,
rtrim(viw.M_PLITYP)     VIWTYP,
rtrim(lut.M_NCCY1)      LUTCUR1,
rtrim(viw.M_LEGCUR0)    VIWCUR1,
rtrim(lut.M_NCCY2)      LUTCUR2,
rtrim(viw.M_LEGCUR1)    VIWCUR2,
rtrim(viw.M_INDLAB0)    VIWIND0,
rtrim(viw.M_INDLAB1)    VIWIND1,
rtrim(lut.M_I_REFRATE)  LUTREFRTE,
rtrim(viw.M_REFRTE)     VIWREFRTE,
-- case when rtrim(lut.M_I_REFRATE) = rtrim(viw.M_REFRTE) then 0 else 1 end DIFF_REFRTE
rtrim(lut.M_I_ASSETCL)  LUTASS,
rtrim(viw.M_EMIR_ASSET) VIWASS,
case when rtrim(M_I_ASSETCL) = rtrim(viw.M_EMIR_ASSET) then 0 else 1 end DIFF_ASS


from UDTB342_DBF lut
left join VIW_PLIREG_DBF viw on rtrim(lut.M_INSTRUMENT) = rtrim(viw.M_PLILAB)

order by LUTPLI