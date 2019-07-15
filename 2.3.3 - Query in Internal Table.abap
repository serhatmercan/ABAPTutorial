* KNA1 tablosundaki bütün müşterilerin kod ve isimleri bir internal table’a toplayip ekrana dökecek program. Select - Into Kullanımı

TABLES: kna1.

  DATA:
    BEGIN OF gt_kna1 OCCURS 0,
      kunnr LIKE kna1-kunnr,
      name1 LIKE kna1-name1,
    END OF gt_kna1.

START-OF-SELECTION.

  SELECT kunnr name1 INTO (gt_kna1-kunnr, gt_kna1-name1) FROM kna1.
    APPEND gt_kna1.
  ENDSELECT.

  LOOP AT gt_kna1. "
    WRITE:/ gt_kna1-kunnr, gt_kna1-name1.
  ENDLOOP.

END-OF-SELECTION.
