*&---------------------------------------------------------------------*
*& Report  ZALVPOPUP_EXEMPLO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zalvpopup_exemplo.

DATA: lt_mara            TYPE TABLE OF mara,
      lt_fcat            TYPE lvc_t_fcat,
      lt_hotspot         TYPE zthotspot,
      lt_totalrow        TYPE alfieldnames,
      lt_ignoring_fields TYPE alfieldnames,
      lt_selected_rows   TYPE salv_t_row.

FIELD-SYMBOLS: <mara>          LIKE LINE OF lt_mara,
               <fcat>          LIKE LINE OF lt_fcat,
               <hotspot>       LIKE LINE OF lt_hotspot,
               <totalrow>      LIKE LINE OF lt_totalrow,
               <field_ignored> LIKE LINE OF lt_ignoring_fields.

* Busca dados para exibição
SELECT * UP TO 5 ROWS
  FROM mara
  INTO TABLE lt_mara.

* Ignora campos do ALV
CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  EXPORTING
    i_structure_name       = 'MARA'
  CHANGING
    ct_fieldcat            = lt_fcat
  EXCEPTIONS
    inconsistent_interface = 1
    program_error          = 2
    OTHERS                 = 3.
IF sy-subrc <> 0.
ENDIF.

LOOP AT lt_fcat ASSIGNING <fcat>.

  IF sy-tabix > 30.
    APPEND INITIAL LINE TO lt_ignoring_fields ASSIGNING <field_ignored>.
    <field_ignored> = <fcat>-fieldname.
  ENDIF.

ENDLOOP.

* Hotspot
APPEND INITIAL LINE TO lt_hotspot ASSIGNING <hotspot>.
<hotspot>-tcode      = 'MM03'.
<hotspot>-field      = 'MATNR'.
<hotspot>-subfield   = 'MATNR'.
<hotspot>-parameters = 'MAT'.

* Linha somatória
APPEND INITIAL LINE TO lt_totalrow ASSIGNING <totalrow>.
<totalrow> = 'BRGEW'.

* Exibe pop-up
CALL FUNCTION 'ZALV_POPUP'
  EXPORTING
    i_table_data      = lt_mara
    i_structure       = 'MARA'
    i_ignoring_fields = lt_ignoring_fields
    i_hotspot         = lt_hotspot
    i_totalrow        = lt_totalrow
    i_selection_mode  = if_salv_c_selection_mode=>single
    i_title           = 'Selecione um material'
  IMPORTING
    e_selected_rows   = lt_selected_rows.
