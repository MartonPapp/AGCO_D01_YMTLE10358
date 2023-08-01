CLASS ymtle10358cl_bcs_reduced DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES ymtle10358i_bcs_reduced .
    ALIASES add_recipient FOR ymtle10358i_bcs_reduced~add_recipient.
    ALIASES set_document FOR ymtle10358i_bcs_reduced~set_document.
    ALIASES send FOR ymtle10358i_bcs_reduced~send.

    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_send_request TYPE REF TO cl_bcs.
ENDCLASS.



CLASS YMTLE10358CL_BCS_REDUCED IMPLEMENTATION.


  METHOD constructor.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Y class for BCS with reduced functionality
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    TRY.
        mo_send_request = cl_bcs=>create_persistent( ).
      CATCH cx_bcs INTO DATA(lx_bcs).
        MESSAGE lx_bcs->get_text( ) TYPE 'E'.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD ymtle10358i_bcs_reduced~add_recipient.
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
    mo_send_request->add_recipient( i_recipient = io_recipient ).
  ENDMETHOD.


  METHOD ymtle10358i_bcs_reduced~send.
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
    rv_result = mo_send_request->send(  ).
  ENDMETHOD.


  METHOD ymtle10358i_bcs_reduced~set_document.
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
    mo_send_request->set_document( io_document ).
  ENDMETHOD.
ENDCLASS.
