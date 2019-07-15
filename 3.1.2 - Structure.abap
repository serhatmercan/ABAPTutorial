* MARA tablosundaki bazı alanları(matnr, ersda, ernam) içeren bir yapı yaratıp, 
* Bu yapiya referans verilerek yaratilmiş bir internal table olsun. 
* Bu internal table’i mara’dan doldurup ve alv kullanmadan ekrana döksün.

TABLES: mara.

DATA: gt_mara TYPE TABLE OF zsm_ae_s22 WITH HEADER LINE.

START-OF-SELECTION.

SELECT *
  FROM mara
  INTO CORRESPONDING FIELDS OF TABLE gt_mara.

END-OF-SELECTION.

LOOP AT gt_mara.
  WRITE:/ gt_mara-matnr, gt_mara-ersda, gt_mara-ernam.
ENDLOOP.
