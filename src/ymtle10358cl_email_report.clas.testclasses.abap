*"* use this source file for your ABAP unit test classes
CLASS lcl_defect_dao_injector DEFINITION DEFERRED.

CLASS ltd_defect_dao DEFINITION FOR TESTING
    FRIENDS lcl_defect_dao_injector.
  PUBLIC SECTION.
    INTERFACES ymtle10358i_defect_dao PARTIALLY IMPLEMENTED.
  PRIVATE SECTION.
    CLASS-DATA: gt_email_lst TYPE tty_email_lst,
                gt_email_rec TYPE tty_email_rec,
*                    gt_recipients type BCSY_SMTPA,
                gt_defects   TYPE ymtle10358tt_defect.
ENDCLASS.

CLASS ltd_defect_dao IMPLEMENTATION.
  METHOD ymtle10358i_defect_dao~save_defects_from_table ##NEEDED.

  ENDMETHOD.

  METHOD ymtle10358i_defect_dao~get_defects_by_status.
    rt_defects = VALUE #( FOR ls_defect IN gt_defects WHERE ( status = iv_status ) ( ls_defect ) ).
  ENDMETHOD.

  METHOD ymtle10358i_defect_dao~get_recipients.
    DATA(ls_email_lst) = VALUE ymtlt_email_lst( gt_email_lst[ lgnum = is_parameters-lgnum
                                                             lgtyp = is_parameters-lgtyp
                                                             defcat = is_parameters-defcat ] DEFAULT '' ).
    rt_recipients = VALUE #( FOR ls_rec IN gt_email_rec WHERE ( email_list_id = ls_email_lst-email_list_id )
                                ( ls_rec-smtp_addr ) ) .
  ENDMETHOD.

  METHOD ymtle10358i_defect_dao~get_email_lst.
    rt_email_lst = VALUE #( FOR ls_lst IN  gt_email_lst
                                WHERE ( lgnum IN it_lgnum
                                    AND lgtyp IN it_lgtyp
                                    AND defcat IN it_defcat )
                                ( ls_lst ) ).
  ENDMETHOD.

  METHOD ymtle10358i_defect_dao~get_recipients_by_id.
    rt_recipients = VALUE #( FOR ls_rec IN gt_email_rec WHERE ( email_list_id = iv_email_list_id )
                                ( ls_rec-smtp_addr ) ).
  ENDMETHOD.

  METHOD ymtle10358i_defect_dao~get_domain_value.
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
                            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_msg) ##NEEDED.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS ltd_bcs_reduced DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES ymtle10358i_bcs_reduced.
ENDCLASS.

CLASS ltd_bcs_reduced IMPLEMENTATION.
  METHOD ymtle10358i_bcs_reduced~add_recipient ##NEEDED.

  ENDMETHOD.

  METHOD ymtle10358i_bcs_reduced~set_document ##NEEDED.

  ENDMETHOD.

  METHOD ymtle10358i_bcs_reduced~send.
    rv_result = abap_true.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_defect_dao_injector DEFINITION FOR TESTING.
  PUBLIC SECTION.
    CLASS-METHODS set_defects IMPORTING it_defects TYPE ymtle10358tt_defect.
    CLASS-METHODS set_email_lst IMPORTING it_email_lst TYPE tty_email_lst.
    CLASS-METHODS set_email_rec IMPORTING it_email_rec TYPE tty_email_rec.

ENDCLASS.

CLASS lcl_defect_dao_injector IMPLEMENTATION.

  METHOD set_defects.
    ltd_defect_dao=>gt_defects = it_defects.
  ENDMETHOD.

  METHOD set_email_lst.
    ltd_defect_dao=>gt_email_lst = it_email_lst.
  ENDMETHOD.

  METHOD set_email_rec.
    ltd_defect_dao=>gt_email_rec = it_email_rec.
  ENDMETHOD.

ENDCLASS.

