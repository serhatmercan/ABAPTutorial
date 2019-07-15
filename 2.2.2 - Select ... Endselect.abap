* KNA1 tablosundaki kod ve isimleri listeleyen bir program

TABLES: kna1.

START-OF-SELECTION.
  SELECT kunnr name1 name2
  INTO (kna1-kunnr, kna1-name1, kna1-name2)
  FROM kna1.
    WRITE:/ kna1-kunnr, kna1-name1, kna1-name2.
  ENDSELECT.
END-OF-SELECTION.
