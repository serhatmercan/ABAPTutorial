* Program, seçim ekranında bir tarih sorsun. Girilen tarihe göre, kullanicinin burcunu bulup söylesin.

DATA: lv_ay(2), lv_gun(2).

SELECTION-SCREEN BEGIN OF BLOCK sb1 WITH FRAME TITLE text-001.
PARAMETERS: p_date TYPE sy-datum.
SELECTION-SCREEN END OF BLOCK sb1.

START-OF-SELECTION.

  lv_ay  = p_date+4(2).
  lv_gun = p_date+6(2).

  IF ( lv_ay EQ '03'  AND lv_gun GE '21' ) OR
     ( lv_ay EQ '04'  AND lv_gun LE '20' ).
    WRITE: 'Koç'.
  ELSEIF ( lv_ay EQ '04'  AND lv_gun GE '21' ) OR
         ( lv_ay EQ '05'  AND lv_gun LE '21' ).
    WRITE: 'Boğa'.
  ELSEIF ( lv_ay EQ '05'  AND lv_gun GE '22' ) OR
         ( lv_ay EQ '06'  AND lv_gun LE '22' ).
    WRITE: 'İkizler'.
  ELSEIF ( lv_ay EQ '06'  AND lv_gun GE '23' ) OR
         ( lv_ay EQ '07'  AND lv_gun LE '22' ).
    WRITE: 'Yengeç'.
  ELSEIF ( lv_ay EQ '07'  AND lv_gun GE '23' ) OR
         ( lv_ay EQ '08'  AND lv_gun LE '22' ).
    WRITE: 'Aslan'.
  ELSEIF ( lv_ay EQ '08'  AND lv_gun GE '23' ) OR
         ( lv_ay EQ '09'  AND lv_gun LE '22' ).
    WRITE: 'Başak'.
  ELSEIF ( lv_ay EQ '09'  AND lv_gun GE '23' ) OR
         ( lv_ay EQ '10'  AND lv_gun LE '22' ).
    WRITE: 'Terazi'.
  ELSEIF ( lv_ay EQ '10'  AND lv_gun GE '23' ) OR
         ( lv_ay EQ '11'  AND lv_gun LE '21' ).
    WRITE: 'Akrep'.
  ELSEIF ( lv_ay EQ '11'  AND lv_gun GE '22' ) OR
         ( lv_ay EQ '12'  AND lv_gun LE '21' ).
    WRITE: 'Yay'.
  ELSEIF ( lv_ay EQ '12'  AND lv_gun GE '22' ) OR
         ( lv_ay EQ '01'  AND lv_gun LE '21' ).
    WRITE: 'Oğlak'.
  ELSEIF ( lv_ay EQ '01'  AND lv_gun GE '22' ) OR
         ( lv_ay EQ '02'  AND lv_gun LE '19' ).
    WRITE: 'Kova'.
  ELSEIF ( lv_ay EQ '02'  AND lv_gun GE '20' ) OR
         ( lv_ay EQ '03'  AND lv_gun LE '20' ).
    WRITE: 'Kova'.
  ENDIF.


END-OF-SELECTION.
