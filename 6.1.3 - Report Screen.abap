* Öğrenci, seçim ekranında girilen metni aynen görüntüleyen bir diyalog ekrani oluştursun.

TABLES: mara.

DATA: s_char  TYPE string,
      out_txt TYPE string.

 SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
   PARAMETERS: p_txt LIKE s_char.
 SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  out_txt = p_txt.
  CALL SCREEN 100.
END-OF-SELECTION.
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

  CASE sy-ucomm.

  WHEN 'CANCEL' OR 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.

  MODIFY SCREEN.

  ENDCASE.
ENDMODULE.
