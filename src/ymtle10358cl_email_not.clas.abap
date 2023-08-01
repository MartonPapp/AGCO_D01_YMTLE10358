CLASS ymtle10358cl_email_not DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES ymtle10358i_email_notification.
    ALIASES handle_email_event FOR ymtle10358i_email_notification~handle_email_event.

    CONSTANTS: mc_ymtlt_defect TYPE tabname VALUE 'YMTLT_DEFECT'.

    METHODS constructor
      RAISING ycx_agco_globcore_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: gc_subject TYPE char50 VALUE 'MTL.E.10358 Warehouse Defect Notification' ##NO_TEXT.
    CONSTANTS: gc_attachment_subject TYPE char50 VALUE 'Defects'  ##NO_TEXT.
    DATA: mo_send_request TYPE REF TO ymtle10358i_bcs_reduced.
    DATA: mo_defect_dao TYPE REF TO ymtle10358i_defect_dao.
    DATA: mo_salv TYPE REF TO cl_salv_table.

    METHODS set_recipients
      IMPORTING it_recipients TYPE bcsy_smtpa
      RAISING   cx_bcs.
    METHODS build_document
      IMPORTING it_defects     TYPE ymtle10358tt_defect
      RETURNING VALUE(rt_text) TYPE bcsy_text
      RAISING   cx_bcs
                ycx_agco_globcore_exception.
    METHODS create_xlsx_from_itab
      IMPORTING VALUE(it_defects) TYPE ymtle10358tt_defect
      EXPORTING ev_size           TYPE i
      RETURNING VALUE(rt_solix)   TYPE solix_tab.
    METHODS build_html
      IMPORTING it_defects     TYPE ymtle10358tt_defect
      RETURNING VALUE(rt_html) TYPE soli_tab
      RAISING   ycx_agco_globcore_exception.
    METHODS build_return_value
      IMPORTING it_recipients    TYPE bcsy_smtpa
                it_text          TYPE bcsy_text
      RETURNING VALUE(rt_result) TYPE bcsy_text.
ENDCLASS.



CLASS YMTLE10358CL_EMAIL_NOT IMPLEMENTATION.


  METHOD build_document.
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
    DATA: lo_document TYPE REF TO cl_document_bcs.
    DATA: lt_html   TYPE soli_tab,
          lt_binary TYPE solix_tab,
          lv_size   TYPE i.

    lt_html = me->build_html( it_defects ).

    lo_document = cl_document_bcs=>create_document(
                                    i_type = 'HTM'
                                    i_text = lt_html
                                    i_subject = gc_subject ).

    lt_binary = me->create_xlsx_from_itab( EXPORTING it_defects = it_defects
                                           IMPORTING ev_size = lv_size ).

    lo_document->add_attachment( i_attachment_type = 'BIN'
                                 i_attachment_subject = |{ gc_attachment_subject }.XLSX|
                                 i_attachment_size = CONV so_obj_len( lv_size )
                                 i_att_content_hex = lt_binary ).

    mo_send_request->set_document( lo_document ).

*For testing and logging purposes
    rt_text = VALUE #( FOR ls_defect IN it_defects
                        ( |{ ls_defect-defect_nr } \| { ls_defect-credat DATE = ENVIRONMENT } \| { ls_defect-cretim TIME = ENVIRONMENT  } \| { ls_defect-ernam } | &&
                          |\| { ls_defect-defcat } \| { ls_defect-lgnum } \| { ls_defect-lgtyp } \| { ls_defect-lgpla } | &&
                          |\| { ls_defect-matnr } \| { ls_defect-status } \| { ls_defect-notes } \| { ls_defect-closedby } | &&
                          |\| { ls_defect-closed_date DATE = ENVIRONMENT } \| { ls_defect-closed_time TIME = ENVIRONMENT }| ) ).

  ENDMETHOD.        "build_document


  METHOD build_html.
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
    DATA: lt_html TYPE soli_tab.
    DATA: lv_value     TYPE so_text255,
          lv_value_tmp TYPE domvalue_l,
          lv_date      TYPE dats,
          lv_time      TYPE tims.

    lt_html = VALUE #( ( line = '<!DOCTYPE html>' )
                       ( line = '<html> <head> <style>' )
                       ( line = 'TABLE, TH, TD {')
                       ( line = 'BORDER: 1PX SOLID BLACK;')
                       ( line = 'BORDER-COLLAPSE: COLLAPSE; }' )
                       ( line = 'TH, TD { PADDING: 5PX; }' )
                       ( line = '</style> </head>' )
                       ( line = '<body>' )
                       ( line = '<h2>Defects:</h2>' )
                       ( line = '<table style="width:100%">' )     "style="width:100%
                        ( line = '<tr>' ) ).

*Populate HTML columns from Field list
    LOOP AT CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( mc_ymtlt_defect ) )->get_components( ) ASSIGNING FIELD-SYMBOL(<ls_comp>)
        WHERE name   NE 'MANDT'
        AND   name NE 'EMAIL_NEW'
        AND   name NE 'EMAIL_OPEN'
        AND   name NE 'EMAIL_CLOSED'.
      APPEND VALUE #( line = '<th>' && CAST cl_abap_elemdescr( <ls_comp>-type )->get_ddic_field( )-scrtext_m && '</th>' ) TO lt_html.
    ENDLOOP.

    lt_html = VALUE #( BASE lt_html
                        ( line = '</tr>' ) ).