CLASS ltc_email_report DEFINITION FOR TESTING
    RISK LEVEL HARMLESS
    DURATION SHORT.
  PRIVATE SECTION.
    DATA: mo_cut TYPE REF TO ymtle10358cl_email_report.

    METHODS setup.
    METHODS assert_data CHANGING ct_act TYPE bcsy_text
                                 ct_exp TYPE bcsy_text.


    METHODS one_dfct_one_rec FOR TESTING.
    METHODS mltp_dfct_one_rec FOR TESTING.
    METHODS dif_def_types FOR TESTING.
    METHODS dif_lgtyp_same_defcat FOR TESTING.
    METHODS mltp_dfct_email_stat FOR TESTING.
*    methods no_list_for_lgtyp for testing.

ENDCLASS.

CLASS ltc_email_report IMPLEMENTATION.

  METHOD setup.
    "Given
    ymtle10358cl_dao_factory=>set_defect_dao_instance( NEW ltd_defect_dao( ) ).
    ymtle10358cl_dao_factory=>set_bcs_instance( NEW ltd_bcs_reduced( ) ).
  ENDMETHOD.

  METHOD assert_data.
    cl_abap_unit_assert=>assert_equals( act = ct_act
                                        exp = ct_exp ).

  ENDMETHOD.

  METHOD one_dfct_one_rec.
    "given
    DATA: lt_act TYPE bcsy_text.
    DATA: lt_exp TYPE bcsy_text.

    TRY.
        mo_cut = NEW #( ).
      CATCH ycx_agco_globcore_exception  ##NO_HANDLER.
    ENDTRY.

    DATA(lt_defects) = VALUE ymtle10358tt_defect( ( defect_nr = '0000000001'
                                                    credat = '20220411'
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '101'
                                                    lgpla = '1010201004'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    email_new = ''
                                                    email_open = ''
                                                    email_closed = ''
                                                    closed_date = 00000000
                                                    closed_time = 000000  ) ).

    DATA(lt_email_lst) = VALUE tty_email_lst( ( lgnum = 'ZS1' lgtyp = '101' defcat = 'R' email_list_id = '0001' )
                                              ( lgnum = 'ZS1' lgtyp = '101' defcat = 'L' email_list_id = '0001' )
                                               ).
    DATA(lt_email_rec) = VALUE tty_email_rec( ( email_list_id = '0001' smtp_addr = 'john.dow@alma.com' ) ).

    lcl_defect_dao_injector=>set_defects( lt_defects ).

    lcl_defect_dao_injector=>set_email_lst( lt_email_lst ).
    lcl_defect_dao_injector=>set_email_rec( lt_email_rec ).
    "when
    TRY.
        lt_act = mo_cut->send_emails( 'NEW' ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.
    "then
    lt_exp = VALUE #( ( line = 'john.dow@alma.com' )
                      ( line = '0000000001 | 11.04.2022 | 00:00:00 | HUNMCP | R | ZS1 | 101 | 1010201004 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = ymtle10358cl_email_report=>gv_email_separator )
                         ).

    me->assert_data( CHANGING ct_act = lt_act
                              ct_exp = lt_exp ).
  ENDMETHOD.

  METHOD mltp_dfct_one_rec.
    "given
    DATA: lt_act TYPE bcsy_text.
    DATA: lt_exp TYPE bcsy_text.

    TRY.
        mo_cut = NEW #( ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.

    DATA(lt_defects) = VALUE ymtle10358tt_defect( ( defect_nr = '0000000001'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '101'
                                                    lgpla = '1010201004'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    email_new = ''
                                                    email_open = ''
                                                    email_closed = ''
                                                    closed_date = 00000000
                                                    closed_time = 000000  )
                                                  ( defect_nr = '0000000002'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '101'
                                                    lgpla = '1010000001'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    email_new = ''
                                                    email_open = ''
                                                    email_closed = ''
                                                    closed_date = 00000000
                                                    closed_time = 000000 ) ).

    DATA(lt_email_lst) = VALUE tty_email_lst( ( lgnum = 'ZS1' lgtyp = '101' defcat = 'R' email_list_id = '0001' )
                                              ( lgnum = 'ZS1' lgtyp = '101' defcat = 'L' email_list_id = '0001' )
                                               ).
    DATA(lt_email_rec) = VALUE tty_email_rec( ( email_list_id = '0001' smtp_addr = 'john.dow@alma.com' )
                                              ( email_list_id = '0002' smtp_addr = 'xy.zc@alma.com' ) ).

    lcl_defect_dao_injector=>set_defects( lt_defects ).

    lcl_defect_dao_injector=>set_email_lst( lt_email_lst ).
    lcl_defect_dao_injector=>set_email_rec( lt_email_rec ).
    "when
    TRY.
        lt_act = mo_cut->send_emails( 'NEW' ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.
    "then
    lt_exp = VALUE #( ( line = 'john.dow@alma.com' )
                      ( line = '0000000001 | 00.00.0000 | 00:00:00 | HUNMCP | R | ZS1 | 101 | 1010201004 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = '0000000002 | 00.00.0000 | 00:00:00 | HUNMCP | R | ZS1 | 101 | 1010000001 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = ymtle10358cl_email_report=>gv_email_separator )
                        ).

    me->assert_data( CHANGING ct_act = lt_act
                              ct_exp = lt_exp ).
  ENDMETHOD.

  METHOD dif_def_types.
    "given
    DATA: lt_act TYPE bcsy_text.
    DATA: lt_exp TYPE bcsy_text.

    TRY.
        mo_cut = NEW #( ).
      CATCH ycx_agco_globcore_exception  ##NO_HANDLER.
    ENDTRY.

    DATA(lt_defects) = VALUE ymtle10358tt_defect( ( defect_nr = '0000000001'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '101'
                                                    lgpla = '1010201004'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    closed_date = 00000000
                                                    closed_time = 000000  )
                                                  ( defect_nr = '0000000002'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'L'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '346'
                                                    lgpla = '3460101001'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    closed_date = 00000000
                                                    closed_time = 000000 ) ).

    DATA(lt_email_lst) = VALUE tty_email_lst( ( lgnum = 'ZS1' lgtyp = '101' defcat = 'R' email_list_id = '0001' )
                                              ( lgnum = 'ZS1' lgtyp = '346' defcat = 'L' email_list_id = '0002' )
                                               ).
    DATA(lt_email_rec) = VALUE tty_email_rec( ( email_list_id = '0001' smtp_addr = 'john.dow@alma.com' )
                                              ( email_list_id = '0002' smtp_addr = 'xy.zc@alma.com' ) ).

    lcl_defect_dao_injector=>set_defects( lt_defects ).

    lcl_defect_dao_injector=>set_email_lst( lt_email_lst ).
    lcl_defect_dao_injector=>set_email_rec( lt_email_rec ).
    "when
    TRY.
        lt_act = mo_cut->send_emails( 'NEW' ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.
    "then
    lt_exp = VALUE #( ( line = 'john.dow@alma.com' )
                      ( line = '0000000001 | 00.00.0000 | 00:00:00 | HUNMCP | R | ZS1 | 101 | 1010201004 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = ymtle10358cl_email_report=>gv_email_separator )
                      ( line = 'xy.zc@alma.com' )
                      ( line = '0000000002 | 00.00.0000 | 00:00:00 | HUNMCP | L | ZS1 | 346 | 3460101001 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = ymtle10358cl_email_report=>gv_email_separator )
                        ).

    me->assert_data( CHANGING ct_act = lt_act
                              ct_exp = lt_exp ).
  ENDMETHOD.

  METHOD dif_lgtyp_same_defcat.
    "given
    DATA: lt_act TYPE bcsy_text.
    DATA: lt_exp TYPE bcsy_text.

    TRY.
        mo_cut = NEW #( ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.

    DATA(lt_defects) = VALUE ymtle10358tt_defect( ( defect_nr = '0000000001'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '344'
                                                    lgpla = '3442210001'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    closed_date = 00000000
                                                    closed_time = 000000  )
                                                  ( defect_nr = '0000000002'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '345'
                                                    lgpla = '3450101001'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    closed_date = 00000000
                                                    closed_time = 000000 ) ).

    DATA(lt_email_lst) = VALUE tty_email_lst( ( lgnum = 'ZS1' lgtyp = '344' defcat = 'R' email_list_id = '0001' )
                                              ( lgnum = 'ZS1' lgtyp = '345' defcat = 'R' email_list_id = '0001' )
                                               ).
    DATA(lt_email_rec) = VALUE tty_email_rec( ( email_list_id = '0001' smtp_addr = 'john.dow@alma.com' )
                                              ( email_list_id = '0001' smtp_addr = 'xy.zc@alma.com' ) ).

    lcl_defect_dao_injector=>set_defects( lt_defects ).

    lcl_defect_dao_injector=>set_email_lst( lt_email_lst ).
    lcl_defect_dao_injector=>set_email_rec( lt_email_rec ).
    "when
    TRY.
        lt_act = mo_cut->send_emails( 'NEW' ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.
    "then
    lt_exp = VALUE #( ( line = 'john.dow@alma.com' )
                      ( line = 'xy.zc@alma.com' )
                      ( line = '0000000001 | 00.00.0000 | 00:00:00 | HUNMCP | R | ZS1 | 344 | 3442210001 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = '0000000002 | 00.00.0000 | 00:00:00 | HUNMCP | R | ZS1 | 345 | 3450101001 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = ymtle10358cl_email_report=>gv_email_separator )
                        ).

    me->assert_data( CHANGING ct_act = lt_act
                              ct_exp = lt_exp ).
  ENDMETHOD.

  METHOD mltp_dfct_email_stat.
    "given
    DATA: lt_act TYPE bcsy_text.
    DATA: lt_exp TYPE bcsy_text.

    TRY.
        mo_cut = NEW #( ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.

    DATA(lt_defects) = VALUE ymtle10358tt_defect( ( defect_nr = '0000000001'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '101'
                                                    lgpla = '1010201004'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    email_new = ''
                                                    email_open = ''
                                                    email_closed = ''
                                                    closed_date = 00000000
                                                    closed_time = 000000  )
                                                  ( defect_nr = '0000000002'
                                                    credat = 00000000
                                                    cretim = 000000
                                                    ernam = 'HUNMCP'
                                                    defcat = 'R'
                                                    lgnum = 'ZS1'
                                                    lgtyp = '101'
                                                    lgpla = '1010000001'
                                                    matnr = 'matnr'
                                                    status = 'NEW'
                                                    notes = 'notes'
                                                    closedby = 'closedby'
                                                    email_new = 'X'
                                                    email_open = ''
                                                    email_closed = ''
                                                    closed_date = 00000000
                                                    closed_time = 000000 ) ).

    DATA(lt_email_lst) = VALUE tty_email_lst( ( lgnum = 'ZS1' lgtyp = '101' defcat = 'R' email_list_id = '0001' )
                                              ( lgnum = 'ZS1' lgtyp = '101' defcat = 'L' email_list_id = '0001' )
                                               ).
    DATA(lt_email_rec) = VALUE tty_email_rec( ( email_list_id = '0001' smtp_addr = 'john.dow@alma.com' )
                                              ( email_list_id = '0002' smtp_addr = 'xy.zc@alma.com' ) ).

    lcl_defect_dao_injector=>set_defects( lt_defects ).

    lcl_defect_dao_injector=>set_email_lst( lt_email_lst ).
    lcl_defect_dao_injector=>set_email_rec( lt_email_rec ).
    "when
    TRY.
        lt_act = mo_cut->send_emails( 'NEW' ).
      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
    ENDTRY.
    "then
    lt_exp = VALUE #( ( line = 'john.dow@alma.com' )
                      ( line = '0000000001 | 00.00.0000 | 00:00:00 | HUNMCP | R | ZS1 | 101 | 1010201004 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
                      ( line = ymtle10358cl_email_report=>gv_email_separator )
                        ).

    me->assert_data( CHANGING ct_act = lt_act
                              ct_exp = lt_exp ).
  ENDMETHOD.

*  METHOD no_list_for_lgtyp.
*    "given
*    DATA: lt_act TYPE bcsy_text.
*    DATA: lt_exp TYPE bcsy_text.
*
*    TRY.
*        mo_cut = NEW #( ).
*      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
*    ENDTRY.
*
*    DATA(lt_defects) = VALUE ymtle10358tt_defect( ( defect_nr = '0000000001'
*                                                    credat = 00000000
*                                                    cretim = 000000
*                                                    ernam = 'HUNMCP'
*                                                    defcat = 'R'
*                                                    lgnum = 'ZS1'
*                                                    lgtyp = '101'
*                                                    lgpla = '1010201004'
*                                                    matnr = 'matnr'
*                                                    status = 'NEW'
*                                                    notes = 'notes'
*                                                    closedby = 'closedby'
*                                                    email_new = ''
*                                                    email_open = ''
*                                                    email_closed = ''
*                                                    closed_date = 00000000
*                                                    closed_time = 000000  )
*                                                  ( defect_nr = '0000000002'
*                                                    credat = 00000000
*                                                    cretim = 000000
*                                                    ernam = 'HUNMCP'
*                                                    defcat = 'R'
*                                                    lgnum = 'ZS1'
*                                                    lgtyp = '102'
*                                                    lgpla = '1010000001'
*                                                    matnr = 'matnr'
*                                                    status = 'NEW'
*                                                    notes = 'notes'
*                                                    closedby = 'closedby'
*                                                    email_new = ''
*                                                    email_open = ''
*                                                    email_closed = ''
*                                                    closed_date = 00000000
*                                                    closed_time = 000000 ) ).
*
*    DATA(lt_email_lst) = VALUE tty_email_lst( ( lgnum = 'ZS1' lgtyp = '101' defcat = 'R' email_list_id = '0001' )
*                                              ( lgnum = 'ZS1' lgtyp = '101' defcat = 'L' email_list_id = '0001' ) ).
*    DATA(lt_email_rec) = VALUE tty_email_rec( ( email_list_id = '0001' smtp_addr = 'john.dow@alma.com' )
*                                              ( email_list_id = '0002' smtp_addr = 'xy.zc@alma.com' ) ).
*
*    lcl_defect_dao_injector=>set_defects( lt_defects ).
*
*    lcl_defect_dao_injector=>set_email_lst( lt_email_lst ).
*    lcl_defect_dao_injector=>set_email_rec( lt_email_rec ).
*    "when
*    TRY.
*        lt_act = mo_cut->send_emails( 'NEW' ).
*      CATCH ycx_agco_globcore_exception ##NO_HANDLER.
*    ENDTRY.
*    "then
*    lt_exp = VALUE #( ( line = 'john.dow@alma.com' )
*                      ( line = '0000000001 | 00.00.0000 | 00:00:00 | HUNMCP | R | ZS1 | 101 | 1010201004 | matnr | NEW | notes | closedby | 00.00.0000 | 00:00:00' )
*                      ( line = ymtle10358cl_email_report=>gv_email_separator )
*                      ( line = 'No e-mail list for LGTYP: 102.' )
*                      ( line = 'No e-mail sent for Defect Nr.: 0000000002.' )
*                        ).
*
*    me->assert_data( CHANGING ct_act = lt_act
*                              ct_exp = lt_exp ).
*  ENDMETHOD.

ENDCLASS.
