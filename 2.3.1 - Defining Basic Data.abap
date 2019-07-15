* T001W tablosundaki üretim yeri kodlarını ve isimlerini bir internal table’a doldurup, sonra bu değerleri loop yardimiyla ekrana yazdirsin.

TABLES: t001w.

DATA:
     BEGIN OF gt_t001w OCCURS 0,
       werks LIKE t001w-werks,
       name1 LIKE t001w-name1,
     END OF gt_t001w.

START-OF-SELECTION.

  SELECT werks name1
  FROM t001w
  INTO CORRESPONDING FIELDS OF TABLE gt_t001w.

  LOOP AT gt_t001w.
    WRITE:/ gt_t001w-werks, gt_t001w-name1.
  ENDLOOP.

END-OF-SELECTION.
