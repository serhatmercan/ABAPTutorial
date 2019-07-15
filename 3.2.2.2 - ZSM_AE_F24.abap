FUNCTION zsm_ae_f24.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IR_BELNR) TYPE  EVAL_IV_BELNR_RANGE_T
*"     REFERENCE(IR_GJAHR) TYPE  ZSM_AE_TT_GJAHR
*"  TABLES
*"      LT_RETURN STRUCTURE  ZSM_AE_S24
*"      LT_MESSAGE STRUCTURE  ZSM_AE_ST_MESSAGE
*"----------------------------------------------------------------------
SELECT *
  FROM bseg
  INTO CORRESPONDING FIELDS OF TABLE lt_return
  WHERE bseg~belnr IN ir_belnr
  AND   bseg~gjahr IN ir_gjahr.

  IF sy-subrc EQ 0.
    lt_message-type    = 'S'.
    lt_message-message = 'Başarılı'.
    APPEND lt_message.
  ELSE.
    lt_message-type    = 'E'.
    lt_message-message = 'Başarısız'.
    APPEND lt_message.
  ENDIF.
ENDFUNCTION.
