CLASS ymtle10358cl_dao_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    CLASS-METHODS get_defect_dao_instance
      RETURNING VALUE(ro_defect_dao_instance) TYPE REF TO ymtle10358i_defect_dao.
    CLASS-METHODS set_defect_dao_instance
      IMPORTING io_defect_dao_instance TYPE REF TO ymtle10358i_defect_dao.

    CLASS-METHODS get_bcs_instance
      RETURNING VALUE(ro_bcs_instance) TYPE REF TO ymtle10358i_bcs_reduced.
    CLASS-METHODS set_bcs_instance
      IMPORTING io_bcs_instance TYPE REF TO ymtle10358i_bcs_reduced.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: go_defect_dao_instance TYPE REF TO ymtle10358i_defect_dao.
    CLASS-DATA: go_bcs_instance TYPE REF TO ymtle10358i_bcs_reduced.
ENDCLASS.



CLASS YMTLE10358CL_DAO_FACTORY IMPLEMENTATION.


  METHOD get_bcs_instance.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Factory class for DAO object
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    IF go_bcs_instance IS BOUND.
      ro_bcs_instance = go_bcs_instance.
    ELSE.
      ro_bcs_instance = NEW ymtle10358cl_bcs_reduced( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_defect_dao_instance.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Factory class for DAO object
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    IF go_defect_dao_instance IS NOT BOUND.
      go_defect_dao_instance = NEW ymtle10358cl_defect_dao( ).
    ENDIF.
    ro_defect_dao_instance = go_defect_dao_instance.
  ENDMETHOD.


  METHOD set_bcs_instance.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Factory class for DAO object
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    go_bcs_instance = io_bcs_instance.
  ENDMETHOD.


  METHOD set_defect_dao_instance.
*----------------------------------------------------------------------*
* Author: Marton Papp
* Date:   2022.03.02.
* RICEFW OBJECT: MTL.E.10358
* CR/IN: CHG0087015/CHG0083294 - HES project
*----------------------------------------------------------------------*
* Short description:
* Factory class for DAO object
*----------------------------------------------------------------------*
* Changes
* Index Name         Date        Short description
*----------------------------------------------------------------------*
    go_defect_dao_instance = io_defect_dao_instance.
  ENDMETHOD.
ENDCLASS.
