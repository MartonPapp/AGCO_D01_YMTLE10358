CLASS ymtle10358cl_email_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES ymtle10358i_email_report .

    ALIASES bal_log
      FOR ymtle10358i_email_report~bal_log .
    ALIASES send_emails
      FOR ymtle10358i_email_report~send_emails .

    CONSTANTS gc_new TYPE ymtle10358de_status VALUE 'NEW' ##NO_TEXT.
    CONSTANTS gc_open TYPE ymtle10358de_status VALUE 'OPEN' ##NO_TEXT.
    CONSTANTS gc_closed TYPE ymtle10358de_status VALUE 'CLOSED' ##NO_TEXT.
    CLASS-DATA gv_email_separator TYPE char5 VALUE '>--->' ##NO_TEXT.

    METHODS constructor
      RAISING
        ycx_agco_globcore_exception .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_defect_dao TYPE REF TO ymtle10358i_defect_dao.
    DATA: mt_defects TYPE ymtle10358tt_defect.
    DATA: mt_result TYPE bcsy_text.

    DATA:
      ms_bal_s_log       TYPE bal_s_log,
      mv_log_handle      TYPE balloghndl,
      mt_log_handle      TYPE bal_t_logh,
      ms_display_profile TYPE bal_s_prof.
    METHODS set_email_status
      IMPORTING iv_status   TYPE ymtle10358de_status
                it_defectnr TYPE ymtle10358tt_defectnr
      RAISING   ycx_agco_globcore_exception.
ENDCLASS.



CLASS YMTLE10358CL_EMAIL_REPORT IMPLEMENTATION.


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
  ENDMETHOD.


  METHOD set_email_status.
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
    CHECK it_defectnr IS NOT INITIAL.
