*&---------------------------------------------------------------------*
*&  Include           ZSERHATM_EV_TOP
*&---------------------------------------------------------------------*
CLASS: gcl_application DEFINITION DEFERRED .

TYPE-POOLS: slis.

TABLES:     mara.

CONSTANTS: gc_structure_name TYPE  dd02l-tabname VALUE
                                                   'ZSERHATM_OOP_ALV_S',
           gc_top_of_page    TYPE slis_formname VALUE 'F_TOP_OF_PAGE',
           gc_user_command   TYPE slis_formname VALUE 'F_USER_COMMAND',
           gc_pf_status_set  TYPE slis_formname VALUE 'F_PF_STATUS_SET',
           gc_default        TYPE c VALUE 'X',
           gc_save           TYPE c VALUE 'A'.

CONSTANTS: gc_x TYPE xfeld VALUE 'X' .

CONTROLS: container TYPE TABSTRIP.

DATA : g_docking_container TYPE REF TO cl_gui_docking_container,
       g_splitter          TYPE REF TO cl_gui_splitter_container,
       g_grid              TYPE REF TO cl_gui_alv_grid,
       g_grid2             TYPE REF TO cl_gui_alv_grid,
       g_dock              TYPE REF TO cl_gui_docking_container,
       g_application       TYPE REF TO gcl_application,
       custom_container1   TYPE REF TO cl_gui_custom_container,
       custom_container2   TYPE REF TO cl_gui_custom_container,
       mycontainer1        TYPE scrfname VALUE 'CC1', "Container Name1
       mycontainer2        TYPE scrfname VALUE 'CC2'. "Container Name2

*** Extra ***
DATA: lt_fieldcat    TYPE lvc_t_fcat,
      ls_layout      TYPE lvc_s_layo,
      ls_variant     TYPE disvariant,
      lt_toolbar_exc TYPE TABLE OF ui_func,
      lv_dynnr       TYPE sy-dynnr.

DATA: lt_f4     TYPE lvc_t_f4 WITH HEADER LINE.

ls_layout-sel_mode = 'A'.

DATA: lr_selections TYPE REF TO cl_salv_selections.
*** Extra ***

DATA: p_mtart TYPE mara-mtart.

DATA: it          TYPE TABLE OF zserhatm_oop_alv_s,
      wa          LIKE LINE OF it,
      ok_code_100 LIKE sy-ucomm.

DATA: it_select LIKE it,
      wa_select LIKE LINE OF it_select.

DATA: it_selected_rows TYPE lvc_t_roid,
      wa_selected_row  TYPE lvc_s_roid.

DATA: flag     TYPE mara-mtart,
      flag2(1) TYPE c,
      flag3(1) TYPE c.

CLASS gcl_application DEFINITION .
  PUBLIC SECTION.
*    METHODS
*      handle_double_click
*                    FOR EVENT double_click OF cl_gui_alv_grid
*        IMPORTING e_row e_column es_row_no.
ENDCLASS .

CLASS gcl_application  IMPLEMENTATION.
*  METHOD handle_double_click .
*    PERFORM handle_double_click USING e_row "obsolete
*                                      e_column
**                                      es_row_no .
*  ENDMETHOD .                    "handle_double_click
ENDCLASS .
*&---------------------------------------------------------------------*
*&  Include           ZSERHATM_EV_F1
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*      Module  STATUS_0100  OUTPUT
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR  'TITLE'.
ENDMODULE.
*----------------------------------------------------------------------*
*      Module  USER_COMMAND_0100  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE ok_code_100.

  WHEN 'TAB1'.
    container-activetab = 'TAB1'.
  WHEN 'TAB2'.
    container-activetab = 'TAB2'.
  WHEN 'CANCEL' OR 'BACK' OR 'EXIT'.
    LEAVE TO SCREEN 0.

ENDCASE.
MODIFY SCREEN.
ENDMODULE.
*----------------------------------------------------------------------*
*      Form  GET_DATA
*----------------------------------------------------------------------*
FORM get_data .
REFRESH it.
CLEAR wa.

 SELECT matnr ernam ersda mtart
  FROM mara
  INTO CORRESPONDING FIELDS OF TABLE it
  WHERE mtart EQ p_mtart.

LOOP AT it INTO wa.
  flag = wa-mtart.
ENDLOOP.

ENDFORM.
*----------------------------------------------------------------------*
*      Module  USER_COMMAND_0200  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

