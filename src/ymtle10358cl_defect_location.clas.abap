CLASS ymtle10358cl_defect_location DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES ymtle10358i_defect_location .

    ALIASES check_parameters
      FOR ymtle10358i_defect_location~check_parameters .

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_msg TYPE string ##NEEDED.
    DATA: mo_defect_dao TYPE REF TO ymtle10358i_defect_dao,
          mt_xuser      TYPE lrf_wkqu_t1,
          ms_xuser      TYPE lrf_wkqu.

    METHODS validate_lgtyp IMPORTING iv_lgtyp        TYPE lgtyp
                                     iv_lgnum        TYPE lgnum
                           RETURNING VALUE(rv_exist) TYPE abap_bool.

    METHODS validate_lgpla IMPORTING iv_lgpla        TYPE lgpla
                                     iv_lgtyp        TYPE lgtyp
                                     iv_lgnum        TYPE lgnum
                           RETURNING VALUE(rv_exist) TYPE abap_bool.
    METHODS validate_matnr IMPORTING iv_matnr        TYPE matnr
                           RETURNING VALUE(rv_exist) TYPE abap_bool.
ENDCLASS.



CLASS YMTLE10358CL_DEFECT_LOCATION IMPLEMENTATION.


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
    mo_defect_dao = ymtle10358cl_dao_factory=>get_defect_dao_instance(  ).
  ENDMETHOD.                "constructor


  METHOD validate_lgpla.
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
    SELECT SINGLE @abap_true INTO @rv_exist FROM lagp
        WHERE lgpla EQ @iv_lgpla
          AND lgtyp EQ @iv_lgtyp
          AND lgnum EQ @iv_lgnum.
  ENDMETHOD.                "validate_lgpla


  METHOD validate_lgtyp.
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
    SELECT SINGLE @abap_true INTO @rv_exist FROM t301
      WHERE lgtyp EQ @iv_lgtyp
        AND lgnum EQ @iv_lgnum.
  ENDMETHOD.                "validate_lgtyp


  METHOD validate_matnr.
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
    SELECT SINGLE @abap_true INTO @rv_exist FROM mara
        WHERE matnr EQ @iv_matnr.
  ENDMETHOD.                "validate_matnr


  METHOD ymtle10358i_defect_location~check_parameters.
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
    mt_xuser = mo_defect_dao->user_data_get( EXPORTING iv_uname = is_parameters-uname ).
    TRY.
        ms_xuser = mt_xuser[ statu = 'X' ].
      CATCH cx_sy_itab_line_not_found.
        MESSAGE e015 WITH is_parameters-uname INTO mv_msg.      "No active warehouse assigned to user: &1.
        RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDTRY.
    IF NOT me->validate_lgtyp( EXPORTING iv_lgtyp = is_parameters-lgtyp
                                     iv_lgnum = ms_xuser-lgnum ).
      MESSAGE e001 WITH is_parameters-lgtyp INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.

    IF NOT me->validate_lgpla( EXPORTING iv_lgpla = is_parameters-lgpla
                                     iv_lgtyp = is_parameters-lgtyp
                                     iv_lgnum = ms_xuser-lgnum ).
      MESSAGE e002 WITH is_parameters-lgpla INTO mv_msg.
      RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
    ENDIF.

    IF is_parameters-matnr IS NOT INITIAL.
      IF NOT me->validate_matnr( is_parameters-matnr ).
        MESSAGE e003 WITH is_parameters-matnr INTO mv_msg.
        RAISE EXCEPTION TYPE ycx_agco_globcore_exception.
      ENDIF.
    ENDIF.
  ENDMETHOD.                "check_parameters
ENDCLASS.
