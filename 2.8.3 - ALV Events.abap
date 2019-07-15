* Program, seçim ekranından girilen şirket kodu & mali yıl & kayıt tarihi araliği & belge numarasi araliğina uyan bütün malzeme
* belgelerini çeksin ve kalemlerini alv list formatinda ekrana döksün.
* Raporun başinda (top_of_list) şirket kodu , sonunda ise (end_of_list) geri dönen kayit sayisi yazsin. 
* Save düğmesine tiklandiğinda, kullaniciya popup ile “hello” metni gösterilsin.

TYPE-POOLS: slis.

TABLES: bseg.

DATA: gt_bseg TYPE TABLE OF bseg.

DATA: gt_fcat        TYPE slis_t_fieldcat_alv,
      gs_layout1     TYPE slis_layout_alv.

DATA: gt_event1  TYPE slis_t_event,
      wa_events  LIKE LINE OF gt_event1,
      i_heading  TYPE         slis_t_listheader,
      wa_heading LIKE LINE OF i_heading.

DATA : v_count TYPE i.

CONSTANTS: gc_program_name LIKE sy-repid VALUE 'ZSERHATM_P01'.

SELECTION-SCREEN BEGIN OF BLOCK sb1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_skod FOR bseg-bukrs,
                s_myil FOR bseg-gjahr,
                s_bno  FOR bseg-belnr.
SELECTION-SCREEN END OF BLOCK sb1.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM get_events .
END-OF-SELECTION.


  PERFORM display_with_alv.
*----------------------------------------------------------------------*
*      F O R M      D I S P L A Y_W I T H_A L V
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
     i_program_name               = gc_program_name
     i_structure_name             = 'BSEG'
     i_client_never_display       = 'X'
     i_inclname                   = gc_program_name
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
FORM get_data .
  SELECT *
      UP TO 100 ROWS
      FROM bseg
      INTO TABLE gt_bseg
      WHERE bseg~bukrs IN s_skod
      AND   bseg~gjahr IN s_myil
      AND   bseg~belnr IN s_bno.
ENDFORM.

FORM pf_status_set USING x.
  SET PF-STATUS '0100'.
ENDFORM. "F_ALV_STATUS

FORM user_command USING pv_r_ucomm     LIKE sy-ucomm
      ps_rs_selfield TYPE slis_selfield.
  CASE pv_r_ucomm.
    WHEN 'SAVE'.
       CALL FUNCTION 'POPUP_TO_DISPLAY_TEXT'
        EXPORTING
           textline1          = 'HELLO'.
    WHEN 'CANCEL' OR 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDFORM. "User Command

FORM get_events .
  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
   IMPORTING
     et_events             = gt_event1 .

*TOP OF LIST
  READ TABLE gt_event1 INTO wa_events WITH KEY name = 'TOP_OF_PAGE' .
  wa_events-form = 'FORM_TOP_OF_PAGE' .
  MODIFY  gt_event1 FROM wa_events INDEX sy-tabix .

*END OF LIST
  READ TABLE gt_event1 INTO wa_events WITH KEY name = 'END_OF_LIST' .
  wa_events-form = 'FORM_END_OF_LIST' .
  MODIFY  gt_event1 FROM wa_events INDEX sy-tabix .
ENDFORM.

FORM form_top_of_page .

  wa_heading-typ  = 'S'.
  wa_heading-key  = 'Şirket Kodu: '.

  CONCATENATE s_skod-low '-' s_skod-high INTO wa_heading-info.
  APPEND wa_heading TO i_heading.
  CLEAR  wa_heading.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
       EXPORTING
            it_list_commentary = i_heading.

ENDFORM .                    "FORM_TOP_OF_PAGE

FORM form_end_of_list .
  REFRESH i_heading .
  CLEAR   wa_heading .

  DESCRIBE TABLE gt_bseg LINES v_count.

  wa_heading-typ = 'S' .
  wa_heading-key  = 'Kayıt Sayısı: '.
  wa_heading-info = v_count .
  APPEND wa_heading TO i_heading .

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
   EXPORTING
     it_list_commentary       = i_heading
    i_end_of_list_grid       = 'X'
           .
ENDFORM .                    "FORM_END_OF_LIST
