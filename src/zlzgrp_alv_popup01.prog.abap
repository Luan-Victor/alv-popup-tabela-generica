*&---------------------------------------------------------------------*
*&  Include           ZLZGRP_ALV_POPUP01
*&---------------------------------------------------------------------*

CLASS handle_events IMPLEMENTATION.

  METHOD on_link_click.

    FIELD-SYMBOLS: <hotspot>    LIKE LINE OF gt_hotspot,
                   <field_data> TYPE any.

    CHECK row > 0.

    READ TABLE <gt_table_data> ASSIGNING <row_data> INDEX row.
    CHECK sy-subrc = 0.

    LOOP AT gt_hotspot ASSIGNING <hotspot> WHERE field = column.

      ASSIGN COMPONENT <hotspot>-subfield OF STRUCTURE <row_data> TO <field_data>.
      IF <field_data> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      SET PARAMETER ID <hotspot>-parameters FIELD <field_data>.

    ENDLOOP.

    READ TABLE gt_hotspot ASSIGNING <hotspot> WITH KEY field = column.
    CHECK sy-subrc = 0.

    CALL TRANSACTION <hotspot>-tcode AND SKIP FIRST SCREEN.

  ENDMETHOD.                    "lcl_event_handler

  METHOD on_user_command.

    DATA: lo_selections TYPE REF TO cl_salv_selections.

    CASE e_salv_function.
      WHEN 'CANC'.
        go_salv_table->close_screen( ).
      WHEN '&SEL'.
        lo_selections    = go_salv_table->get_selections( ).
        gt_selected_rows = lo_selections->get_selected_rows( ).
        go_salv_table->close_screen( ).
    ENDCASE.

  ENDMETHOD.                    "on_user_command

ENDCLASS.                    "handle_events IMPLEMENTATION
