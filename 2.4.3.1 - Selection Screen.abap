* Seçim ekranından girilen malzeme aralığına ait VVSAL tutarini mbew tablosundan okuyup, malzeme bazida kümüle edip ekrana dökecek program 

TABLES: mbew.

DATA: BEGIN OF it_mbew OCCURS 0,
        matnr LIKE mbew-matnr,
        vvsal LIKE mbew-vvsal,
      END OF it_mbew.

SELECT-OPTIONS: s_matnr FOR mbew-matnr.

START-OF-SELECTION.

SELECT matnr vvsal
  INTO (it_mbew-matnr, it_mbew-vvsal)
  FROM mbew
  WHERE matnr IN s_matnr.
  COLLECT it_mbew.
ENDSELECT.

LOOP AT it_mbew.
  WRITE:/ it_mbew-matnr, it_mbew-vvsal.
ENDLOOP.
