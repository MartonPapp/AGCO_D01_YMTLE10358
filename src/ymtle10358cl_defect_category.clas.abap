CLASS ymtle10358cl_defect_category DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES ymtle10358i_defect_category .

    ALIASES check_radiobutton
      FOR ymtle10358i_defect_category~check_radiobutton .
    ALIASES create_defect
      FOR ymtle10358i_defect_category~create_defect .
    ALIASES email_notification
      FOR ymtle10358i_defect_category~email_notification .
    ALIASES set_putaway_block_status
      FOR ymtle10358i_defect_category~set_putaway_block_status.

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_nr_obj_ymtle10358 TYPE nrobj VALUE 'YMTLE10358' ##NO_TEXT.
    CONSTANTS gc_nr_nr_ymtle10358 TYPE nrnr VALUE '01' ##NO_TEXT.
    DATA mo_defect_dao TYPE REF TO ymtle10358i_defect_dao .
    DATA mo_email_notif TYPE REF TO ymtle10358i_email_notification .
    DATA: mo_change_strg_bin TYPE REF TO ymtli10423i_change_strg_bin.
    DATA mt_xuser TYPE lrf_wkqu_t1 .
    DATA ms_xuser TYPE lrf_wkqu .
    DATA mv_msg TYPE string ##NEEDED.
ENDCLASS.



CLASS YMTLE10358CL_DEFECT_CATEGORY IMPLEMENTATION.


  METHOD constructor.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
*
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    mo_defect_dao = ymtle10358cl_dao_factory=>get_defect_dao_instance( ).

  ENDMETHOD.              "constructor


  METHOD check_radiobutton.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
*
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    IF is_parameters-rbt_damgd_label IS INITIAL
    AND is_parameters-rbt_damgd_rack IS INITIAL
    AND is_parameters-rbt_inv_disc IS INITIAL.
      rv_res = abap_false.
    ELSE.
      rv_res = abap_true.
    ENDIF.
  ENDMETHOD.              "check_radiobutton


  METHOD create_defect.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* saves defect to DB
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    TRY.
        mt_xuser = mo_defect_dao->user_data_get( EXPORTING iv_uname = is_parameters-uname ).

        TRY.
            ms_xuser = mt_xuser[ statu = 'X' ].
          CATCH cx_sy_itab_line_not_found.
            MESSAGE e015 WITH is_parameters-uname INTO mv_msg.      "No active warehouse assigned to user: &1.
            RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
        ENDTRY.

        mo_defect_dao->enqueue_number_range( gc_nr_obj_ymtle10358 ).

        DATA(ls_defect) = VALUE ymtle10358s_defect( defect_nr = mo_defect_dao->get_defect_id( EXPORTING iv_object = gc_nr_obj_ymtle10358
                                                                                                        iv_range_nr = gc_nr_nr_ymtle10358 )
                                                    credat    = sy-datum
                                                    cretim    = sy-timlo
                                                    ernam     = is_parameters-uname
                                                    defcat    = COND #( WHEN is_parameters-rbt_inv_disc EQ abap_true THEN ymtle10358i_defect_dao=>gc_defcat_inv_discrepancy
                                                                        WHEN is_parameters-rbt_damgd_label EQ abap_true THEN ymtle10358i_defect_dao=>gc_defcat_damaged_label
                                                                        WHEN is_parameters-rbt_damgd_rack EQ abap_true THEN ymtle10358i_defect_dao=>gc_defcat_damaged_rack
                                                                        ELSE '' )
                                                    lgnum     = ms_xuser-lgnum
                                                    lgtyp     = it_values[ compid = 'EDT_T301_LGTYP' ]-cvalue
                                                    lgpla     = it_values[ compid = 'EDT_LAGP_LGPLA' ]-cvalue
                                                    matnr     = it_values[ compid = 'EDT_MARA_MATNR' ]-cvalue
                                                    status    = 'NEW'
                                                    notes     = ''
                                                    closedby  = ''
                                                    email_new = ''
                                                    email_open = ''
                                                    email_closed = ''
                                                    closed_date = ''
                                                    closed_time = '' ).

        mo_defect_dao->dequeue_number_range( gc_nr_obj_ymtle10358 ).

        mo_defect_dao->save_defect( ls_defect ).

        rs_defect = ls_defect.

      CATCH cx_sy_itab_line_not_found INTO DATA(lx_itab).
        MESSAGE lx_itab->get_text( ) TYPE 'E'.
        RAISE EXCEPTION TYPE ycx_agco_globcore_exception
          EXPORTING
            msgty = sy-msgty
            msgid = sy-msgid
            msgno = sy-msgno
            msgv1 = sy-msgv1
            msgv2 = sy-msgv2
            msgv3 = sy-msgv3
            msgv4 = sy-msgv4.

    ENDTRY.
  ENDMETHOD.              "create_defect


  METHOD ymtle10358i_defect_category~email_notification.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
*
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    IF mo_email_notif IS NOT BOUND.
      mo_email_notif = NEW ymtle10358cl_email_not( ).
    ENDIF.

    DATA(lt_defects) = VALUE ymtle10358tt_defect( ( is_defect )  ).

*       Send e-mail
    mo_email_notif->handle_email_event( EXPORTING it_defects    = lt_defects
                                                  it_recipients = it_recipients ).

*       Set e-mail status
    DATA(ls_defect_mod) = CORRESPONDING ymtle10358s_defect( is_defect ).
    CASE ls_defect_mod-status.
      WHEN 'NEW'.
        ls_defect_mod-email_new = abap_true.
      WHEN 'OPEN'.
        ls_defect_mod-email_open = abap_true.
      WHEN 'CLOSED'.
        ls_defect_mod-email_closed = abap_true.
    ENDCASE.

    mo_defect_dao->save_defect( ls_defect_mod ).

    rv_res = abap_true.
  ENDMETHOD.              "email_notification


  METHOD ymtle10358i_defect_category~set_putaway_block_status.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2023.03.31.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
*
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    IF mo_change_strg_bin IS NOT BOUND.
      mo_change_strg_bin = NEW ymtli10423cl_change_strg_bin( ).
    ENDIF.

    mt_xuser = mo_defect_dao->user_data_get( EXPORTING iv_uname = is_parameters-uname ).

    TRY.
        ms_xuser = mt_xuser[ statu = 'X' ].
      CATCH cx_sy_itab_line_not_found.
        MESSAGE e015 WITH is_parameters-uname INTO mv_msg.      "No active warehouse assigned to user: &1.
        RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDTRY.

    DATA(ls_xlagpv) = VALUE lagpv( lgnum = ms_xuser-lgnum
                                   lgtyp = it_values[ compid = 'EDT_T301_LGTYP' ]-cvalue
                                   lgpla = it_values[ compid = 'EDT_LAGP_LGPLA' ]-cvalue
                                   skzue = 'X'
                                   spgru = COND #( WHEN is_parameters-rbt_inv_disc EQ abap_true THEN ymtle10358i_defect_dao=>gc_defcat_inv_discrepancy
                                                   WHEN is_parameters-rbt_damgd_label EQ abap_true THEN ymtle10358i_defect_dao=>gc_defcat_damaged_label
                                                   WHEN is_parameters-rbt_damgd_rack EQ abap_true THEN ymtle10358i_defect_dao=>gc_defcat_damaged_rack
                                                   ELSE '' ) ).

    mo_change_strg_bin->l_lagp_veraendern( ls_xlagpv ).

  ENDMETHOD.
ENDCLASS.
