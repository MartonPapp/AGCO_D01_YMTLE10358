INTERFACE ymtle10358i_defect_location
  PUBLIC .
  METHODS check_parameters
    IMPORTING is_parameters TYPE ymtle10358s_param
    CHANGING  ct_bdcmsgcoll TYPE trty_bdcmsgcoll
    RETURNING VALUE(rv_res) TYPE abap_bool
    RAISING   ycx_agco_globcore_exception.
ENDINTERFACE.
