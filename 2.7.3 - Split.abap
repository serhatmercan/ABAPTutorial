* Kullanıcı, seçim ekranından bir FI belge numarasi (+şirket kodu +yil) girsin. 
* PROGRAM, bu belgeye ait wrbtr tutarlarinin tamsayi ve ondalik kisimlarini iki ayri alan haline getirerek, kalem bazinda ekrana döksün.

TABLES: bseg.

DATA: lv_wrbtr TYPE string,
      a1       TYPE string,
      a2       TYPE string.

DATA: BEGIN OF it_bseg OCCURS 0,
        belnr LIKE bseg-belnr,
        wrbtr LIKE bseg-wrbtr,
      END OF it_bseg.

SELECTION-SCREEN BEGIN OF BLOCK sb1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS: s_belno FOR bseg-belnr.
SELECTION-SCREEN END OF BLOCK sb1.

START-OF-SELECTION.

SELECT belnr wrbtr
  FROM bseg
  INTO CORRESPONDING FIELDS OF TABLE it_bseg
  WHERE bseg~belnr IN s_belno.

LOOP AT it_bseg.
  WRITE:/ it_bseg-belnr,
          it_bseg-wrbtr.
  lv_wrbtr = it_bseg-wrbtr.
  SPLIT lv_wrbtr AT '.' INTO a1 a2.
  WRITE: a1, a2.
ENDLOOP.

END-OF-SELECTION.
