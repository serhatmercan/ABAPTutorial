* MBEW tablosundaki LBKUM değerlerini MATNR ve MEINS bazında kümüle etsin ve değerleri ekrana döksün. 
* Meins değeri, mara tablosundan okunmalidir. 

TABLES: mbew, mara.

DATA: BEGIN OF itab OCCURS 0,
        lbkum LIKE mbew-lbkum,
        matnr LIKE mbew-matnr,
        meins LIKE mara-meins,
      END OF itab.

START-OF-SELECTION.
  SELECT * 
    FROM mbew
    UP TO 500 ROWS.

    SELECT * FROM mara WHERE matnr = mbew-matnr.
    CLEAR itab.
    itab-lbkum = mbew-lbkum.
    itab-matnr = mbew-matnr.
    itab-meins = mara-meins.
    APPEND itab.
    ENDSELECT.

  ENDSELECT.

LOOP AT itab.
  WRITE:/ itab-lbkum, itab-matnr, itab-meins.
ENDLOOP.

END-OF-SELECTION.
