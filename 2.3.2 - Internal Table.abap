* Program, TCURC tablosundan bütün para birimi kodlarını ve metinlerini toplayip bir internal table’a doldursun. 
* Doldurduktan sonra, “a” veya “t” diye başlamayan bütün kodlari internal table’dan silsin. 
* Bu işlemden sonra, “a” diye başlayan bütün kodlarin metnini “aaaaa” diye değiştirsin. son olarak, internal table içeriğini ekrana döksün.

TABLES: tcurc.

DATA: BEGIN OF gt_tcurc OCCURS 0,
        waers LIKE tcurc-waers,
      END OF gt_tcurc.

 START-OF-SELECTION.

  SELECT waers
  FROM   tcurc
  INTO CORRESPONDING FIELDS OF TABLE gt_tcurc.

LOOP AT gt_tcurc.
IF gt_tcurc-waers(1) EQ 'A'  OR gt_tcurc-waers(1) EQ 'T' .

ELSE.

DELETE gt_tcurc INDEX sy-tabix.
REPLACE ALL OCCURRENCES OF REGEX 'A' IN TABLE gt_tcurc WITH 'aaaaa'.

ENDIF.
ENDLOOP.

LOOP AT gt_tcurc.
  WRITE: / gt_tcurc-waers.
ENDLOOP.

END-OF-SELECTION.
