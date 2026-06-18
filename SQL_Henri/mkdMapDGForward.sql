select 
rtrim(lut.M_DGMXLABEL) MXLAB,
rtrim(lut.M_DGPUBLICAT) MXPUB,
rtrim(lut.M_DGQLABEL) MXQOT,
rtrim(lut.M_DGGENERAT) MXGEN,
rtrim(lut.M_DGPTYPE) PRODTYP,
rtrim(lut.M_DGMODEL) MODEL,
rtrim(lut.M_DGPROFILE) PROFIL,
rtrim(lut.M_DGTENOR) TENOR,
rtrim(lut.M_DGSEP) SEPA,
rtrim(lut.M_DGDIVIDE) DIVFCT,
rtrim(lut.M_DGMATFOR) MATFMT,
rtrim(lut.M_DGFOLDER) DGFLD,
rtrim(lut.M_DGCMPSITE) DGCOMPO,
rtrim(lut.M_DGPUBDATE) DGPUBDAT

from UDTB237_DBF lut

order by MXLAB, PRODTYP

