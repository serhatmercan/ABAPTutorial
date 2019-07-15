* Sistemdeki malzemelerin kodunu ve metnini MARA & MAKT tablolarindan inner join yardimiyla çekip listeleyeceği program
* Malzeme numara araliği, seçim ekraninda parametre olsun.

TABLES: mara, makt.

DATA: BEGIN OF itab OCCURS 0,
        ernam LIKE mara-ernam,
        maktx LIKE makt-maktx,
      END OF itab.

SELECTION-SCREEN BEGIN OF BLOCK sb1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS: s_mn FOR mara-matnr.
SELECTION-SCREEN END OF BLOCK sb1.

START-OF-SELECTION.

SELECT mara~ernam
       makt~maktx
FROM  mara
INNER JOIN makt ON mara~matnr EQ makt~matnr
INTO CORRESPONDING FIELDS OF TABLE itab
WHERE mara~matnr IN s_mn.

LOOP AT itab.
  WRITE:/ itab-ernam, itab-maktx.
ENDLOOP.

END-OF-SELECTION.
