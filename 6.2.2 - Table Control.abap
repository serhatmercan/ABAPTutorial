* Öğrenci, mali yıl & şirket kodu girilebilecek iki kutucuk ve iki adet table control içeren bir ekran yaratsin. 
* Mali yil & şirket kodu girilip düğmeye tiklandiğinda, o yil ve 
* şirket koduna ait bütün muhasebe belgeleri soldaki tablo kontrolünde listelensin. 
* Soldaki tabloda bir(kaç) kayit seçilip bir diğer düğmeye tiklandiğinda, seçilen belgelere ait kalemler sağdaki tabloda listelensin.

DATA  : p_gjahr TYPE bseg-gjahr,
        p_bukrs TYPE bseg-bukrs.

DATA: BEGIN OF it_bseg OCCURS 0,
        mark   TYPE xfeld,
        belnr  LIKE bseg-belnr,
        gjahr  LIKE bseg-gjahr,
        bukrs  LIKE bseg-bukrs,
      END OF it_bseg.

DATA: it2_bseg LIKE TABLE OF it_bseg.

DATA: wa_bseg  LIKE LINE OF it_bseg,
      wa2_bseg LIKE LINE OF it2_bseg.

CONTROLS: container TYPE TABSTRIP,
          tablec    TYPE TABLEVIEW USING SCREEN 200.

START-OF-SELECTION.
  CALL SCREEN 100.
END-OF-SELECTION.
*---------------------------------------------------------------------*
*      Module  STATUS_0100  OUTPUT
*---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR  'TITLE'.
ENDMODULE.
*---------------------------------------------------------------------*
*      Module  USER_COMMAND_0100  INPUT
*---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE sy-ucomm.

  WHEN 'TAB1'.
    container-activetab = 'TAB1'.
  WHEN 'TAB2'.
    container-activetab = 'TAB2'.
  WHEN 'CANCEL' OR 'BACK' OR 'EXIT'.
    LEAVE TO SCREEN 0.

  MODIFY SCREEN.

ENDCASE.
ENDMODULE.
*---------------------------------------------------------------------*
*      Module  USER_COMMAND_0200  INPUT
*---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

CASE sy-ucomm.

  WHEN 'ARA'.
    PERFORM get_data.
  WHEN 'AKTAR'.
    PERFORM get_selected_data.

  MODIFY SCREEN.

ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .
SELECT belnr gjahr bukrs
 FROM bseg
 INTO CORRESPONDING FIELDS OF TABLE it_bseg
 WHERE bseg~gjahr EQ p_gjahr
 AND bseg~bukrs   EQ p_bukrs.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
*  SET PF-STATUS 'STATUS2'.
*  SET TITLEBAR  'TITLE2'.
ENDMODULE.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'BSEG' ITSELF
CONTROLS: bseg TYPE TABLEVIEW USING SCREEN 0200.

*&SPWIZARD: OUTPUT MODULE FOR TC 'BSEG'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE bseg_change_tc_attr OUTPUT.
  DESCRIBE TABLE it_bseg LINES bseg-lines.
ENDMODULE.
*---------------------------------------------------------------------*
*      Form  GET_SELECTED_DATA
*---------------------------------------------------------------------*
FORM get_selected_data.

 LOOP AT it_bseg.
   MOVE-CORRESPONDING it_bseg TO wa2_bseg.
     APPEND wa2_bseg TO it2_bseg.
 ENDLOOP.

ENDFORM.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'MARA' ITSELF
CONTROLS: mara TYPE TABLEVIEW USING SCREEN 0300.

*&SPWIZARD: OUTPUT MODULE FOR TC 'MARA'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE mara_change_tc_attr OUTPUT.
  DESCRIBE TABLE it2_bseg LINES mara-lines.
ENDMODULE.