CASE ok_code_100.
  WHEN 'ARA'.
    PERFORM get_data.
      IF flag NE p_mtart OR p_mtart EQ space.
          MESSAGE 'Malzeme Türünü yanlış girdiniz'
          TYPE 'S' DISPLAY LIKE 'E'.
          LEAVE LIST-PROCESSING.
          PERFORM create_object TABLES it USING    mycontainer1
                                          CHANGING g_grid
                                                   custom_container1.
      ELSE.
          PERFORM create_object TABLES it USING    mycontainer1
                                          CHANGING g_grid
                                                   custom_container1.
      ENDIF.
  WHEN 'GONDER'.
    IF flag NE p_mtart OR p_mtart EQ space.
      MESSAGE 'Malzeme Türünü yanlış girdiniz'
      TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ELSE.
      PERFORM p_send_selected_rows.
      IF flag2 EQ 'X'.
           MESSAGE 'İlgili malzeme önceden seçilmiştir'
           TYPE 'S' DISPLAY LIKE 'E'.
           LEAVE LIST-PROCESSING.
      ELSE.
         IF it_select IS INITIAL.
           MESSAGE 'Satır seçimi yapınız'
           TYPE 'S' DISPLAY LIKE 'E'.
           LEAVE LIST-PROCESSING.
         ELSE.
           PERFORM create_object TABLES   it_select USING mycontainer2
                                 CHANGING g_grid2 custom_container2.
           PERFORM refresh_alv   CHANGING g_grid.
           container-activetab = 'TAB2'.
         ENDIF.
      ENDIF.
      flag2 = ''.
    ENDIF.

ENDCASE.

MODIFY SCREEN.

ENDMODULE.
*----------------------------------------------------------------------*
*      Form  GET_FIELDCAT
*----------------------------------------------------------------------*
FORM f_get_fieldcat USING    ip_structure_name LIKE dd02l-tabname
                             ip_det            TYPE xfeld
                    CHANGING ct_fieldcat       TYPE lvc_t_fcat .

DATA: ls_fieldcat LIKE LINE OF ct_fieldcat .
DATA: ls_outtab   LIKE LINE OF it .

DEFINE lm_fcat.
  ls_fieldcat-scrtext_l = &1 .
  ls_fieldcat-scrtext_m = &1 .
  ls_fieldcat-scrtext_s = &1 .
  ls_fieldcat-reptext   = &1 .
  MODIFY ct_fieldcat FROM ls_fieldcat.
END-OF-DEFINITION.

REFRESH ct_fieldcat.

CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  EXPORTING
    i_structure_name       = ip_structure_name
  CHANGING
    ct_fieldcat            = ct_fieldcat
  EXCEPTIONS
    inconsistent_interface = 1
    program_error          = 2
  OTHERS                   = 3.

IF sy-subrc NE 0 .
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

ENDFORM.                    " F_GET_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  CREATE_OBJECT
*&---------------------------------------------------------------------*
FORM create_object TABLES   it_it TYPE zserhatm_oop_alv_tt
                   USING    ip_container_name TYPE scrfname
                   CHANGING l_grid TYPE REF TO cl_gui_alv_grid
                            custom_container
                                   TYPE REF TO cl_gui_custom_container.

IF custom_container IS INITIAL.
CREATE OBJECT custom_container
  EXPORTING
    container_name              = ip_container_name
  EXCEPTIONS
    cntl_error                  = 1
    cntl_system_error           = 2
    create_error                = 3
    lifetime_error              = 4
    lifetime_dynpro_dynpro_link = 5.

CREATE OBJECT l_grid
  EXPORTING
    i_parent = custom_container.

PERFORM  f_get_fieldcat USING    gc_structure_name space
                        CHANGING lt_fieldcat[].

CREATE OBJECT g_application.

CALL METHOD l_grid->set_table_for_first_display
  EXPORTING
    is_layout            = ls_layout
    it_toolbar_excluding = lt_toolbar_exc
    i_bypassing_buffer   = 'X'
    i_save               = 'A'
  CHANGING
    it_outtab            = it_it[]
    it_fieldcatalog      = lt_fieldcat[].
ELSE.
  CALL METHOD l_grid->refresh_table_display.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REFRESH_ALV
*&---------------------------------------------------------------------*
FORM refresh_alv CHANGING l_grid TYPE REF TO cl_gui_alv_grid.
CALL METHOD l_grid->refresh_table_display
  EXPORTING
    i_soft_refresh = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  P_SEND_SELECTED_ROWS
*&---------------------------------------------------------------------*
FORM p_send_selected_rows .

CALL METHOD g_grid->get_selected_rows
  IMPORTING
    et_row_no = it_selected_rows.

LOOP AT it_selected_rows INTO wa_selected_row.
  READ TABLE it INTO wa INDEX wa_selected_row-row_id.
    IF sy-subrc EQ 0.
      READ TABLE it_select INTO wa_select WITH KEY matnr = wa-matnr.
        IF sy-subrc EQ 0.
          flag2 = 'X'.
        ELSE.
          MOVE-CORRESPONDING wa TO wa_select.
          APPEND wa_select TO it_select.
        ENDIF.
    ENDIF.
    CLEAR wa_selected_row.
ENDLOOP.

LOOP AT it INTO wa.
  READ TABLE it_select INTO wa_select WITH KEY matnr = wa-matnr.
   IF sy-subrc EQ 0.
     DELETE TABLE it FROM wa.
   ENDIF.
  CLEAR wa.
ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
CASE ok_code_100.
  WHEN 'GERI'.
    container-activetab = 'TAB1'.
ENDCASE.
MODIFY SCREEN.
ENDMODULE.

START-OF-SELECTION.
  CALL SCREEN 100.
END-OF-SELECTION.
