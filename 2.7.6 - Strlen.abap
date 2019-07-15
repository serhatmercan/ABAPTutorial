* Program, seçim ekranında aralık olarak girilen her bir malzemenin numarasini ve (kullanicinin diline bağli olarak) metnini listelesin.
* 3. bir sütunda, malzeme metninin uzunluğu yazsin.

TABLES: makt.

DATA: length   TYPE i,
      lv_maktx TYPE string.

DATA: BEGIN OF it_makt OCCURS 0,
        matnr LIKE makt-matnr,
        maktx LIKE makt-maktx,
      END OF it_makt.

SELECTION-SCREEN BEGIN OF BLOCK sb1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS: s_mno FOR makt-matnr.
SELECTION-SCREEN END OF BLOCK sb1.

START-OF-SELECTION.

SELECT matnr maktx
  FROM makt
  INTO CORRESPONDING FIELDS OF TABLE it_makt
  WHERE makt~matnr IN s_mno
  AND makt~spras   EQ 'TR'.

LOOP AT it_makt.
  lv_maktx = it_makt-maktx.
  length   = strlen( lv_maktx ).
  WRITE:/ it_makt-matnr, it_makt-maktx, length.
ENDLOOP.

END-OF-SELECTION.