*Populate HTML from the data

    LOOP AT it_defects ASSIGNING FIELD-SYMBOL(<ls_defect>).

      APPEND VALUE #( line = '<tr>' ) TO lt_html.
      LOOP AT CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( mc_ymtlt_defect ) )->get_components( ) ASSIGNING <ls_comp>
          WHERE name NE 'MANDT'
          AND   name NE 'EMAIL_NEW'
          AND   name NE 'EMAIL_OPEN'
          AND   name NE 'EMAIL_CLOSED'.
        ASSIGN COMPONENT <ls_comp>-name OF STRUCTURE <ls_defect> TO FIELD-SYMBOL(<ls_value>).
        CHECK sy-subrc = 0.

        IF <ls_comp>-name EQ 'DEFCAT'.
          WRITE <ls_value>  TO lv_value_tmp.
          CONDENSE lv_value_tmp.
          lv_value = mo_defect_dao->get_domain_value( EXPORTING iv_domname = 'YMTLE10358D_DEFCAT'
                                                                iv_domvalue = lv_value_tmp ).
        ELSEIF <ls_comp>-name EQ 'CREDAT'
        OR <ls_comp>-name EQ 'CLOSED_DATE'.
          lv_date =  <ls_value> .
          lv_value = |{ lv_date DATE = ENVIRONMENT } |.
        ELSEIF <ls_comp>-name EQ 'CRETIM'
        OR <ls_comp>-name EQ 'CLOSED_TIME'.
          lv_time = <ls_value>.
          lv_value = |{ lv_time TIME = ENVIRONMENT }|.
        ELSE.
          WRITE <ls_value> TO lv_value.
          CONDENSE lv_value.
        ENDIF.
        APPEND VALUE #( line = '<td>' && lv_value && '</th>' ) TO lt_html.
      ENDLOOP.
      APPEND VALUE #( line = '</tr>' ) TO lt_html.
    ENDLOOP.

    lt_html = VALUE #( BASE lt_html
                       ( line = '</table>')
                       ( line = '</body>' )
                       ( line = '</html>' ) ).

    rt_html = lt_html.
  ENDMETHOD.        "build_html


  METHOD build_return_value.
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
    rt_result = VALUE #( FOR ls_recipients IN it_recipients
                            ( CONV so_text255( ls_recipients ) ) ).

    APPEND LINES OF it_text TO rt_result.

  ENDMETHOD.        "build_return_value


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
    TRY.
        mo_send_request = ymtle10358cl_dao_factory=>get_bcs_instance( ). "cl_bcs=>create_persistent( ).
        mo_defect_dao = ymtle10358cl_dao_factory=>get_defect_dao_instance( ).
      CATCH cx_bcs INTO DATA(lx_bcs).
        RAISE EXCEPTION TYPE ycx_agco_globcore_exception
          EXPORTING
            msgty = lx_bcs->msgty
            msgid = lx_bcs->msgid
            msgno = lx_bcs->msgno
            msgv1 = lx_bcs->msgv1
            msgv2 = lx_bcs->msgv2
            msgv3 = lx_bcs->msgv3
            msgv4 = lx_bcs->msgv4.
    ENDTRY.
  ENDMETHOD.


  METHOD create_xlsx_from_itab.
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
    DATA(lt_defects) = CORRESPONDING ymtle10358tt_defect_email( it_defects ).

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = mo_salv
                                CHANGING t_table = lt_defects ).
      CATCH cx_salv_msg INTO DATA(lx_salv).
        MESSAGE lx_salv->get_text( ) TYPE 'E'.
        RETURN.
    ENDTRY.

    DATA(lv_xlsx) = mo_salv->to_xml( if_salv_bs_xml=>c_type_xlsx ).
    ev_size = xstrlen( lv_xlsx ).
    rt_solix = cl_document_bcs=>xstring_to_solix( lv_xlsx ).
  ENDMETHOD.            "create_xlsx_from_itab


  METHOD set_recipients.
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
    DATA: lo_recipients TYPE REF TO if_recipient_bcs.

    LOOP AT it_recipients INTO DATA(ls_recipient).
      lo_recipients = cl_cam_address_bcs=>create_internet_address( ls_recipient ).

      mo_send_request->add_recipient( io_recipient = lo_recipients ).
    ENDLOOP.
  ENDMETHOD.            "set_recipients


  METHOD ymtle10358i_email_notification~handle_email_event.
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
    TRY.
        "Set Recipients
        me->set_recipients( it_recipients ).
        "Build Document
        DATA(lt_text) = me->build_document( it_defects ).
        "Send e-mail
        IF mo_send_request->send(  ).
          rt_result = me->build_return_value( it_recipients = it_recipients
                                              it_text = lt_text ).
        ENDIF.
      CATCH cx_bcs INTO DATA(lx_bcs).
        RAISE EXCEPTION TYPE ycx_agco_globcore_exception
          EXPORTING
            msgty = lx_bcs->msgty
            msgid = lx_bcs->msgid
            msgno = lx_bcs->msgno
            msgv1 = lx_bcs->msgv1
            msgv2 = lx_bcs->msgv2
            msgv3 = lx_bcs->msgv3
            msgv4 = lx_bcs->msgv4.
    ENDTRY.
  ENDMETHOD.                "handle_email_event
ENDCLASS.
