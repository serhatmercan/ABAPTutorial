* LFA1 tablosundan bütün satıcıların kodlarını ve isimlerini listeleyen bir program. 
* Liste; satıcı koduna göre artan, satıcı adına göre azalan sırada olsun.

TABLES: lfa1.

START-OF-SELECTION.
  SELECT lifnr name1 name2 name3 name4 INTO (lfa1-lifnr, lfa1-name1,
                                             lfa1-name2, lfa1-name3,
                                             lfa1-name4)
  FROM lfa1 ORDER BY lifnr DESCENDING name1.
    WRITE:/ lfa1-lifnr, lfa1-name1, lfa1-name2, lfa1-name3, lfa1-name4.
  ENDSELECT.
END-OF-SELECTION.
