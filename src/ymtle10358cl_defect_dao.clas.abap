CLASS ymtle10358cl_defect_dao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES ymtle10358i_defect_dao .

    ALIASES save_defect
      FOR ymtle10358i_defect_dao~save_defect .

    ALIASES save_defects_from_table
      FOR ymtle10358i_defect_dao~save_defects_from_table.

    ALIASES user_data_get
      FOR ymtle10358i_defect_dao~user_data_get .

    ALIASES enqueue_number_range
      FOR ymtle10358i_defect_dao~enqueue_number_range.

    ALIASES dequeue_number_range
      FOR ymtle10358i_defect_dao~dequeue_number_range.

    ALIASES get_defect_id
      FOR ymtle10358i_defect_dao~get_defect_id.

    ALIASES get_defect_by_id
      FOR ymtle10358i_defect_dao~get_defect_by_id.

    ALIASES get_defects
      FOR ymtle10358i_defect_dao~get_defects_by_category.

    ALIASES get_defects_by_status
      FOR ymtle10358i_defect_dao~get_defects_by_status.

    ALIASES get_email_lst
      FOR ymtle10358i_defect_dao~get_email_lst.

    ALIASES get_recipients
      FOR ymtle10358i_defect_dao~get_recipients.

    ALIASES get_recipients_by_id
      FOR ymtle10358i_defect_dao~get_recipients_by_id.

    ALIASES user_get_addsmtp
      FOR ymtle10358i_defect_dao~user_get_addsmtp.

    ALIASES bal_log_create
      FOR ymtle10358i_defect_dao~bal_log_create.

    ALIASES bal_log_msg_add
      FOR ymtle10358i_defect_dao~bal_log_msg_add.

    ALIASES bal_log_msg_add_free_text
      FOR ymtle10358i_defect_dao~bal_log_msg_add_free_text.

    ALIASES bal_dsp_profile_no_tree_get
      FOR  ymtle10358i_defect_dao~bal_dsp_profile_no_tree_get.

    ALIASES bal_dsp_log_textform
      FOR ymtle10358i_defect_dao~bal_dsp_log_textform.

    ALIASES bal_dsp_log_display
      FOR ymtle10358i_defect_dao~bal_dsp_log_display.

    ALIASES get_domain_value
      FOR ymtle10358i_defect_dao~get_domain_value.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_msg TYPE string ##NEEDED.
ENDCLASS.



CLASS YMTLE10358CL_DEFECT_DAO IMPLEMENTATION.


  METHOD ymtle10358i_defect_dao~bal_dsp_log_display.
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
    CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
      EXPORTING
        i_s_display_profile  = is_display_profile    " Display Profile
        i_t_log_handle       = it_log_handle    " Restrict display by log handle
