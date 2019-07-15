* Gönderilen malzeme belge numarası & yıla ait malzeme kalemlerini döndüren bir fonksiyon yazsin.
* Bu fonksiyonu; seçim ekranindan girilen yil & malzeme belgesi için çağirip kalemleri alv formatinda ekrana döken bir program yazsin.
* Eğer belge veritabaninda bulunamazsa, fonksiyon bir hata üretiyor olsun.
* PROGRAM bu hatayi sy-subrc’ye bakarak yakalasin ve alv’nin end_of_list’inde göstersin.
* Transaction Code: ZSERHATM_AE_P24

TYPE-POOLS: slis.

TABLES: bseg.

DATA: gt_fcat     TYPE slis_t_fieldcat_alv,
      gs_layout1  TYPE slis_layout_alv,
      gt_event1   TYPE slis_t_event.

DATA: wa_events  LIKE LINE OF gt_event1,
      i_heading  TYPE         slis_t_listheader,
      wa_heading LIKE LINE OF i_heading.

DATA: gt_bseg    TYPE TABLE OF zsm_ae_s24 WITH HEADER LINE,
      gt_message TYPE TABLE OF zsm_ae_st_message WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK sb1.
SELECT-OPTIONS: s_bno  FOR bseg-belnr,
                s_myil FOR bseg-gjahr.
SELECTION-SCREEN END OF BLOCK sb1.

START-OF-SELECTION.
  PERFORM get_data.
END-OF-SELECTION.

PERFORM get_events.
PERFORM display_with_alv.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*----------------------------------------------------------------------*
FORM get_data .
CALL FUNCTION 'ZSM_AE_F24'
  EXPORTING
    ir_belnr         = s_bno[]
    ir_gjahr         = s_myil[]
  TABLES
    lt_return        = gt_bseg[]
    lt_message       = gt_message[].
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_WITH_ALV
*----------------------------------------------------------------------*
FORM display_with_alv .

  DATA ls_event TYPE slis_alv_event.

  gs_layout1-info_fieldname     = 'LINE_COLOR'.
  gs_layout1-zebra              = 'X' .
  gs_layout1-colwidth_optimize  = 'X' .

  ls_event-name = 'USER_COMMAND'.
  ls_event-form = 'USER_COMMAND'.
  APPEND ls_event TO gt_event1.

  ls_event-name = 'PF_STATUS_SET'.
  ls_event-form = 'PF_STATUS_SET'.
  APPEND ls_event TO gt_event1.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
   EXPORTING
     i_program_name               = sy-repid
     i_internal_tabname           = 'GT_BSEG'
     i_structure_name             = 'ZSM_AE_S24'
     i_client_never_display       = 'X'
     i_inclname                   = sy-repid
    CHANGING
      ct_fieldcat                  = gt_fcat
   EXCEPTIONS
     inconsistent_interface       = 1
     program_error                = 2
     OTHERS                       = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat               = gt_fcat[]
      is_layout                 = gs_layout1
      i_save                    = 'X'
      i_callback_program        = sy-repid
      it_events                 = gt_event1
    TABLES
      t_outtab           = gt_bseg.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

FORM pf_status_set USING x.
  SET PF-STATUS '0100'.
ENDFORM. "F_ALV_STATUS

FORM user_command USING pv_r_ucomm     LIKE sy-ucomm
      ps_rs_selfield TYPE slis_selfield.
  CASE pv_r_ucomm.
    WHEN 'CANCEL' OR 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDFORM. "User Command
*&---------------------------------------------------------------------*
*&      Form  GET_EVENTS
*----------------------------------------------------------------------*
FORM get_events .
  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
   IMPORTING
     et_events             = gt_event1 .

*END OF LIST
  READ TABLE gt_event1 INTO wa_events WITH KEY name = 'END_OF_LIST' .
  wa_events-form = 'FORM_END_OF_LIST' .
  MODIFY  gt_event1 FROM wa_events INDEX sy-tabix .
ENDFORM.

FORM form_end_of_list .
  REFRESH i_heading .
  CLEAR   wa_heading .

  LOOP AT gt_message.
    wa_heading-typ = 'S' .
    wa_heading-key  = 'Durum: '.
    wa_heading-info = gt_message-message.
    APPEND wa_heading TO i_heading.
  ENDLOOP.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
   EXPORTING
     it_list_commentary       = i_heading
    i_end_of_list_grid       = 'X'
           .
ENDFORM .                    "FORM_END_OF_LIST
