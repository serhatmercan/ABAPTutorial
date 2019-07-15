* T001 tablosundaki bütün şirket kodlarını ve şirket kodu metinlerini döken program 

TABLES: t001.

START-OF-SELECTION.

  SELECT * FROM t001.
    WRITE:/ t001-bukrs,
            t001-butxt.
  ENDSELECT.

END-OF-SELECTION.
