* Öğrenci, seçim ekranından belge & yıl & şirket kodu verilen bir muhasebe belgesinin bazi başlik bilgilerini tepede ve 
* kalem bilgilerini aşağida görüntüleyen bir layout & program hazirlasin.
* Belge başliğinda, (varsa) belgenin ait olduğu satici veya müşterinin adres bilgisi de olsun. 
* Eğer satici varsa tepede satici faturasi, müşteri varsa müşteri faturasi yazsin.

TABLES: bseg.

DATA: it_bseg_head TYPE TABLE OF zsm_st_head_p26,
      wa_bseg_head TYPE          zsm_st_head_p26.

DATA: it_bseg_main TYPE TABLE OF zsm_st_main_p26,
      wa_bseg_main TYPE          zsm_st_main_p26.

DATA: fm_name TYPE rs38l_fnam.

DATA: iv_bill TYPE char2.

SELECTION-SCREEN BEGIN OF BLOCK sb1 WITH FRAME TITLE text-001.
  PARAMETERS: p_bno  TYPE bseg-belnr,
              p_yil  TYPE bseg-gjahr,
              p_skod TYPE bseg-bukrs.
SELECTION-SCREEN END OF BLOCK sb1.

IF p_bno IS INITIAL OR p_yil IS INITIAL OR p_skod IS INITIAL.
  MESSAGE 'Parametrelerden hepsi dolu olması gereklidir.'
  TYPE 'S' DISPLAY LIKE 'E'.
  LEAVE LIST-PROCESSING.
ENDIF.

START-OF-SELECTION.
  PERFORM f_get_head_data.
  PERFORM f_get_main_data.
END-OF-SELECTION.

PERFORM f_print.
*&---------------------------------------------------------------------*
*&      Form  F_GET_HEAD_DATA
*&---------------------------------------------------------------------*
FORM f_get_head_data .
  SELECT  belnr
          gjahr
          bukrs
          kunnr
          lifnr
    FROM  bseg
    INTO  CORRESPONDING FIELDS OF TABLE it_bseg_head
    WHERE belnr EQ p_bno
    AND   gjahr EQ p_yil
    AND   bukrs EQ p_skod.

    LOOP AT it_bseg_head INTO wa_bseg_head WHERE lifnr NE space.
      iv_bill = 'SB'.
    ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_GET_MAIN_DATA
*&---------------------------------------------------------------------*
FORM f_get_main_data .
  SELECT  buzid
          augdt
          augcp
          augbl
          bschl
    FROM  bseg
    INTO  CORRESPONDING FIELDS OF TABLE it_bseg_main
    WHERE belnr EQ p_bno
    AND   gjahr EQ p_yil
    AND   bukrs EQ p_skod.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_PRINT
*&---------------------------------------------------------------------*
FORM f_print .
CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    formname                 = 'ZSM_SF_P26'
 IMPORTING
    fm_name                  = fm_name
 EXCEPTIONS
    no_form                  = 1
    no_function_module       = 2
    OTHERS                   = 3.

CALL FUNCTION fm_name
  EXPORTING
    ev_bill                   = iv_bill
    et_bseg_head              = wa_bseg_head
  TABLES
    et_bseg_main              = it_bseg_main[]
 EXCEPTIONS
   formatting_error           = 1
   internal_error             = 2
   send_error                 = 3
   user_canceled              = 4
   OTHERS                     = 5.
ENDFORM.
