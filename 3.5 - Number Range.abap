* Z’li bir tablo ve numara aralığı yaratsın. 
* Tabloda MANDT, id, ernam, erdat, uzeit alanlari olsun.
* yazacaği program her çaliştirildiğinda; bu z’li tabloya numara araliğindan alinmiş yeni bir sayi ve çaliştırılma bilgileri kaydedilsin.
* Database Table: ZSM_AE_DBT_P25      Number Range: Z_NR_P25

DATA: lv_number_range(10) TYPE n,
      gt_nr TYPE TABLE OF zsm_ae_dbt_p25 WITH HEADER LINE,
      lv_query TYPE zsm_ae_dbt_p25.

CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING
   nr_range_nr                   = '1'
   object                        = 'Z_NR_P25'
 IMPORTING
   number                        = lv_number_range.

IF sy-subrc <> 0.
 MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

CLEAR lv_query.
lv_query-id    = lv_number_range.
lv_query-ernam = 'Serhat'.
lv_query-erdat = sy-datum.
lv_query-uzeit = sy-uzeit.
MODIFY zsm_ae_dbt_p25 FROM lv_query.

WRITE : / 'The New Number is  :', lv_number_range.
