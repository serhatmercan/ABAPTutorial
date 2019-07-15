* İçinde bulunulan yılın ilk iki ayında kaydedilmiş bütün malzeme belgelerini listelensin. 
* Şirket kodu constant olmali, yil sy-datum’dan alinmali, malzeme belgelerinin kayit tarihi ise bir range içerisinde belirtilmelidir.

TABLES: bkpf.

DATA: it_bkpf LIKE bkpf OCCURS 0 WITH HEADER LINE.

RANGES: r_budat FOR bkpf-budat.

r_budat-sign   = 'I'.
r_budat-option = 'BT'.
r_budat-low    = '19950606'.
r_budat-high   = '19950707'.

APPEND r_budat.

START-OF-SELECTION.

SELECT *
  FROM bkpf
  INTO CORRESPONDING FIELDS OF TABLE it_bkpf
  WHERE bkpf~budat IN r_budat
  AND bkpf~bukrs EQ '0001'.

LOOP AT it_bkpf.
  WRITE:/ it_bkpf-budat.
ENDLOOP.

END-OF-SELECTION.
