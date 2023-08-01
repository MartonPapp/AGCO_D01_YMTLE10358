*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Background job for e-mail sending
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*

CLASS lcl_report DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING it_status_rng TYPE ymtle10358tt_status_rng.
    CLASS-METHODS: initialization .
    METHODS: start_of_selection.
  PRIVATE SECTION.
    DATA: mt_status_rng TYPE ymtle10358tt_status_rng.
    DATA: mo_email_report TYPE REF TO ymtle10358i_email_report.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.
  METHOD constructor.
    mt_status_rng = it_status_rng.
    TRY.
        mo_email_report = NEW ymtle10358cl_email_report( ).
      CATCH ycx_agco_globcore_exception INTO DATA(lx_agco).
        MESSAGE ID lx_agco->msgid TYPE lx_agco->msgty NUMBER lx_agco->msgno
                WITH lx_agco->msgv1 lx_agco->msgv2 lx_agco->msgv3 lx_agco->msgv4.
    ENDTRY.
  ENDMETHOD.

  METHOD initialization.
    DATA(ls_restriction) = VALUE sscr_restrict( ).
    ls_restriction-opt_list_tab = VALUE #( ( name = '1' options = VALUE #( eq = abap_true ) ) ).
    ls_restriction-ass_tab = VALUE #( ( kind = 'S' name = 'S_STAT' sg_main = 'I' op_main = '1' ) ).

    CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
      EXPORTING
        restriction            = ls_restriction
      EXCEPTIONS
        too_late               = 1
        repeated               = 2
        selopt_without_options = 3
        selopt_without_signs   = 4
        invalid_sign           = 5
        empty_option_list      = 6
        invalid_kind           = 7
        repeated_kind_a        = 8
        OTHERS                 = 9.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.

  METHOD start_of_selection.
    DATA: lt_bapiret2_all TYPE bapiret2_tt,
          lt_bapiret2     TYPE bapiret2_tt,
          lt_result_all   TYPE bcsy_text.

    TRY.
        LOOP AT mt_status_rng INTO DATA(ls_status).
          CLEAR lt_bapiret2.
          DATA(lt_result) = mo_email_report->send_emails( EXPORTING iv_status   = ls_status-low
                                                          IMPORTING et_bapiret2 = lt_bapiret2 ).
          APPEND LINES OF lt_result TO lt_result_all.
          APPEND LINES OF lt_bapiret2 TO lt_bapiret2_all.
        ENDLOOP.

        mo_email_report->bal_log( EXPORTING it_msg       = lt_result_all
                                            it_bapiret2  = lt_bapiret2_all ).

      CATCH ycx_agco_globcore_exception INTO DATA(lx_agco).
        MESSAGE ID lx_agco->msgid TYPE lx_agco->msgty NUMBER lx_agco->msgno
                WITH lx_agco->msgv1 lx_agco->msgv2 lx_agco->msgv3 lx_agco->msgv4.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
