FUNCTION zsm_ae_f23.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IP_BELNR) TYPE  EVAL_IV_BELNR_RANGE_T
*"     REFERENCE(IP_GJAHR) TYPE  ZSM_AE_TT_GJAHR
*"     REFERENCE(IP_BUKRS) TYPE  ZSM_AE_TT_BUKRS
*"  TABLES
*"      LT_RETURN STRUCTURE  ZSM_AE_S23
*"----------------------------------------------------------------------
SELECT *
  FROM bseg
  INTO CORRESPONDING FIELDS OF TABLE lt_return
  WHERE bseg~belnr IN ip_belnr
  AND   bseg~gjahr IN ip_gjahr
  AND   bseg~bukrs IN ip_bukrs.
ENDFUNCTION.
