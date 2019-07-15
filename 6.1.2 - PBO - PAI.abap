* Öğrenci; iki metin kutusu ve bir KOPYALA düğmesi içeren bir diyalog yaratsin. 
* Metin kutusuna bir yazi yazip kopyala düğmesine tiklandiğinda; metin, diğer kutucuğa kopyalansin.

DATA: txt_orginal TYPE string,
      txt_copy    TYPE string.

CALL SCREEN 0100.
*----------------------------------------------------------------------*
*      Module  STATUS_0100  OUTPUT
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATU'.
  SET TITLEBAR  'TITLES'.
ENDMODULE.
*----------------------------------------------------------------------*
*      Module  USER_COMMAND_0100  INPUT
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.

  WHEN 'COPY'.
    txt_copy = txt_orginal.

  WHEN 'CANCEL' OR 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.

  MODIFY SCREEN.

  ENDCASE.
ENDMODULE.
