* MAKT tablosunda dili TR veya EN olan bütün malzeme metinlerini ve malzeme kodlarını yazdiran program

TABLES: makt.

START-OF-SELECTION.
  SELECT * FROM makt WHERE spras = 'TR' OR spras = 'EN'.
    WRITE:/ makt-matnr, makt-maktx, makt-spras.
  ENDSELECT.
END-OF-SELECTION.