*  Update only the defects for which e-mail was sent
    DATA(lt_defects_filtered) = FILTER ymtle10358tt_defect( mt_defects IN it_defectnr WHERE defect_nr = defect_nr ).

    DATA(lt_defects_mod) = VALUE ymtle10358tt_defect(
        FOR ls_def IN lt_defects_filtered
        LET ls_def_mod = COND ymtle10358s_defect( WHEN iv_status = gc_new
                                                    THEN VALUE #( BASE ls_def
                                                        email_new = abap_true )
                                                  WHEN iv_status = gc_open
                                                    THEN VALUE #( BASE ls_def
                                                        email_open = abap_true )
                                                  WHEN iv_status = gc_closed
                                                    THEN VALUE #( BASE ls_def
                                                        email_closed  = abap_true )  ) IN
        ( ls_def_mod ) ).

    mo_defect_dao->save_defects_from_table( lt_defects_mod ).

  ENDMETHOD.        "set_email_status


  METHOD ymtle10358i_email_report~bal_log.
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
    DATA: lv_msg_was_added TYPE boolean  ##NEEDED.

    mo_defect_dao->bal_log_create( EXPORTING is_bal_s_log = ms_bal_s_log
                                   IMPORTING ev_log_handle = mv_log_handle ).

    LOOP AT it_bapiret2 INTO DATA(ls_bapiret2).
      DATA(ls_bal_msg) = VALUE bal_s_msg( msgid = ls_bapiret2-id
                                          msgno = ls_bapiret2-number
                                          msgty = ls_bapiret2-type
                                          msgv1 = ls_bapiret2-message_v1
                                          msgv2 = ls_bapiret2-message_v2
                                          msgv3 = ls_bapiret2-message_v3
                                          msgv4 = ls_bapiret2-message_v4 ).

      mo_defect_dao->bal_log_msg_add( EXPORTING iv_log_handle = mv_log_handle
                                                is_s_msg = ls_bal_msg
                                      IMPORTING ev_msg_was_logged = lv_msg_was_added ).
    ENDLOOP.

    LOOP AT it_msg INTO DATA(ls_msg).
      mo_defect_dao->bal_log_msg_add_free_text( EXPORTING iv_log_handle = mv_log_handle
                                                          iv_msgty      = 'I'
                                                          iv_text       = ls_msg-line
                                                IMPORTING ev_msg_was_logged = lv_msg_was_added ).
    ENDLOOP.

    mo_defect_dao->bal_dsp_profile_no_tree_get( IMPORTING es_display_profile = ms_display_profile ).
    ms_display_profile-use_grid = abap_true.

    APPEND mv_log_handle TO mt_log_handle.
    IF sy-batch EQ 'X'.
      mo_defect_dao->bal_dsp_log_textform( EXPORTING it_log_handle = mt_log_handle ).
    ELSE.
      mo_defect_dao->bal_dsp_log_display( EXPORTING it_log_handle = mt_log_handle
                                                    is_display_profile = ms_display_profile ).
    ENDIF.
  ENDMETHOD.            "bal_log


  METHOD ymtle10358i_email_report~send_emails.
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
    DATA: lt_defects_by_mail_lst TYPE ymtle10358tt_defect.
    TRY.
        mt_defects = mo_defect_dao->get_defects_by_status( iv_status ).
      CATCH ycx_agco_globcore_exception.
        APPEND VALUE #(  type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        RETURN.
    ENDTRY.

    CASE iv_status.
      WHEN gc_new.
        DELETE mt_defects WHERE email_new IS NOT INITIAL.
      WHEN gc_open.
        DELETE mt_defects WHERE email_open IS NOT INITIAL.
      WHEN gc_closed.
        DELETE mt_defects WHERE email_closed IS NOT INITIAL.
    ENDCASE.

    IF mt_defects IS INITIAL.
      MESSAGE i016 WITH iv_status INTO DATA(lv_msg) ##NEEDED.           "All defects with status &1 were already sent out by e-mail.
      APPEND VALUE #(  type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
      RETURN.
    ENDIF.

    DATA(lt_lgnum) = VALUE shp_lgnum_range_t( FOR GROUPS grp_lgnum OF ls_defects IN mt_defects
                                                GROUP BY ( lgnum  =  ls_defects-lgnum )  WITHOUT MEMBERS
                                                ( sign = 'I'
                                                  option = 'EQ'
                                                  low = grp_lgnum ) ).

    DATA(lt_lgtyp) = VALUE ymtlr4503tt_lgtyp_rng( FOR GROUPS grp_lgtyp OF ls_defects IN mt_defects
                                                    GROUP BY ( lgtyp  =  ls_defects-lgtyp ) WITHOUT MEMBERS
                                                    ( sign = 'I'
                                                      option = 'EQ'
                                                      low = grp_lgtyp ) ).

    DATA(lt_defcat) = VALUE ymtle10358tt_defcat_rng( FOR GROUPS grp_defcat OF ls_defects IN mt_defects
                                                        GROUP BY ( defcat = ls_defects-defcat ) WITHOUT MEMBERS
                                                        ( sign = 'I'
                                                          option = 'EQ'
                                                          low = grp_defcat ) ).
    TRY.
        DATA(lt_email_lst) = mo_defect_dao->get_email_lst( it_lgnum = lt_lgnum
                                                           it_lgtyp = lt_lgtyp
                                                           it_defcat = lt_defcat ).
      CATCH ycx_agco_globcore_exception.
        APPEND VALUE #(  type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        LOOP AT lt_lgnum INTO DATA(ls_lgnum).
          MESSAGE w019 WITH ls_lgnum-low INTO lv_msg.
          APPEND VALUE #(  type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        ENDLOOP.
        LOOP AT lt_lgtyp INTO DATA(ls_lgtyp).
          MESSAGE w020 WITH ls_lgtyp-low INTO lv_msg.
          APPEND VALUE #(  type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        ENDLOOP.
        LOOP AT lt_defcat INTO DATA(ls_defcat).
          MESSAGE w021 WITH ls_defcat-low INTO lv_msg.
          APPEND VALUE #(  type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        ENDLOOP.
        LOOP AT mt_defects INTO DATA(ls_def_no_mail).
            MESSAGE w018 WITH ls_def_no_mail-defect_nr INTO lv_msg.                 "No e-mail sent for Defect Nr.: &1.
            APPEND VALUE #( type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        ENDLOOP.
        RETURN.
    ENDTRY.


    LOOP AT lt_email_lst INTO DATA(ls_email_lst)
