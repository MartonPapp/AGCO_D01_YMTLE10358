*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Maintenance for e-mail lists
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*

CLASS lcl_report DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES: tty_lgnum_rng  TYPE RANGE OF ymtlt_email_lst-lgnum,
           tty_lgtyp_rng  TYPE RANGE OF ymtlt_email_lst-lgtyp,
           tty_defcat_rng TYPE RANGE OF ymtlt_email_lst-defcat.

    METHODS: constructor IMPORTING it_lgnum_rng  TYPE tty_lgnum_rng
                                   it_lgtyp_rng  TYPE tty_lgtyp_rng
                                   it_defcat_rng TYPE tty_defcat_rng.
    METHODS: start_of_selection.
  PRIVATE SECTION.
    DATA: mt_lgnum_rng  TYPE tty_lgnum_rng,
          mt_lgtyp_rng  TYPE tty_lgtyp_rng,
          mt_defcat_rng TYPE tty_defcat_rng.
    METHODS: display.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.
  METHOD constructor.
    mt_lgnum_rng = it_lgnum_rng.
    mt_lgtyp_rng = it_lgtyp_rng.
    mt_defcat_rng = it_defcat_rng.
  ENDMETHOD.          "constructor

  METHOD start_of_selection.
    me->display( ).
  ENDMETHOD.          "start_of_selection

  METHOD display.
    DATA: lt_sellist TYPE TABLE OF vimsellist.

    IF mt_lgnum_rng IS NOT INITIAL.
      CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
        EXPORTING
          fieldname          = 'LGNUM'    " Name of the field for which the Rangetab applies
          append_conjunction = 'AND'    " Conjunction for extending the passed SELLIST
        TABLES
          sellist            = lt_sellist    " Results table
          rangetab           = mt_lgnum_rng.    " Range table
    ENDIF.

    IF mt_lgtyp_rng IS NOT INITIAL.
      CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
        EXPORTING
          fieldname          = 'LGTYP'    " Name of the field for which the Rangetab applies
          append_conjunction = 'AND'    " Conjunction for extending the passed SELLIST
        TABLES
          sellist            = lt_sellist    " Results table
          rangetab           = mt_lgtyp_rng.    " Range table
    ENDIF.

    IF mt_defcat_rng IS NOT INITIAL.
      CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
        EXPORTING
          fieldname          = 'DEFCAT'    " Name of the field for which the Rangetab applies
          append_conjunction = 'AND'    " Conjunction for extending the passed SELLIST
        TABLES
          sellist            = lt_sellist    " Results table
          rangetab           = mt_defcat_rng.    " Range table
    ENDIF.

    CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
      EXPORTING
        viewcluster_name             = 'YMTLE10358VC_EMAIL_LIST'    " View Cluster Name
        maintenance_action           = 'S'    " Action (Display/Change/Transport: S/U/T/C)
        show_selection_popup         = ' '    " Flag: Display Selection Conditions Dialog Box
        no_warning_for_clientindep   = ''    " Flag: No Warning for Cross-Client Objects
      TABLES
        dba_sellist                  = lt_sellist    " Selection Conditions Only for Initial Object
*       dba_sellist_cluster          =     " Selection Conditions for Any Objects
*       excl_cua_funct_all_objects   =     " GUI Functions to be Deactivated for All Objects
*       excl_cua_funct_cluster       =     " GUI Functions to be Deactivated for Any Objects
*       dpl_sellist_for_start_object =     " Initial Object Display Selections
      EXCEPTIONS
        client_reference             = 1
        foreign_lock                 = 2
        viewcluster_not_found        = 3
        viewcluster_is_inconsistent  = 4
        missing_generated_function   = 5
        no_upd_auth                  = 6
        no_show_auth                 = 7
        object_not_found             = 8
        no_tvdir_entry               = 9
        no_clientindep_auth          = 10
        invalid_action               = 11
        saving_correction_failed     = 12
        system_failure               = 13
        unknown_field_in_dba_sellist = 14
        missing_corr_number          = 15
        OTHERS                       = 16.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.          "display
ENDCLASS.
