* Belli bir şirket kodu & yıla ait olup numarası 1 ve 2 ile başlayan bütün muhasebe belge numaralarini bkpf’den çeksin ve ekrana döksün. 
* Şirket kodu constant olmali, yil sy-datum’dan alinmali, muhasebe belge numaralari ise bir range içerisinde belirtilmelidir.

TABLES: bkpf.

DATA:
      BEGIN OF it_bkpf OCCURS 0,
        bukrs TYPE bkpf-bukrs,
        gjahr TYPE bkpf-gjahr,
        belnr TYPE bkpf-belnr,
      END OF it_bkpf.

RANGES: r_belnr FOR bkpf-belnr.

r_belnr-sign   = 'I'.
r_belnr-option = 'CP'.
r_belnr-low    = '1*'.

APPEND r_belnr.

r_belnr-sign   = 'I'.
r_belnr-option = 'CP'.
r_belnr-low    = '2*'.

APPEND r_belnr.

START-OF-SELECTION.

SELECT bukrs gjahr belnr
  FROM bkpf
  INTO CORRESPONDING FIELDS OF TABLE it_bkpf
  WHERE bkpf~belnr IN r_belnr
  AND bkpf~bukrs EQ '0001'.
  AND bkpf~gjahr EQ sy-datum+0(4).

LOOP AT it_bkpf.
  WRITE:/ it_bkpf-bukrs,
          it_bkpf-gjahr,
          it_bkpf-belnr.
ENDLOOP.

END-OF-SELECTION.