"Send emails by email lists
        GROUP BY ( email_list_id = ls_email_lst-email_list_id
                   gs = GROUP SIZE
                   gi = GROUP INDEX ) INTO DATA(grp_list).

      DATA(lo_email_notif) = NEW ymtle10358cl_email_not( ).
      "Collect all defects for the warehouse, strg type and defcat available under the current email list
      CLEAR lt_defects_by_mail_lst.
      LOOP AT GROUP grp_list INTO DATA(ls_list).
        lt_defects_by_mail_lst = VALUE #( BASE lt_defects_by_mail_lst
                                          FOR ls_defect IN mt_defects
                                            WHERE ( lgnum = ls_list-lgnum
                                                AND lgtyp = ls_list-lgtyp
                                                AND defcat = ls_list-defcat )
                                             ( ls_defect )  ).
      ENDLOOP.
      IF lt_defects_by_mail_lst IS INITIAL.
        CONTINUE.
      ENDIF.
*Collect defectnr to know which defects were processed, those needs to be updated
      DATA(lt_defectnr) = VALUE ymtle10358tt_defectnr( FOR ls_defect IN lt_defects_by_mail_lst
                              ( defect_nr = ls_defect-defect_nr ) ).
      "Send e-mails to the recipients
      TRY.
          mt_result = lo_email_notif->handle_email_event( it_defects = lt_defects_by_mail_lst
                                                          it_recipients = mo_defect_dao->get_recipients_by_id( grp_list-email_list_id ) ).

          me->set_email_status( iv_status = iv_status
                                it_defectnr = lt_defectnr ).
*         Delete the already processed defects from the global table
          mt_defects = FILTER #( mt_defects EXCEPT IN lt_defectnr WHERE defect_nr = defect_nr ).

          APPEND LINES OF mt_result TO rt_result.
          APPEND gv_email_separator TO rt_result.

        CATCH ycx_agco_globcore_exception .
          APPEND VALUE #(  type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
          LOOP AT lt_defectnr INTO data(ls_def_no_mail_2).
            MESSAGE w018 WITH ls_def_no_mail_2-defect_nr INTO lv_msg.                 "No e-mail sent for Defect Nr.: &1.
            APPEND VALUE #( type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
          ENDLOOP.
          mt_defects = FILTER #( mt_defects EXCEPT IN lt_defectnr WHERE defect_nr = defect_nr ).
      ENDTRY.

    ENDLOOP.

    IF lines( mt_defects ) GT 0.
      LOOP AT mt_defects INTO DATA(ls_def) GROUP BY ( lgtyp = ls_def-lgtyp
                                                      defcat = ls_def-defcat )
                                           INTO DATA(lgtyp_grp) .
        MESSAGE w017 WITH lgtyp_grp-lgtyp lgtyp_grp-defcat INTO lv_msg.            "No e-mail list for LGTYP: &1 DEFCAT: &2.
        APPEND VALUE #( type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        LOOP AT GROUP lgtyp_grp INTO DATA(ls_lgtyp_member).
          MESSAGE w018 WITH ls_lgtyp_member-defect_nr INTO lv_msg.                 "No e-mail sent for Defect Nr.: &1.
          APPEND VALUE #( type = sy-msgty id = sy-msgid number = sy-msgno message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_bapiret2.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.        "send_emails
ENDCLASS.
