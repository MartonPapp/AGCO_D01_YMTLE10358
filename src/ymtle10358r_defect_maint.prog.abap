*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Defect Maintenance Program
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
REPORT ymtle10358r_defect_maint.

INCLUDE ymtle10358r_defect_maint_top.
INCLUDE ymtle10358r_defect_maint_s01.

CLASS lcl_report DEFINITION FINAL.
  PUBLIC SECTION.
    CONSTANTS: gc_u    TYPE c VALUE 'U',
               gc_view TYPE dd02v-tabname VALUE 'YMTLV_DEFECT'.
    METHODS start_of_selection.
  PRIVATE SECTION.
    METHODS add_rangetab
      RETURNING VALUE(rt_sellist) TYPE scprvimsellist.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.
  METHOD start_of_selection.
    DATA(lt_sellist) = me->add_rangetab( ).

    CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
      EXPORTING
        action                       = gc_u
        view_name                    = gc_view    " Name of the View/Table to be Edited
      TABLES
        dba_sellist                  = lt_sellist    " Database Access Selection Conditions
      EXCEPTIONS
        client_reference             = 1
        foreign_lock                 = 2
        invalid_action               = 3
        no_clientindependent_auth    = 4
        no_database_function         = 5
        no_editor_function           = 6
        no_show_auth                 = 7
        no_tvdir_entry               = 8
        no_upd_auth                  = 9
        only_show_allowed            = 10
        system_failure               = 11
        unknown_field_in_dba_sellist = 12
        view_not_found               = 13
        maintenance_prohibited       = 14
        OTHERS                       = 15.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.                  "start_of_selection

  METHOD add_rangetab.
    CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
      EXPORTING
        fieldname          = 'DEFCAT'   " Name of the field for which the Rangetab applies
        append_conjunction = 'AND'      " Conjunction for extending the passed SELLIST
      TABLES
        sellist            = rt_sellist   " Results table
        rangetab           = s_dfcat.  " Range table

    CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
      EXPORTING
        fieldname          = 'LGNUM'   " Name of the field for which the Rangetab applies
        append_conjunction = 'AND'      " Conjunction for extending the passed SELLIST
      TABLES
        sellist            = rt_sellist   " Results table
        rangetab           = s_lgnum.  " Range table

    CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
      EXPORTING
        fieldname          = 'LGTYP'   " Name of the field for which the Rangetab applies
        append_conjunction = 'AND'      " Conjunction for extending the passed SELLIST
      TABLES
        sellist            = rt_sellist   " Results table
        rangetab           = s_lgtyp.  " Range table

    CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
      EXPORTING
        fieldname          = 'STATUS'   " Name of the field for which the Rangetab applies
        append_conjunction = 'AND'      " Conjunction for extending the passed SELLIST
      TABLES
        sellist            = rt_sellist   " Results table
        rangetab           = s_stat.    " Range table
  ENDMETHOD.                  "add_rangetab
ENDCLASS.

START-OF-SELECTION.

  NEW lcl_report( )->start_of_selection( ).
