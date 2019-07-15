* Gönderilen belge numarasi & yil & şirket koduna ait fi kalemlerini döndüren bir fonksiyon yazılıp, 
* Bu fonksiyonu; seçim ekranindan girilen yil & şirket & belge numarasi için çağirip, 
* kalemleri alv formatinda ekrana döken bir program yazsin.

TYPE-POOLS: slis.

DATA: gt_fcat     TYPE slis_t_fieldcat_alv,
      gs_layout1  TYPE slis_layout_alv,
      gt_event1   TYPE slis_t_event.

TABLES: bseg.

DATA: gt_bseg TYPE TABLE OF zsm_ae_s23 WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK sb1.
SELECT-OPTIONS: s_bno  FOR bseg-belnr,
                s_myil FOR bseg-gjahr,
                s_skod FOR bseg-bukrs.
SELECTION-SCREEN END OF BLOCK sb1.

START-OF-SELECTION.
  PERFORM get_data.
end-of-SELECTION.

PERFORM display_with_alv.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*----------------------------------------------------------------------*
FORM get_data .

CALL FUNCTION 'ZSM_AE_F23'
  EXPORTING
    ip_belnr        = s_bno[]
    ip_gjahr        = s_myil[]
    ip_bukrs        = s_skod[]
  TABLES
    lt_return       = gt_bseg[].

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
     I_INTERNAL_TABNAME           = 'GT_BSEG'
     i_structure_name             = 'ZSM_AE_S23'
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
