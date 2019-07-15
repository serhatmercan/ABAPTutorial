* Program; MONTH_NAMES_GET fonksiyonunun yardımıyla, seçim ekranında verilen dilde bütün aylari listelesin.

DATA: d_return  LIKE sy-subrc,
      itab_t247 LIKE t247 OCCURS 0 WITH HEADER LINE.

CALL FUNCTION 'MONTH_NAMES_GET'
 EXPORTING
   language                    = sy-langu
 IMPORTING
   return_code                 = d_return
  TABLES
    month_names                = itab_t247
 EXCEPTIONS
   month_names_not_found       = 1
   OTHERS                      = 2
          .
IF sy-subrc <> 0.

ENDIF.

LOOP AT itab_t247.
  WRITE:/ itab_t247-ltx.
ENDLOOP.