*       i_t_msg_handle       =     " Restrict display by message handle
*       i_s_log_filter       =     " Restrict display by log filter
*       i_s_msg_filter       =     " Restrict display by message filter
*       i_t_log_context_filter =     " Restrict display by log context filter
*       i_t_msg_context_filter =     " Restrict display by message context filter
*       i_amodal             = SPACE    " Display amodally in new session
*       i_srt_by_timstmp     = SPACE    " Sort Logs by Timestamp ('X') or Log Number (SPACE)
*      IMPORTING
*       e_s_exit_command     =     " Application Log: Key confirmed by user at end
      EXCEPTIONS
        profile_inconsistent = 1
        internal_error       = 2
        no_data_available    = 3
        no_authority         = 4
        OTHERS               = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.        "bal_dsp_log_display


  METHOD ymtle10358i_defect_dao~bal_dsp_log_textform.
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
    CALL FUNCTION 'BAL_DSP_LOG_TEXTFORM'
      EXPORTING
        i_log_handle   = iv_log_handle    " Application Log: Log Handle
        it_log_handle  = it_log_handle    " Application Log: Log Handle Table
      IMPORTING
        e_spool_number = ev_spool_number   " Number of Generated Spool Request
      EXCEPTIONS
        log_not_found  = 1
        print_error    = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.        "bal_dsp_log_textform


  METHOD ymtle10358i_defect_dao~bal_dsp_profile_no_tree_get.
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
    CALL FUNCTION 'BAL_DSP_PROFILE_NO_TREE_GET'
      IMPORTING
        e_s_display_profile = es_display_profile. " Display Profile
  ENDMETHOD.        "bal_dsp_profile_no_tree_get


  METHOD ymtle10358i_defect_dao~bal_log_create.
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
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = is_bal_s_log   " Log header data
      IMPORTING
        e_log_handle            = ev_log_handle   " Log handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "bal_log_create


  METHOD bal_log_msg_add.
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
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = iv_log_handle    " Log handle
        i_s_msg          = is_s_msg         " Notification data
      IMPORTING
        e_msg_was_logged = ev_msg_was_logged    " Message collected
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "bal_log_msg_add


  METHOD ymtle10358i_defect_dao~bal_log_msg_add_free_text.
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
    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
      EXPORTING
        i_log_handle     = iv_log_handle    " Log handle
        i_msgty          = iv_msgty    " Message type (A, E, W, I, S)
        i_text           = iv_text    " Message data
      IMPORTING
        e_msg_was_logged = ev_msg_was_logged   " Message collected
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.        "bal_log_msg_add_free_text


  METHOD dequeue_number_range.
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
    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = iv_object    " Name of number range object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.          "dequeue_number_range


  METHOD enqueue_number_range.
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
    CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
      EXPORTING
        object           = iv_object    " Name of number range object
      EXCEPTIONS
        foreign_lock     = 1
        object_not_found = 2
        system_failure   = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.          "enqueue_number_range


  METHOD ymtle10358i_defect_dao~get_defects_by_category.
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
    SELECT * FROM ymtlt_defect
        WHERE defcat EQ @iv_defcat
        INTO TABLE @rt_defects.
    IF sy-subrc NE 0.
      MESSAGE e009 WITH iv_defcat INTO mv_msg.   "No defects found for defcat: &1.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "get_defects_by_category


  METHOD ymtle10358i_defect_dao~get_defects_by_status.
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
    SELECT * FROM ymtlt_defect
        WHERE status EQ @iv_status
        INTO TABLE @rt_defects.
    IF sy-subrc NE 0.
      MESSAGE e008 WITH iv_status INTO mv_msg.   "No defects found for status: &1.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "get_defects_by_status


  METHOD ymtle10358i_defect_dao~get_defect_by_id.
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
    SELECT * FROM ymtlt_defect
        WHERE defect_nr EQ @iv_defect_nr
        INTO @rs_defect
        UP TO 1 ROWS.
    ENDSELECT.
    IF sy-subrc NE 0.
      MESSAGE e010 WITH iv_defect_nr INTO mv_msg.  "No defects found for defect_nr: &1.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "get_defect_by_id


  METHOD get_defect_id.
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
    DATA: lv_returncode TYPE char1  ##NEEDED.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = iv_range_nr    " Number range number
        object                  = iv_object      " Name of number range object
      IMPORTING
        number                  = rv_defect_id   " free number
        returncode              = lv_returncode   " Return code
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.      "get_defect_id


  METHOD get_domain_value.
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
    CALL FUNCTION 'DOMAIN_VALUE_GET'
      EXPORTING
        i_domname  = iv_domname    " Domain Name
        i_domvalue = iv_domvalue    " Domain Constant
      IMPORTING
        e_ddtext   = rv_ddtext
      EXCEPTIONS
        not_exist  = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.        "get_domain_value


  METHOD get_email_lst.
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
    SELECT * FROM ymtlt_email_lst
        WHERE lgnum IN @it_lgnum
          AND lgtyp IN @it_lgtyp
          AND defcat IN @it_defcat
          INTO TABLE @rt_email_lst.
    IF sy-subrc NE 0.
      MESSAGE w005 INTO mv_msg.           "No appropriate e-mail lists found!
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "get_email_lst


  METHOD get_recipients.
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
    SELECT smtp_addr FROM ymtlt_email_rec AS r
        INNER JOIN ymtlt_email_lst AS l ON
            l~email_list_id = r~email_list_id
        WHERE l~lgnum EQ @is_parameters-lgnum
          AND l~lgtyp EQ @is_parameters-lgtyp
          AND l~defcat EQ @is_parameters-defcat
        INTO TABLE @rt_recipients.
    IF sy-subrc NE 0.
      MESSAGE e006 WITH is_parameters-lgnum is_parameters-lgtyp is_parameters-defcat INTO mv_msg.  "No recipients found for lgnum: &1, lgtyp: &2, defcat: &3.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "get_recipients


  METHOD get_recipients_by_id.
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
    SELECT smtp_addr FROM ymtlt_email_rec
        WHERE email_list_id EQ @iv_email_list_id
        INTO TABLE @rt_recipients.
    IF sy-subrc NE 0.
      MESSAGE w007 WITH iv_email_list_id INTO mv_msg. " No recipients found for e-mail list ID: &1.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.            "get_recipients_by_id


  METHOD save_defect.
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
    MODIFY ymtlt_defect FROM is_defect.
    IF sy-subrc NE 0.
      ROLLBACK WORK.
      MESSAGE e004 INTO mv_msg.                           "YMTLT_DEFECT table was not updated!
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ELSE.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.              "save_defect


  METHOD ymtle10358i_defect_dao~save_defects_from_table.
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
    MODIFY ymtlt_defect FROM TABLE it_defects.
    IF sy-subrc NE 0.
      ROLLBACK WORK.
      MESSAGE e004 INTO mv_msg.                           "YMTLT_DEFECT table was not updated!
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ELSE.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.              "save_defects_from_table


  METHOD user_data_get.
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
    DATA lt_xuser TYPE TABLE OF lrf_wkqu.
    CALL FUNCTION 'L_USER_DATA_GET'
      EXPORTING
        i_uname        = iv_uname
      TABLES
        t_xuser        = lt_xuser
      EXCEPTIONS
        no_entry_found = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
    TRY.
        rt_xuser = CORRESPONDING #( lt_xuser ).
      CATCH cx_sy_itab_duplicate_key INTO DATA(lv_msg) ##NEEDED.
        RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDTRY.
  ENDMETHOD.              "user_data_get


  METHOD user_get_addsmtp.
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
    DATA: lt_return  TYPE bapiret2_t,
          lt_addsmtp TYPE addrt_bapiadsmtp.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username = iv_username    " User Name
      TABLES
        return   = lt_return    " Return Structure
        addsmtp  = lt_addsmtp.    " E-Mail Addresses BAPI Structure

    rt_recipients = VALUE #( FOR ls_addsmtp IN lt_addsmtp
                                ( ls_addsmtp-e_mail ) ).
  ENDMETHOD.            "user_get_addsmtp
ENDCLASS.
